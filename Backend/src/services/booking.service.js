const db = require("../config/db");
const {
  sendBookingConfirmation,
  notifyHallManager,
} = require("../utils/email.util");
const { createNotification } = require("../utils/notification.util");
const { logAction } = require("../utils/log.util");
const parseTime = (t) => {
  const [h, m] = t.split(":");
  return parseInt(h) * 60 + parseInt(m); // total minutes
};
exports.createBooking = async (data, decoded) => {
  const connection = await db.getConnection();
  await connection.beginTransaction();

  try {
    // Validate user from token
    const { id: userId, token_version } = decoded;
    
    const [[user]] = await connection.execute(
      `SELECT id, token_version FROM users WHERE id = ?`,
      [userId]
    );

    if (!user) throw new Error('User account not found');
    if (Number(user.token_version) !== Number(token_version)) {
      throw new Error('Session expired. Please login again');
    }
    
    const customer_id = user.id;
    const { hall_id, guest_count, event_date, event_time, service_ids = [] } = data;

    // Validate input
    const requiredFields = ['hall_id', 'guest_count', 'event_date', 'event_time'];
    const missingFields = requiredFields.filter(field => !data[field]);
    if (missingFields.length) {
      throw new Error(`Missing required fields: ${missingFields.join(', ')}`);
    }
    
    // Numeric validation
    if (!Number.isInteger(guest_count) || guest_count <= 0 || guest_count > 1000) {
      throw new Error('Guest count must be between 1-1000');
    }

    // Date validation
    const bookingDateTime = new Date(`${event_date}T${event_time}`);
    if (isNaN(bookingDateTime.getTime())) {
      throw new Error('Invalid date/time format');
    }
    if (bookingDateTime < new Date()) {
      throw new Error('Cannot book past dates');
    }

    // NEW: Hall availability check - one booking per day
    const [existingBookings] = await connection.execute(
      `SELECT id FROM bookings 
       WHERE hall_id = ? AND event_date = ? 
       AND status IN ('pending', 'confirmed')`,
      [hall_id, event_date]
    );
    
    if (existingBookings.length) {
      throw new Error('Hall already booked for this date');
    }

    // Hall capacity check
    const [[hall]] = await connection.execute(
      `SELECT capacity FROM wedding_halls WHERE id = ?`,
      [hall_id]
    );
    
    if (!hall) throw new Error('Hall not found');
    if (hall.capacity < guest_count) {
      throw new Error(`Exceeds hall capacity (max: ${hall.capacity})`);
    }

    // Create booking
    const [result] = await connection.execute(
      `INSERT INTO bookings 
      (customer_id, hall_id, guest_count, event_date, event_time, status)
      VALUES (?, ?, ?, ?, ?, 'pending')`,
      [customer_id, hall_id, guest_count, event_date, event_time]
    );
    
    const bookingId = result.insertId;

    // Process services if any
    if (service_ids.length) {
      // Create placeholders for service IDs
      const placeholders = service_ids.map(() => '?').join(',');
      const query = `
        SELECT id, price_per_person, pricing_type 
        FROM services 
        WHERE id IN (${placeholders}) AND hall_id = ?
      `;
      
      // Validate service IDs - ensure they belong to this hall
      const [validServices] = await connection.query(
        query,
        [...service_ids, hall_id]
      );
      
      if (validServices.length !== service_ids.length) {
        const invalidIds = service_ids.filter(id => 
          !validServices.some(s => s.id === id)
        );
        throw new Error(`Invalid services: ${invalidIds.join(', ')}`);
      }

      // Calculate and insert service costs
      const serviceInserts = validServices.map(service => {
        const cost = service.pricing_type === 'invitation_based'
          ? service.price_per_person * guest_count
          : service.price_per_person;
          
        return [bookingId, service.id, cost];
      });

      await connection.query(
        `INSERT INTO booking_services 
        (booking_id, service_id, price_at_booking)
        VALUES ?`,
        [serviceInserts]
      );
    }

    // Create customer notification
    await connection.execute(
      `INSERT INTO notifications 
      (user_id, message, type, related_booking_id)
      VALUES (?, ?, ?, ?)`,
      [
        customer_id,
        `Booking #${bookingId} for ${event_date} at ${event_time} is pending`,
        'booking_confirmation',
        bookingId
      ]
    );

    // Create manager notification
    const [[hallInfo]] = await connection.execute(
      `SELECT sub_admin_id FROM wedding_halls WHERE id = ?`,
      [hall_id]
    );
    
    if (hallInfo?.sub_admin_id) {
      await connection.execute(
        `INSERT INTO notifications 
        (user_id, message, type, related_booking_id)
        VALUES (?, ?, ?, ?)`,
        [
          hallInfo.sub_admin_id,
          `New booking #${bookingId} for Hall ${hall_id} on ${event_date} at ${event_time}`,
          'new_booking',
          bookingId
        ]
      );
    }

    // Commit transaction
    await connection.commit();
    connection.release();

    // Send emails after successful booking creation
    try {
      await sendBookingConfirmation(customer_id, hall_id, event_date, event_time);
    } catch (emailError) {
      console.error('Failed to send booking confirmation email:', emailError);
    }
    
    try {
      await notifyHallManager(hall_id, customer_id, event_date, event_time);
    } catch (managerEmailError) {
      console.error('Failed to send hall manager notification:', managerEmailError);
    }

    return {
      id: bookingId,
      customer_id,
      hall_id,
      guest_count,
      event_date,
      event_time,
      status: 'pending'
    };

  } catch (error) {
    // Rollback on any error
    await connection.rollback();
    connection.release();
    
    throw error;
  }
};
// lat working one exports.createBooking = async (data, decoded) => {
//   const connection = await db.getConnection();
//   await connection.beginTransaction();

