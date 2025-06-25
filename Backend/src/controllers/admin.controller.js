const adminService = require('../services/admin.service');

exports.getStats = async (req, res) => {
  try {
    const stats = await adminService.getDashboardStats();
    res.json(stats);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getAllBookings = async (req, res) => {
  try {
    const { status } = req.query; // optional filter
    const bookings = await adminService.getAllBookings(status);
    res.json(bookings);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.updateBookingStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;
    const result = await adminService.updateBookingStatus(id, status, req.user);
    res.json(result);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.getBookingBreakdown = async (req, res) => {
  try {
    const breakdown = await adminService.getBookingStatusBreakdown();
    res.json(breakdown);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getCustomers = async (req, res) => {
  try {
    const customers = await adminService.getAllCustomers();
    res.json(customers);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getSubAdmins = async (req, res) => {
  try {
    const subs = await adminService.getAllSubAdmins();
    res.json(subs);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getAllNotifications = async (req, res) => {
  try {
    const notifications = await adminService.getAllNotifications();
    res.json(notifications);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getLogs = async (req, res) => {
  try {
    const logs = await adminService.getLogs();
    res.json(logs);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getRecentBookings = async (req, res) => {
  try {
    const limit = parseInt(req.query.limit) || 5;
    const bookings = await adminService.getRecentBookings(limit);
    res.json(bookings);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getBookingsPerDay = async (req, res) => {
  try {
    const data = await adminService.getBookingsPerDay();
    res.json(data);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
