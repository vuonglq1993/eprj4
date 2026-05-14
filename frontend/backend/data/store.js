const { v4: uuidv4 } = require('uuid');
const bcrypt = require('bcryptjs');

// Helper to create objects with id + timestamps
function m(id, extra = {}) {
  return { id, createdAt: new Date().toISOString(), updatedAt: new Date().toISOString(), ...extra };
}

// ======================
// USERS
// ======================
const hashPassword = async (pw) => bcrypt.hashSync(pw, 10);

const defaultUsers = [
  m('u1', {
    email: 'admin@eprj4.com',
    password: hashPassword('admin123'),
    firstName: 'Admin',
    lastName: 'User',
    role: 'ADMIN',
    avatarUrl: null,
    nativeLanguage: 'Vietnamese',
    onboardingCompleted: true,
  }),
  m('u2', {
    email: 'student@eprj4.com',
    password: hashPassword('user123'),
    firstName: 'Student',
    lastName: 'User',
    role: 'STUDENT',
    avatarUrl: null,
    nativeLanguage: 'Vietnamese',
    onboardingCompleted: false,
  }),
];

// ======================
// LANGUAGES
// ======================
const languages = [
  m('lang1', { name: 'English', code: 'EN', nativeName: 'English' }),
  m('lang2', { name: 'Japanese', code: 'JA', nativeName: '日本語' }),
  m('lang3', { name: 'Korean', code: 'KO', nativeName: '한국어' }),
  m('lang4', { name: 'Chinese', code: 'ZH', nativeName: '中文' }),
  m('lang5', { name: 'French', code: 'FR', nativeName: 'Français' }),
  m('lang6', { name: 'Spanish', code: 'ES', nativeName: 'Español' }),
  m('lang7', { name: 'German', code: 'DE', nativeName: 'Deutsch' }),
  m('lang8', { name: 'Vietnamese', code: 'VI', nativeName: 'Tiếng Việt' }),
];

// ======================
// TOPICS
// ======================
const topics = [
  m('t1', { name: 'Grammar', description: 'Grammar fundamentals and sentence structure', iconUrl: null, isActive: true, orderIndex: 1 }),
  m('t2', { name: 'Vocabulary', description: 'Word learning and vocabulary building', iconUrl: null, isActive: true, orderIndex: 2 }),
  m('t3', { name: 'Conversation', description: 'Daily conversation practice', iconUrl: null, isActive: true, orderIndex: 3 }),
  m('t4', { name: 'Pronunciation', description: 'Phonetics and pronunciation', iconUrl: null, isActive: true, orderIndex: 4 }),
  m('t5', { name: 'Culture', description: 'Cultural insights and customs', iconUrl: null, isActive: true, orderIndex: 5 }),
  m('t6', { name: 'Business', description: 'Business language and professional communication', iconUrl: null, isActive: true, orderIndex: 6 }),
  m('t7', { name: 'Travel', description: 'Travel and tourism vocabulary', iconUrl: null, isActive: true, orderIndex: 7 }),
  m('t8', { name: 'Food & Dining', description: 'Food, restaurant, and dining vocabulary', iconUrl: null, isActive: false, orderIndex: 8 }),
];

// ======================
// LEARNING PATHS
// ======================
const learningPaths = [
  m('lp1', {
    title: 'English for Beginners',
    description: 'Start your English journey with essential vocabulary, basic grammar, and everyday conversations.',
    languageId: 'lang1',
    languageName: 'English',
    targetLevel: 'BEGINNER',
    thumbnailUrl: 'https://images.unsplash.com/photo-1546410531-bb4caa6b424d?w=400',
    isPublished: true,
    totalCourses: 5,
    creatorId: 'u2',
  }),
  m('lp2', {
    title: 'Japanese JLPT N5',
    description: 'Prepare for JLPT N5 with hiragana, katakana, basic kanji, and essential grammar patterns.',
    languageId: 'lang2',
    languageName: 'Japanese',
    targetLevel: 'BEGINNER',
    thumbnailUrl: 'https://images.unsplash.com/photo-1528164344705-47542687000d?w=400',
    isPublished: true,
    totalCourses: 6,
    creatorId: 'u2',
  }),
  m('lp3', {
    title: 'Korean K-drama Master',
    description: 'Learn Korean through popular K-drama dialogues and expressions used in real episodes.',
    languageId: 'lang3',
    languageName: 'Korean',
    targetLevel: 'INTERMEDIATE',
    thumbnailUrl: 'https://images.unsplash.com/photo-1538485399081-7191377e8241?w=400',
    isPublished: true,
    totalCourses: 4,
    creatorId: 'u2',
  }),
  m('lp4', {
    title: 'Business English Pro',
    description: 'Master professional English for meetings, emails, presentations, and negotiations.',
    languageId: 'lang1',
    languageName: 'English',
    targetLevel: 'ADVANCED',
    thumbnailUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
    isPublished: true,
    totalCourses: 7,
    creatorId: 'u2',
  }),
  m('lp5', { title: 'Spanish Travel Essentials', description: 'Essential Spanish phrases for traveling in Spanish-speaking countries.', languageId: 'lang6', languageName: 'Spanish', targetLevel: 'BEGINNER', thumbnailUrl: null, isPublished: false, totalCourses: 3, creatorId: 'u2' }),
];