//   try {
//     // Validate user from token
//     const { id: userId, token_version } = decoded;
    
//     const [[user]] = await connection.execute(
//       `SELECT id, token_version FROM users WHERE id = ?`,
//       [userId]
//     );

//     if (!user) throw new Error('User account not found');
//     if (Number(user.token_version) !== Number(token_version)) {
//       throw new Error('Session expired. Please login again');
//     }
    
//     const customer_id = user.id;
//     const { hall_id, guest_count, event_date, event_time, service_ids = [] } = data;

//     // Validate input
//     const requiredFields = ['hall_id', 'guest_count', 'event_date', 'event_time'];
//     const missingFields = requiredFields.filter(field => !data[field]);
//     if (missingFields.length) {
//       throw new Error(`Missing required fields: ${missingFields.join(', ')}`);
//     }
    
//     // Numeric validation
//     if (!Number.isInteger(guest_count) || guest_count <= 0 || guest_count > 1000) {
//       throw new Error('Guest count must be between 1-1000');
//     }

//     // Date validation
//     const bookingDateTime = new Date(`${event_date}T${event_time}`);
//     if (isNaN(bookingDateTime.getTime())) {
//       throw new Error('Invalid date/time format');
//     }
//     if (bookingDateTime < new Date()) {
//       throw new Error('Cannot book past dates');
//     }

//     // Hall availability check
//     const [existingBookings] = await connection.execute(
//       `SELECT id FROM bookings 
//        WHERE hall_id = ? AND event_date = ? AND event_time = ?
//        AND status IN ('pending', 'confirmed')`,
//       [hall_id, event_date, event_time]
//     );
    
//     if (existingBookings.length) {
//       throw new Error('Hall already booked at this date/time');
//     }

//     // Hall capacity check
//     const [[hall]] = await connection.execute(
//       `SELECT capacity FROM wedding_halls WHERE id = ?`,
//       [hall_id]
//     );
    
//     if (!hall) throw new Error('Hall not found');
//     if (hall.capacity < guest_count) {
//       throw new Error(`Exceeds hall capacity (max: ${hall.capacity})`);
//     }

//     // Create booking
//     const [result] = await connection.execute(
//       `INSERT INTO bookings 
//       (customer_id, hall_id, guest_count, event_date, event_time, status)
//       VALUES (?, ?, ?, ?, ?, 'pending')`,
//       [customer_id, hall_id, guest_count, event_date, event_time]
//     );
    
//     const bookingId = result.insertId;

//     // Process services if any
//     if (service_ids.length) {
//       // Create placeholders for service IDs
//       const placeholders = service_ids.map(() => '?').join(',');
//       const query = `
//         SELECT id, price_per_person, pricing_type 
//         FROM services 
//         WHERE id IN (${placeholders}) AND hall_id = ?
//       `;
      
