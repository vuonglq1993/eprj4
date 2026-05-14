const express = require('express');
const { v4: uuidv4 } = require('uuid');
const { authenticate } = require('../middleware/auth');
const store = require('../data/store');
const multer = require('multer');
const path = require('path');
const fs = require('fs');

const router = express.Router();

const uploadsDir = path.join(__dirname, '..', 'uploads', 'records');
if (!fs.existsSync(uploadsDir)) {
  fs.mkdirSync(uploadsDir, { recursive: true });
}

const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, uploadsDir),
  filename: (req, file, cb) => cb(null, `${uuidv4()}_${file.originalname}`),
});
const upload = multer({ storage, limits: { fileSize: 10 * 1024 * 1024 } });

// POST /records/upload
router.post('/upload', authenticate, upload.single('file'), (req, res) => {
  const { title, exerciseId } = req.body;

  if (!req.file) {
    return res.status(400).json({ message: 'No audio file provided' });
  }
  if (!title) {
    return res.status(400).json({ message: 'title is required' });
  }
  if (!exerciseId) {
    return res.status(400).json({ message: 'exerciseId is required' });
  }

  const audioUrl = `/uploads/records/${req.file.filename}`;

  const newRecord = {
    id: uuidv4(),
    audioUrl,
    title,
    userId: req.user.id,
    exerciseId,
    transcript: null,
    score: null,
    isCorrect: null,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  };

  store.recordings.push(newRecord);
  res.status(201).json({
    audioUrl: newRecord.audioUrl,
    title: newRecord.title,
  });
});

// GET /records/exercise/:exerciseId
router.get('/exercise/:exerciseId', authenticate, (req, res) => {
  const records = store.recordings.filter((r) => r.exerciseId === req.params.exerciseId);
  const response = records.map((r) => ({
    audioUrl: r.audioUrl,
    title: r.title,
  }));
  res.json(response);
});

module.exports = router;
