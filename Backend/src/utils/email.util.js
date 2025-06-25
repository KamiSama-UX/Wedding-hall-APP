const nodemailer = require('nodemailer');
const db = require('../config/db');
require('dotenv').config();

//  Reusable transporter
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});

//  Send with timeout
const sendWithTimeout = (mailOptions, timeoutMs = 10000) => {
  return Promise.race([
    transporter.sendMail(mailOptions),
    new Promise((_, reject) =>
      setTimeout(() => reject(new Error('Email send timed out')), timeoutMs)
    ),
  ]);
};

//  Wrapper function for sending
const sendMail = async ({ to, subject, html }) => {
  const mailOptions = {
    from: `'Wedding Hall App' <${process.env.EMAIL_USER}>`,
    to,
    subject,
    html,
  };

  try {
    await sendWithTimeout(mailOptions);
  } catch (err) {
    console.error(`[Email Error] To: ${to} | Subject: ${subject} | ${err.message}`);
  }
};

exports.sendMail = sendMail;

//  Booking confirmation to customer
exports.sendBookingConfirmation = async (userId, hallId, event_date, event_time) => {
  try {
    const [[user]] = await db.execute('SELECT name, email FROM users WHERE id = ?', [userId]);
    const [[hall]] = await db.execute('SELECT name FROM wedding_halls WHERE id = ?', [hallId]);

    await sendMail({
      to: user.email,
      subject: 'Your Booking is Pending Confirmation',
      html: `
        <p>Hi ${user.name},</p>
        <p>Thank you for booking <strong>${hall.name}</strong> on <strong>${event_date}</strong> at <strong>${event_time}</strong>.</p>
        <p>Status: <strong>Pending</strong></p>
        <p>We will notify you once it’s confirmed.</p>
      `,
    });
  } catch (err) {
    console.error('[sendBookingConfirmation Error]', err.message);
  }
};

//  Booking alert to manager
exports.notifyHallManager = async (hallId, customerId, event_date, event_time) => {
  try {
    const [[hall]] = await db.execute(
      `SELECT h.name AS hall_name, u.email, u.name AS manager_name
       FROM wedding_halls h
       JOIN users u ON h.sub_admin_id = u.id
       WHERE h.id = ?`,
      [hallId]
    );

    const [[customer]] = await db.execute(
      'SELECT name, email FROM users WHERE id = ?',
      [customerId]
    );

    await sendMail({
      to: hall.email,
      subject: `📅 New Booking for ${hall.hall_name}`,
      html: `
        <p>Hello ${hall.manager_name},</p>
        <p>A new booking was placed by <strong>${customer.name}</strong>:</p>
        <ul>
          <li>Hall: ${hall.hall_name}</li>
          <li>Date: ${event_date}</li>
          <li>Time: ${event_time}</li>
          <li>Customer Email: ${customer.email}</li>
        </ul>
        <p>Please review and confirm or decline the booking in the admin dashboard.</p>
      `,
    });
  } catch (err) {
    console.error('[notifyHallManager Error]', err.message);
  }
};

//  OTP for password reset
exports.sendPasswordResetOTPEmail = async (to, code) => {
  await sendMail({
    to,
    subject: 'Reset Your Password',
    html: `
      <p>You requested a password reset.</p>
      <p>Your reset OTP is:</p>
      <h2>${code}</h2>
      <p>This code will expire in 15 minutes.</p>
    `,
  });
};

// OTP for verification
exports.sendVerificationOTPEmail = async (to, code) => {
  await sendMail({
    to,
    subject: 'Verify Your Email',
    html: `
      <p>Your email verification OTP is:</p>
      <h2>${code}</h2>
      <p>This code will expire in 15 minutes.</p>
    `,
  });
};

// const nodemailer = require('nodemailer');
// require('dotenv').config();
// const db = require('../config/db');
// const sendMail = async ({ to, subject, html }) => {
//   const mailOptions = {
//     from: `'Wedding Hall App' <${process.env.EMAIL_USER}>`,
//     to,
//     subject,
//     html,
//   };

//   await transporter.sendMail(mailOptions);
// };

// exports.sendMail = sendMail;

// const transporter = nodemailer.createTransport({
//   service: 'gmail', // or use SMTP settings
//   auth: {
//     user: process.env.EMAIL_USER,
//     pass: process.env.EMAIL_PASS,
//   },
// });

// // exports.sendVerificationEmail = async (to, token) => {
// //   const verifyUrl = `${process.env.FRONTEND_URL}/verify-email?token=${token}`;