//       // Validate service IDs - ensure they belong to this hall
//       const [validServices] = await connection.query(
//         query,
//         [...service_ids, hall_id]
//       );
      
//       if (validServices.length !== service_ids.length) {
//         const invalidIds = service_ids.filter(id => 
//           !validServices.some(s => s.id === id)
//         );
//         throw new Error(`Invalid services: ${invalidIds.join(', ')}`);
//       }

//       // Calculate and insert service costs
//       const serviceInserts = validServices.map(service => {
//         const cost = service.pricing_type === 'invitation_based'
//           ? service.price_per_person * guest_count
//           : service.price_per_person;
          
//         return [bookingId, service.id, cost];
//       });

//       await connection.query(
//         `INSERT INTO booking_services 
//         (booking_id, service_id, price_at_booking)
//         VALUES ?`,
//         [serviceInserts]
//       );
//     }

//     // Create customer notification
//     await connection.execute(
//       `INSERT INTO notifications 
//       (user_id, message, type, related_booking_id)
//       VALUES (?, ?, ?, ?)`,
//       [
//         customer_id,
//         `Booking #${bookingId} for ${event_date} at ${event_time} is pending`,
//         'booking_confirmation',
//         bookingId
//       ]
//     );

//     // Create manager notification
//     const [[hallInfo]] = await connection.execute(
//       `SELECT sub_admin_id FROM wedding_halls WHERE id = ?`,
//       [hall_id]
//     );
    
//     if (hallInfo?.sub_admin_id) {
//       await connection.execute(
//         `INSERT INTO notifications 
//         (user_id, message, type, related_booking_id)
//         VALUES (?, ?, ?, ?)`,
//         [
//           hallInfo.sub_admin_id,
//           `New booking #${bookingId} for Hall ${hall_id} on ${event_date} at ${event_time}`,
//           'new_booking',
//           bookingId
//         ]
//       );
//     }

//     // Commit transaction
//     await connection.commit();
//     connection.release();

//     // Send emails after successful booking creation (fire-and-forget)
//     try {
//       await sendBookingConfirmation(customer_id, hall_id, event_date, event_time);
//     } catch (emailError) {
//       console.error('Failed to send booking confirmation email:', emailError);
//     }
    
//     try {
//       await notifyHallManager(hall_id, customer_id, event_date, event_time);
//     } catch (managerEmailError) {
//       console.error('Failed to send hall manager notification:', managerEmailError);
//     }

//     return {
//       id: bookingId,
//       customer_id,
//       hall_id,
//       guest_count,
//       event_date,
//       event_time,
//       status: 'pending'
//     };

//   } catch (error) {
//     // Rollback on any error
//     await connection.rollback();
//     connection.release();
    
//     throw error;
//   }
// };

// exports.createBooking = async (data, decoded) => {
//   const connection = await db.getConnection();
//   await connection.beginTransaction();

//   try {
//     // Validate user from token
//     const { id: userId, token_version } = decoded;
    
//     const [[user]] = await connection.execute(
//       `SELECT id, token_version FROM users WHERE id = ?`,
//       [userId]
//     );

//     if (!user) throw new Error('User account not found');
//     if (Number(user.token_version) !== Number(token_version)) {
//       throw new Error('Session expired. Please login again');
//     }
    
//     const customer_id = user.id;
//     const { hall_id, guest_count, event_date, event_time, service_ids = [] } = data;

//     // Validate input
//     const requiredFields = ['hall_id', 'guest_count', 'event_date', 'event_time'];
//     const missingFields = requiredFields.filter(field => !data[field]);
//     if (missingFields.length) {
//       throw new Error(`Missing required fields: ${missingFields.join(', ')}`);
//     }
    
//     // Numeric validation
//     if (!Number.isInteger(guest_count) || guest_count <= 0 || guest_count > 1000) {
//       throw new Error('Guest count must be between 1-1000');
//     }

//     // Date validation
//     const bookingDateTime = new Date(`${event_date}T${event_time}`);
//     if (isNaN(bookingDateTime.getTime())) {
//       throw new Error('Invalid date/time format');
//     }
//     if (bookingDateTime < new Date()) {
//       throw new Error('Cannot book past dates');
//     }

