const db = require('../config/db');

exports.logAction = async ({
  actor_id,
  action,
  target_type,
  target_id,
  description,
}) => {
  await db.execute(
    `INSERT INTO logs (actor_id, action, target_type, target_id, description)
     VALUES (?, ?, ?, ?, ?)`,
    [actor_id, action, target_type, target_id, description]
  );
};
