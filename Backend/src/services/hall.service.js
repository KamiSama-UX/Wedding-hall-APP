const db = require("../config/db");

exports.createHall = async (data, creatorId, userRole) => {
  const { name, location, capacity, description, sub_admin_id } = data;

  //  if creator is admin, allow provided sub_admin_id, else force their own ID
  const ownerId = userRole === "admin" ? sub_admin_id : creatorId;

  const [result] = await db.execute(
    `INSERT INTO wedding_halls (name, location, capacity, description, sub_admin_id)
     VALUES (?, ?, ?, ?, ?)`,
    [name, location, capacity, description, ownerId]
  );

  return {
    id: result.insertId,
    name,
    location,
    capacity,
    description,
    sub_admin_id: ownerId,
  };
};

exports.getHallsBySubAdmin = async (sub_admin_id) => {
  const [rows] = await db.execute(
    `SELECT * FROM wedding_halls WHERE sub_admin_id = ?`,
    [sub_admin_id]
  );
  return rows;
};

exports.updateHall = async (id, data, userId, role) => {
  await exports.verifyOwnership(id, userId, role);

  const { name, location, capacity, description } = data;
  await db.execute(
    `UPDATE wedding_halls
     SET name = ?, location = ?, capacity = ?, description = ?
     WHERE id = ?`,
    [name, location, capacity, description, id]
  );

  return { message: "Hall updated successfully" };
};

exports.deleteHall = async (id, userId, role) => {
  await exports.verifyOwnership(id, userId, role);

  await db.execute("DELETE FROM wedding_halls WHERE id = ?", [id]);
  await logAction({
    actor_id: req.user.id,
    action: "deleted_user",
    target_type: "user",
    target_id: deletedUserId,
    description: `User ${deletedUserId} deleted by ${req.user.id}`,
  });

  return { message: "Hall deleted successfully" };
};

exports.getAllHalls = async (userId = null, role = null) => {
  let query = "";
  let params = [];

  if (role === "customer") {
    query = `
      SELECT h.id, h.name, h.location, h.capacity, h.description,
        EXISTS (
          SELECT 1 FROM saved_halls s
          WHERE s.hall_id = h.id AND s.user_id = ?
        ) AS is_saved
      FROM wedding_halls h
    `;
    params = [userId];
  } else if (role === "admin") {
    query = `
      SELECT h.id, h.name, h.location, h.capacity, h.description,
        h.sub_admin_id, u.name AS sub_admin_name,
        h.status,
        false AS is_saved
      FROM wedding_halls h
      JOIN users u ON h.sub_admin_id = u.id
    `;
  } else if (role === "sub_admin") {
    query = `
      SELECT h.id, h.name, h.location, h.capacity, h.description,
        h.status,
        false AS is_saved
      FROM wedding_halls h
      WHERE h.sub_admin_id = ?
    `;
    params = [userId];
  } else {
    query = `
      SELECT id, name, location, capacity, description,
        false AS is_saved
      FROM wedding_halls
    `;
  }

  const [halls] = await db.execute(query, params);

  for (const hall of halls) {
    const [photos] = await db.execute(
      `SELECT id, photo_url, is_cover FROM hall_photos WHERE hall_id = ?`,
      [hall.id]
    );

    // Fallback if no cover marked
    const cover = photos.find(p => p.is_cover) || photos[0];

    hall.cover_photo = cover
      ? `${process.env.BACKEND_URL}${cover.photo_url}`
      : null;
    hall.photos = photos.map(p => ({
      id: p.id,
      url: `${process.env.BACKEND_URL}${p.photo_url}`,
      is_cover: !!p.is_cover,
      imageName:`${p.photo_url}`,
    }));
  }

  return halls;
};

exports.verifyOwnership = async (hallId, userId, role) => {
  const [rows] = await db.execute(
    "SELECT sub_admin_id FROM wedding_halls WHERE id = ?",
    [hallId]
  );
  const hall = rows[0];

  if (!hall) throw new Error("Hall not found");
  if (role === "sub_admin" && hall.sub_admin_id !== userId) {
    throw new Error("Access denied: you do not own this hall");
  }
};