//     // Hall availability check
//     const [existingBookings] = await connection.execute(
//       `SELECT id FROM bookings 
//        WHERE hall_id = ? AND event_date = ? AND event_time = ?
//        AND status IN ('pending', 'confirmed')`,
//       [hall_id, event_date, event_time]
//     );
    
//     if (existingBookings.length) {
//       throw new Error('Hall already booked at this date/time');
//     }

//     // Hall capacity check
//     const [[hall]] = await connection.execute(
//       `SELECT capacity FROM wedding_halls WHERE id = ?`,
//       [hall_id]
//     );
    
//     if (!hall) throw new Error('Hall not found');
//     if (hall.capacity < guest_count) {
//       throw new Error(`Exceeds hall capacity (max: ${hall.capacity})`);
//     }

//     // Create booking
//     const [result] = await connection.execute(
//       `INSERT INTO bookings 
//       (customer_id, hall_id, guest_count, event_date, event_time, status)
//       VALUES (?, ?, ?, ?, ?, 'pending')`,
//       [customer_id, hall_id, guest_count, event_date, event_time]
//     );
    
//     const bookingId = result.insertId;

//     // Process services if any
//     if (service_ids.length) {
//       // Create placeholders for service IDs
//       const placeholders = service_ids.map(() => '?').join(',');
//       const query = `
//         SELECT id, price_per_person, pricing_type 
//         FROM services 
//         WHERE id IN (${placeholders}) AND hall_id = ?
//       `;
      
//       // Validate service IDs - ensure they belong to this hall
//       const [validServices] = await connection.query(
//         query,
//         [...service_ids, hall_id]
//       );
      
//       if (validServices.length !== service_ids.length) {
//         const invalidIds = service_ids.filter(id => 
//           !validServices.some(s => s.id === id)
//         );
//         throw new Error(`Invalid services: ${invalidIds.join(', ')}`);
//       }

//       // Calculate and insert service costs
//       const serviceInserts = validServices.map(service => {
//         const cost = service.pricing_type === 'invitation_based'
//           ? service.price_per_person * guest_count
//           : service.price_per_person;
          
//         return [bookingId, service.id, cost];
//       });

//       await connection.query(
//         `INSERT INTO booking_services 
//         (booking_id, service_id, price_at_booking)
//         VALUES ?`,
//         [serviceInserts]
//       );
//     }

//     // Create customer notification - FIXED SQL SYNTAX
//     await connection.execute(
//       `INSERT INTO notifications 
//       (user_id, message, type, related_booking_id)
//       VALUES (?, ?, ?, ?)`,
//       [
//         customer_id,
//         `Booking #${bookingId} for ${event_date} at ${event_time} is pending`,
//         'booking_confirmation',
//         bookingId
//       ]
//     );

//     // Create manager notification - FIXED SQL SYNTAX
//     const [[hallInfo]] = await connection.execute(
//       `SELECT sub_admin_id FROM wedding_halls WHERE id = ?`,
//       [hall_id]
//     );
    
//     if (hallInfo?.sub_admin_id) {
//       await connection.execute(
//         `INSERT INTO notifications 
//         (user_id, message, type, related_booking_id)
//         VALUES (?, ?, ?, ?)`,
//         [
//           hallInfo.sub_admin_id,
//           `New booking #${bookingId} for Hall ${hall_id} on ${event_date} at ${event_time}`,
//           'new_booking',
//           bookingId
//         ]
//       );
//     }

//     // Commit transaction
//     await connection.commit();
//     connection.release();

//     return {
//       id: bookingId,
//       customer_id,
//       hall_id,
//       guest_count,
//       event_date,
//       event_time,
//       status: 'pending'
//     };

//   } catch (error) {
//     // Rollback on any error
//     await connection.rollback();
//     connection.release();
    
//     throw error;
//   }
// };

// exports.createBooking = async (data, decoded) => {
//   const { hall_id, guest_count, event_date, event_time, service_ids = [] } = data;

//   if (!Number.isInteger(guest_count) || guest_count <= 0) {
//     throw new Error('Guest count must be a positive number');
//   }

//   const bookingDateTime = new Date(`${event_date}T${event_time}`);
//   if (bookingDateTime < new Date()) {
//     throw new Error('Cannot book for a past date/time');
//   }