// //   const mailOptions = {
// //     from: `'Wedding Hall App' <${process.env.EMAIL_USER}>`,
// //     to,
// //     subject: 'Verify Your Email',
// //     html: `
// //       <p>Please verify your email by clicking the link below:</p>
// //       <a href='${verifyUrl}'>Verify Email</a>
// //       <p>This link expires in 1 hour.</p>
// //     `
// //   };

// //   await transporter.sendMail(mailOptions);
// // };

// exports.sendBookingConfirmation = async (
//   userId,
//   hallId,
//   event_date,
//   event_time
// ) => {
//   // Get user and hall info
//   const [[user]] = await db.execute(
//     'SELECT name, email FROM users WHERE id = ?',
//     [userId]
//   );
//   const [[hall]] = await db.execute(
//     'SELECT name FROM wedding_halls WHERE id = ?',
//     [hallId]
//   );

//   const mailOptions = {
//     from: `'Wedding Hall Booking' <${process.env.EMAIL_USER}>`,
//     to: user.email,
//     subject: 'Your Booking is Pending Confirmation',
//     html: `
//       <p>Hi ${user.name},</p>
//       <p>Thank you for booking <strong>${hall.name}</strong> on <strong>${event_date}</strong> at <strong>${event_time}</strong>.</p>
//       <p>Status: <strong>Pending</strong></p>
//       <p>We will notify you once it’s confirmed.</p>
//     `,
//   };

//   await transporter.sendMail(mailOptions);
// };

// exports.notifyHallManager = async (
//   hallId,
//   customerId,
//   event_date,
//   event_time
// ) => {
//   // Get hall + sub_admin info
//   const [[hall]] = await db.execute(
//     `SELECT h.name AS hall_name, u.email, u.name AS manager_name
//      FROM wedding_halls h
//      JOIN users u ON h.sub_admin_id = u.id
//      WHERE h.id = ?`,
//     [hallId]
//   );

//   // Get customer info
//   const [[customer]] = await db.execute(
//     `SELECT name, email FROM users WHERE id = ?`,
//     [customerId]
//   );

//   const mailOptions = {
//     from: `'Wedding Hall Booking' <${process.env.EMAIL_USER}>`,
//     to: hall.email,
//     subject: `📅 New Booking for ${hall.hall_name}`,
//     html: `
//       <p>Hello ${hall.manager_name},</p>
//       <p>A new booking was placed by <strong>${customer.name}</strong>:</p>
//       <ul>
//         <li>Hall: ${hall.hall_name}</li>
//         <li>Date: ${event_date}</li>
//         <li>Time: ${event_time}</li>
//         <li>Customer Email: ${customer.email}</li>
//       </ul>
//       <p>Please review and confirm or decline the booking in the admin dashboard.</p>
//     `,
//   };

//   await transporter.sendMail(mailOptions);
// };

// // exports.sendPasswordResetEmail = async (to, token) => {
// //   const resetUrl = `${process.env.FRONTEND_URL}/reset-password?token=${token}`;

// //   const mailOptions = {
// //     from: `'Wedding Hall Support' <${process.env.EMAIL_USER}>`,
// //     to,
// //     subject: 'Reset Your Password',
// //     html: `
// //       <p>You requested a password reset.</p>
// //       <p>Click below to reset your password:</p>
// //       <a href='${resetUrl}'>Reset Password</a>
// //       <p>This link expires in 15 minutes.</p>
// //     `
// //   };

// //   await transporter.sendMail(mailOptions);
// // };

// exports.sendPasswordResetOTPEmail = async (to, code) => {
//   const mailOptions = {
//     from: `'Wedding Hall Support' <${process.env.EMAIL_USER}>`,
//     to,
//     subject: 'Reset Your Password',
//     html: `
//       <p>You requested a password reset.</p>
//       <p>Your reset OTP is:</p>
//       <h2>${code}</h2>
//       <p>This code will expire in 15 minutes.</p>
//     `,
//   };

//   await transporter.sendMail(mailOptions);
// };

// exports.sendPasswordResetOTPEmail = async (to, code) => {
//   const mailOptions = {
//     from: `'Wedding Hall Support' <${process.env.EMAIL_USER}>`,
//     to,
//     subject: 'Reset Your Password',
//     html: `
//       <p>You requested a password reset.</p>
//       <p>Your reset OTP is:</p>
//       <h2>${code}</h2>
//       <p>This code will expire in 15 minutes.</p>
//     `,
//   };

//   await transporter.sendMail(mailOptions);
// };

// exports.sendVerificationOTPEmail = async (to, code) => {
//   const html = `
//     <p>Your email verification OTP is:</p>
//     <h2>${code}</h2>
//     <p>This code will expire in 15 minutes.</p>
//   `;

//   await sendMail({
//     to,
//     subject: 'Verify Your Email',
//     html,
//   });
// };
