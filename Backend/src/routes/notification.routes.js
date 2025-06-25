const express = require('express');
const router = express.Router();
const notificationController = require('../controllers/notification.controller');
const { authenticate } = require('../middlewares/auth.middleware');

router.get('/', authenticate, notificationController.getMyNotifications);
router.patch('/:id/read', authenticate, notificationController.markAsRead);
router.patch(
  '/mark-all-read',
  authenticate,
  notificationController.markAllAsRead
);
router.get(
  '/unread-count',
  authenticate,
  notificationController.getUnreadCount
);
router.get('/:id', authenticate, notificationController.getNotificationById);

module.exports = router;
