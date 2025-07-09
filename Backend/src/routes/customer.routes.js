const express = require('express');
const router = express.Router();
const customerController = require('../controllers/customer.controller');
const {
  authenticate,
  authorizeRoles,
} = require('../middlewares/auth.middleware');
const { validateUpdateProfile } = require('../validations/user.validation');
const { validatePasswordChange } = require('../validations/user.validation');

router.use(authenticate, authorizeRoles('customer'));
router.put(
  '/change-password',
  validatePasswordChange,
  customerController.changePassword
);
router.get('/profile', customerController.getProfile);
router.put('/profile', validateUpdateProfile, customerController.updateProfile);
router.get('/bookings', customerController.getBookings);
router.get('/favorites', customerController.getFavorites);
router.post('/favorites/:hallId', customerController.saveHall);
router.delete('/favorites/:hallId', customerController.removeSavedHall);
router.get('/my-bookings', customerController.getMyBookings);

module.exports = router;
