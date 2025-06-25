const hallService = require('../services/hall.service');
const db = require("../config/db");

exports.createHall = async (req, res) => {
  try {
    const hall = await hallService.createHall(
      req.body,
      req.user.id,
      req.user.role
    );
    res.status(201).json(hall);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getHallsBySubAdmin = async (req, res) => {
  try {
    const halls = await hallService.getHallsBySubAdmin(req.user.id);
    res.json(halls);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.updateHall = async (req, res) => {
  try {
    const result = await hallService.updateHall(
      req.params.id,
      req.body,
      req.user.id,
      req.user.role
    );
    res.json(result);
  } catch (err) {
    res.status(403).json({ error: err.message });
  }
};

exports.deleteHall = async (req, res) => {
  try {
    const result = await hallService.deleteHall(
      req.params.id,
      req.user.id,
      req.user.role
    );
    res.json(result);
  } catch (err) {
    res.status(403).json({ error: err.message });
  }
};

exports.uploadPhoto = async (req, res) => {
  try {
    const hallId = req.params.hallId;

    if (!req.file) {
      return res.status(400).json({ error: 'Photo file is required' });
    }

    const photoUrl = `/uploads/${req.file.filename}`;
    const db = require('../config/db');

    await db.execute(
      'INSERT INTO hall_photos (hall_id, photo_url) VALUES (?, ?)',
      [hallId, photoUrl]
    );

    res.status(201).json({ message: 'Photo uploaded', photoUrl });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.updateHall = async (req, res) => {
  try {
    const result = await hallService.updateHall(req.params.id, req.body);
    res.json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.deleteHall = async (req, res) => {
  try {
    const result = await hallService.deleteHall(req.params.id);
    res.json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getAllHalls = async (req, res) => {
  const userId = req.user?.id || null;
  const role = req.user?.role || null;

  const halls = await hallService.getAllHalls(userId, role);
  res.json(halls);
};

exports.getHallById = async (req, res) => {
  try {
    const hall = await hallService.getHallDetails(req.params.id);
    if (!hall) return res.status(404).json({ error: 'Hall not found' });
    res.json(hall);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.reassignHall = async (req, res) => {
  try {
    const hallId = req.params.id;
    const { sub_admin_id } = req.body;

    const result = await hallService.reassignHall(
      hallId,
      sub_admin_id,
      req.user.role
    );

    res.json(result);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.getTopHalls = async (req, res) => {
  try {
    const halls = await hallService.getTopHalls();
    res.json(halls);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// GET /api/halls/Trend
exports.getBookingTrend = async (req, res) => {
  try {
    const halls = await hallService.getBookingTrend();
    res.json(halls);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getServicesByHallId = async (req, res) => {
  try {
    const { hallId } = req.params;
    const services = await hallService.getServicesByHallId(hallId);
    res.json({ hallId, services });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.updateService = async (req, res) => {
  try {
    const { serviceId } = req.params;
    const updated = await hallService.updateService(
      serviceId,
      req.user.id,
      req.user.role,
      req.body
    );
    res.json(updated);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.addServiceToHall = async (req, res) => {
  try {
    const { hallId } = req.params;
    const { name, price_per_person, pricing_type } = req.body;
    const user = req.user;

    const result = await hallService.addServiceToHall(
      hallId,
      name,
      price_per_person,
      pricing_type || 'invitation_based',
      user
    );

    res.status(201).json(result);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};


exports.getAvailability = async (req, res) => {
  try {
    const { hall_id } = req.body;

    const parsedId = parseInt(hall_id, 10);
    if (isNaN(parsedId)) {
      return res.status(400).json({ error: 'Invalid hall ID' });
    }

    const map = await hallService.getAvailabilityMap(parsedId);
    res.json(map);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getServicesByHallId = async (req, res) => {
  try {
    const { hallId } = req.params;

    const services = await hallService.getServicesByHallId(hallId);
    res.json({
      hallId,
      services
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.editHall = async (req, res) => {
  try {
    const hallId = req.params.id;
    const data = req.body;
    const user = req.user;

    const result = await hallService.editHall(
      hallId,
      data,
      user.id,
      user.role
    );

    res.json(result);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.getHallPhotos = async (req, res) => {
  try {
    const { hallId } = req.params;
    const photos = await hallService.getPhotosByHallId(hallId);
    res.json({ hallId, photos });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.setCoverPhoto = async (req, res) => {
  try {
    const { hallId, photoId } = req.params;
    const result = await hallService.setCoverPhoto(photoId, hallId, req.user);
    res.json(result);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.deleteHallPhoto = async (req, res) => {
  try {
    const { hallId, photoId } = req.params;

    const [[photo]] = await db.execute(
      `SELECT is_cover FROM hall_photos WHERE id = ? AND hall_id = ?`,
      [photoId, hallId]
    );

    if (!photo) return res.status(404).json({ error: 'Photo not found' });

    if (photo.is_cover) {
      const [[count]] = await db.execute(
        `SELECT COUNT(*) as total FROM hall_photos WHERE hall_id = ?`,
        [hallId]
      );
      if (count.total <= 1) {
        return res.status(400).json({ error: 'Cannot delete the only (cover) photo' });
      }
      return res.status(400).json({ error: 'Cannot delete cover photo without replacing it' });
    }

    await db.execute(`DELETE FROM hall_photos WHERE id = ?`, [photoId]);
    res.json({ message: 'Photo deleted' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
