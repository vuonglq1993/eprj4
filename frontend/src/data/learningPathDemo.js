/** Dữ liệu mẫu khi API lộ trình không phản hồi — chỉ dùng ở frontend */
export const DEMO_LEARNING_PATHS = [
  {
    id: 'demo-lp-1',
    title: 'English for Beginners',
    description: 'Từ vựng, ngữ pháp cơ bản và hội thoại hàng ngày.',
    languageId: 'demo-lang-en',
    languageName: 'English',
    targetLevel: 'BEGINNER',
    isPublished: true,
    totalCourses: 5,
  },
  {
    id: 'demo-lp-2',
    title: 'Japanese JLPT N5',
    description: 'Hiragana, katakana và ngữ pháp N5.',
    languageId: 'demo-lang-ja',
    languageName: 'Japanese',
    targetLevel: 'BEGINNER',
    isPublished: true,
    totalCourses: 6,
  },
  {
    id: 'demo-lp-3',
    title: 'Korean Conversation',
    description: 'Luyện hội thoại tiếng Hàn trung cấp.',
    languageId: 'demo-lang-ko',
    languageName: 'Korean',
    targetLevel: 'INTERMEDIATE',
    isPublished: true,
    totalCourses: 4,
  },
];

export const DEMO_LANGUAGES_FOR_PATH = [
  { id: 'demo-lang-en', name: 'English', code: 'EN' },
  { id: 'demo-lang-ja', name: 'Japanese', code: 'JA' },
  { id: 'demo-lang-ko', name: 'Korean', code: 'KO' },
  { id: 'demo-lang-vi', name: 'Vietnamese', code: 'VI' },
];
