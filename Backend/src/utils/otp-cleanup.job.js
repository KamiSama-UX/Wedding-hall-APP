const cron = require('node-cron');
const db = require('../config/db');

// Run every 15 minutes
cron.schedule('*/15 * * * *', async () => {
  try {
    await db.execute(
      'DELETE FROM email_verification_codes WHERE expires_at < NOW()'
    );
    await db.execute(
      'DELETE FROM password_reset_codes WHERE expires_at < NOW()'
    );
    console.log('✅ OTP cleanup job ran successfully');
  } catch (err) {
    console.error('❌ OTP cleanup job failed:', err.message);
  }
});