//   const [existingBookings] = await db.execute(
//     `SELECT id FROM bookings 
//      WHERE hall_id = ? AND event_date = ? AND status IN ('pending', 'confirmed')`,
//     [hall_id, event_date]
//   );
//   if (existingBookings.length > 0) {
//     throw new Error('Hall is already booked on this date');
//   }


//   const [result] = await db.execute(
//     `INSERT INTO bookings (customer_id, hall_id, guest_count, event_date, event_time)
//      VALUES (?, ?, ?, ?, ?)`,
//     [customer_id, hall_id, guest_count, event_date, event_time]
//   );
//   const bookingId = result.insertId;


//   if (service_ids.length > 0) {
//     const placeholders = service_ids.map(() => '?').join(', ');
//     const query = `
//       SELECT id, price_per_person, pricing_type 
//       FROM services 
//       WHERE hall_id = ? AND id IN (${placeholders})
//     `;

//     const [services] = await db.execute(query, [hall_id, ...service_ids]);

//     if (services.length !== service_ids.length) {
//       throw new Error('Invalid or mismatched services provided');
//     }

//     for (const service of services) {
//       let cost = service.price_per_person;
//       if (service.pricing_type === 'invitation_based') {
//         cost *= guest_count;
//       }

//       await db.execute(
//         `INSERT INTO booking_services (booking_id, service_id, price_at_booking)
//          VALUES (?, ?, ?)`,
//         [bookingId, service.id, cost]
//       );
//     }
//   }

//   await sendBookingConfirmation(customer_id, hall_id, event_date, event_time);
//   await notifyHallManager(hall_id, customer_id, event_date, event_time);

//   const [[manager]] = await db.execute(
//     `SELECT sub_admin_id FROM wedding_halls WHERE id = ?`,
//     [hall_id]
//   );

//   if (manager?.sub_admin_id) {
//     const msg = `New booking for Hall ID ${hall_id} on ${event_date} at ${event_time}`;
//     await createNotification(manager.sub_admin_id, msg, bookingId);
//   }

//   return {
//     id: bookingId,
//     customer_id,
//     hall_id,
//     guest_count,
//     event_date,
//     event_time,
//     status: 'pending'
//   };
// };

//   const { hall_id, guest_count, event_date, event_time, service_ids = [] } = data;

//   if (!Number.isInteger(guest_count) || guest_count <= 0) {
//     throw new Error('Guest count must be a positive number');
//   }

//   // Prevent past bookings
//   const bookingDateTime = new Date(`${event_date}T${event_time}`);
//   if (bookingDateTime < new Date()) {
//     throw new Error('Cannot book for a past date/time');
//   }

//   // Prevent time conflict (3hr buffer)
//   const [conflicts] = await db.execute(
//     `SELECT event_time FROM bookings 
//      WHERE hall_id = ? AND event_date = ? AND status IN ('pending', 'confirmed')`,
//     [hall_id, event_date]
//   );

//   const requestedTime = parseTime(event_time);
//   const timeConflict = conflicts.some(b => {
//     const existing = parseTime(b.event_time);
//     return Math.abs(existing - requestedTime) < 180;
//   });

//   if (timeConflict) throw new Error('Hall already booked in this time range');

//   // Insert booking
//   const [result] = await db.execute(`
//     INSERT INTO bookings (customer_id, hall_id, guest_count, event_date, event_time)
//     VALUES (?, ?, ?, ?, ?)`,
//     [customer_id, hall_id, guest_count, event_date, event_time]
//   );

//   const bookingId = result.insertId;

//   // 💰 Handle Services
//   if (service_ids.length > 0) {
//   const placeholders = service_ids.map(() => '?').join(', ');
//   const query = `
//     SELECT id, price_per_person, pricing_type 
//     FROM services 
//     WHERE hall_id = ? AND id IN (${placeholders})
//   `;

//   const [services] = await db.execute(query, [hall_id, ...service_ids]);

//   if (services.length !== service_ids.length) {
//     throw new Error('Invalid or mismatched services provided');
//   }

//   for (const service of services) {
//     let cost = service.price_per_person;
//     if (service.pricing_type === 'invitation_based') {
//       cost *= guest_count;
//     }

//     await db.execute(
//       `INSERT INTO booking_services (booking_id, service_id, price_at_booking)
//        VALUES (?, ?, ?)`,
//       [bookingId, service.id, cost]
//     );
//   }
// }