exports.reassignHall = async (hallId, newSubAdminId, userRole) => {
  if (userRole !== "admin") {
    throw new Error("Only admins can reassign halls");
  }

  // Make sure sub_admin exists
  const [subAdminRows] = await db.execute(
    `SELECT id FROM users WHERE id = ? AND role = 'sub_admin'`,
    [newSubAdminId]
  );
  if (subAdminRows.length === 0) {
    throw new Error("Target sub_admin not found");
  }

  // Update hall assignment
  await logAction({
    actor_id: req.user.id,
    action: "reassigned_hall",
    target_type: "hall",
    target_id: hallId,
    description: `Hall ${hallId} reassigned to sub_admin ${newSubAdminId}`,
  });

  const [result] = await db.execute(
    `UPDATE wedding_halls SET sub_admin_id = ? WHERE id = ?`,
    [newSubAdminId, hallId]
  );

  return { message: "Hall reassigned successfully" };
};

exports.getHallDetails = async (hallId) => {
  const [[hall]] = await db.execute(
    `SELECT h.*, u.name AS sub_admin_name
     FROM wedding_halls h
     JOIN users u ON h.sub_admin_id = u.id
     WHERE h.id = ?`,
    [hallId]
  );

  if (!hall) throw new Error("Hall not found");

  const [photos] = await db.execute(
    `SELECT id, photo_url, is_cover FROM hall_photos WHERE hall_id = ?`,
    [hallId]
  );

  const cover = photos.find(p => p.is_cover) || photos[0];

  return {
    ...hall,
    cover_photo: cover
      ? `${process.env.BACKEND_URL}${cover.photo_url}`
      : null,
    photos: photos.map(p => ({
      id: p.id,
      url: `${process.env.BACKEND_URL}${p.photo_url}`,
      is_cover: !!p.is_cover,
      imageName:`${p.photo_url}`,
    })),
  };
};

/**
 * Get top booked halls all-time, with services and images
 */
/**
 * Get Top 5 Halls by Total Bookings
 */
exports.getTopHalls = async () => {
  const [rows] = await db.execute(`
    SELECT h.id, h.name, h.location, h.capacity, h.description,
           COUNT(b.id) AS bookings_count
    FROM wedding_halls h
    LEFT JOIN bookings b ON h.id = b.hall_id
    GROUP BY h.id
    ORDER BY bookings_count DESC
    LIMIT 5
  `);
  return await enrichHalls(rows);
};

/**
 * Get Trending Halls (booked most in last 7 days)
 */
exports.getBookingTrend = async () => {
  const [rows] = await db.execute(`
    SELECT h.id, h.name, h.location, h.capacity, h.description,
           COUNT(b.id) AS recent_bookings
    FROM wedding_halls h
    JOIN bookings b ON h.id = b.hall_id
    WHERE b.created_at >= CURDATE() - INTERVAL 7 DAY
    GROUP BY h.id
    ORDER BY recent_bookings DESC
    LIMIT 5
  `);
  return await enrichHalls(rows);
};

/**
 * Attach Cover Photo & Services to Each Hall
 */
async function enrichHalls(halls) {
  return Promise.all(
    halls.map(async (hall) => {
      const [services] = await db.execute(
        `SELECT id, name, price_per_person, pricing_type FROM services WHERE hall_id = ? ORDER BY id`,
        [hall.id]
      );

      const [photos] = await db.execute(
        `SELECT id, photo_url, is_cover FROM hall_photos WHERE hall_id = ?`,
        [hall.id]
      );

      const cover = photos.find(p => p.is_cover) || photos[0];

      return {
        ...hall,
        services,
        cover_photo: cover ? `${process.env.BACKEND_URL}${cover.photo_url}` : null,
        photos: photos.map(p => ({
          id: p.id,
          url: `${process.env.BACKEND_URL}${p.photo_url}`,
          is_cover: !!p.is_cover,
          imageName:`${p.photo_url}`,
        }))
      };
    })
  );
}

exports.addServiceToHall = async (hallId, name, price_per_person, pricing_type, user) => {
  if (!name || typeof name !== "string" || name.trim() === "") {
    throw new Error("Service name is required");
  }

  if (!price_per_person || isNaN(price_per_person) || price_per_person <= 0) {
    throw new Error("Valid price_per_person is required");
  }

  if (!['static', 'invitation_based'].includes(pricing_type)) {
    throw new Error("Invalid pricing_type. Must be 'static' or 'invitation_based'");
  }

  const [[hall]] = await db.execute(
    `SELECT sub_admin_id FROM wedding_halls WHERE id = ?`,
    [hallId]
  );
  if (!hall) throw new Error("Hall not found");

  if (user.role === "sub_admin" && hall.sub_admin_id !== user.id) {
    throw new Error("You do not own this hall");
  }

  const [[existing]] = await db.execute(
    `SELECT id FROM services WHERE hall_id = ? AND name = ?`,
    [hallId, name]
  );
  if (existing) throw new Error("Service already exists for this hall");

  await db.execute(
    `INSERT INTO services (hall_id, name, price_per_person, pricing_type) VALUES (?, ?, ?, ?)`,
    [hallId, name.trim(), price_per_person, pricing_type]
  );

  return { message: "Service added successfully" };
};

