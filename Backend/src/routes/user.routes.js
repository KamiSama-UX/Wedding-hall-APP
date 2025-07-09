const express = require('express');
const router = express.Router();
const userController = require('../controllers/user.controller');
const {
  authenticate,
  authorizeRoles,
} = require('../middlewares/auth.middleware');
const { validateAdminUser } = require('../validations/user.validation');

router.post(
  '/create',
  authenticate,
  authorizeRoles('admin'),
  validateAdminUser,
  userController.createUser
);

module.exports = router;
