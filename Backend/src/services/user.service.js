const db = require("../config/db");
const bcrypt = require("bcryptjs");

exports.createUser = async ({ name, email, password, role }) => {
  // Check if role is valid
  if (!["admin", "sub_admin"].includes(role)) {
    throw new Error("Invalid role");
  }

  // Prevent duplicate emails
  const [existing] = await db.execute("SELECT id FROM users WHERE email = ?", [
    email,
  ]);
  if (existing.length > 0) throw new Error("Email already exists");

  const hashedPassword = await bcrypt.hash(password, 10);

  const [result] = await db.execute(
    `INSERT INTO users (name, email, password_hash, role) VALUES (?, ?, ?, ?)`,
    [name, email, hashedPassword, role]
  );

  return { id: result.insertId, name, email, role };
};
