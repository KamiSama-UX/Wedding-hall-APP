require('dotenv').config();
const app = require('./app');
const server = require('http').createServer(app);

const PORT = process.env.PORT || 5000;
server.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
 global.io = require('socket.io')(server, { cors: { origin: "*" } });

global.io.on('connection', (socket) => {
  console.log('📡 New client connected:', socket.id);

  // Optional: Handle room joining or custom events
  socket.on('join', (userId) => {
    socket.join(`user:${userId}`);
    console.log(`👤 User ${userId} joined their notification room`);
  });

  socket.on('disconnect', () => {
    console.log('❌ Client disconnected:', socket.id);
  });
});
});
