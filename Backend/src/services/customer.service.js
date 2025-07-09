const db = require("../config/db");
const bcrypt = require("bcrypt");
const { sendMail } = require("../utils/email.util");
const { logAction } = require("../utils/log.util");

exports.changePassword = async (userId, currentPassword, newPassword) => {
  const [[user]] = await db.execute(
    `SELECT password_hash FROM users WHERE id = ? AND role = 'customer'`,
    [userId]
  );

  if (!user) throw new Error("User not found");

  const match = await bcrypt.compare(currentPassword, user.password_hash);
  if (!match) throw new Error("Current password is incorrect");

  const hashed = await bcrypt.hash(newPassword, 10);

  await db.execute(
    `UPDATE users SET password_hash = ?, token_version = token_version + 1 WHERE id = ?`,
    [hashed, userId]
  );
  await logAction({
    actor_id: userId,
    action: "changed_password",
    target_type: "user",
    target_id: userId,
    description: `Customer ${userId} changed their password`,
  });

  const [[customer]] = await db.execute(
    `SELECT name, email FROM users WHERE id = ?`,
    [userId]
  );

  await sendMail({
    to: customer.email,
    subject: "Your password has been changed",
    html: `
    <p>Hello ${customer.name},</p>
    <p>This is a confirmation that your password was successfully changed.</p>
    <p>If you didn’t do this, please contact support immediately.</p>
  `,
  });
};

exports.getProfile = async (id) => {
  const [[user]] = await db.execute(
    `SELECT id, name, email, role, created_at FROM users WHERE id = ? AND role = 'customer'`,
    [id]
  );
  return user;
};

exports.updateProfile = async (id, data) => {
  const { name, email } = data;
  await db.execute(
    `UPDATE users SET name = ?, email = ? WHERE id = ? AND role = 'customer'`,
    [name, email, id]
  );
  await logAction({
    actor_id: id,
    action: "updated_profile",
    target_type: "user",
    target_id: id,
    description: `Customer ${id} updated their profile`,
  });
  return { id, name, email };
};

exports.getBookings = async (customerId) => {
  const [rows] = await db.execute(
    `
    SELECT b.id, h.name AS hall, b.event_date, b.event_time, b.guest_count, b.status
    FROM bookings b
    JOIN wedding_halls h ON h.id = b.hall_id
    WHERE b.customer_id = ?
    ORDER BY b.event_date DESC
  `,
    [customerId]
  );
  return rows;
};

exports.saveHall = async (userId, hallId) => {
  await db.execute(
    `INSERT IGNORE INTO saved_halls (user_id, hall_id) VALUES (?, ?)`,
    [userId, hallId]
  );
};

exports.removeSavedHall = async (userId, hallId) => {
  await db.execute(
    `DELETE FROM saved_halls WHERE user_id = ? AND hall_id = ?`,
    [userId, hallId]
  );
};

exports.getFavorites = async (userId, page = 1, limit = 10) => {
  const offset = (page - 1) * limit;

  const [favorites] = await db.execute(
    `
    SELECT h.id, h.name, h.location, h.capacity, h.description
    FROM saved_halls s
    JOIN wedding_halls h ON s.hall_id = h.id
    WHERE s.user_id = ?
    ORDER BY s.created_at DESC
    LIMIT ? OFFSET ?
    `,
    [userId, limit, offset]
  );

  const [[{ total }]] = await db.execute(
    `SELECT COUNT(*) as total FROM saved_halls WHERE user_id = ?`,
    [userId]
  );

  return {
    total,
    page,
    limit,
    data: favorites,
  };
};

exports.getMyBookings = async (customerId, filters = {}) => {
  let query = `
    SELECT 
      b.id, b.hall_id, h.name AS hall_name, h.location, 
      b.event_date, b.event_time, b.guest_count, b.status, b.created_at
    FROM bookings b
    JOIN wedding_halls h ON h.id = b.hall_id
    WHERE b.customer_id = ?
  `;

  const params = [customerId];

  if (filters.status) {
    query += ` AND b.status = ?`;
    params.push(filters.status);
  }

  if (filters.from) {
    query += ` AND b.event_date >= ?`;
    params.push(filters.from);
  }

  if (filters.to) {
    query += ` AND b.event_date <= ?`;
    params.push(filters.to);
  }

  query += ` ORDER BY b.event_date DESC`;

  const [rows] = await db.execute(query, params);
  return rows;
};
