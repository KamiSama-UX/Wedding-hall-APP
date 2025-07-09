const db = require('../config/db');

/**
 * 🛎️ Create a new notification
 * @param {number} userId - Target user ID
 * @param {string} message - Notification message content
 * @param {number|null} relatedBookingId - Related booking ID (optional)
 * @param {'booking'|'system'|'reminder'|'custom'} type - Notification type
 */
exports.createNotification = async (
  userId,
  message,
  relatedBookingId = null,
  type = 'booking'
) => {
  try {
    await db.execute(
      `INSERT INTO notifications (user_id, message, related_booking_id, type)
       VALUES (?, ?, ?, ?)`,
      [userId, message, relatedBookingId, type]
    );

     // Emit real-time if available
  exports.sendNotificationWS(userId, { message, relatedBookingId, type });
  
 if (global.io) {
    global.io.to(`user:${userId}`).emit('notification', notification);
  }
  } catch (err) {
    console.error('[Notification Error]', err.message);
    throw new Error('Failed to create notification');
  }
};

/**
 * 📡 Send WebSocket notification to connected client
 * (requires global.io to be set via Socket.IO setup)
 * @param {number} userId - Target user ID
 * @param {Object} notification - Notification payload
 */
exports.sendNotificationWS = (userId, notification) => {
  if (global.io) {
    global.io.emit(`notification:${userId}`, notification);
  }
};
