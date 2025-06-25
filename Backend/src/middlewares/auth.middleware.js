const jwt = require('jsonwebtoken');
const db = require('../config/db'); // ✅ REQUIRED

// 🔐 Middleware: Verify JWT and attach user to req
exports.authenticate = async (req, res, next) => {
  try {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) return res.status(401).json({ message: 'Access denied' });

    // 🔑 Decode token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    // 🔍 Validate user + token version
    const [[user]] = await db.execute(
      `SELECT id, role, token_version FROM users WHERE id = ?`,
      [decoded.id]
    );

    if (!user || Number(user.token_version) !== Number(decoded.token_version)) {
  return res.status(401).json({ message: 'Session expired. Please log in again.' });
}


    req.user = {
      id: user.id,
      role: user.role,
      token_version: user.token_version,
    };

    next();
  } catch (err) {
    console.error('JWT Auth Error:', err.message); // ✅ Better debug
    res.status(401).json({ message: 'Invalid token' });
  }
};

// 🔒 Middleware: Role-based access
exports.authorizeRoles = (...roles) => {
  return (req, res, next) => {
    if (!roles.includes(req.user?.role)) {
      return res.status(403).json({
        message: `Forbidden: Requires one of these roles: ${roles.join(', ')}`,
      });
    }
    next();
  };
};
