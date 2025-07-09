const express = require('express');
const router = express.Router();
const adminController = require('../controllers/admin.controller');
const {
  authenticate,
  authorizeRoles,
} = require('../middlewares/auth.middleware');
const authController = require('../controllers/auth.controller');
router.use(authenticate, authorizeRoles('admin'));

router.get('/stats', adminController.getStats);

// List bookings (optional ?status=confirmed)
router.get('/bookings', adminController.getAllBookings);

// Update status (confirm, decline, cancel)
router.patch(
  '/bookings/:id/status',
  adminController.updateBookingStatus
);

router.get(
  '/charts/bookings',
  adminController.getBookingBreakdown
);

router.get('/customers', adminController.getCustomers);

router.get('/sub-admins', adminController.getSubAdmins);

router.get('/notifications', adminController.getAllNotifications);

router.get('/logs', adminController.getLogs);

router.get(
  '/bookings/recent',
  adminController.getRecentBookings
);

router.get(
  '/charts/bookings-per-day',
  adminController.getBookingsPerDay
);
module.exports = router;
