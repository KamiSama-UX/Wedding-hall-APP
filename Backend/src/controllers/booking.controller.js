const db = require('../config/db');
const { sendBookingConfirmation, notifyHallManager } = require('../utils/email.util');
const { createNotification } = require('../utils/notification.util');
const { logAction } = require('../utils/log.util');
const bookingService = require('../services/booking.service');
const parseTime = (t) => {
  const [h, m] = t.split(':');
  return parseInt(h) * 60 + parseInt(m); // total minutes
};
const jwt = require('jsonwebtoken');

exports.getMyBookings = async (req, res) => {
  try {
    const bookings = await bookingService.getMyBookings(req.user.id);
    res.json(bookings);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.updateStatus = async (req, res) => {
  try {
    const { status } = req.body;
    const { id } = req.params;
    const result = await bookingService.updateStatus(id, status, req.user);
    res.json(result);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.cancelBooking = async (req, res) => {
  try {
    const result = await bookingService.cancelBooking(
      req.params.id,
      req.user.id,
      req.user
    );
    res.json(result);
  } catch (err) {
    res.status(403).json({ error: err.message });
  }
};

exports.deleteBooking = async (req, res) => {
  try {
    const result = await bookingService.deleteBooking(req.params.id, req.user);
    res.json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.createBooking = async (req, res) => {
  try {
     const token = req.headers.authorization?.split(' ')[1];
        if (!token) return res.status(401).json({ error: 'Token missing' });
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const bookingData = req.body;

    const result = await bookingService.createBooking(bookingData, decoded);
    res.status(201).json(result);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.updateBooking = async (req, res) => {
  try {
    const result = await bookingService.updateBooking(
      req.params.id,
      req.user.id,
      req.body
    );
    res.json(result);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};
