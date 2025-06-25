const rateLimit = require('express-rate-limit');

// Global limiter (default: 100 requests per 15 minutes)
exports.globalLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 5000,
  message: 'Too many requests from this IP. Please try again later.',
});

// Strict limiter for auth (e.g., login)
exports.authLimiter = rateLimit({
  windowMs: 10 * 60 * 1000,
  max: 5000,
  message: 'Too many login attempts. Try again after 10 minutes.',
});

// Password reset limiter
exports.resetLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 5000,
  message: 'Too many reset requests. Try again later.',
});

// Limit sending OTP to 3 times per 15 minutes
exports.otpSendLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 mins
  max: 5000,
  message: 'Too many OTP requests. Please try again later.',
  standardHeaders: true,
  legacyHeaders: false,
});

// Limit verifying OTP to 5 attempts per 15 minutes
exports.otpVerifyLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 mins
  max: 5000,
  message: 'Too many OTP verification attempts. Please try again later.',
  standardHeaders: true,
  legacyHeaders: false,
});
