const express = require('express');
const cors = require('cors');
const { globalLimiter } = require('./middlewares/rate-limit.middleware');
const app = express();
const helmet = require('helmet');
const path = require('path');
require('dotenv').config();

// Middlewares
app.use(helmet()); // Sets secure headers
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(globalLimiter);
require('./utils/otp-cleanup.job');

// Routes
const hallRoutes = require('./routes/hall.routes');
const userRoutes = require('./routes/user.routes');
const authRoutes = require('./routes/auth.routes');
const bookingRoutes = require('./routes/booking.routes');
const notificationRoutes = require('./routes/notification.routes');
const adminRoutes = require('./routes/admin.routes');
const customerRoutes = require('./routes/customer.routes');
const ChatRoutes = require('./routes/ChatBot.routes');

app.use('/api/customer', customerRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api/notifications', notificationRoutes);
app.use('/api/bookings', bookingRoutes);
app.use('/api/users', userRoutes);
app.use('/api/auth', authRoutes);
app.use('/api/halls', hallRoutes);
app.use('/uploads', express.static('public/uploads'));
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));
app.use('/api/Chat', ChatRoutes);
app.use(cors({
  origin: [
    'http://localhost:8080', 
    'http://localhost:5554',
    'http://localhost:5555'
  ],
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
  credentials: true
}));
app.use((req, res, next) => {
  res.setHeader("Access-Control-Allow-Origin", "http://127.0.0.1:5500");
  res.setHeader("Access-Control-Allow-Methods", "GET, POST, put, patch, delete");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type");
  next();
});
// 404 Handler
app.use((req, res) => {
  res.status(404).json({ message: 'Not Found 404' });
});

module.exports = app;
