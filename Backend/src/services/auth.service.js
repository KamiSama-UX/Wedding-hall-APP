const db = require("../config/db");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
// const { sendVerificationEmail } = require('../utils/email.util');
const { generateOTP, code } = require("../utils/otp.util");
const {
  sendVerificationOTPEmail,
  sendPasswordResetOTPEmail,
} = require("../utils/email.util");

exports.register = async ({ name, email, password }) => {
  const [existing] = await db.execute(`SELECT id FROM users WHERE email = ?`, [
    email,
  ]);
  if (existing.length > 0) throw new Error("Email already exists");

  const hashed = await bcrypt.hash(password, 10);

  const [result] = await db.execute(
    `INSERT INTO users (name, email, password_hash, role) VALUES (?, ?, ?, ?)`,
    [name, email, hashed, "customer"]
  );

  const userId = result.insertId;

  //  Send OTP for verification
  await exports.sendVerificationOTP(email, code);

  return {
    id: userId,
    name,
    email,
    role: "customer",
    message: "Verification code sent to email",
  };
};

exports.login = async ({ email, password }) => {
  const [rows] = await db.execute(`SELECT * FROM users WHERE email = ?`, [
    email,
  ]);
  const user = rows[0];

  if (!user.is_verified) {
    throw new Error("Please verify your email before logging in");
  }

  if (!user) throw new Error("Invalid credentials");

  const isMatch = await bcrypt.compare(password, user.password_hash);
  if (!isMatch) throw new Error("Invalid credentials");

const token = jwt.sign(
  {
    id: user.id,
    role: user.role,
    token_version: Number(user.token_version), // FIX HERE
  },
  process.env.JWT_SECRET,
  { expiresIn: '1h' }
);
  // Hide hash before returning
  delete user.password_hash;

  return { token, user };
};

exports.createUser = async ({ name, email, password, role }) => {
  //  Check if role is valid
  if (!["admin", "sub_admin"].includes(role)) {
    throw new Error("Invalid role");
  }

  //  Prevent duplicate emails
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

exports.sendPasswordResetOTP = async (email) => {
  const [[user]] = await db.execute(`SELECT id FROM users WHERE email = ?`, [
    email,
  ]);
  if (!user) throw new Error("No user with that email");

  const code = generateOTP(6);
  const expiresAt = new Date(Date.now() + 15 * 60 * 1000); // 15 minutes

  await db.execute(`DELETE FROM password_reset_codes WHERE user_id = ?`, [
    user.id,
  ]); // cleanup
  await db.execute(
    `INSERT INTO password_reset_codes (user_id, code, expires_at) VALUES (?, ?, ?)`,
    [user.id, code, expiresAt]
  );

  await sendPasswordResetOTPEmail(email, code);

  return { message: "Reset code sent to email" };
};

// exports.resendVerification = async (email) => {
//   const [[user]] = await db.execute(`SELECT id, is_verified FROM users WHERE email = ?`, [email]);
//   if (!user) throw new Error('User not found');
//   if (user.is_verified) throw new Error('Email already verified');

//   const token = jwt.sign({ id: user.id }, process.env.JWT_EMAIL_SECRET, { expiresIn: '1h' });

//   await sendVerificationEmail(email, token);
//   return { message: 'Verification email resent' };
// };

exports.sendVerificationOTP = async (email) => {
  const [[user]] = await db.execute(
    `SELECT id, is_verified FROM users WHERE email = ?`,
    [email]
  );

  if (!user) throw new Error("User not found");
  if (user.is_verified) throw new Error("User is already verified");

  const code = generateOTP(6);
  const expiresAt = new Date(Date.now() + 15 * 60 * 1000); // 15 mins

  // Remove old OTPs (optional cleanup)
  await db.execute(`DELETE FROM email_verification_codes WHERE user_id = ?`, [
    user.id,
  ]);

  await db.execute(
    `INSERT INTO email_verification_codes (user_id, code, expires_at) VALUES (?, ?, ?)`,
    [user.id, code, expiresAt]
  );

  await sendVerificationOTPEmail(email, code);

  return { message: "Verification code sent to email" };
};

exports.verifyEmailWithOTP = async (req, res) => {
  const { email, code } = req.body;

  const [[user]] = await db.execute(`SELECT id FROM users WHERE email = ?`, [
    email,
  ]);

  if (!user) return res.status(404).json({ error: "User not found" });

  const [[otpEntry]] = await db.execute(
    `
    SELECT * FROM email_verification_codes
    WHERE user_id = ? AND code = ? AND expires_at > NOW()
  `,
    [user.id, code]
  );

  if (!otpEntry)
    return res.status(400).json({ error: "Invalid or expired code" });

  await db.execute(`UPDATE users SET is_verified = 1 WHERE id = ?`, [user.id]);
  await db.execute(`DELETE FROM email_verification_codes WHERE user_id = ?`, [
    user.id,
  ]);

  res.json({ message: "Email verified successfully" });
};

exports.verifyPasswordResetOTP = async (email, code) => {
  const [[user]] = await db.execute(`SELECT id FROM users WHERE email = ?`, [
    email,
  ]);
  if (!user) throw new Error("User not found");

  const [[match]] = await db.execute(
    `
    SELECT id FROM password_reset_codes 
    WHERE user_id = ? AND code = ? AND expires_at > NOW()
  `,
    [user.id, code]
  );

  if (!match) throw new Error("Invalid or expired OTP");

  return { userId: user.id };
};

exports.resetPasswordWithOTP = async (email, newPassword) => {
  const [[user]] = await db.execute(`SELECT id FROM users WHERE email = ?`, [
    email,
  ]);
  if (!user) throw new Error("User not found");

  const hashed = await bcrypt.hash(newPassword, 10);

  await db.execute(
    `UPDATE users SET password_hash = ?, token_version = token_version + 1 WHERE id = ?`,
    [hashed, user.id]
  );
  await db.execute(`DELETE FROM password_reset_codes WHERE user_id = ?`, [
    user.id,
  ]);

  return { message: "Password updated successfully" };
};

exports.getUserFromToken = async (decoded) => {
  const { id, role, token_version } = decoded;

  const [[user]] = await db.execute(
    `SELECT id, name, email, role, token_version, is_verified FROM users WHERE id = ?`,
    [id]
  );

if (!user || Number(user.token_version) !== Number(token_version)) {
  throw new Error('Invalid or expired token');
}
  delete user.password_hash;
  return user;
};