// ======================
// COURSES
// ======================
const courses = [
  m('c1', { title: 'English Alphabet & Pronunciation', description: 'Learn the English alphabet and correct pronunciation of each letter.', languageId: 'lang1', topicId: 't4', targetLevel: 'BEGINNER', isPublished: true, price: 0, thumbnailUrl: 'https://images.unsplash.com/photo-1546410531-bb4caa6b424d?w=400', creatorId: 'u2', durationMinutes: 60, lessonsCount: 10 }),
  m('c2', { title: 'Basic English Grammar', description: 'Understand sentence structure, tenses, and common grammar patterns.', languageId: 'lang1', topicId: 't1', targetLevel: 'BEGINNER', isPublished: true, price: 0, thumbnailUrl: 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=400', creatorId: 'u2', durationMinutes: 120, lessonsCount: 15 }),
  m('c3', { title: 'Everyday English Conversations', description: 'Practice common dialogues for daily situations.', languageId: 'lang1', topicId: 't3', targetLevel: 'BEGINNER', isPublished: true, price: 99000, thumbnailUrl: 'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=400', creatorId: 'u2', durationMinutes: 90, lessonsCount: 12 }),
  m('c4', { title: 'Hiragana Master', description: 'Learn all 46 hiragana characters with writing practice.', languageId: 'lang2', topicId: 't1', targetLevel: 'BEGINNER', isPublished: true, price: 0, thumbnailUrl: 'https://images.unsplash.com/photo-1528164344705-47542687000d?w=400', creatorId: 'u2', durationMinutes: 90, lessonsCount: 10 }),
  m('c5', { title: 'Katakana for Beginners', description: 'Master katakana for reading loanwords and foreign names.', languageId: 'lang2', topicId: 't1', targetLevel: 'BEGINNER', isPublished: true, price: 0, thumbnailUrl: null, creatorId: 'u2', durationMinutes: 75, lessonsCount: 8 }),
  m('c6', { title: 'Korean K-Pop Vocabulary', description: 'Learn Korean through K-pop songs and idol interviews.', languageId: 'lang3', topicId: 't2', targetLevel: 'INTERMEDIATE', isPublished: true, price: 149000, thumbnailUrl: 'https://images.unsplash.com/photo-1538485399081-7191377e8241?w=400', creatorId: 'u2', durationMinutes: 80, lessonsCount: 10 }),
  m('c7', { title: 'Business Email Writing', description: 'Write professional emails in English with confidence.', languageId: 'lang1', topicId: 't6', targetLevel: 'ADVANCED', isPublished: true, price: 199000, thumbnailUrl: null, creatorId: 'u2', durationMinutes: 100, lessonsCount: 12 }),
];

// ======================
// LESSONS
// ======================
const lessons = [
  m('les1', { courseId: 'c1', title: 'The Alphabet', orderIndex: 1, content: 'Learn A-Z', durationMinutes: 10 }),
  m('les2', { courseId: 'c1', title: 'Vowel Sounds', orderIndex: 2, content: 'A, E, I, O, U', durationMinutes: 10 }),
  m('les3', { courseId: 'c1', title: 'Consonant Sounds', orderIndex: 3, content: 'B, C, D, F...', durationMinutes: 10 }),
  m('les4', { courseId: 'c2', title: 'Nouns and Articles', orderIndex: 1, content: 'a, an, the', durationMinutes: 15 }),
  m('les5', { courseId: 'c2', title: 'Present Simple Tense', orderIndex: 2, content: 'I do, you do...', durationMinutes: 20 }),
];

// ======================
// EXERCISES
// ======================
const exercises = [
  m('ex1', { lessonId: 'les1', type: 'MULTIPLE_CHOICE', question: 'What letter makes the /æ/ sound in "cat"?', options: ['A', 'C', 'E', 'O'], correctAnswer: 'B', orderIndex: 1 }),
  m('ex2', { lessonId: 'les1', type: 'FILL_BLANK', question: 'Complete: A, B, C, D, ___', correctAnswer: 'E', orderIndex: 2 }),
  m('ex3', { lessonId: 'les2', type: 'MULTIPLE_CHOICE', question: 'Which vowel has the /i:/ sound?', options: ['A', 'E', 'I', 'U'], correctAnswer: 'B', orderIndex: 1 }),
];

// ======================
// SUBSCRIPTION PLANS
// ======================
const subscriptionPlans = [
  m('sp1', { name: 'Free', description: 'Access free courses and limited content', price: 0, currency: 'VND', durationDays: 9999, features: ['Free courses', 'Basic lessons', 'Community support'], isActive: true }),
  m('sp2', { name: 'Basic', description: 'Unlock all courses and track your progress', price: 199000, currency: 'VND', durationDays: 30, features: ['All courses', 'Progress tracking', 'Download materials', 'Email support'], isActive: true }),
  m('sp3', { name: 'Premium', description: 'Full access with priority support and certificates', price: 499000, currency: 'VND', durationDays: 30, features: ['All courses', 'Priority support', 'Certificates', 'Offline mode', '1-on-1 tutoring'], isActive: true }),
  m('sp4', { name: 'Annual', description: 'Best value — full access for a whole year', price: 3999000, currency: 'VND', durationDays: 365, features: ['All Premium features', '2 months free', 'Exclusive webinars', 'Mentor access'], isActive: true }),
  m('sp5', { name: 'Legacy Plan', description: 'Old pricing — no longer available', price: 99000, currency: 'VND', durationDays: 30, features: ['Limited courses'], isActive: false }),
];

// ======================
// SUBSCRIPTIONS (user subscriptions)
// ======================
const subscriptions = [
  m('sub1', { userId: 'u2', planId: 'sp2', status: 'ACTIVE', startDate: new Date().toISOString(), endDate: new Date(Date.now() + 30 * 86400000).toISOString() }),
];

// ======================
// PAYMENTS
// ======================
const payments = [
  m('pay1', { userId: 'u2', planId: 'sp2', amount: 199000, currency: 'VND', status: 'COMPLETED', paymentMethod: 'VNPAY', transactionId: 'VNPAY_TXN_001', createdAt: new Date().toISOString() }),
  m('pay2', { userId: 'u2', planId: 'sp3', amount: 499000, currency: 'VND', status: 'COMPLETED', paymentMethod: 'MOMO', transactionId: 'MOMO_TXN_002', createdAt: new Date().toISOString() }),
];

// ======================
// STUDY LOGS
// ======================
const studyLogs = [
  m('sl1', { userId: 'u2', date: new Date().toISOString().split('T')[0], minutesSpent: 30, lessonsCompleted: 2 }),
  m('sl2', { userId: 'u2', date: new Date(Date.now() - 86400000).toISOString().split('T')[0], minutesSpent: 45, lessonsCompleted: 3 }),
  m('sl3', { userId: 'u2', date: new Date(Date.now() - 2 * 86400000).toISOString().split('T')[0], minutesSpent: 20, lessonsCompleted: 1 }),
];

// ======================
// PROGRESS
// ======================
const progress = [
  m('pr1', { userId: 'u2', courseId: 'c1', completedLessons: 2, totalLessons: 10, percentComplete: 20, lastAccessedAt: new Date().toISOString() }),
  m('pr2', { userId: 'u2', courseId: 'c2', completedLessons: 5, totalLessons: 15, percentComplete: 33, lastAccessedAt: new Date(Date.now() - 86400000).toISOString() }),
];

// ======================
// ONBOARDING
// ======================
const onboardingData = {};

// ======================
// ENROLLMENTS (learning path enrollments)
// ======================
const enrollments = [
  m('enr1', { userId: 'u2', learningPathId: 'lp1', enrolledAt: new Date().toISOString() }),
];

// ======================
// RECORDINGS (audio records for exercises)
// ======================
const recordings = [
  m('rec1', {
    audioUrl: '/uploads/records/sample_recording_1.mp3',
    title: 'Alphabet Pronunciation Practice',
    userId: 'u2',
    exerciseId: 'ex1',
    transcript: null,
    score: 85,
    isCorrect: true,
  }),
  m('rec2', {
    audioUrl: '/uploads/records/sample_recording_2.mp3',
    title: 'Fill in the Blank Attempt',
    userId: 'u2',
    exerciseId: 'ex2',
    transcript: null,
    score: 70,
    isCorrect: false,
  }),
  m('rec3', {
    audioUrl: '/uploads/records/sample_recording_3.mp3',
    title: 'Vowel Sounds Practice',
    userId: 'u2',
    exerciseId: 'ex3',
    transcript: null,
    score: 90,
    isCorrect: true,
  }),
];

// ======================
// STORE (in-memory)
// ======================
const store = {
  users: [...defaultUsers],
  languages: [...languages],
  topics: [...topics],
  learningPaths: [...learningPaths],
  courses: [...courses],
  lessons: [...lessons],
  exercises: [...exercises],
  subscriptionPlans: [...subscriptionPlans],
  subscriptions: [...subscriptions],
  payments: [...payments],
  studyLogs: [...studyLogs],
  progress: [...progress],
  onboardingData: { ...onboardingData },
  enrollments: [...enrollments],
  recordings: [...recordings],
};

module.exports = store;
