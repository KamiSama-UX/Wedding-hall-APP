const db = require("../config/db");
const { logAction } = require("../utils/log.util");

exports.getDashboardStats = async () => {
  const [[{ total_users }]] = await db.execute(
    `SELECT COUNT(*) AS total_users FROM users`
  );
  const [[{ total_customers }]] = await db.execute(
    `SELECT COUNT(*) AS total_customers FROM users WHERE role = 'customer'`
  );
  const [[{ total_halls }]] = await db.execute(
    `SELECT COUNT(*) AS total_halls FROM wedding_halls`
  );
  const [[{ total_bookings }]] = await db.execute(
    `SELECT COUNT(*) AS total_bookings FROM bookings`
  );
  const [[{ revenue }]] = await db.execute(
    `SELECT COUNT(*) * 5000 AS revenue FROM bookings WHERE status = 'confirmed'`
  );

  return {
    total_users,
    total_customers,
    total_halls,
    total_bookings,
    revenue,
  };
};

exports.getAllBookings = async (status = null) => {
  let query = `
    SELECT 
      b.id, b.customer_id, u.name AS customer_name, b.hall_id, h.name AS hall_name,
      b.guest_count, b.event_date, b.event_time, b.status, b.created_at
    FROM bookings b
    JOIN users u ON b.customer_id = u.id
    JOIN wedding_halls h ON b.hall_id = h.id
  `;

  const params = [];
  if (status) {
    query += ` WHERE b.status = ?`;
    params.push(status);
  }

  query += ` ORDER BY b.created_at DESC`;

  const [rows] = await db.execute(query, params);
  return rows;
};

exports.updateBookingStatus = async (booking_id, status, actor) => {
  const valid = ["pending", "confirmed", "declined", "cancelled"];
  if (!valid.includes(status)) {
    throw new Error("Invalid status");
  }

  const [result] = await db.execute(
    `UPDATE bookings SET status = ? WHERE id = ?`,
    [status, booking_id]
  );

  if (result.affectedRows === 0) {
    throw new Error("Booking not found");
  }

  await logAction({
    actor_id: actor.id,
    action: `${status}_booking`,
    target_type: "booking",
    target_id: booking_id,
    description: `Booking ${booking_id} marked as ${status} by ${actor.role} ${actor.id}`,
  });

  return { message: `Booking ${booking_id} updated to ${status}` };
};

exports.getBookingStatusBreakdown = async () => {
  const [rows] = await db.execute(`
    SELECT status, COUNT(*) as count
    FROM bookings
    GROUP BY status
  `);

  return rows; // [{ status: 'confirmed', count: 10 }, ...]
};

exports.getAllCustomers = async () => {
  const [rows] = await db.execute(
    `SELECT id, name, email, created_at FROM users WHERE role = 'customer'`
  );
  return rows;
};

exports.getAllSubAdmins = async () => {
  const [rows] = await db.execute(
    `SELECT id, name, email, created_at FROM users WHERE role = 'sub_admin'`
  );
  return rows;
};

exports.getAllNotifications = async () => {
  const [rows] = await db.execute(`
    SELECT n.id, n.message, n.created_at, u.name AS user_name
    FROM notifications n
    JOIN users u ON n.user_id = u.id
    ORDER BY n.created_at DESC
  `);
  return rows;
};

exports.getLogs = async () => {
  const [rows] = await db.execute(`
    SELECT l.id, l.action, l.target_type, l.target_id, l.description, l.created_at,
           u.name AS actor_name
    FROM logs l
    JOIN users u ON l.actor_id = u.id
    ORDER BY l.created_at DESC
  `);
  return rows;
};

exports.getRecentBookings = async (limit = 5) => {
  const [rows] = await db.execute(
    `
    SELECT 
      b.id, b.event_date, b.event_time, b.status, b.created_at,
      u.name AS customer_name,
      h.name AS hall_name
    FROM bookings b
    JOIN users u ON b.customer_id = u.id
    JOIN wedding_halls h ON b.hall_id = h.id
    ORDER BY b.created_at DESC
    LIMIT ?
  `,
    [limit]
  );

  return rows;
};

exports.getBookingsPerDay = async () => {
  const [rows] = await db.execute(`
    SELECT h.name AS hall_name, COUNT(b.id) AS total_bookings
    FROM bookings b
    JOIN wedding_halls h ON h.id = b.hall_id
    GROUP BY b.hall_id
    ORDER BY total_bookings DESC
  `);

  return rows;
};