//   // 🔔 Notify customer and manager
//   await sendBookingConfirmation(customer_id, hall_id, event_date, event_time);
//   await notifyHallManager(hall_id, customer_id, event_date, event_time);

//   // 🔔 Notify sub_admin
//   const [[manager]] = await db.execute(
//     `SELECT sub_admin_id FROM wedding_halls WHERE id = ?`,
//     [hall_id]
//   );

//   if (manager?.sub_admin_id) {
//     const msg = `New booking for Hall ID ${hall_id} on ${event_date} at ${event_time}`;
//     await createNotification(manager.sub_admin_id, msg, bookingId);
//   }

//   return {
//     id: bookingId,
//     customer_id,
//     hall_id,
//     guest_count,
//     event_date,
//     event_time,
//     status: 'pending'
//   };
// };
// exports.createBooking = async (data, customer_id) => {
//   const {
//     hall_id,
//     guest_count,
//     event_date,
//     event_time,
//     service_ids = [],
//   } = data;

//   if (!Number.isInteger(guest_count) || guest_count <= 0) {
//     throw new Error("Guest count must be a positive number");
//   }

//   const bookingDateTime = new Date(`${event_date}T${event_time}`);
//   if (bookingDateTime < new Date()) {
//     throw new Error("Cannot book for a past date/time");
//   }

//   // Prevent overlapping bookings
//   const [conflicts] = await db.execute(
//     `SELECT event_time FROM bookings 
//      WHERE hall_id = ? AND event_date = ? AND status IN ('pending', 'confirmed')`,
//     [hall_id, event_date]
//   );

//   const requestedTime = parseTime(event_time);
//   const timeConflict = conflicts.some((b) => {
//     const existing = parseTime(b.event_time);
//     return Math.abs(existing - requestedTime) < 180;
//   });

//   if (timeConflict) throw new Error("Hall already booked in this time range");

//   // Create booking
//   const [result] = await db.execute(
//     `INSERT INTO bookings (customer_id, hall_id, guest_count, event_date, event_time)
//      VALUES (?, ?, ?, ?, ?)`,
//     [customer_id, hall_id, guest_count, event_date, event_time]
//   );

//   const bookingId = result.insertId;

//   //  Handle service selection (price snapshot)
//   if (service_ids.length > 0) {
//     const [services] = await db.query(
//   `SELECT id, price_per_person, pricing_type FROM services WHERE id IN (?) AND hall_id = ?`,
//   [service_ids, hall_id]
// );

//     // if (services.length !== service_ids.length) {
//     //   throw new Error("Some selected services are invalid for this hall");
//     // }

//     for (const service of services) {
//   let cost = service.price_per_person;
//   if (service.pricing_type === 'invitation_based') {
//     cost *= guest_count;
//   }

//   await db.execute(
//     `INSERT INTO booking_services (booking_id, service_id, price_at_booking)
//      VALUES (?, ?, ?)`,
//     [bookingId, service.id, cost]
//   );
// }
//   }

//   // Notifications
//   await sendBookingConfirmation(customer_id, hall_id, event_date, event_time);
//   await notifyHallManager(hall_id, customer_id, event_date, event_time);

//   const [[manager]] = await db.execute(
//     `SELECT sub_admin_id FROM wedding_halls WHERE id = ?`,
//     [hall_id]
//   );
//   if (manager?.sub_admin_id) {
//     const msg = `New booking for Hall ID ${hall_id} on ${event_date} at ${event_time}`;
//     await createNotification(manager.sub_admin_id, msg, bookingId);
//   }

//   return {
//     id: bookingId,
//     customer_id,
//     hall_id,
//     guest_count,
//     event_date,
//     event_time,
//     status: "pending",
//     services: service_ids,
//   };
// };

