const express = require('express');
const router = express.Router();
const bookingController = require('../controllers/booking.controller');
const {
  authenticate,
  authorizeRoles,
} = require('../middlewares/auth.middleware');

// Create booking service_ids must be passed as an array in the booking request body.

// Each service's price is fetched and stored at the time of booking for historical accuracy (from services into booking_services).

// Validation ensures selected services belong to the same hall_id.
router.post(
  '/',
  authenticate,
  authorizeRoles('customer'),
  bookingController.createBooking
);

// View personal booking history
router.get(
  '/my-bookings',
  authenticate,
  authorizeRoles('customer'),
  bookingController.getMyBookings
);

// Update booking status (admin/sub_admin)
router.patch(
  '/:id/status',
  authenticate,
  authorizeRoles('admin', 'sub_admin'),
  bookingController.updateStatus
);

// Cancel by customer
router.patch(
  '/:id/cancel',
  authenticate,
  authorizeRoles('customer'),
  bookingController.cancelBooking
);

// Hard delete by admin or sub_admin
router.delete(
  '/:id',
  authenticate,
  authorizeRoles('admin', 'sub_admin'),
  bookingController.deleteBooking
);

router.put(
  '/:id',
  authenticate,
  authorizeRoles('customer'),
  bookingController.updateBooking
);

module.exports = router;
