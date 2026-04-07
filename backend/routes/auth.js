const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { v4: uuidv4 } = require('uuid');
const { authenticate, JWT_SECRET } = require('../middleware/auth');
const store = require('../data/store');

const router = express.Router();

// POST /auth/login
router.post('/login', async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) {
    return res.status(400).json({ message: 'Email and password are required' });
  }
  const user = store.users.find((u) => u.email === email);
  if (!user) {
    return res.status(401).json({ message: 'Email hoặc mật khẩu không đúng' });
  }
  const valid = await bcrypt.compare(password, user.password);
  if (!valid) {
    return res.status(401).json({ message: 'Email hoặc mật khẩu không đúng' });
  }
  const accessToken = jwt.sign(
    { id: user.id, email: user.email, role: user.role },
    JWT_SECRET,
    { expiresIn: '7d' }
  );
  const refreshToken = jwt.sign({ id: user.id }, JWT_SECRET, { expiresIn: '30d' });
  const { password: _, ...userData } = user;
  res.json({ accessToken, refreshToken, user: userData });
});

// POST /auth/register
router.post('/register', async (req, res) => {
  const { email, password, firstName, lastName } = req.body;
  if (!email || !password) {
    return res.status(400).json({ message: 'Email and password are required' });
  }
  if (store.users.find((u) => u.email === email)) {
    return res.status(409).json({ message: 'Email already registered' });
  }
  const hashed = await bcrypt.hashSync(password, 10);
  const newUser = {
    id: uuidv4(),
    email,
    password: hashed,
    firstName: firstName || '',
    lastName: lastName || '',
    role: 'USER',
    avatarUrl: null,
    nativeLanguage: null,
    onboardingCompleted: false,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  };
  store.users.push(newUser);
  const { password: _, ...userData } = newUser;
  res.status(201).json(userData);
});

// POST /auth/google (mock Google OAuth)
router.post('/google', async (req, res) => {
  const { email, firstName, lastName, avatarUrl } = req.body;
  if (!email) {
    return res.status(400).json({ message: 'Email is required' });
  }
  let user = store.users.find((u) => u.email === email);
  if (!user) {
    user = {
      id: uuidv4(),
      email,
      password: '',
      firstName: firstName || '',
      lastName: lastName || '',
      role: 'USER',
      avatarUrl: avatarUrl || null,
      nativeLanguage: null,
      onboardingCompleted: false,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };
    store.users.push(user);
  }
  const accessToken = jwt.sign(
    { id: user.id, email: user.email, role: user.role },
    JWT_SECRET,
    { expiresIn: '7d' }
  );
  const refreshToken = jwt.sign({ id: user.id }, JWT_SECRET, { expiresIn: '30d' });
  const { password: _, ...userData } = user;
  res.json({ accessToken, refreshToken, user: userData });
});

// POST /auth/logout
router.post('/logout', authenticate, (req, res) => {
  res.json({ message: 'Logged out successfully' });
});

// POST /auth/refresh
router.post('/refresh', (req, res) => {
  const { refreshToken } = req.body;
  if (!refreshToken) {
    return res.status(400).json({ message: 'Refresh token required' });
  }
  try {
    const decoded = jwt.verify(refreshToken, JWT_SECRET);
    const user = store.users.find((u) => u.id === decoded.id);
    if (!user) {
      return res.status(401).json({ message: 'User not found' });
    }
    const accessToken = jwt.sign(
      { id: user.id, email: user.email, role: user.role },
      JWT_SECRET,
      { expiresIn: '7d' }
    );
    res.json({ accessToken });
  } catch {
    res.status(401).json({ message: 'Invalid refresh token' });
  }
});

module.exports = router;
