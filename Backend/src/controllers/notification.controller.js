const db = require('../config/db');

exports.getMyNotifications = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const offset = (page - 1) * limit;

    const [notifications] = await db.execute(
      `SELECT id, message, is_read, created_at
       FROM notifications
       WHERE user_id = ?
       ORDER BY created_at DESC
       LIMIT ? OFFSET ?`,
      [req.user.id, limit, offset]
    );

    const [[{ total }]] = await db.execute(
      `SELECT COUNT(*) AS total FROM notifications WHERE user_id = ?`,
      [req.user.id]
    );

    res.json({
      page,
      limit,
      total,
      data: notifications,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.markAsRead = async (req, res) => {
  try {
    const { id } = req.params;
    await db.execute(
      `UPDATE notifications SET is_read = 1 WHERE id = ? AND user_id = ?`,
      [id, req.user.id]
    );
    res.json({ message: 'Marked as read' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.markAllAsRead = async (req, res) => {
  try {
    await db.execute(`UPDATE notifications SET is_read = 1 WHERE user_id = ?`, [
      req.user.id,
    ]);
    res.json({ message: 'All notifications marked as read' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getUnreadCount = async (req, res) => {
  try {
    const [[{ count }]] = await db.execute(
      `SELECT COUNT(*) AS count FROM notifications WHERE user_id = ? AND is_read = 0`,
      [req.user.id]
    );
    res.json({ count });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getNotificationById = async (req, res) => {
  const { id } = req.params;

  try {
    // Mark as read
    await db.execute(
      `UPDATE notifications SET is_read = 1 WHERE id = ? AND user_id = ?`,
      [id, req.user.id]
    );

    // Return the notification
    const [[notification]] = await db.execute(
      `SELECT * FROM notifications WHERE id = ? AND user_id = ?`,
      [id, req.user.id]
    );

    if (!notification)
      return res.status(404).json({ error: 'Notification not found' });

    res.json(notification);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