exports.updateService = async (serviceId, userId, userRole, data) => {
  const { name, price_per_person } = data;

  // Check if service exists
  const [[service]] = await db.execute(
    `SELECT s.*, h.sub_admin_id FROM services s 
     JOIN wedding_halls h ON s.hall_id = h.id 
     WHERE s.id = ?`,
    [serviceId]
  );

  if (!service) throw new Error("Service not found");

  // Check if user is owner or admin
  if (userRole !== "admin" && service.sub_admin_id !== userId) {
    throw new Error("Unauthorized to update this service");
  }

  // Update the service
  await db.execute(
    `UPDATE services SET name = ?, price_per_person = ?, pricing_type=? WHERE id = ?`,
    [name, price_per_person, serviceId, pricing_type]
  );

  return { message: "Service updated successfully" };
};

exports.getAvailabilityMap = async (hallId, days = 30) => {
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  const endDate = new Date(today);
  endDate.setDate(today.getDate() + days);

  const startStr = today.toISOString().slice(0, 10);
  const endStr = endDate.toISOString().slice(0, 10);

  const [bookings] = await db.execute(
    `SELECT DATE_FORMAT(event_date, '%Y-%m-%d') AS event_date 
     FROM bookings 
     WHERE hall_id = ? 
       AND event_date BETWEEN ? AND ? 
       AND status IN ('pending', 'confirmed')`,
    [hallId, startStr, endStr]
  );

  const bookedDates = new Set(bookings.map(b => b.event_date));

  const availabilityMap = {};
  const current = new Date(today);

  for (let i = 0; i <= days; i++) {
    const dateStr = current.toISOString().slice(0, 10);
    availabilityMap[dateStr] = !bookedDates.has(dateStr); 
    current.setDate(current.getDate() + 1);
  }

  return availabilityMap;
};


exports.getServicesByHallId = async (hallId) => {
  const [services] = await db.execute(
    `SELECT id, name, price_per_person, pricing_type 
     FROM services 
     WHERE hall_id = ? 
     ORDER BY name ASC`,
    [hallId]
  );

  return services;
};

exports.editHall = async (hallId, data, userId, role) => {
  const { name, location, capacity, description } = data;

  // Ownership check (admin can edit anything, sub_admin only their own)
  const [rows] = await db.execute(
    "SELECT sub_admin_id FROM wedding_halls WHERE id = ?",
    [hallId]
  );

  const hall = rows[0];
  if (!hall) throw new Error("Hall not found");

  if (role === "sub_admin" && hall.sub_admin_id !== userId) {
    throw new Error("You do not have permission to edit this hall");
  }

  // Proceed with update
  await db.execute(
    `UPDATE wedding_halls 
     SET name = ?, location = ?, capacity = ?, description = ? 
     WHERE id = ?`,
    [name, location, capacity, description, hallId]
  );

  return { message: "Hall updated successfully" };
};

exports.getPhotosByHallId = async (hallId) => {
  const [photos] = await db.execute(
    `SELECT * FROM hall_photos WHERE hall_id = ?`,
    [hallId]
  );

  return photos.map(p => ({
    id: p.id,
    is_cover: p.is_cover,
    url: `${process.env.BACKEND_URL}${p.photo_url}`
  }));
};

exports.setCoverPhoto = async (photoId, hallId, user) => {
  // Check photo exists and belongs to the hall
  const [[photo]] = await db.execute(
    `SELECT id FROM hall_photos WHERE id = ? AND hall_id = ?`,
    [photoId, hallId]
  );

  if (!photo) throw new Error("Photo not found or doesn't belong to this hall");

  // Ownership check (only owner or admin can update)
  if (user.role === 'sub_admin') {
    const [[hall]] = await db.execute(
      `SELECT sub_admin_id FROM wedding_halls WHERE id = ?`,
      [hallId]
    );
    if (!hall || hall.sub_admin_id !== user.id) {
      throw new Error("You do not have permission to update this hall");
    }
  }

  // Reset other cover flags
  await db.execute(
    `UPDATE hall_photos SET is_cover = FALSE WHERE hall_id = ?`,
    [hallId]
  );

  // Set new cover
  await db.execute(
    `UPDATE hall_photos SET is_cover = TRUE WHERE id = ?`,
    [photoId]
  );

  return { message: "Cover photo updated successfully" };
};
