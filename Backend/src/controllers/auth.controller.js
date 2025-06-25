const authService = require('../services/auth.service');
const userService = require('../services/user.service');
const jwt = require('jsonwebtoken');
const db = require('../config/db');
// const { sendPasswordResetEmail } = require('../utils/email.util');
// const bcrypt = require('bcrypt');

exports.loginWithToken = async (req, res) => {
  try {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) return res.status(401).json({ error: 'Token missing' });
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const user = await authService.getUserFromToken(decoded);

    res.json({ user });
  } catch (err) {
    res.status(401).json({ error: 'Invalid or expired token' });
  }
};
exports.register = async (req, res) => {
  try {
    const user = await authService.register(req.body);
    res.status(201).json(user);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.login = async (req, res) => {
  try {
    const { token, user } = await authService.login(req.body);
    res.json({ token, user });
  } catch (err) {
    res.status(401).json({ error: err.message });
  }
};

exports.getMe = async (req, res) => {
  try {
    res.json({ user: req.user });
  } catch (err) {
    res.status(500).json({ error: 'Something went wrong' });
  }
};

exports.createUser = async (req, res) => {
  try {
    const user = await userService.createUser(req.body);
    res.status(201).json(user);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

// exports.verifyEmail = async (req, res) => {
//   const token = req.query.token;
//   if (!token) return res.status(400).json({ error: 'Missing token' });

//   try {
//     const payload = jwt.verify(token, process.env.JWT_EMAIL_SECRET);
//     await db.execute(`UPDATE users SET is_verified = 1 WHERE id = ?`, [payload.id]);
//     res.json({ message: 'Email verified successfully' });
//   } catch (err) {
//     res.status(400).json({ error: 'Invalid or expired token' });
//   }
// };

// exports.forgotPassword = async (req, res) => {
//   const { email } = req.body;

//   const [[user]] = await db.execute('SELECT id FROM users WHERE email = ?', [email]);
//   if (!user) return res.status(404).json({ error: 'No user with that email' });

//   const token = jwt.sign({ id: user.id }, process.env.JWT_RESET_SECRET, { expiresIn: '15m' });

//   await sendPasswordResetEmail(email, token);
//   res.json({ message: 'Password reset link sent to your email' });
// };

// exports.resetPassword = async (req, res) => {
//   const { token, newPassword } = req.body;

//   try {
//     const payload = jwt.verify(token, process.env.JWT_RESET_SECRET);
//     const hashed = await bcrypt.hash(newPassword, 10);

//     await db.execute(
//       `UPDATE users SET password_hash = ? WHERE id = ?`,
//       [hashed, payload.id]
//     );

// exports.resetPassword = async (req, res) => {
//   const { token, newPassword } = req.body;

//   try {
//     const payload = jwt.verify(token, process.env.JWT_RESET_SECRET);
//     const hashed = await bcrypt.hash(newPassword, 10);

//     await db.execute(
//       `UPDATE users SET password_hash = ? WHERE id = ?`,
//       [hashed, payload.id]
//     );

//     // Get fresh user data and sign a new auth token
//     const [[user]] = await db.execute(
//       `SELECT id, name, email, role, created_at, updated_at
//        FROM users WHERE id = ?`, [payload.id]
//     );

//     const authToken = jwt.sign(
//       { id: user.id, role: user.role },
//       process.env.JWT_SECRET,
//       { expiresIn: '1d' }
//     );

//     res.json({ message: 'Password updated and logged in', token: authToken, user });
//   } catch (err) {
//     res.status(400).json({ error: 'Invalid or expired token' });
//   }
// };

//   } catch (err) {
//     res.status(400).json({ error: 'Invalid or expired token' });
//   }
// };

// exports.resendVerification = async (req, res) => {
//   try {
//     const { email } = req.body;
//     if (!email) return res.status(400).json({ error: 'Email is required' });

//     const result = await authService.resendVerification(email);
//     res.json(result);
//   } catch (err) {
//     res.status(400).json({ error: err.message });
//   }
// };

exports.resendOTP = async (req, res) => {
  try {
    const { email } = req.body;
    if (!email) return res.status(400).json({ error: 'Email is required' });

    const result = await authService.sendVerificationOTP(email);
    res.json(result);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.verifyEmailWithOTP = async (req, res) => {
  try {
    const { email, code } = req.body;

    const [[user]] = await db.execute(`SELECT id FROM users WHERE email = ?`, [
      email,
    ]);
    if (!user) return res.status(404).json({ error: 'User not found' });

    const [[match]] = await db.execute(
      `
      SELECT id FROM email_verification_codes
      WHERE user_id = ? AND code = ? AND expires_at > NOW()
    `,
      [user.id, code]
    );

    if (!match)
      return res.status(400).json({ error: 'Invalid or expired code' });

    await db.execute(`UPDATE users SET is_verified = 1 WHERE id = ?`, [
      user.id,
    ]);
    await db.execute(`DELETE FROM email_verification_codes WHERE user_id = ?`, [
      user.id,
    ]);

    res.json({ message: 'Email verified successfully' });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.sendResetOTP = async (req, res) => {
  try {
    const result = await authService.sendPasswordResetOTP(req.body.email);
    res.json(result);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.verifyResetOTP = async (req, res) => {
  try {
    const result = await authService.verifyPasswordResetOTP(
      req.body.email,
      req.body.code
    );
    res.json({ verified: true });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.resetPasswordWithOTP = async (req, res) => {
  try {
    const { email, newPassword } = req.body;
    const result = await authService.resetPasswordWithOTP(email, newPassword);
    res.json(result);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};
