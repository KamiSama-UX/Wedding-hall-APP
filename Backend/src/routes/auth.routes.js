const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth.controller');
const {
  validateRegister,
  validateLogin,
} = require('../validations/auth.validation');
const {
  authenticate,
  authorizeRoles,
} = require('../middlewares/auth.middleware');
const { validateAdminUser } = require('../validations/user.validation');
const {
  authLimiter,
  resetLimiter,
  otpSendLimiter,
  otpVerifyLimiter,
} = require('../middlewares/rate-limit.middleware');

router.post(
  '/admin/create',
  authenticate,
  authorizeRoles('admin'),
  validateAdminUser,
  authController.createUser
);
// router.get('/verify-email', authController.verifyEmail);
router.post('/register', validateRegister, authController.register);
router.get('/me', authenticate, authController.getMe);
// router.post('/reset-password', authController.resetPassword);
// ⏱️ Login abuse protection
router.post('/login', authLimiter, validateLogin, authController.login);
// ⏱️ Forgot password abuse protection
// router.post('/forgot-password', resetLimiter, authController.forgotPassword);
router.post('/resend-otp', authController.resendOTP);
router.post(
  '/verify-email-otp',
  otpVerifyLimiter,
  authController.verifyEmailWithOTP
);
router.post('/reset/send-otp', otpSendLimiter, authController.sendResetOTP);
router.post(
  '/reset/verify-otp',
  otpVerifyLimiter,
  authController.verifyResetOTP
);
router.post('/reset-password', authController.resetPasswordWithOTP);

router.get('/token-login', authController.loginWithToken);


module.exports = router;
