const express = require('express');
const store = require('../data/store');

const router = express.Router();

// GET /languages
router.get('/', (req, res) => {
  res.json(store.languages);
});

// GET /languages/:id
router.get('/:id', (req, res) => {
  const lang = store.languages.find((l) => l.id === req.params.id);
  if (!lang) return res.status(404).json({ message: 'Language not found' });
  res.json(lang);
});

module.exports = router;
