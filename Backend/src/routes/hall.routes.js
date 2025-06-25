const express = require('express');
const router = express.Router();
const hallController = require('../controllers/hall.controller');
const {
  authenticate,
  authorizeRoles,
} = require('../middlewares/auth.middleware');
const upload = require('../middlewares/upload.middleware');
const { validateCreateHall } = require('../validations/hall.validation');
const {
  handleValidationErrors,
} = require('../middlewares/validation.middleware');

// Upload hall photo (sub_admin and admin only)
router.post(
  '/:hallId/photos',
  authenticate,
  authorizeRoles('admin', 'sub_admin'),
  upload.single('photo'),
  hallController.uploadPhoto
);

router.get(
  '/my-halls',
  authenticate,
  authorizeRoles('sub_admin'),
  hallController.getHallsBySubAdmin
);

router.get(
  '/',
  authenticate,
  authorizeRoles('admin'),
  hallController.getAllHalls
);

router.delete(
  '/:id',
  authenticate,
  authorizeRoles('admin', 'sub_admin'),
  hallController.deleteHall
);

// Reassign hall to another sub_admin (admin only)
router.patch(
  '/:id/reassign',
  authenticate,
  authorizeRoles('admin'),
  hallController.reassignHall
);

router.post(
  '/create',
  authenticate,
  authorizeRoles('admin'),
  validateCreateHall,
  handleValidationErrors, // must come after validators
  hallController.createHall
);

router.get('/all', hallController.getAllHalls);

router.get('/:id', hallController.getHallById);

router.get('/Top/halls', hallController.getTopHalls);

router.get('/Trend/halls', hallController.getBookingTrend);

router.post(
  '/:hallId/services',
  authenticate,
  authorizeRoles('admin', 'sub_admin'),
  hallController.addServiceToHall
);

router.post('/availability', hallController.getAvailability);

router.get('/hall/:hallId', hallController.getServicesByHallId);

router.get('/:hallId/services', hallController.getServicesByHallId);

router.put(
  '/:serviceId/services',
  authenticate,
  authorizeRoles('admin', 'sub_admin'),
  hallController.updateService
);

router.post(
  '/:hallId/services',
  authenticate,
  authorizeRoles('admin', 'sub_admin'),
  hallController.addServiceToHall
);

router.get('/:hallId/services', hallController.getServicesByHallId);

router.put(
  '/:id',
  authenticate,
  authorizeRoles('admin', 'sub_admin'),
  hallController.editHall
);

router.get('/:hallId/photos', hallController.getHallPhotos);

router.patch(
  '/:hallId/photos/:photoId/cover',
  authenticate,
  authorizeRoles('admin', 'sub_admin'),
  hallController.setCoverPhoto
);

router.delete(
  '/:hallId/photos/:photoId',
  authenticate,
  authorizeRoles('admin', 'sub_admin'),
  hallController.deleteHallPhoto
);


module.exports = router;