exports.updateBooking = async (booking_id, user_id, updatedData) => {
  const { guest_count, event_date, event_time } = updatedData;

  // Check if booking exists and belongs to user and not confirmed
  const [[booking]] = await db.execute(
    `SELECT * FROM bookings 
     WHERE id = ? AND customer_id = ? AND status != 'confirmed'`,
    [booking_id, user_id]
  );
  if (!Number.isInteger(guest_count) || guest_count <= 0) {
    throw new Error("Guest count must be a positive number");
  }

  if (!booking) {
    throw new Error("Booking not found, not yours, or already confirmed");
  }

  // Prevent past date/time
  const bookingDateTime = new Date(`${event_date}T${event_time}`);
  if (bookingDateTime < new Date()) {
    throw new Error("Cannot book for a past date/time");
  }

  // Check time conflicts (3-hour buffer)
  const [conflicts] = await db.execute(
    `SELECT event_time FROM bookings 
     WHERE hall_id = ? AND event_date = ? AND id != ? AND status IN ('pending', 'confirmed')`,
    [booking.hall_id, event_date, booking_id]
  );

  const parseTime = (t) => {
    const [h, m] = t.split(":");

    return parseInt(h) * 60 + parseInt(m);
  };

  const requestedTime = parseTime(event_time);
  const timeConflict = conflicts.some((b) => {
    const existing = parseTime(b.event_time);
    return Math.abs(existing - requestedTime) < 180;
  });

  if (timeConflict) {
    throw new Error("Hall already booked in this time range");
  }

  // Update the booking
  await db.execute(
    `UPDATE bookings SET guest_count = ?, event_date = ?, event_time = ? WHERE id = ?`,
    [guest_count, event_date, event_time, booking_id]
  );

  await logAction({
    actor_id: user_id,
    action: "booking_updated",
    target_type: "booking",
    target_id: booking_id,
    description: `Customer ${user_id} updated booking ${booking_id}`,
  });

  return { message: "Booking updated successfully" };
};

exports.getMyBookings = async (customer_id) => {
  // Get bookings with hall info
  const [bookings] = await db.execute(
    `SELECT b.*, h.name AS hall_name 
     FROM bookings b
     JOIN wedding_halls h ON b.hall_id = h.id
     WHERE b.customer_id = ?
     ORDER BY b.event_date DESC, b.event_time DESC`,
    [customer_id]
  );

  // For each booking, fetch associated services
  for (const booking of bookings) {
 const [services] = await db.execute(
  `SELECT 
      bs.service_id, 
      s.name, 
      bs.price_at_booking,
      s.pricing_type
   FROM booking_services bs
   JOIN services s ON bs.service_id = s.id
   WHERE bs.booking_id = ?`,
  [booking.id]
);

// Add calculated cost per person for invitation_based services
services.forEach(service => {
  if (service.pricing_type === 'invitation_based') {
    service.cost_per_person = service.price_at_booking / booking.guest_count;
  } else {
    service.cost_per_person = service.price_at_booking;
  }
});

    booking.services = services;
  }

  return bookings;
};

exports.updateStatus = async (booking_id, status, actor) => {
  await db.execute(`UPDATE bookings SET status = ? WHERE id = ?`, [
    status,
    booking_id,
  ]);

  await logAction({
    actor_id: actor.id,
    action: `booking_${status}`,
    target_type: "booking",
    target_id: booking_id,
    description: `Booking ${booking_id} marked as ${status} by ${actor.role} ${actor.id}`,
  });

  return { message: `Booking marked as ${status}` };
};

// Cancel by customer (status change)
exports.cancelBooking = async (booking_id, actor) => {
  const [rows] = await db.execute(
    `SELECT * FROM bookings WHERE id = ? AND customer_id = ?`,
    [booking_id, actor.id]
  );

  if (rows.length === 0) {
    throw new Error("Booking not found or not yours");
  }

  await db.execute(`UPDATE bookings SET status = 'cancelled' WHERE id = ?`, [
    booking_id,
  ]);

  await logAction({
    actor_id: actor.id,
    action: "booking_cancelled",
    target_type: "booking",
    target_id: booking_id,
    description: `Booking ${booking_id} cancelled by ${actor.role} ${actor.id}`,
  });

  return { message: "Booking cancelled successfully" };
};
// Hard delete by admin/sub_admin
exports.deleteBooking = async (booking_id, actor) => {
  await db.execute(`DELETE FROM bookings WHERE id = ?`, [booking_id]);

  await logAction({
    actor_id: actor.id,
    action: "booking_deleted",
    target_type: "booking",
    target_id: booking_id,
    description: `Booking ${booking_id} deleted by ${actor.role} ${actor.id}`,
  });

  return { message: "Booking deleted permanently" };
};

