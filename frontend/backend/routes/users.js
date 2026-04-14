const express = require('express');
const bcrypt = require('bcryptjs');
const { v4: uuidv4 } = require('uuid');
const { authenticate, requireRole } = require('../middleware/auth');
const store = require('../data/store');

const router = express.Router();

// GET /users/me - Authenticated
router.get('/me', authenticate, (req, res) => {
  const user = store.users.find((u) => u.id === req.user.id);
  if (!user) return res.status(404).json({ message: 'User not found' });
  const { password: _, ...userData } = user;
  res.json(userData);
});

// PUT /users/me - Authenticated (update own profile)
router.put('/me', authenticate, (req, res) => {
  const idx = store.users.findIndex((u) => u.id === req.user.id);
  if (idx === -1) return res.status(404).json({ message: 'User not found' });
  const { firstName, lastName, avatarUrl } = req.body;
  if (firstName !== undefined) store.users[idx].firstName = firstName;
  if (lastName !== undefined) store.users[idx].lastName = lastName;
  if (avatarUrl !== undefined) store.users[idx].avatarUrl = avatarUrl;
  store.users[idx].updatedAt = new Date().toISOString();
  const { password: _, ...userData } = store.users[idx];
  res.json(userData);
});

// PUT /users/me/password - Authenticated
router.put('/me/password', authenticate, async (req, res) => {
  const idx = store.users.findIndex((u) => u.id === req.user.id);
  if (idx === -1) return res.status(404).json({ message: 'User not found' });
  const { currentPassword, newPassword } = req.body;
  if (!currentPassword || !newPassword) return res.status(400).json({ message: 'Both passwords are required' });
  const valid = await bcrypt.compare(currentPassword, store.users[idx].password);
  if (!valid) return res.status(400).json({ message: 'Current password is incorrect' });
  store.users[idx].password = await bcrypt.hashSync(newPassword, 10);
  store.users[idx].updatedAt = new Date().toISOString();
  res.json({ message: 'Password updated successfully' });
});

// GET /users - Admin only
router.get('/', authenticate, requireRole('ADMIN'), (req, res) => {
  const users = store.users.map(({ password: _, ...u }) => u);
  res.json(users);
});

// PUT /users/:id/role - Admin only
router.put('/:id/role', authenticate, requireRole('ADMIN'), (req, res) => {
  const idx = store.users.findIndex((u) => u.id === req.params.id);
  if (idx === -1) return res.status(404).json({ message: 'User not found' });
  const { role } = req.body;
  if (!['USER', 'TEACHER', 'ADMIN'].includes(role)) return res.status(400).json({ message: 'Invalid role' });
  store.users[idx].role = role;
  store.users[idx].updatedAt = new Date().toISOString();
  const { password: _, ...userData } = store.users[idx];
  res.json(userData);
});

// DELETE /users/:id - Admin only
router.delete('/:id', authenticate, requireRole('ADMIN'), (req, res) => {
  const idx = store.users.findIndex((u) => u.id === req.params.id);
  if (idx === -1) return res.status(404).json({ message: 'User not found' });
  store.users.splice(idx, 1);
  res.json({ message: 'User deleted' });
});

module.exports = router;
