const customerService = require('../services/customer.service');

exports.getMyBookings = async (req, res) => {
  try {
    const filters = {
      status: req.query.status,
      from: req.query.from,
      to: req.query.to,
    };

    const bookings = await customerService.getMyBookings(req.user.id, filters);
    res.json(bookings);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getProfile = async (req, res) => {
  try {
    const profile = await customerService.getProfile(req.user.id);
    res.json(profile);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.updateProfile = async (req, res) => {
  try {
    const updated = await customerService.updateProfile(req.user.id, req.body);
    res.json(updated);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.getBookings = async (req, res) => {
  try {
    const bookings = await customerService.getBookings(req.user.id);
    res.json(bookings);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.changePassword = async (req, res) => {
  try {
    const { currentPassword, newPassword } = req.body;
    await customerService.changePassword(
      req.user.id,
      currentPassword,
      newPassword
    );
    res.json({ message: 'Password updated successfully' });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.getFavorites = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;

    const favorites = await customerService.getFavorites(
      req.user.id,
      page,
      limit
    );
    res.json(favorites);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.saveHall = async (req, res) => {
  try {
    await customerService.saveHall(req.user.id, req.params.hallId);
    res.status(201).json({ message: 'Hall saved' });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.removeSavedHall = async (req, res) => {
  try {
    await customerService.removeSavedHall(req.user.id, req.params.hallId);
    res.json({ message: 'Removed from favorites' });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};
