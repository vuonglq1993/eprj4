-- ============================================================
-- LANGUAGE LEARNING APP - SEED DATA (MySQL)
-- Mỗi ngôn ngữ: 5 courses, mỗi course: 5 lessons, mỗi lesson: 5 exercises
-- Tổng: 10 languages × 5 courses × 5 lessons × 5 exercises = 1,250 exercises
-- ============================================================

-- ============================================================
-- 1. LANGUAGES
-- ============================================================
INSERT INTO languages (id, code, name, native_name, flag, is_active) VALUES
(UUID(), 'en', 'English', 'English', '🇺🇸', true),
(UUID(), 'ja', 'Japanese', '日本語', '🇯🇵', true),
(UUID(), 'ko', 'Korean', '한국어', '🇰🇷', true),
(UUID(), 'zh', 'Chinese', '中文', '🇨🇳', true),
(UUID(), 'fr', 'French', 'Français', '🇫🇷', true),
(UUID(), 'de', 'German', 'Deutsch', '🇩🇪', true),
(UUID(), 'es', 'Spanish', 'Español', '🇪🇸', true),
(UUID(), 'vi', 'Vietnamese', 'Tiếng Việt', '🇻🇳', true),
(UUID(), 'ru', 'Russian', 'Русский', '🇷🇺', true),
(UUID(), 'pt', 'Portuguese', 'Português', '🇧🇷', true);

-- ============================================================
-- 2. USERS
-- ============================================================
INSERT INTO users (id, email, password, phone, first_name, last_name, avatar_url, role, provider, provider_id, email_verified, is_active, ui_language, created_at, updated_at) VALUES
(UUID(), 'admin@langapp.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye4P7N6UMGUKW.FpBFP6V3z9qJGKzGzWe', NULL, 'Admin', 'LangApp', 'https://api.dicebear.com/7.x/avataaars/svg?seed=admin', 'ADMIN', 'LOCAL', NULL, true, true, 'vi', NOW(), NOW()),
(UUID(), 'teacher.nguyen@langapp.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye4P7N6UMGUKW.FpBFP6V3z9qJGKzGzWe', NULL, 'Minh', 'Nguyen', 'https://api.dicebear.com/7.x/avataaars/svg?seed=teacher1', 'TEACHER', 'LOCAL', NULL, true, true, 'vi', NOW(), NOW()),
(UUID(), 'student.levan@langapp.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye4P7N6UMGUKW.FpBFP6V3z9qJGKzGzWe', NULL, 'Le', 'Van', 'https://api.dicebear.com/7.x/avataaars/svg?seed=levan', 'STUDENT', 'LOCAL', NULL, true, true, 'vi', NOW(), NOW()),
(UUID(), 'student.tran@langapp.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye4P7N6UMGUKW.FpBFP6V3z9qJGKzGzWe', NULL, 'Thi', 'Tran', 'https://api.dicebear.com/7.x/avataaars/svg?seed=tran', 'STUDENT', 'LOCAL', NULL, true, true, 'en', NOW(), NOW()),
(UUID(), 'student.hoang@langapp.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye4P7N6UMGUKW.FpBFP6V3z9qJGKzGzWe', NULL, 'Van', 'Hoang', 'https://api.dicebear.com/7.x/avataaars/svg?seed=hoang', 'STUDENT', 'GOOGLE', 'google_123456789', true, true, 'vi', NOW(), NOW()),
(UUID(), 'student.linh@langapp.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye4P7N6UMGUKW.FpBFP6V3z9qJGKzGzWe', NULL, 'Thi', 'Linh', 'https://api.dicebear.com/7.x/avataaars/svg?seed=linh', 'STUDENT', 'LOCAL', NULL, true, true, 'ja', NOW(), NOW()),
(UUID(), 'student.minh@langapp.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye4P7N6UMGUKW.FpBFP6V3z9qJGKzGzWe', NULL, 'Quang', 'Minh', 'https://api.dicebear.com/7.x/avataaars/svg?seed=minh', 'STUDENT', 'LOCAL', NULL, true, true, 'ko', NOW(), NOW()),
(UUID(), 'student.hue@langapp.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye4P7N6UMGUKW.FpBFP6V3z9qJGKzGzWe', NULL, 'Thi', 'Hue', 'https://api.dicebear.com/7.x/avataaars/svg?seed=hue', 'STUDENT', 'FACEBOOK', 'fb_987654321', true, true, 'vi', NOW(), NOW()),
(UUID(), 'student.hanoi@langapp.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye4P7N6UMGUKW.FpBFP6V3z9qJGKzGzWe', NULL, 'Duc', 'Hanoi', 'https://api.dicebear.com/7.x/avataaars/svg?seed=hanoi', 'STUDENT', 'LOCAL', NULL, true, true, 'zh', NOW(), NOW()),
(UUID(), 'student.saigon@langapp.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye4P7N6UMGUKW.FpBFP6V3z9qJGKzGzWe', NULL, 'Phuong', 'Saigon', 'https://api.dicebear.com/7.x/avataaars/svg?seed=saigon', 'STUDENT', 'LOCAL', NULL, true, true, 'fr', NOW(), NOW());

-- ============================================================
-- 3. TOPICS
-- ============================================================
INSERT INTO topics (id, name, description, icon_url, is_active, order_index) VALUES
(UUID(), 'Daily Life', 'Học tiếng qua các tình huống đời thường', '🏠', true, 1),
(UUID(), 'Travel', 'Giao tiếp khi đi du lịch nước ngoài', '✈️', true, 2),
(UUID(), 'Business', 'Tiếng Anh thương mại và công việc', '💼', true, 3),
(UUID(), 'Food & Restaurant', 'Từ vựng và mẫu câu trong nhà hàng', '🍽️', true, 4),
(UUID(), 'Health & Hospital', 'Giao tiếp tại phòng khám, bệnh viện', '🏥', true, 5),
(UUID(), 'Education', 'Môi trường học đường, trường học', '📚', true, 6),
(UUID(), 'Technology', 'Thuật ngữ công nghệ, IT, AI', '💻', true, 7),
(UUID(), 'Entertainment', 'Phim ảnh, âm nhạc, giải trí', '🎬', true, 8),
(UUID(), 'Shopping', 'Mua sắm, thương lượng giá', '🛍️', true, 9),
(UUID(), 'Weather & Nature', 'Thời tiết, thiên nhiên, mùa trong năm', '🌤️', true, 10);

-- ============================================================
-- 4. COURSES - MỖI NGÔN NGỮ 5 COURSES
-- ============================================================
SET @lang_en  = (SELECT id FROM languages WHERE code = 'en' LIMIT 1);
SET @lang_ja  = (SELECT id FROM languages WHERE code = 'ja' LIMIT 1);
SET @lang_ko  = (SELECT id FROM languages WHERE code = 'ko' LIMIT 1);
SET @lang_zh  = (SELECT id FROM languages WHERE code = 'zh' LIMIT 1);
SET @lang_fr  = (SELECT id FROM languages WHERE code = 'fr' LIMIT 1);
SET @lang_de  = (SELECT id FROM languages WHERE code = 'de' LIMIT 1);
SET @lang_es  = (SELECT id FROM languages WHERE code = 'es' LIMIT 1);
SET @lang_vi  = (SELECT id FROM languages WHERE code = 'vi' LIMIT 1);
SET @lang_ru  = (SELECT id FROM languages WHERE code = 'ru' LIMIT 1);
SET @lang_pt  = (SELECT id FROM languages WHERE code = 'pt' LIMIT 1);
SET @admin_id  = (SELECT id FROM users WHERE email = 'admin@langapp.com' LIMIT 1);
SET @teacher_id = (SELECT id FROM users WHERE email = 'teacher.nguyen@langapp.com' LIMIT 1);

-- English: 5 courses
INSERT INTO courses (id, language_id, created_by, title, description, level, thumbnail_url, is_published, total_lessons, created_at, updated_at) VALUES
(UUID(), @lang_en, @admin_id,  'English for Beginners A1', 'Khóa học tiếng Anh từ con số 0, phù hợp người mới bắt đầu hoàn toàn.', 'BEGINNER', 'https://images.unsplash.com/photo-1546410531-bb4caa6b424d?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_en, @admin_id,  'English Elementary A2', 'Nâng cao từ vựng và ngữ pháp cơ bản, giao tiếp đơn giản hàng ngày.', 'ELEMENTARY', 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_en, @admin_id,  'English Intermediate B1', 'Phát triển khả năng giao tiếp lưu loát, hiểu các chủ đề quen thuộc.', 'INTERMEDIATE', 'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_en, @admin_id,  'Business English B2', 'Tiếng Anh thương mại, email business, meeting, presentation.', 'UPPER_INTERMEDIATE', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_en, @admin_id,  'IELTS Preparation', 'Luyện thi IELTS tổng hợp: Reading, Writing, Listening, Speaking.', 'ADVANCED', 'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?w=500', true, 5, NOW(), NOW());

-- Japanese: 5 courses
INSERT INTO courses (id, language_id, created_by, title, description, level, thumbnail_url, is_published, total_lessons, created_at, updated_at) VALUES
(UUID(), @lang_ja, @teacher_id, 'Japanese JLPT N5', 'Khóa học tiếng Nhật chuẩn JLPT N5, từ bảng chữ cái Hiragana, Katakana.', 'BEGINNER', 'https://images.unsplash.com/photo-1528164344705-47542687000d?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_ja, @teacher_id, 'Japanese JLPT N4', 'Mở rộng từ vựng và ngữ pháp JLPT N4, giao tiếp thường ngày.', 'ELEMENTARY', 'https://images.unsplash.com/photo-1580191947416-62d35a55e71d?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_ja, @teacher_id, 'Japanese JLPT N3', 'Nâng cao với ngữ pháp phức tạp và từ vựng mở rộng JLPT N3.', 'INTERMEDIATE', 'https://images.unsplash.com/photo-1480796927426-f609979314bd?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_ja, @teacher_id, 'Japanese Conversation', 'Giao tiếp tiếng Nhật tự nhiên, luyện nói và nghe.', 'INTERMEDIATE', 'https://images.unsplash.com/photo-1545569341-9eb8b30979d9?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_ja, @teacher_id, 'Japanese Business', 'Tiếng Nhật thương mại, giao tiếp trong công việc với đối tác Nhật.', 'ADVANCED', 'https://images.unsplash.com/photo-1553361371-9b22f78e8b1d?w=500', true, 5, NOW(), NOW());

-- Korean: 5 courses
INSERT INTO courses (id, language_id, created_by, title, description, level, thumbnail_url, is_published, total_lessons, created_at, updated_at) VALUES
(UUID(), @lang_ko, @admin_id,  'Korean for Beginners', 'Học tiếng Hàn từ bảng chữ cái Hangul, phát âm và từ vựng cơ bản.', 'BEGINNER', 'https://images.unsplash.com/photo-1601342630235-d7bd4c7b6105?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_ko, @admin_id,  'Korean Elementary', 'Mở rộng từ vựng và cấu trúc câu tiếng Hàn sơ cấp.', 'ELEMENTARY', 'https://images.unsplash.com/photo-1618336753974-aae8e04506aa?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_ko, @admin_id,  'Korean Intermediate', 'Giao tiếp lưu loát hơn với ngữ pháp trung cấp tiếng Hàn.', 'INTERMEDIATE', 'https://images.unsplash.com/photo-1580619305218-8423a7ef79b4?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_ko, @admin_id,  'Korean TOPIK I Preparation', 'Luyện thi TOPIK I (级别 1-2), từ vựng và ngữ pháp.', 'INTERMEDIATE', 'https://images.unsplash.com/photo-1605831932199-2ac4357a3f6f?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_ko, @admin_id,  'Korean K-Drama Style', 'Học tiếng Hàn qua phim truyền hình Hàn Quốc, ngôn ngữ đời thường.', 'ELEMENTARY', 'https://images.unsplash.com/photo-1538485399081-7191377e8241?w=500', true, 5, NOW(), NOW());

-- Chinese: 5 courses
INSERT INTO courses (id, language_id, created_by, title, description, level, thumbnail_url, is_published, total_lessons, created_at, updated_at) VALUES
(UUID(), @lang_zh, @admin_id,  'Chinese HSK 1', 'Tiếng Trung cho người mới, 150 từ vựng cơ bản, giao tiếp đơn giản.', 'BEGINNER', 'https://images.unsplash.com/photo-1508804185872-d7badad00f7d?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_zh, @admin_id,  'Chinese HSK 2', 'Mở rộng lên 300 từ vựng, ngữ pháp cơ bản tiếng Trung.', 'ELEMENTARY', 'https://images.unsplash.com/photo-1547981609-4b6bfe67ca0b?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_zh, @admin_id,  'Chinese HSK 3', 'Nâng cao lên 600 từ vựng, giao tiếp thường ngày thành thạo.', 'INTERMEDIATE', 'https://images.unsplash.com/photo-1529926706528-db9e5010cd3e?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_zh, @admin_id,  'Chinese Conversation', 'Luyện nói tiếng Trung, giao tiếp tự nhiên trong các tình huống.', 'INTERMEDIATE', 'https://images.unsplash.com/photo-1467810563316-b5476525c0f9?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_zh, @admin_id,  'Chinese Business', 'Tiếng Trung thương mại, email, đàm phán và giao dịch kinh doanh.', 'ADVANCED', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500', true, 5, NOW(), NOW());

-- French: 5 courses
INSERT INTO courses (id, language_id, created_by, title, description, level, thumbnail_url, is_published, total_lessons, created_at, updated_at) VALUES
(UUID(), @lang_fr, @teacher_id, 'French A1 - Debutant', 'Khóa tiếng Pháp cho người chưa biết gì, từ bảng chữ cái đến câu đơn giản.', 'BEGINNER', 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_fr, @teacher_id, 'French A2 - Elementaire', 'Xây dựng nền tảng vững chắc, giao tiếp trong các tình huống quen thuộc.', 'ELEMENTARY', 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_fr, @teacher_id, 'French B1 - Intermediaire', 'Phát triển khả năng diễn đạt ý kiến, thảo luận các chủ đề quen thuộc.', 'INTERMEDIATE', 'https://images.unsplash.com/photo-1490676151578-75a768d4dcdb?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_fr, @teacher_id, 'French B2 - Avance', 'Nâng cao, hiểu các văn bản phức tạp, giao tiếp trôi chảy.', 'UPPER_INTERMEDIATE', 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_fr, @teacher_id, 'French for Travel', 'Tiếng Pháp cho người đi du lịch, 200 câu thiết yếu.', 'BEGINNER', 'https://images.unsplash.com/photo-1499856871958-5b9627545d1a?w=500', true, 5, NOW(), NOW());

-- German: 5 courses
INSERT INTO courses (id, language_id, created_by, title, description, level, thumbnail_url, is_published, total_lessons, created_at, updated_at) VALUES
(UUID(), @lang_de, @admin_id,  'German A1 - Anfanger', 'Khóa tiếng Đức cho người mới bắt đầu, bảng chữ cái và từ vựng cơ bản.', 'BEGINNER', 'https://images.unsplash.com/photo-1467269204594-9661b134dd2b?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_de, @admin_id,  'German A2 - Grundstufe', 'Nâng cao từ vựng và ngữ pháp cơ bản, giao tiếp hàng ngày.', 'ELEMENTARY', 'https://images.unsplash.com/photo-1509281373149-e957c6296406?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_de, @admin_id,  'German B1 - Mittelstufe', 'Giao tiếp lưu loát hơn, hiểu các chủ đề quen thuộc trong công việc.', 'INTERMEDIATE', 'https://images.unsplash.com/photo-1516546453174-5e1098a4b4af?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_de, @admin_id,  'German B2 - Oberstufe', 'Nâng cao ngữ pháp và từ vựng, chuẩn bị thi Goethe-Zertifikat B2.', 'UPPER_INTERMEDIATE', 'https://images.unsplash.com/photo-1482398651416-59d0878d0a5e?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_de, @admin_id,  'German for Business', 'Tiếng Đức thương mại, giao tiếp trong môi trường kinh doanh.', 'ADVANCED', 'https://images.unsplash.com/photo-1569012871812-f38ee64cd54c?w=500', true, 5, NOW(), NOW());

-- Spanish: 5 courses
INSERT INTO courses (id, language_id, created_by, title, description, level, thumbnail_url, is_published, total_lessons, created_at, updated_at) VALUES
(UUID(), @lang_es, @teacher_id, 'Spanish A1 - Principiante', 'Khóa tiếng Tây Ban Nha cho người mới, từ bảng chữ cái đến câu đơn giản.', 'BEGINNER', 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_es, @teacher_id, 'Spanish A2 - Elemental', 'Mở rộng từ vựng, ngữ pháp cơ bản, giao tiếp trong tình huống quen thuộc.', 'ELEMENTARY', 'https://images.unsplash.com/photo-1490750967868-88df5691cc19?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_es, @teacher_id, 'Spanish B1 - Intermedio', 'Phát triển kỹ năng giao tiếp, diễn đạt ý kiến về các chủ đề quen thuộc.', 'INTERMEDIATE', 'https://images.unsplash.com/photo-1508739773434-c26b3d09e071?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_es, @teacher_id, 'Spanish B2 - Avanzado', 'Nâng cao, hiểu các văn bản phức tạp, giao tiếp trôi chảy.', 'UPPER_INTERMEDIATE', 'https://images.unsplash.com/photo-1517137800586-2bfe43eb0fa1?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_es, @teacher_id, 'Spanish for Travel', 'Tiếng Tây Ban Nha cho du khách, 200 câu thiết yếu khi đi du lịch.', 'BEGINNER', 'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=500', true, 5, NOW(), NOW());

-- Vietnamese: 5 courses
INSERT INTO courses (id, language_id, created_by, title, description, level, thumbnail_url, is_published, total_lessons, created_at, updated_at) VALUES
(UUID(), @lang_vi, @admin_id,  'Vietnamese for Foreigners A1', 'Khóa tiếng Việt cho người nước ngoài, bảng chữ cái và phát âm cơ bản.', 'BEGINNER', 'https://images.unsplash.com/photo-1553835973-7041b4c85e78?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_vi, @admin_id,  'Vietnamese A2 - Daily Communication', 'Giao tiếp hàng ngày, từ vựng và mẫu câu thông dụng.', 'ELEMENTARY', 'https://images.unsplash.com/photo-1557050543-4d5f4e07ef46?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_vi, @admin_id,  'Vietnamese B1 - Intermediate', 'Nâng cao khả năng giao tiếp, hiểu các chủ đề quen thuộc.', 'INTERMEDIATE', 'https://images.unsplash.com/photo-1583417319070-4a69db38a482?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_vi, @admin_id,  'Vietnamese Culture & Language', 'Học tiếng Việt qua văn hóa, phong tục, ẩm thực Việt Nam.', 'INTERMEDIATE', 'https://images.unsplash.com/photo-1504870712357-65ea720d6078?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_vi, @admin_id,  'Vietnamese for Business', 'Tiếng Việt thương mại, giao tiếp trong công việc với đối tác Việt Nam.', 'ADVANCED', 'https://images.unsplash.com/photo-1508009603885-50cf7c579365?w=500', true, 5, NOW(), NOW());

-- Russian: 5 courses
INSERT INTO courses (id, language_id, created_by, title, description, level, thumbnail_url, is_published, total_lessons, created_at, updated_at) VALUES
(UUID(), @lang_ru, @teacher_id, 'Russian A1 - Beginner', 'Khóa tiếng Nga cho người mới, bảng chữ cáie Cyrillic và từ vựng cơ bản.', 'BEGINNER', 'https://images.unsplash.com/photo-1513326738677-b964603b136d?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_ru, @teacher_id, 'Russian A2 - Elementary', 'Mở rộng từ vựng, ngữ pháp cơ bản, giao tiếp đơn giản.', 'ELEMENTARY', 'https://images.unsplash.com/photo-1520106212299-d99c443e4568?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_ru, @teacher_id, 'Russian B1 - Intermediate', 'Phát triển khả năng giao tiếp, diễn đạt ý kiến về các chủ đề quen thuộc.', 'INTERMEDIATE', 'https://images.unsplash.com/photo-1534430480872-3498386e7856?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_ru, @teacher_id, 'Russian B2 - Upper Intermediate', 'Nâng cao ngữ pháp và từ vựng, hiểu các văn bản phức tạp.', 'UPPER_INTERMEDIATE', 'https://images.unsplash.com/photo-1543819082-8ea77aa1b7b4?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_ru, @teacher_id, 'Russian for Travel', 'Tiếng Nga cho du khách, 200 câu thiết yếu khi du lịch Nga.', 'BEGINNER', 'https://images.unsplash.com/photo-1513326738677-b964603b136d?w=500', true, 5, NOW(), NOW());

-- Portuguese: 5 courses
INSERT INTO courses (id, language_id, created_by, title, description, level, thumbnail_url, is_published, total_lessons, created_at, updated_at) VALUES
(UUID(), @lang_pt, @admin_id,  'Portuguese A1 - Iniciante', 'Khóa tiếng Bồ Đào Nha cho người mới, từ bảng chữ cái đến câu đơn giản.', 'BEGINNER', 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_pt, @admin_id,  'Portuguese A2 - Elementar', 'Mở rộng từ vựng, ngữ pháp cơ bản, giao tiếp trong tình huống quen thuộc.', 'ELEMENTARY', 'https://images.unsplash.com/photo-1483729558449-99ef09a8c325?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_pt, @admin_id,  'Portuguese B1 - Intermediario', 'Phát triển kỹ năng giao tiếp, diễn đạt ý kiến về các chủ đề quen thuộc.', 'INTERMEDIATE', 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_pt, @admin_id,  'Portuguese B2 - Avancado', 'Nâng cao, hiểu các văn bản phức tạp, giao tiếp trôi chảy.', 'UPPER_INTERMEDIATE', 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=500', true, 5, NOW(), NOW()),
(UUID(), @lang_pt, @admin_id,  'Portuguese for Travel', 'Tiếng Bồ Đào Nha cho du khách, 200 câu thiết yếu khi đi du lịch.', 'BEGINNER', 'https://images.unsplash.com/photo-1499856871958-5b9627545d1a?w=500', true, 5, NOW(), NOW());

-- ============================================================
-- 5. LESSONS - MỖI COURSE 5 LESSONS
-- ============================================================
-- English courses
SET @c_en_a1   = (SELECT id FROM courses WHERE title = 'English for Beginners A1' LIMIT 1);
SET @c_en_a2   = (SELECT id FROM courses WHERE title = 'English Elementary A2' LIMIT 1);
SET @c_en_b1   = (SELECT id FROM courses WHERE title = 'English Intermediate B1' LIMIT 1);
SET @c_en_bus  = (SELECT id FROM courses WHERE title = 'Business English B2' LIMIT 1);
SET @c_ielts   = (SELECT id FROM courses WHERE title = 'IELTS Preparation' LIMIT 1);

-- English for Beginners A1 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_en_a1, 'Greetings & Introductions', '<h2>Greetings & Introductions</h2><p>Learn how to greet people and introduce yourself in English.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_en_a1_1', NULL, 1, 15, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_en_a1, 'Numbers & Counting', '<h2>Numbers & Counting</h2><p>Count from one to one hundred and use numbers in everyday situations.</p>', 'VOCABULARY', NULL, NULL, 2, 12, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_en_a1, 'Colors & Shapes', '<h2>Colors & Shapes</h2><p>Describe the world around you with colors and shapes.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_en_a1_3', NULL, 3, 10, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_en_a1, 'Family Members', '<h2>Family Members</h2><p>Learn vocabulary for family members and talk about your family.</p>', 'VOCABULARY', NULL, NULL, 4, 15, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_en_a1, 'Days & Months', '<h2>Days & Months</h2><p>Learn the days of the week and months of the year.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_en_a1_5', NULL, 5, 12, false, 'MONTHLY', NOW(), NOW());

-- English Elementary A2 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_en_a2, 'Daily Routines', '<h2>Daily Routines</h2><p>Talk about what you do every day using present simple tense.</p>', 'GRAMMAR', NULL, NULL, 1, 20, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_en_a2, 'Food & Eating', '<h2>Food & Eating</h2><p>Vocabulary for food, meals, and talking about eating habits.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_en_a2_2', NULL, 2, 18, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_en_a2, 'Shopping & Money', '<h2>Shopping & Money</h2><p>Vocabulary for shopping, prices, and making purchases.</p>', 'VOCABULARY', NULL, NULL, 3, 15, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_en_a2, 'Present Continuous', '<h2>Present Continuous</h2><p>Describe actions happening right now with present continuous tense.</p>', 'GRAMMAR', 'https://www.youtube.com/watch?v=example_en_a2_4', NULL, 4, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_en_a2, 'Weather & Seasons', '<h2>Weather & Seasons</h2><p>Talk about weather, seasons, and what to wear.</p>', 'VOCABULARY', NULL, NULL, 5, 15, false, 'MONTHLY', NOW(), NOW());

-- English Intermediate B1 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_en_b1, 'At the Restaurant', '<h2>At the Restaurant</h2><p>Order food, make reservations and handle dining situations.</p>', 'LISTENING', 'https://www.youtube.com/watch?v=example_en_b1_1', 'https://audio.example.com/restaurant.mp3', 1, 25, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_en_b1, 'Past Tense Narratives', '<h2>Past Tense Narratives</h2><p>Tell stories and describe past events using past simple and continuous.</p>', 'GRAMMAR', NULL, NULL, 2, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_en_b1, 'Future Plans', '<h2>Future Plans</h2><p>Talk about future plans using going to, will, and present continuous.</p>', 'GRAMMAR', 'https://www.youtube.com/watch?v=example_en_b1_3', NULL, 3, 22, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_en_b1, 'Giving Directions', '<h2>Giving Directions</h2><p>Ask for and give directions in a city or building.</p>', 'VOCABULARY', NULL, NULL, 4, 18, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_en_b1, 'Hobbies & Interests', '<h2>Hobbies & Interests</h2><p>Talk about your hobbies, free time activities, and interests.</p>', 'SPEAKING', 'https://www.youtube.com/watch?v=example_en_b1_5', NULL, 5, 20, false, 'MONTHLY', NOW(), NOW());

-- Business English B2 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_en_bus, 'Business Email Writing', '<h2>Business Email Writing</h2><p>Write professional emails for various business situations.</p>', 'WRITING', 'https://www.youtube.com/watch?v=example_en_bus_1', NULL, 1, 30, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_en_bus, 'Meeting Vocabulary', '<h2>Meeting Vocabulary</h2><p>Essential vocabulary and phrases for business meetings.</p>', 'VOCABULARY', NULL, NULL, 2, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_en_bus, 'Presentation Skills', '<h2>Presentation Skills</h2><p>Deliver effective presentations in English.</p>', 'SPEAKING', 'https://www.youtube.com/watch?v=example_en_bus_3', NULL, 3, 35, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_en_bus, 'Negotiation Language', '<h2>Negotiation Language</h2><p>Phrases and strategies for business negotiations.</p>', 'VOCABULARY', NULL, NULL, 4, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_en_bus, 'Telephoning & Conferencing', '<h2>Telephoning & Conferencing</h2><p>Handle phone calls and video conferences professionally.</p>', 'LISTENING', 'https://www.youtube.com/watch?v=example_en_bus_5', 'https://audio.example.com/phone.mp3', 5, 25, false, 'MONTHLY', NOW(), NOW());

-- IELTS Preparation - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_ielts, 'IELTS Reading Strategies', '<h2>IELTS Reading Strategies</h2><p>Techniques to ace the IELTS reading module.</p>', 'READING', 'https://www.youtube.com/watch?v=example_ielts_1', NULL, 1, 40, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_ielts, 'IELTS Writing Task 1', '<h2>IELTS Writing Task 1</h2><p>How to describe graphs, charts, and diagrams effectively.</p>', 'WRITING', NULL, NULL, 2, 40, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ielts, 'IELTS Writing Task 2', '<h2>IELTS Writing Task 2</h2><p>Essay structure and argument development for IELTS Writing Task 2.</p>', 'WRITING', 'https://www.youtube.com/watch?v=example_ielts_3', NULL, 3, 45, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ielts, 'IELTS Listening Tips', '<h2>IELTS Listening Tips</h2><p>Common traps and strategies for the IELTS listening test.</p>', 'LISTENING', 'https://www.youtube.com/watch?v=example_ielts_4', 'https://audio.example.com/ielts_listening.mp3', 4, 35, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ielts, 'IELTS Speaking Part 1-3', '<h2>IELTS Speaking Part 1-3</h2><p>Complete guide to all three parts of the IELTS speaking test.</p>', 'SPEAKING', 'https://www.youtube.com/watch?v=example_ielts_5', NULL, 5, 40, false, 'MONTHLY', NOW(), NOW());

-- Japanese courses
SET @c_ja_n5   = (SELECT id FROM courses WHERE title = 'Japanese JLPT N5' LIMIT 1);
SET @c_ja_n4   = (SELECT id FROM courses WHERE title = 'Japanese JLPT N4' LIMIT 1);
SET @c_ja_n3   = (SELECT id FROM courses WHERE title = 'Japanese JLPT N3' LIMIT 1);
SET @c_ja_conv = (SELECT id FROM courses WHERE title = 'Japanese Conversation' LIMIT 1);
SET @c_ja_bus  = (SELECT id FROM courses WHERE title = 'Japanese Business' LIMIT 1);

-- Japanese JLPT N5 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_ja_n5, 'Hiragana - Basic Syllabaries', '<h2>Hiragana</h2><p>Learn all 46 Hiragana characters with pronunciation and writing.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_ja_n5_1', NULL, 1, 30, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_ja_n5, 'Katakana - Foreign Words', '<h2>Katakana</h2><p>Learn all 46 Katakana characters for foreign words and loanwords.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_ja_n5_2', NULL, 2, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ja_n5, 'Basic Grammar Patterns', '<h2>Basic Grammar - は, が, の</h2><p>Understanding basic Japanese sentence patterns with particles.</p>', 'GRAMMAR', NULL, NULL, 3, 30, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ja_n5, 'Numbers & Time', '<h2>Numbers & Time</h2><p>Count numbers, tell time, and express dates in Japanese.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_ja_n5_4', NULL, 4, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ja_n5, 'N5 Kanji Part 1', '<h2>N5 Kanji Part 1</h2><p>Learn the first 80 essential Kanji for JLPT N5.</p>', 'VOCABULARY', NULL, NULL, 5, 35, false, 'MONTHLY', NOW(), NOW());

-- Japanese JLPT N4 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_ja_n4, 'N4 Kanji Part 1', '<h2>N4 Kanji Part 1</h2><p>Learn essential Kanji for JLPT N4 level.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_ja_n4_1', NULL, 1, 35, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_ja_n4, 'Te-form Grammar', '<h2>Te-form Grammar</h2><p>Master the te-form for making requests, actions sequences, and requests.</p>', 'GRAMMAR', NULL, NULL, 2, 30, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ja_n4, 'N4 Grammar - Potential Form', '<h2>Potential Form</h2><p>Express ability and possibility using potential form.</p>', 'GRAMMAR', 'https://www.youtube.com/watch?v=example_ja_n4_3', NULL, 3, 28, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ja_n4, 'N4 Vocabulary', '<h2>N4 Vocabulary</h2><p>Essential vocabulary words for JLPT N4 examination.</p>', 'VOCABULARY', NULL, NULL, 4, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ja_n4, 'N4 Kanji Part 2', '<h2>N4 Kanji Part 2</h2><p>Continue learning Kanji for JLPT N4.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_ja_n4_5', NULL, 5, 35, false, 'MONTHLY', NOW(), NOW());

-- Japanese JLPT N3 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_ja_n3, 'N3 Grammar - Volitional Form', '<h2>Volitional Form</h2><p>Express volition, intention, and suggestion in N3 level Japanese.</p>', 'GRAMMAR', 'https://www.youtube.com/watch?v=example_ja_n3_1', NULL, 1, 35, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_ja_n3, 'N3 Kanji', '<h2>N3 Kanji</h2><p>Learn advanced Kanji required for JLPT N3.</p>', 'VOCABULARY', NULL, NULL, 2, 40, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ja_n3, 'N3 Passive & Causative', '<h2>Passive & Causative</h2><p>Understand and use passive and causative sentence patterns.</p>', 'GRAMMAR', 'https://www.youtube.com/watch?v=example_ja_n3_3', NULL, 3, 35, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ja_n3, 'N3 Vocabulary', '<h2>N3 Vocabulary</h2><p>Advanced vocabulary words for JLPT N3.</p>', 'VOCABULARY', NULL, NULL, 4, 30, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ja_n3, 'N3 Reading Comprehension', '<h2>N3 Reading Comprehension</h2><p>Practice reading passages and answering comprehension questions.</p>', 'READING', 'https://www.youtube.com/watch?v=example_ja_n3_5', NULL, 5, 40, false, 'MONTHLY', NOW(), NOW());

-- Japanese Conversation - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_ja_conv, 'Casual Greetings', '<h2>Casual Greetings</h2><p>Learn informal greetings used among friends in Japan.</p>', 'SPEAKING', 'https://www.youtube.com/watch?v=example_ja_conv_1', NULL, 1, 20, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_ja_conv, 'Making Plans', '<h2>Making Plans</h2><p>Discuss plans and schedules with friends in Japanese.</p>', 'SPEAKING', NULL, NULL, 2, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ja_conv, 'Shopping & Ordering', '<h2>Shopping & Ordering</h2><p>Go shopping and order items using natural Japanese expressions.</p>', 'SPEAKING', 'https://www.youtube.com/watch?v=example_ja_conv_3', NULL, 3, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ja_conv, 'Travel Japanese', '<h2>Travel Japanese</h2><p>Essential phrases for traveling in Japan.</p>', 'VOCABULARY', NULL, NULL, 4, 30, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ja_conv, 'Expressing Opinions', '<h2>Expressing Opinions</h2><p>Share your thoughts and opinions naturally in conversation.</p>', 'SPEAKING', 'https://www.youtube.com/watch?v=example_ja_conv_5', NULL, 5, 25, false, 'MONTHLY', NOW(), NOW());

-- Japanese Business - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_ja_bus, 'Business Japanese Basics', '<h2>Business Japanese Basics</h2><p>Essential keigo and business language for the workplace.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_ja_bus_1', NULL, 1, 30, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_ja_bus, 'Keigo - Honorific Language', '<h2>Keigo - Honorific Language</h2><p>Master the Japanese honorific language system (keigo).</p>', 'GRAMMAR', NULL, NULL, 2, 40, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ja_bus, 'Business Email Writing', '<h2>Business Email Writing</h2><p>Write professional emails in Japanese business context.</p>', 'WRITING', 'https://www.youtube.com/watch?v=example_ja_bus_3', NULL, 3, 35, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ja_bus, 'Business Meetings', '<h2>Business Meetings</h2><p>Vocabulary and phrases for business meetings in Japanese.</p>', 'VOCABULARY', NULL, NULL, 4, 30, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ja_bus, 'Phone & Video Conferences', '<h2>Phone & Video Conferences</h2><p>Handle business calls and video conferences professionally.</p>', 'LISTENING', 'https://www.youtube.com/watch?v=example_ja_bus_5', NULL, 5, 30, false, 'MONTHLY', NOW(), NOW());

-- Korean courses
SET @c_ko_beg = (SELECT id FROM courses WHERE title = 'Korean for Beginners' LIMIT 1);
SET @c_ko_ele = (SELECT id FROM courses WHERE title = 'Korean Elementary' LIMIT 1);
SET @c_ko_int = (SELECT id FROM courses WHERE title = 'Korean Intermediate' LIMIT 1);
SET @c_ko_topik = (SELECT id FROM courses WHERE title = 'Korean TOPIK I Preparation' LIMIT 1);
SET @c_ko_drama = (SELECT id FROM courses WHERE title = 'Korean K-Drama Style' LIMIT 1);

-- Korean for Beginners - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_ko_beg, 'Hangul - Korean Alphabet', '<h2>Hangul</h2><p>Learn all Korean consonants and vowels in the Hangul writing system.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_ko_beg_1', NULL, 1, 25, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_ko_beg, 'Basic Korean Sentences', '<h2>Basic Korean Sentences</h2><p>Form your first Korean sentences using simple patterns.</p>', 'GRAMMAR', NULL, NULL, 2, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ko_beg, 'Numbers & Counting', '<h2>Numbers & Counting</h2><p>Learn Korean numbers (native and Sino-Korean) and how to count.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_ko_beg_3', NULL, 3, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ko_beg, 'Greetings & Introductions', '<h2>Greetings & Introductions</h2><p>Say hello and introduce yourself in Korean naturally.</p>', 'VOCABULARY', NULL, NULL, 4, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ko_beg, 'Question Words', '<h2>Question Words</h2><p>Learn who, what, where, when, why, and how in Korean.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_ko_beg_5', NULL, 5, 20, false, 'MONTHLY', NOW(), NOW());

-- Korean Elementary - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_ko_ele, 'Korean Particles', '<h2>Korean Particles</h2><p>Understand topic, subject, object, and other essential particles.</p>', 'GRAMMAR', 'https://www.youtube.com/watch?v=example_ko_ele_1', NULL, 1, 25, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_ko_ele, 'Past & Future Tense', '<h2>Past & Future Tense</h2><p>Express past and future actions in Korean.</p>', 'GRAMMAR', NULL, NULL, 2, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ko_ele, 'Adjectives & Descriptions', '<h2>Adjectives & Descriptions</h2><p>Describe people, places, and things using Korean adjectives.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_ko_ele_3', NULL, 3, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ko_ele, 'At the Restaurant', '<h2>At the Restaurant</h2><p>Order food and drinks at a Korean restaurant.</p>', 'SPEAKING', NULL, NULL, 4, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ko_ele, 'Daily Activities', '<h2>Daily Activities</h2><p>Talk about your daily routine in Korean.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_ko_ele_5', NULL, 5, 20, false, 'MONTHLY', NOW(), NOW());

-- Korean Intermediate - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_ko_int, 'Korean Honorifics', '<h2>Korean Honorifics</h2><p>Master polite and formal speech levels in Korean.</p>', 'GRAMMAR', 'https://www.youtube.com/watch?v=example_ko_int_1', NULL, 1, 30, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_ko_int, 'Complex Sentences', '<h2>Complex Sentences</h2><p>Connect sentences using connectors and conjunctions.</p>', 'GRAMMAR', NULL, NULL, 2, 30, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ko_int, 'Expressing Opinions', '<h2>Expressing Opinions</h2><p>Share and justify your opinions in Korean.</p>', 'SPEAKING', 'https://www.youtube.com/watch?v=example_ko_int_3', NULL, 3, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ko_int, 'Making Requests', '<h2>Making Requests</h2><p>Ask people to do things politely using Korean expressions.</p>', 'GRAMMAR', NULL, NULL, 4, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ko_int, 'Korean Idioms', '<h2>Korean Idioms</h2><p>Learn common Korean idioms and expressions.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_ko_int_5', NULL, 5, 25, false, 'MONTHLY', NOW(), NOW());

-- Korean TOPIK I Preparation - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_ko_topik, 'TOPIK Vocabulary 1', '<h2>TOPIK Vocabulary 1</h2><p>Essential vocabulary words for TOPIK I test.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_ko_topik_1', NULL, 1, 30, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_ko_topik, 'TOPIK Grammar Patterns', '<h2>TOPIK Grammar Patterns</h2><p>Key grammar patterns that appear frequently on TOPIK I.</p>', 'GRAMMAR', NULL, NULL, 2, 35, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ko_topik, 'TOPIK Reading Practice', '<h2>TOPIK Reading Practice</h2><p>Practice reading passages with TOPIK-style questions.</p>', 'READING', 'https://www.youtube.com/watch?v=example_ko_topik_3', NULL, 3, 40, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ko_topik, 'TOPIK Listening Practice', '<h2>TOPIK Listening Practice</h2><p>Listening exercises similar to the TOPIK I test format.</p>', 'LISTENING', 'https://www.youtube.com/watch?v=example_ko_topik_4', 'https://audio.example.com/topik_listening.mp3', 4, 35, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ko_topik, 'TOPIK Writing Practice', '<h2>TOPIK Writing Practice</h2><p>Practice writing answers for TOPIK I writing section.</p>', 'WRITING', NULL, NULL, 5, 35, false, 'MONTHLY', NOW(), NOW());

-- Korean K-Drama Style - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_ko_drama, 'K-Drama Vocabulary', '<h2>K-Drama Vocabulary</h2><p>Words and expressions commonly heard in Korean dramas.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_ko_drama_1', NULL, 1, 20, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_ko_drama, 'Romantic Expressions', '<h2>Romantic Expressions</h2><p>Learn romantic and flirty expressions from K-dramas.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_ko_drama_2', NULL, 2, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ko_drama, 'Emotions & Reactions', '<h2>Emotions & Reactions</h2><p>Express emotions naturally like K-drama characters.</p>', 'SPEAKING', NULL, NULL, 3, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ko_drama, 'K-Drama Slang', '<h2>K-Drama Slang</h2><p>Casual slang and informal language from Korean dramas.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_ko_drama_4', NULL, 4, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ko_drama, 'K-Drama Dialogues', '<h2>K-Drama Dialogues</h2><p>Act out common dialogues from Korean dramas.</p>', 'SPEAKING', NULL, NULL, 5, 25, false, 'MONTHLY', NOW(), NOW());

-- Chinese courses
SET @c_zh_hsk1  = (SELECT id FROM courses WHERE title = 'Chinese HSK 1' LIMIT 1);
SET @c_zh_hsk2  = (SELECT id FROM courses WHERE title = 'Chinese HSK 2' LIMIT 1);
SET @c_zh_hsk3  = (SELECT id FROM courses WHERE title = 'Chinese HSK 3' LIMIT 1);
SET @c_zh_conv  = (SELECT id FROM courses WHERE title = 'Chinese Conversation' LIMIT 1);
SET @c_zh_bus   = (SELECT id FROM courses WHERE title = 'Chinese Business' LIMIT 1);

-- Chinese HSK 1 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_zh_hsk1, 'Chinese Pinyin Basics', '<h2>Chinese Pinyin Basics</h2><p>Learn Mandarin pronunciation with Pinyin romanization system.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_zh_hsk1_1', NULL, 1, 30, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_zh_hsk1, 'Basic Greetings', '<h2>Basic Greetings</h2><p>Say hello, goodbye, and common greetings in Mandarin Chinese.</p>', 'VOCABULARY', NULL, NULL, 2, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_zh_hsk1, 'Numbers & Time', '<h2>Numbers & Time</h2><p>Count, tell time, and express dates in Chinese.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_zh_hsk1_3', NULL, 3, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_zh_hsk1, 'Family & People', '<h2>Family & People</h2><p>Talk about your family and describe people in Chinese.</p>', 'VOCABULARY', NULL, NULL, 4, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_zh_hsk1, 'Food & Drinks', '<h2>Food & Drinks</h2><p>Order food and drinks in Chinese restaurants.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_zh_hsk1_5', NULL, 5, 20, false, 'MONTHLY', NOW(), NOW());

-- Chinese HSK 2 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_zh_hsk2, 'HSK 2 Grammar', '<h2>HSK 2 Grammar</h2><p>Essential grammar patterns for HSK 2 level.</p>', 'GRAMMAR', 'https://www.youtube.com/watch?v=example_zh_hsk2_1', NULL, 1, 30, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_zh_hsk2, 'Shopping & Prices', '<h2>Shopping & Prices</h2><p>Negotiate prices and buy things in Chinese markets.</p>', 'VOCABULARY', NULL, NULL, 2, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_zh_hsk2, 'Asking Directions', '<h2>Asking Directions</h2><p>Ask for and give directions in Mandarin Chinese.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_zh_hsk2_3', NULL, 3, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_zh_hsk2, 'Daily Activities', '<h2>Daily Activities</h2><p>Describe your daily routine in Chinese.</p>', 'VOCABULARY', NULL, NULL, 4, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_zh_hsk2, 'HSK 2 Vocabulary', '<h2>HSK 2 Vocabulary</h2><p>150 essential vocabulary words for HSK 2.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_zh_hsk2_5', NULL, 5, 25, false, 'MONTHLY', NOW(), NOW());

-- Chinese HSK 3 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_zh_hsk3, 'HSK 3 Grammar', '<h2>HSK 3 Grammar</h2><p>Advanced grammar patterns including 把, 被, and more.</p>', 'GRAMMAR', 'https://www.youtube.com/watch?v=example_zh_hsk3_1', NULL, 1, 35, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_zh_hsk3, 'HSK 3 Vocabulary', '<h2>HSK 3 Vocabulary</h2><p>300 essential vocabulary words for HSK 3.</p>', 'VOCABULARY', NULL, NULL, 2, 30, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_zh_hsk3, 'Travel in China', '<h2>Travel in China</h2><p>Book hotels, transportation, and sightseeing in Mandarin.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_zh_hsk3_3', NULL, 3, 30, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_zh_hsk3, 'Chinese Reading', '<h2>Chinese Reading</h2><p>Practice reading Chinese texts with comprehension questions.</p>', 'READING', NULL, NULL, 4, 35, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_zh_hsk3, 'Expressing Opinions', '<h2>Expressing Opinions</h2><p>Share your thoughts and discuss topics in Chinese.</p>', 'SPEAKING', 'https://www.youtube.com/watch?v=example_zh_hsk3_5', NULL, 5, 25, false, 'MONTHLY', NOW(), NOW());

-- Chinese Conversation - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_zh_conv, 'Casual Conversations', '<h2>Casual Conversations</h2><p>Chat naturally about everyday topics in Mandarin.</p>', 'SPEAKING', 'https://www.youtube.com/watch?v=example_zh_conv_1', NULL, 1, 25, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_zh_conv, 'Making Phone Calls', '<h2>Making Phone Calls</h2><p>Handle phone conversations in professional and casual settings.</p>', 'SPEAKING', NULL, NULL, 2, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_zh_conv, 'Chinese Social Media', '<h2>Chinese Social Media</h2><p>Understand and use language from Chinese social platforms.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_zh_conv_3', NULL, 3, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_zh_conv, 'Weather & Seasons', '<h2>Weather & Seasons</h2><p>Talk about weather conditions and seasonal activities.</p>', 'VOCABULARY', NULL, NULL, 4, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_zh_conv, 'Expressing Emotions', '<h2>Expressing Emotions</h2><p>Express feelings, reactions, and emotions naturally in Chinese.</p>', 'SPEAKING', 'https://www.youtube.com/watch?v=example_zh_conv_5', NULL, 5, 25, false, 'MONTHLY', NOW(), NOW());

-- Chinese Business - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_zh_bus, 'Business Chinese Basics', '<h2>Business Chinese Basics</h2><p>Essential vocabulary and phrases for the Chinese business world.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_zh_bus_1', NULL, 1, 30, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_zh_bus, 'Business Meetings', '<h2>Business Meetings</h2><p>Conduct and participate in meetings in Mandarin Chinese.</p>', 'VOCABULARY', NULL, NULL, 2, 35, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_zh_bus, 'Business Email Writing', '<h2>Business Email Writing</h2><p>Write professional emails in Chinese business context.</p>', 'WRITING', 'https://www.youtube.com/watch?v=example_zh_bus_3', NULL, 3, 35, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_zh_bus, 'Negotiation Language', '<h2>Negotiation Language</h2><p>Chinese phrases and strategies for business negotiations.</p>', 'VOCABULARY', NULL, NULL, 4, 35, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_zh_bus, 'Chinese Business Culture', '<h2>Chinese Business Culture</h2><p>Navigate business customs, etiquette, and cultural norms in China.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_zh_bus_5', NULL, 5, 30, false, 'MONTHLY', NOW(), NOW());

-- French courses
SET @c_fr_a1   = (SELECT id FROM courses WHERE title = 'French A1 - Debutant' LIMIT 1);
SET @c_fr_a2   = (SELECT id FROM courses WHERE title = 'French A2 - Elementaire' LIMIT 1);
SET @c_fr_b1   = (SELECT id FROM courses WHERE title = 'French B1 - Intermediaire' LIMIT 1);
SET @c_fr_b2   = (SELECT id FROM courses WHERE title = 'French B2 - Avance' LIMIT 1);
SET @c_fr_trav = (SELECT id FROM courses WHERE title = 'French for Travel' LIMIT 1);

-- French A1 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_fr_a1, 'Les Salutations', '<h2>Les Salutations</h2><p>Bonjour, merci, au revoir... Những lời chào cơ bản trong tiếng Pháp.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_fr_a1_1', NULL, 1, 15, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_fr_a1, 'Se presenter', '<h2>Se presenter</h2><p>Introduce yourself: je m appelle, j ai, j habite.</p>', 'VOCABULARY', NULL, NULL, 2, 15, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_fr_a1, 'Les Nombres', '<h2>Les Nombres</h2><p>Count from 0 to 100 in French.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_fr_a1_3', NULL, 3, 15, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_fr_a1, 'La Famille', '<h2>La Famille</h2><p>Vocabulary for family members in French.</p>', 'VOCABULARY', NULL, NULL, 4, 15, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_fr_a1, 'Les Jours et Mois', '<h2>Les Jours et Mois</h2><p>Days of the week and months of the year in French.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_fr_a1_5', NULL, 5, 12, false, 'MONTHLY', NOW(), NOW());

-- French A2 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_fr_a2, 'Les Vetements', '<h2>Les Vetements</h2><p>Vocabulary for clothing and accessories in French.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_fr_a2_1', NULL, 1, 20, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_fr_a2, 'Au Restaurant', '<h2>Au Restaurant</h2><p>Order food and drinks at a French restaurant.</p>', 'VOCABULARY', NULL, NULL, 2, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_fr_a2, 'Le Passe Compose', '<h2>Le Passe Compose</h2><p>Express past events using passe compose.</p>', 'GRAMMAR', 'https://www.youtube.com/watch?v=example_fr_a2_3', NULL, 3, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_fr_a2, 'Les Transports', '<h2>Les Transports</h2><p>Talk about transportation and directions in French.</p>', 'VOCABULARY', NULL, NULL, 4, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_fr_a2, 'Les Vacances', '<h2>Les Vacances</h2><p>Plan and talk about vacations in French.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_fr_a2_5', NULL, 5, 20, false, 'MONTHLY', NOW(), NOW());

-- French B1 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_fr_b1, 'L Imparfait', '<h2>L Imparfait</h2><p>Describe past habits and ongoing actions using imparfait.</p>', 'GRAMMAR', 'https://www.youtube.com/watch?v=example_fr_b1_1', NULL, 1, 25, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_fr_b1, 'Exprimer son Opinion', '<h2>Exprimer son Opinion</h2><p>Express opinions, agree and disagree in French.</p>', 'SPEAKING', NULL, NULL, 2, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_fr_b1, 'Le Subjonctif Present', '<h2>Le Subjonctif Present</h2><p>Master the subjunctive mood in French.</p>', 'GRAMMAR', 'https://www.youtube.com/watch?v=example_fr_b1_3', NULL, 3, 30, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_fr_b1, 'La Presse Francaise', '<h2>La Presse Francaise</h2><p>Read and understand French news articles.</p>', 'READING', NULL, NULL, 4, 30, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_fr_b1, 'Les Relations Sociales', '<h2>Les Relations Sociales</h2><p>Navigate social situations and relationships in French.</p>', 'SPEAKING', 'https://www.youtube.com/watch?v=example_fr_b1_5', NULL, 5, 25, false, 'MONTHLY', NOW(), NOW());

-- French B2 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_fr_b2, 'Le Conditionnel Present', '<h2>Le Conditionnel Present</h2><p>Express hypothetical situations using conditional.</p>', 'GRAMMAR', 'https://www.youtube.com/watch?v=example_fr_b2_1', NULL, 1, 30, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_fr_b2, 'Le Discours Rapporte', '<h2>Le Discours Rapporte</h2><p>Report what others said using indirect speech.</p>', 'GRAMMAR', NULL, NULL, 2, 30, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_fr_b2, 'Redaction Littendaire', '<h2>Redaction Litteraire</h2><p>Write short literary texts in French.</p>', 'WRITING', 'https://www.youtube.com/watch?v=example_fr_b2_3', NULL, 3, 35, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_fr_b2, 'Expressions Idiomatiques', '<h2>Expressions Idiomatiques</h2><p>Learn common French idiomatic expressions.</p>', 'VOCABULARY', NULL, NULL, 4, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_fr_b2, 'Debat et Argumentation', '<h2>Debat et Argumentation</h2><p>Participate in debates and build strong arguments.</p>', 'SPEAKING', 'https://www.youtube.com/watch?v=example_fr_b2_5', NULL, 5, 35, false, 'MONTHLY', NOW(), NOW());

-- French for Travel - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_fr_trav, 'A l Aeroport', '<h2>A l Aeroport</h2><p>Navigate airports in French: check-in, boarding, customs.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_fr_trav_1', NULL, 1, 20, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_fr_trav, 'A l Hotel', '<h2>A l Hotel</h2><p>Book rooms, ask for services, and check out in French.</p>', 'VOCABULARY', NULL, NULL, 2, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_fr_trav, 'En Ville', '<h2>En Ville</h2><p>Ask for directions and explore a French city.</p>', 'SPEAKING', 'https://www.youtube.com/watch?v=example_fr_trav_3', NULL, 3, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_fr_trav, 'Les Achats', '<h2>Les Achats</h2><p>Shop for souvenirs and negotiate prices in French.</p>', 'VOCABULARY', NULL, NULL, 4, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_fr_trav, 'Les Urgences', '<h2>Les Urgences</h2><p>Handle emergencies and ask for help while traveling.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_fr_trav_5', NULL, 5, 20, false, 'MONTHLY', NOW(), NOW());

-- German courses
SET @c_de_a1   = (SELECT id FROM courses WHERE title = 'German A1 - Anfanger' LIMIT 1);
SET @c_de_a2   = (SELECT id FROM courses WHERE title = 'German A2 - Grundstufe' LIMIT 1);
SET @c_de_b1   = (SELECT id FROM courses WHERE title = 'German B1 - Mittelstufe' LIMIT 1);
SET @c_de_b2   = (SELECT id FROM courses WHERE title = 'German B2 - Oberstufe' LIMIT 1);
SET @c_de_bus  = (SELECT id FROM courses WHERE title = 'German for Business' LIMIT 1);

-- German A1 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_de_a1, 'Deutsche Begrussungen', '<h2>Deutsche Begrussungen</h2><p>German greetings: Guten Tag, Auf Wiedersehen, Tschuss.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_de_a1_1', NULL, 1, 15, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_de_a1, 'Sich Vorstellen', '<h2>Sich Vorstellen</h2><p>Introduce yourself: Ich heisse, Ich komme aus, Ich bin.</p>', 'VOCABULARY', NULL, NULL, 2, 15, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_de_a1, 'Zahlen 1-100', '<h2>Zahlen 1-100</h2><p>Count from 1 to 100 in German.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_de_a1_3', NULL, 3, 15, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_de_a1, 'Die Familie', '<h2>Die Familie</h2><p>Family vocabulary in German.</p>', 'VOCABULARY', NULL, NULL, 4, 15, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_de_a1, 'Wochentage und Monate', '<h2>Wochentage und Monate</h2><p>Days of the week and months in German.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_de_a1_5', NULL, 5, 12, false, 'MONTHLY', NOW(), NOW());

-- German A2 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_de_a2, 'Im Restaurant', '<h2>Im Restaurant</h2><p>Order food and drinks at a German restaurant.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_de_a2_1', NULL, 1, 20, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_de_a2, 'Einkaufen', '<h2>Einkaufen</h2><p>Shopping vocabulary and making purchases in German.</p>', 'VOCABULARY', NULL, NULL, 2, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_de_a2, 'Das Perfekt', '<h2>Das Perfekt</h2><p>Express past events using Perfekt tense.</p>', 'GRAMMAR', 'https://www.youtube.com/watch?v=example_de_a2_3', NULL, 3, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_de_a2, 'Ortsangaben', '<h2>Ortsangaben</h2><p>Give and ask for directions in German.</p>', 'VOCABULARY', NULL, NULL, 4, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_de_a2, 'Freizeit und Hobbys', '<h2>Freizeit und Hobbys</h2><p>Talk about free time activities and hobbies.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_de_a2_5', NULL, 5, 20, false, 'MONTHLY', NOW(), NOW());

-- German B1 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_de_b1, 'Meinungen aussern', '<h2>Meinungen aussern</h2><p>Express opinions, agree and disagree in German.</p>', 'SPEAKING', 'https://www.youtube.com/watch?v=example_de_b1_1', NULL, 1, 25, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_de_b1, 'Die Vergangenheit', '<h2>Die Vergangenheit</h2><p>Prateritum vs Perfekt in spoken and written German.</p>', 'GRAMMAR', NULL, NULL, 2, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_de_b1, 'Deutsch lesen', '<h2>Deutsch lesen</h2><p>Read German texts with improved comprehension skills.</p>', 'READING', 'https://www.youtube.com/watch?v=example_de_b1_3', NULL, 3, 30, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_de_b1, 'Gesundheit', '<h2>Gesundheit</h2><p>Talk about health, visits to the doctor, and wellness.</p>', 'VOCABULARY', NULL, NULL, 4, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_de_b1, 'Kultur und Kunst', '<h2>Kultur und Kunst</h2><p>Discuss German and Austrian culture, art, and traditions.</p>', 'SPEAKING', 'https://www.youtube.com/watch?v=example_de_b1_5', NULL, 5, 25, false, 'MONTHLY', NOW(), NOW());

-- German B2 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_de_b2, 'Konjunktiv II', '<h2>Konjunktiv II</h2><p>Express wishes and hypothetical situations using Konjunktiv II.</p>', 'GRAMMAR', 'https://www.youtube.com/watch?v=example_de_b2_1', NULL, 1, 30, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_de_b2, 'Nebensatze', '<h2>Nebensatze</h2><p>Master subordinate clauses with weil, obwohl, dass.</p>', 'GRAMMAR', NULL, NULL, 2, 30, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_de_b2, 'Aufsatzschreiben', '<h2>Aufsatzschreiben</h2><p>Write structured essays and arguments in German.</p>', 'WRITING', 'https://www.youtube.com/watch?v=example_de_b2_3', NULL, 3, 35, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_de_b2, 'Redewendungen', '<h2>Redewendungen</h2><p>Common German idiomatic expressions and sayings.</p>', 'VOCABULARY', NULL, NULL, 4, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_de_b2, 'Debatte und Argumentation', '<h2>Debatte und Argumentation</h2><p>Participate in formal debates with strong arguments.</p>', 'SPEAKING', 'https://www.youtube.com/watch?v=example_de_b2_5', NULL, 5, 35, false, 'MONTHLY', NOW(), NOW());

-- German for Business - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_de_bus, 'Geschaftsdeutsch Grundlagen', '<h2>Geschaftsdeutsch Grundlagen</h2><p>Essential business German vocabulary and phrases.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_de_bus_1', NULL, 1, 30, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_de_bus, 'Geschaftsbriefe', '<h2>Geschaftsbriefe</h2><p>Write professional German business letters.</p>', 'WRITING', NULL, NULL, 2, 35, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_de_bus, 'Besprechungen', '<h2>Besprechungen</h2><p>Vocabulary and phrases for German business meetings.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_de_bus_3', NULL, 3, 35, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_de_bus, 'Verhandeln', '<h2>Verhandeln</h2><p>Negotiation strategies and language in German business.</p>', 'VOCABULARY', NULL, NULL, 4, 35, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_de_bus, 'Deutsch im BUro', '<h2>Deutsch im BUro</h2><p>German for office communication and scheduling.</p>', 'LISTENING', 'https://www.youtube.com/watch?v=example_de_bus_5', NULL, 5, 30, false, 'MONTHLY', NOW(), NOW());

-- Spanish courses
SET @c_es_a1   = (SELECT id FROM courses WHERE title = 'Spanish A1 - Principiante' LIMIT 1);
SET @c_es_a2   = (SELECT id FROM courses WHERE title = 'Spanish A2 - Elemental' LIMIT 1);
SET @c_es_b1   = (SELECT id FROM courses WHERE title = 'Spanish B1 - Intermedio' LIMIT 1);
SET @c_es_b2   = (SELECT id FROM courses WHERE title = 'Spanish B2 - Avanzado' LIMIT 1);
SET @c_es_trav = (SELECT id FROM courses WHERE title = 'Spanish for Travel' LIMIT 1);

-- Spanish A1 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_es_a1, 'Saludos y Despedidas', '<h2>Saludos y Despedidas</h2><p>Hola, buenos dias, adios... Basic greetings in Spanish.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_es_a1_1', NULL, 1, 15, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_es_a1, 'Presentarse', '<h2>Presentarse</h2><p>Introduce yourself: me llamo, tengo, soy de.</p>', 'VOCABULARY', NULL, NULL, 2, 15, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_es_a1, 'Los Numeros', '<h2>Los Numeros</h2><p>Count from 0 to 100 in Spanish.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_es_a1_3', NULL, 3, 15, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_es_a1, 'La Familia', '<h2>La Familia</h2><p>Family vocabulary in Spanish.</p>', 'VOCABULARY', NULL, NULL, 4, 15, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_es_a1, 'Los Dias y los Meses', '<h2>Los Dias y los Meses</h2><p>Days of the week and months of the year in Spanish.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_es_a1_5', NULL, 5, 12, false, 'MONTHLY', NOW(), NOW());

-- Spanish A2 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_es_a2, 'En el Restaurante', '<h2>En el Restaurante</h2><p>Order food and drinks at a Spanish restaurant.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_es_a2_1', NULL, 1, 20, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_es_a2, 'Presente Continuo', '<h2>Presente Continuo</h2><p>Describe actions happening right now with estar + gerundio.</p>', 'GRAMMAR', NULL, NULL, 2, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_es_a2, 'Pretérito Indefinido', '<h2>Preterito Indefinido</h2><p>Express completed past actions using preterite tense.</p>', 'GRAMMAR', 'https://www.youtube.com/watch?v=example_es_a2_3', NULL, 3, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_es_a2, 'De Compras', '<h2>De Compras</h2><p>Shopping vocabulary and negotiating in Spanish.</p>', 'VOCABULARY', NULL, NULL, 4, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_es_a2, 'Los Viajes', '<h2>Los Viajes</h2><p>Plan trips, book hotels, and navigate airports.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_es_a2_5', NULL, 5, 20, false, 'MONTHLY', NOW(), NOW());

-- Spanish B1 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_es_b1, 'Impersonal Expressions', '<h2>Impersonal Expressions</h2><p>Use se puede, hay que, es necesario for impersonal statements.</p>', 'GRAMMAR', 'https://www.youtube.com/watch?v=example_es_b1_1', NULL, 1, 25, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_es_b1, 'Subjuntivo Presente', '<h2>Subjuntivo Presente</h2><p>Master the present subjunctive mood in Spanish.</p>', 'GRAMMAR', NULL, NULL, 2, 30, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_es_b1, 'Exprima su Opinion', '<h2>Exprima su Opinion</h2><p>Express opinions, hopes, and wishes in Spanish.</p>', 'SPEAKING', 'https://www.youtube.com/watch?v=example_es_b1_3', NULL, 3, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_es_b1, 'Lectura en Espanol', '<h2>Lectura en Espanol</h2><p>Read Spanish texts with improved comprehension.</p>', 'READING', NULL, NULL, 4, 30, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_es_b1, 'Cultura Hispanica', '<h2>Cultura Hispanica</h2><p>Explore Spanish-speaking cultures around the world.</p>', 'SPEAKING', 'https://www.youtube.com/watch?v=example_es_b1_5', NULL, 5, 25, false, 'MONTHLY', NOW(), NOW());

-- Spanish B2 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_es_b2, 'Pretérito Pluscuamperfecto', '<h2>Preterito Pluscuamperfecto</h2><p>Express past events that happened before another past event.</p>', 'GRAMMAR', 'https://www.youtube.com/watch?v=example_es_b2_1', NULL, 1, 30, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_es_b2, 'Discurso Indirecto', '<h2>Discurso Indirecto</h2><p>Report what others said using indirect speech in Spanish.</p>', 'GRAMMAR', NULL, NULL, 2, 30, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_es_b2, 'Escritura Academica', '<h2>Escritura Academica</h2><p>Write academic essays and formal documents in Spanish.</p>', 'WRITING', 'https://www.youtube.com/watch?v=example_es_b2_3', NULL, 3, 35, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_es_b2, 'Expresiones Idiomáticas', '<h2>Expresiones Idiomáticas</h2><p>Common Spanish idiomatic expressions and sayings.</p>', 'VOCABULARY', NULL, NULL, 4, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_es_b2, 'Debate y Argumentación', '<h2>Debate y Argumentacion</h2><p>Participate in formal debates with structured arguments.</p>', 'SPEAKING', 'https://www.youtube.com/watch?v=example_es_b2_5', NULL, 5, 35, false, 'MONTHLY', NOW(), NOW());

-- Spanish for Travel - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_es_trav, 'En el Aeropuerto', '<h2>En el Aeropuerto</h2><p>Navigate airports in Spanish: check-in, boarding, customs.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_es_trav_1', NULL, 1, 20, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_es_trav, 'En el Hotel', '<h2>En el Hotel</h2><p>Book rooms, request services, and check out in Spanish.</p>', 'VOCABULARY', NULL, NULL, 2, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_es_trav, 'Pidiendo Direcciones', '<h2>Pidiendo Direcciones</h2><p>Ask for and give directions while exploring a Spanish city.</p>', 'SPEAKING', 'https://www.youtube.com/watch?v=example_es_trav_3', NULL, 3, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_es_trav, 'De Compras en la Calle', '<h2>De Compras en la Calle</h2><p>Shop at local markets and bargain in Spanish.</p>', 'VOCABULARY', NULL, NULL, 4, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_es_trav, 'Emergencias', '<h2>Emergencias</h2><p>Handle emergencies and ask for help while traveling.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_es_trav_5', NULL, 5, 20, false, 'MONTHLY', NOW(), NOW());

-- Vietnamese courses
SET @c_vi_a1   = (SELECT id FROM courses WHERE title = 'Vietnamese for Foreigners A1' LIMIT 1);
SET @c_vi_a2   = (SELECT id FROM courses WHERE title = 'Vietnamese A2 - Daily Communication' LIMIT 1);
SET @c_vi_b1   = (SELECT id FROM courses WHERE title = 'Vietnamese B1 - Intermediate' LIMIT 1);
SET @c_vi_cult = (SELECT id FROM courses WHERE title = 'Vietnamese Culture & Language' LIMIT 1);
SET @c_vi_bus  = (SELECT id FROM courses WHERE title = 'Vietnamese for Business' LIMIT 1);

-- Vietnamese A1 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_vi_a1, 'Chao hoi & Gioi thieu', '<h2>Chao hoi & Gioi thieu</h2><p>Xin chao, tam biet, gioi thieu ban than bang tieng Viet.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_vi_a1_1', NULL, 1, 15, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_vi_a1, 'So dem & Gio', '<h2>So dem & Gio</h2><p>Dem so, xem gio, hoc cach hoi gio trong tieng Viet.</p>', 'VOCABULARY', NULL, NULL, 2, 15, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_vi_a1, 'Bo chu cai', '<h2>Bo chu cai</h2><p>Hoc bang chu cai tieng Viet va cach phat am.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_vi_a1_3', NULL, 3, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_vi_a1, 'Gia dinh', '<h2>Gia dinh</h2><p>Tu vung ve gia dinh trong tieng Viet.</p>', 'VOCABULARY', NULL, NULL, 4, 15, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_vi_a1, 'Ngay thang', '<h2>Ngay thang</h2><p>Cac ngay trong tuan va thang trong nam bang tieng Viet.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_vi_a1_5', NULL, 5, 12, false, 'MONTHLY', NOW(), NOW());

-- Vietnamese A2 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_vi_a2, 'Di choi & Mua sam', '<h2>Di choi & Mua sam</h2><p>Mua do, thuong luong gia, giao tiep tai thi truong.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_vi_a2_1', NULL, 1, 20, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_vi_a2, 'Nha hang & Mon an', '<h2>Nha hang & Mon an</h2><p>Order mon an, uong nuoc tai nha hang Viet Nam.</p>', 'VOCABULARY', NULL, NULL, 2, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_vi_a2, 'Di lai', '<h2>Di lai</h2><p>Huong dan di chuyen, hoi duong, su dung phuong tien giao thong.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_vi_a2_3', NULL, 3, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_vi_a2, 'Khach san', '<h2>Khach san</h2><p>Dat phong, yeu cau dich vu, tra phong khach san.</p>', 'VOCABULARY', NULL, NULL, 4, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_vi_a2, 'Suc khoe', '<h2>Suc khoe</h2><p>Noi ve suc khoe, di kham, mua thuoc tai hieu thuoc.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_vi_a2_5', NULL, 5, 20, false, 'MONTHLY', NOW(), NOW());

-- Vietnamese B1 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_vi_b1, 'Nghe & Hieu', '<h2>Nghe & Hieu</h2><p>Luyen nghe tieng Viet, hieu cac tinh huong giao tiep thong dung.</p>', 'LISTENING', 'https://www.youtube.com/watch?v=example_vi_b1_1', NULL, 1, 25, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_vi_b1, 'Bieu dien cam xuc', '<h2>Bieu dien cam xuc</h2><p>Bieu hien cam xuc, cam on, xin loi, gap lai trong tieng Viet.</p>', 'SPEAKING', NULL, NULL, 2, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_vi_b1, 'Van phong', '<h2>Van phong</h2><p>Lam viec tai van phong, noi chuyen trong moi truong lam viec.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_vi_b1_3', NULL, 3, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_vi_b1, 'Giai tri', '<h2>Giai tri</h2><p>Noi ve phim, am nhac, the thao va cac hoat dong giai tri.</p>', 'SPEAKING', NULL, NULL, 4, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_vi_b1, 'Giao tiep xa hoi', '<h2>Giao tiep xa hoi</h2><p>Giao tiep trong cac tinh huong xa hoi khac nhau.</p>', 'SPEAKING', 'https://www.youtube.com/watch?v=example_vi_b1_5', NULL, 5, 25, false, 'MONTHLY', NOW(), NOW());

-- Vietnamese Culture & Language - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_vi_cult, 'Am thuc Viet Nam', '<h2>Am thuc Viet Nam</h2><p>Hoc tieng Viet qua am thuc: mon an, cach che bien, goi ten.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_vi_cult_1', NULL, 1, 25, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_vi_cult, 'Le hoi Viet Nam', '<h2>Le hoi Viet Nam</h2><p>Cac le hoi, phong tuc, tap quan cua nguoi Viet Nam.</p>', 'VOCABULARY', NULL, NULL, 2, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_vi_cult, 'Van hoa gia dinh', '<h2>Van hoa gia dinh</h2><p>Giao tiep trong gia dinh, cac bieu hien van hoa Viet.</p>', 'SPEAKING', 'https://www.youtube.com/watch?v=example_vi_cult_3', NULL, 3, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_vi_cult, 'Du lich Viet Nam', '<h2>Du lich Viet Nam</h2><p>Khám phá các địa điểm du lịch nổi tiếng của Việt Nam.</p>', 'VOCABULARY', NULL, NULL, 4, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_vi_cult, 'Thanh ngu & Tuc ngu', '<h2>Thanh ngu & Tuc ngu</h2><p>Các thành ngữ, tục ngữ phổ biến trong tiếng Việt.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_vi_cult_5', NULL, 5, 25, false, 'MONTHLY', NOW(), NOW());

-- Vietnamese for Business - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_vi_bus, 'Tieng Viet van phong', '<h2>Tieng Viet van phong</h2><p>Tu vung va thuc hanh tieng Viet trong moi truong lam viec.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_vi_bus_1', NULL, 1, 30, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_vi_bus, 'Hop dong & Thuong mai', '<h2>Hop dong & Thuong mai</h2><p>Thuat ngu trong hop dong, ký ket thuong mai.</p>', 'VOCABULARY', NULL, NULL, 2, 35, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_vi_bus, 'Email doanh nghiep', '<h2>Email doanh nghiep</h2><p>Viet email chuyen nghiep trong tieng Viet.</p>', 'WRITING', 'https://www.youtube.com/watch?v=example_vi_bus_3', NULL, 3, 35, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_vi_bus, 'Dam phan kinh doanh', '<h2>Dam phan kinh doanh</h2><p>Cau truc va ky nang dam phan voi doi tac Viet Nam.</p>', 'SPEAKING', NULL, NULL, 4, 35, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_vi_bus, 'Van hoa kinh doanh Viet', '<h2>Van hoa kinh doanh Viet</h2><p>Phong tục, le roi, va van hoa kinh doanh tai Viet Nam.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_vi_bus_5', NULL, 5, 30, false, 'MONTHLY', NOW(), NOW());

-- Russian courses
SET @c_ru_a1   = (SELECT id FROM courses WHERE title = 'Russian A1 - Beginner' LIMIT 1);
SET @c_ru_a2   = (SELECT id FROM courses WHERE title = 'Russian A2 - Elementary' LIMIT 1);
SET @c_ru_b1   = (SELECT id FROM courses WHERE title = 'Russian B1 - Intermediate' LIMIT 1);
SET @c_ru_b2   = (SELECT id FROM courses WHERE title = 'Russian B2 - Upper Intermediate' LIMIT 1);
SET @c_ru_trav = (SELECT id FROM courses WHERE title = 'Russian for Travel' LIMIT 1);

-- Russian A1 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_ru_a1, 'Russian Alphabet (Cyrillic)', '<h2>Russian Alphabet</h2><p>Learn the Cyrillic alphabet used in the Russian language.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_ru_a1_1', NULL, 1, 30, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_ru_a1, 'Basic Greetings', '<h2>Basic Greetings</h2><p>Say hello, goodbye, and common greetings in Russian.</p>', 'VOCABULARY', NULL, NULL, 2, 15, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ru_a1, 'Numbers & Counting', '<h2>Numbers & Counting</h2><p>Count from 0 to 100 in Russian.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_ru_a1_3', NULL, 3, 15, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ru_a1, 'Introducing Yourself', '<h2>Introducing Yourself</h2><p>Introduce yourself: menya zovut, ya iz, mne let.</p>', 'VOCABULARY', NULL, NULL, 4, 15, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ru_a1, 'Family Members', '<h2>Family Members</h2><p>Family vocabulary in Russian.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_ru_a1_5', NULL, 5, 15, false, 'MONTHLY', NOW(), NOW());

-- Russian A2 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_ru_a2, 'Past Tense', '<h2>Past Tense</h2><p>Express past actions using the Russian past tense.</p>', 'GRAMMAR', 'https://www.youtube.com/watch?v=example_ru_a2_1', NULL, 1, 25, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_ru_a2, 'Food & Restaurant', '<h2>Food & Restaurant</h2><p>Order food and drinks at a Russian restaurant.</p>', 'VOCABULARY', NULL, NULL, 2, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ru_a2, 'Shopping & Prices', '<h2>Shopping & Prices</h2><p>Shop and negotiate prices in Russian.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_ru_a2_3', NULL, 3, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ru_a2, 'Future Tense', '<h2>Future Tense</h2><p>Express future actions using Russian future tense.</p>', 'GRAMMAR', NULL, NULL, 4, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ru_a2, 'Asking Directions', '<h2>Asking Directions</h2><p>Ask for and give directions in Russian.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_ru_a2_5', NULL, 5, 20, false, 'MONTHLY', NOW(), NOW());

-- Russian B1 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_ru_b1, 'Expressing Opinions', '<h2>Expressing Opinions</h2><p>Share your thoughts and opinions in Russian.</p>', 'SPEAKING', 'https://www.youtube.com/watch?v=example_ru_b1_1', NULL, 1, 25, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_ru_b1, 'Russian Cases Review', '<h2>Russian Cases Review</h2><p>Review and master the six cases in Russian grammar.</p>', 'GRAMMAR', NULL, NULL, 2, 30, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ru_b1, 'Conditional & Subjunctive', '<h2>Conditional & Subjunctive</h2><p>Express hypothetical situations in Russian.</p>', 'GRAMMAR', 'https://www.youtube.com/watch?v=example_ru_b1_3', NULL, 3, 30, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ru_b1, 'Russian Literature', '<h2>Russian Literature</h2><p>Read and understand simplified Russian literature.</p>', 'READING', NULL, NULL, 4, 35, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ru_b1, 'Russian Idioms', '<h2>Russian Idioms</h2><p>Learn common Russian idiomatic expressions.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_ru_b1_5', NULL, 5, 25, false, 'MONTHLY', NOW(), NOW());

-- Russian B2 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_ru_b2, 'Complex Sentence Structures', '<h2>Complex Sentence Structures</h2><p>Build complex sentences with multiple clauses.</p>', 'GRAMMAR', 'https://www.youtube.com/watch?v=example_ru_b2_1', NULL, 1, 30, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_ru_b2, 'Russian News Reading', '<h2>Russian News Reading</h2><p>Read and understand Russian news articles.</p>', 'READING', NULL, NULL, 2, 35, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ru_b2, 'Academic Writing', '<h2>Academic Writing</h2><p>Write essays and formal documents in Russian.</p>', 'WRITING', 'https://www.youtube.com/watch?v=example_ru_b2_3', NULL, 3, 35, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ru_b2, 'Debate & Argumentation', '<h2>Debate & Argumentation</h2><p>Participate in debates and build strong arguments.</p>', 'SPEAKING', NULL, NULL, 4, 35, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ru_b2, 'Russian Formal Speech', '<h2>Russian Formal Speech</h2><p>Master formal speech patterns for professional settings.</p>', 'SPEAKING', 'https://www.youtube.com/watch?v=example_ru_b2_5', NULL, 5, 30, false, 'MONTHLY', NOW(), NOW());

-- Russian for Travel - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_ru_trav, 'At the Airport', '<h2>At the Airport</h2><p>Navigate airports in Russian: check-in, boarding, customs.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_ru_trav_1', NULL, 1, 20, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_ru_trav, 'In the Hotel', '<h2>In the Hotel</h2><p>Book rooms, request services, and check out in Russian.</p>', 'VOCABULARY', NULL, NULL, 2, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ru_trav, 'Asking for Directions', '<h2>Asking for Directions</h2><p>Explore Russian cities with confidence.</p>', 'SPEAKING', 'https://www.youtube.com/watch?v=example_ru_trav_3', NULL, 3, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ru_trav, 'Shopping in Russia', '<h2>Shopping in Russia</h2><p>Shop at markets and stores in Russian.</p>', 'VOCABULARY', NULL, NULL, 4, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_ru_trav, 'Emergencies & Help', '<h2>Emergencies & Help</h2><p>Handle emergencies and ask for help while traveling.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_ru_trav_5', NULL, 5, 20, false, 'MONTHLY', NOW(), NOW());

-- Portuguese courses
SET @c_pt_a1   = (SELECT id FROM courses WHERE title = 'Portuguese A1 - Iniciante' LIMIT 1);
SET @c_pt_a2   = (SELECT id FROM courses WHERE title = 'Portuguese A2 - Elementar' LIMIT 1);
SET @c_pt_b1   = (SELECT id FROM courses WHERE title = 'Portuguese B1 - Intermediario' LIMIT 1);
SET @c_pt_b2   = (SELECT id FROM courses WHERE title = 'Portuguese B2 - Avancado' LIMIT 1);
SET @c_pt_trav = (SELECT id FROM courses WHERE title = 'Portuguese for Travel' LIMIT 1);

-- Portuguese A1 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_pt_a1, 'Saudacoes e Despedidas', '<h2>Saudacoes e Despedidas</h2><p>Olá, bom dia, até logo... Basic greetings in Portuguese.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_pt_a1_1', NULL, 1, 15, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_pt_a1, 'Apresentar-se', '<h2>Apresentar-se</h2><p>Introduce yourself: chamo-me, tenho, sou de.</p>', 'VOCABULARY', NULL, NULL, 2, 15, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_pt_a1, 'Os Numeros', '<h2>Os Numeros</h2><p>Count from 0 to 100 in Portuguese.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_pt_a1_3', NULL, 3, 15, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_pt_a1, 'A Familia', '<h2>A Familia</h2><p>Family vocabulary in Portuguese.</p>', 'VOCABULARY', NULL, NULL, 4, 15, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_pt_a1, 'Dias e Meses', '<h2>Dias e Meses</h2><p>Days of the week and months in Portuguese.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_pt_a1_5', NULL, 5, 12, false, 'MONTHLY', NOW(), NOW());

-- Portuguese A2 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_pt_a2, 'No Restaurante', '<h2>No Restaurante</h2><p>Order food and drinks at a Portuguese restaurant.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_pt_a2_1', NULL, 1, 20, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_pt_a2, 'Passado Preterito', '<h2>Passado Preterito</h2><p>Express past actions using preterite tense in Portuguese.</p>', 'GRAMMAR', NULL, NULL, 2, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_pt_a2, 'Futuro do Presente', '<h2>Futuro do Presente</h2><p>Express future actions in Portuguese.</p>', 'GRAMMAR', 'https://www.youtube.com/watch?v=example_pt_a2_3', NULL, 3, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_pt_a2, 'De Compras', '<h2>De Compras</h2><p>Shopping vocabulary and bargaining in Portuguese.</p>', 'VOCABULARY', NULL, NULL, 4, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_pt_a2, 'Transportes', '<h2>Transportes</h2><p>Use public transportation in Portuguese-speaking countries.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_pt_a2_5', NULL, 5, 20, false, 'MONTHLY', NOW(), NOW());

-- Portuguese B1 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_pt_b1, 'Imperfeito vs Preterito', '<h2>Imperfeito vs Preterito</h2><p>When to use imperfect vs preterite in Portuguese.</p>', 'GRAMMAR', 'https://www.youtube.com/watch?v=example_pt_b1_1', NULL, 1, 25, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_pt_b1, 'Exprima sua Opiniao', '<h2>Exprima sua Opiniao</h2><p>Express opinions and engage in discussions in Portuguese.</p>', 'SPEAKING', NULL, NULL, 2, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_pt_b1, 'Mais-que-Perfeito', '<h2>Mais-que-Perfeito</h2><p>Express past events that occurred before another past event.</p>', 'GRAMMAR', 'https://www.youtube.com/watch?v=example_pt_b1_3', NULL, 3, 30, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_pt_b1, 'Leitura em Portugues', '<h2>Leitura em Portugues</h2><p>Read and understand Portuguese texts.</p>', 'READING', NULL, NULL, 4, 30, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_pt_b1, 'Cultura Lusofona', '<h2>Cultura Lusofona</h2><p>Explore Portuguese-speaking cultures from Brazil to Portugal.</p>', 'SPEAKING', 'https://www.youtube.com/watch?v=example_pt_b1_5', NULL, 5, 25, false, 'MONTHLY', NOW(), NOW());

-- Portuguese B2 - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_pt_b2, 'Conjuntivo Presente', '<h2>Conjuntivo Presente</h2><p>Master the present subjunctive mood in Portuguese.</p>', 'GRAMMAR', 'https://www.youtube.com/watch?v=example_pt_b2_1', NULL, 1, 30, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_pt_b2, 'Discurso Indireto', '<h2>Discurso Indireto</h2><p>Report speech using indirect speech in Portuguese.</p>', 'GRAMMAR', NULL, NULL, 2, 30, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_pt_b2, 'Escrita Academica', '<h2>Escrita Academica</h2><p>Write essays and formal documents in Portuguese.</p>', 'WRITING', 'https://www.youtube.com/watch?v=example_pt_b2_3', NULL, 3, 35, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_pt_b2, 'Expressoes Idiomáticas', '<h2>Expressoes Idiomáticas</h2><p>Common Portuguese idiomatic expressions and sayings.</p>', 'VOCABULARY', NULL, NULL, 4, 25, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_pt_b2, 'Debate e Argumentacao', '<h2>Debate e Argumentacao</h2><p>Participate in formal debates with structured arguments.</p>', 'SPEAKING', 'https://www.youtube.com/watch?v=example_pt_b2_5', NULL, 5, 35, false, 'MONTHLY', NOW(), NOW());

-- Portuguese for Travel - 5 lessons
INSERT INTO lessons (id, course_id, title, content, type, video_url, audio_url, order_index, duration_minutes, is_free, access_tier, created_at, updated_at) VALUES
(UUID(), @c_pt_trav, 'No Aeroporto', '<h2>No Aeroporto</h2><p>Navigate airports in Portuguese: check-in, boarding, customs.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_pt_trav_1', NULL, 1, 20, true, 'PREVIEW', NOW(), NOW()),
(UUID(), @c_pt_trav, 'No Hotel', '<h2>No Hotel</h2><p>Book rooms, request services, and check out in Portuguese.</p>', 'VOCABULARY', NULL, NULL, 2, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_pt_trav, 'Pedindo Direcoes', '<h2>Pedindo Direcoes</h2><p>Ask for and give directions in Portuguese-speaking areas.</p>', 'SPEAKING', 'https://www.youtube.com/watch?v=example_pt_trav_3', NULL, 3, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_pt_trav, 'Compras nas Lojas', '<h2>Compras nas Lojas</h2><p>Shop at stores and bargain in Portuguese.</p>', 'VOCABULARY', NULL, NULL, 4, 20, false, 'MONTHLY', NOW(), NOW()),
(UUID(), @c_pt_trav, 'Emergencias', '<h2>Emergencias</h2><p>Handle emergencies and ask for help while traveling.</p>', 'VOCABULARY', 'https://www.youtube.com/watch?v=example_pt_trav_5', NULL, 5, 20, false, 'MONTHLY', NOW(), NOW());

-- ============================================================
-- 6. EXERCISES - MỖI LESSON 5 EXERCISES
-- ============================================================
-- Get all lesson IDs for English
SET @l_en_a1_1 = (SELECT id FROM lessons WHERE title = 'Greetings & Introductions' LIMIT 1);
SET @l_en_a1_2 = (SELECT id FROM lessons WHERE title = 'Numbers & Counting' LIMIT 1);
SET @l_en_a1_3 = (SELECT id FROM lessons WHERE title = 'Colors & Shapes' LIMIT 1);
SET @l_en_a1_4 = (SELECT id FROM lessons WHERE title = 'Family Members' LIMIT 1);
SET @l_en_a1_5 = (SELECT id FROM lessons WHERE title = 'Days & Months' LIMIT 1);
SET @l_en_a2_1 = (SELECT id FROM lessons WHERE title = 'Daily Routines' LIMIT 1);
SET @l_en_a2_2 = (SELECT id FROM lessons WHERE title = 'Food & Eating' LIMIT 1);
SET @l_en_a2_3 = (SELECT id FROM lessons WHERE title = 'Shopping & Money' LIMIT 1);
SET @l_en_a2_4 = (SELECT id FROM lessons WHERE title = 'Present Continuous' LIMIT 1);
SET @l_en_a2_5 = (SELECT id FROM lessons WHERE title = 'Weather & Seasons' LIMIT 1);
SET @l_en_b1_1 = (SELECT id FROM lessons WHERE title = 'At the Restaurant' LIMIT 1);
SET @l_en_b1_2 = (SELECT id FROM lessons WHERE title = 'Past Tense Narratives' LIMIT 1);
SET @l_en_b1_3 = (SELECT id FROM lessons WHERE title = 'Future Plans' LIMIT 1);
SET @l_en_b1_4 = (SELECT id FROM lessons WHERE title = 'Giving Directions' LIMIT 1);
SET @l_en_b1_5 = (SELECT id FROM lessons WHERE title = 'Hobbies & Interests' LIMIT 1);
SET @l_en_bus_1 = (SELECT id FROM lessons WHERE title = 'Business Email Writing' LIMIT 1);
SET @l_en_bus_2 = (SELECT id FROM lessons WHERE title = 'Meeting Vocabulary' LIMIT 1);
SET @l_en_bus_3 = (SELECT id FROM lessons WHERE title = 'Presentation Skills' LIMIT 1);
SET @l_en_bus_4 = (SELECT id FROM lessons WHERE title = 'Negotiation Language' LIMIT 1);
SET @l_en_bus_5 = (SELECT id FROM lessons WHERE title = 'Telephoning & Conferencing' LIMIT 1);
SET @l_ielts_1 = (SELECT id FROM lessons WHERE title = 'IELTS Reading Strategies' LIMIT 1);
SET @l_ielts_2 = (SELECT id FROM lessons WHERE title = 'IELTS Writing Task 1' LIMIT 1);
SET @l_ielts_3 = (SELECT id FROM lessons WHERE title = 'IELTS Writing Task 2' LIMIT 1);
SET @l_ielts_4 = (SELECT id FROM lessons WHERE title = 'IELTS Listening Tips' LIMIT 1);
SET @l_ielts_5 = (SELECT id FROM lessons WHERE title = 'IELTS Speaking Part 1-3' LIMIT 1);

-- English A1 Lesson 1: Greetings & Introductions - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_en_a1_1, 'Choose correct greeting at 3 PM', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Which is the appropriate greeting at 3 PM?","options":["Good morning","Good afternoon","Good night","See you"],"correctIndex":1,"explanation":"3 PM is afternoon, so use Good afternoon."}'),
  1, 10, 30, NOW()),
(UUID(), @l_en_a1_1, 'Complete: My name _____ John', 'FILL_IN_BLANK',
  CONCAT('{"question":"My name _____ John. Nice to meet you.","answer":"is","hints":["verb to be"],"explanation":"Use is with singular name in present simple."}'),
  2, 10, 20, NOW()),
(UUID(), @l_en_a1_1, 'Match greeting to time of day', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Good evening","right":"6 PM"},{"left":"Good night","right":"Before sleep"},{"left":"Good morning","right":"Before noon"},{"left":"Good afternoon","right":"Noon to 6 PM"}]}'),
  3, 15, 45, NOW()),
(UUID(), @l_en_a1_1, 'Fill in: Nice to _____ you', 'FILL_IN_BLANK',
  CONCAT('{"question":"Nice to _____ you.","answer":"meet","hints":["a verb meaning to see"],"explanation":"Nice to meet you is a common greeting phrase."}'),
  4, 10, 15, NOW()),
(UUID(), @l_en_a1_1, 'Choose formal introduction', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Which introduction is the most formal?","options":["Hey, I am John","Hello, my name is John Smith","Sup? I am John","Yo, John here"],"correctIndex":1,"explanation":"Hello, my name is John Smith is the most formal and appropriate for professional settings."}'),
  5, 10, 20, NOW());

-- English A1 Lesson 2: Numbers & Counting - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_en_a1_2, 'What comes after 15?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What comes after 15?","options":["Thirteen","Fourteen","Sixteen","Seventeen"],"correctIndex":2,"explanation":"Sixteen comes after fifteen."}'),
  1, 10, 15, NOW()),
(UUID(), @l_en_a1_2, 'Complete: Two plus two equals _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Two plus two equals _____","answer":"four","hints":["think 2+2"],"explanation":"Two plus two equals four."}'),
  2, 10, 15, NOW()),
(UUID(), @l_en_a1_2, 'Match numbers to words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"7","right":"Seven"},{"left":"12","right":"Twelve"},{"left":"20","right":"Twenty"},{"left":"5","right":"Five"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_en_a1_2, 'How many is fifty minus ten?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How many is fifty minus ten?","options":["Sixty","Thirty","Forty","Forty-five"],"correctIndex":2,"explanation":"50 - 10 = 40, which is Forty."}'),
  4, 10, 20, NOW()),
(UUID(), @l_en_a1_2, 'Write 19 in words', 'FILL_IN_BLANK',
  CONCAT('{"question":"Write the number 19 in words.","answer":"nineteen","hints":["teen ending"],"explanation":"Nineteen is the word for the number 19."}'),
  5, 10, 15, NOW());

-- English A1 Lesson 3: Colors & Shapes - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_en_a1_3, 'Match colors to objects', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Red","right":"Apple"},{"left":"Blue","right":"Ocean"},{"left":"Green","right":"Tree"},{"left":"Yellow","right":"Sun"}]}'),
  1, 15, 60, NOW()),
(UUID(), @l_en_a1_3, 'How many sides does a triangle have?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How many sides does a triangle have?","options":["Two","Three","Four","Five"],"correctIndex":1,"explanation":"A triangle has 3 sides as the name suggests (tri = 3)."}'),
  2, 10, 15, NOW()),
(UUID(), @l_en_a1_3, 'What color is the sky?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What color is the sky on a clear day?","options":["Red","Green","Blue","Yellow"],"correctIndex":2,"explanation":"The sky appears blue on a clear day."}'),
  3, 10, 10, NOW()),
(UUID(), @l_en_a1_3, 'Fill in: The circle is _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"The circle is _____ (color). The sun is yellow.","answer":"yellow","hints":["think of the sun color"],"explanation":"The circle representing the sun is yellow."}'),
  4, 10, 15, NOW()),
(UUID(), @l_en_a1_3, 'Match shapes to names', 'MATCHING',
  CONCAT('{"pairs":[{"left":"O","right":"Circle"},{"left":"square","right":"Square"},{"left":"triangle","right":"Triangle"},{"left":"rectangle","right":"Rectangle"}]}'),
  5, 15, 30, NOW());

-- English A1 Lesson 4: Family Members - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_en_a1_4, 'Who is your mother''s son?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"If you are a male, who is your mother''s son?","options":["Father","Brother","Son","Uncle"],"correctIndex":2,"explanation":"Your mother''s son is you (if you are male) or your brother."}'),
  1, 10, 20, NOW()),
(UUID(), @l_en_a1_4, 'Complete: My _____ is my father''s wife', 'FILL_IN_BLANK',
  CONCAT('{"question":"My _____ is my father''s wife.","answer":"mother","hints":["female parent"],"explanation":"Your father''s wife is your mother."}'),
  2, 10, 15, NOW()),
(UUID(), @l_en_a1_4, 'Match family words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Son","right":"Male child"},{"left":"Daughter","right":"Female child"},{"left":"Grandmother","right":"Mother''s mother"},{"left":"Uncle","right":"Father''s brother"}]}'),
  3, 15, 45, NOW()),
(UUID(), @l_en_a1_4, 'How do you say "anh trai" in English?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say anh trai (older brother) in English?","options":["Brother","Father","Son","Uncle"],"correctIndex":0,"explanation":"Anh trai means brother in English."}'),
  4, 10, 15, NOW()),
(UUID(), @l_en_a1_4, 'Fill in: I have two _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"I have two _____ (male siblings). I have two brothers.","answer":"brothers","hints":["male siblings"],"explanation":"Brothers are male siblings."}'),
  5, 10, 15, NOW());

-- English A1 Lesson 5: Days & Months - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_en_a1_5, 'What day comes after Monday?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What day comes after Monday?","options":["Sunday","Tuesday","Wednesday","Saturday"],"correctIndex":1,"explanation":"Tuesday comes after Monday in the week."}'),
  1, 10, 10, NOW()),
(UUID(), @l_en_a1_5, 'Which month is the 3rd month?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Which month is the 3rd month of the year?","options":["February","March","April","January"],"correctIndex":1,"explanation":"January is 1st, February is 2nd, March is 3rd."}'),
  2, 10, 15, NOW()),
(UUID(), @l_en_a1_5, 'Fill in: Today is _____ 17th', 'FILL_IN_BLANK',
  CONCAT('{"question":"Today is _____ 17th. What month are we in? (April)","answer":"April","hints":["the 4th month"],"explanation":"April is the 4th month of the year."}'),
  3, 10, 15, NOW()),
(UUID(), @l_en_a1_5, 'Match days with correct order', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Friday","right":"5th day"},{"left":"Monday","right":"1st day"},{"left":"Wednesday","right":"3rd day"},{"left":"Sunday","right":"7th day"}]}'),
  4, 15, 30, NOW()),
(UUID(), @l_en_a1_5, 'How many months have 31 days?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How many months have 31 days?","options":["Four","Five","Six","Seven"],"correctIndex":3,"explanation":"Seven months have 31 days: Jan, Mar, May, Jul, Aug, Oct, Dec."}'),
  5, 10, 20, NOW());

-- English A2 Lesson 1: Daily Routines - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_en_a2_1, 'Complete with correct verb', 'FILL_IN_BLANK',
  CONCAT('{"question":"She _____ (wake up) at 6 AM every day.","answer":"wakes up","hints":["add -s for 3rd person singular"],"explanation":"Third person singular requires -s/-es in present simple."}'),
  1, 10, 25, NOW()),
(UUID(), @l_en_a2_1, 'Choose correct sentence', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Which sentence is correct for present simple?","options":["She go to school","She goes to school","She going to school","She goed to school"],"correctIndex":1,"explanation":"She goes (with -es) is correct for 3rd person singular."}'),
  2, 10, 20, NOW()),
(UUID(), @l_en_a2_1, 'Match routine to time', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Wake up","right":"6 AM"},{"left":"Have breakfast","right":"7 AM"},{"left":"Go to work","right":"8 AM"},{"left":"Sleep","right":"10 PM"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_en_a2_1, 'Fill in: He usually _____ at 7 AM', 'FILL_IN_BLANK',
  CONCAT('{"question":"He usually _____ (have) breakfast at 7 AM.","answer":"has","hints":["present simple 3rd person"],"explanation":"He has breakfast (not have) in present simple."}'),
  4, 10, 20, NOW()),
(UUID(), @l_en_a2_1, 'Which is NOT a daily routine?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Which is NOT typically part of a daily routine?","options":["Brush teeth","Go to school","Have dinner","Climb mountains"],"correctIndex":3,"explanation":"Climb mountains is not a daily activity."}'),
  5, 10, 15, NOW());

-- English A2 Lesson 2: Food & Eating - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_en_a2_2, 'Which is a vegetable?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Which of these is a vegetable?","options":["Apple","Banana","Carrot","Orange"],"correctIndex":2,"explanation":"Carrot is a vegetable. Apple, banana, and orange are fruits."}'),
  1, 10, 15, NOW()),
(UUID(), @l_en_a2_2, 'Fill in: I would like some _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"I would like some _____ (the meal eaten in the morning).","answer":"breakfast","hints":["morning meal"],"explanation":"Breakfast is the first meal of the day, eaten in the morning."}'),
  2, 10, 15, NOW()),
(UUID(), @l_en_a2_2, 'Match food categories', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Rice","right":"Staple"},{"left":"Chicken","right":"Protein"},{"left":"Carrot","right":"Vegetable"},{"left":"Apple","right":"Fruit"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_en_a2_2, 'What do you drink in the morning?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What beverage is commonly drunk in the morning?","options":["Soda","Coffee","Beer","Wine"],"correctIndex":1,"explanation":"Coffee is the most common morning beverage."}'),
  4, 10, 15, NOW()),
(UUID(), @l_en_a2_2, 'Complete: She eats lunch at _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"She eats lunch at _____ (the middle of the day).","answer":"noon","hints":["12 o clock"],"explanation":"Lunch is typically eaten around noon (12 PM)."}'),
  5, 10, 15, NOW());

-- English A2 Lesson 3: Shopping & Money - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_en_a2_3, 'How much is this item?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"The price tag shows $19.99. How much is the item?","options":["Nineteen dollars","Ninety-nine dollars","One hundred ninety-nine dollars","Nineteen thousand dollars"],"correctIndex":0,"explanation":"$19.99 is approximately nineteen dollars."}'),
  1, 10, 20, NOW()),
(UUID(), @l_en_a2_3, 'Complete: Can I pay by _____?', 'FILL_IN_BLANK',
  CONCAT('{"question":"Can I pay by _____? (credit card method)","answer":"credit card","hints":["card payment"],"explanation":"Credit card is a common payment method."}'),
  2, 10, 15, NOW()),
(UUID(), @l_en_a2_3, 'Match shopping terms', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Price tag","right":"Shows cost"},{"left":"Receipt","right":"After purchase"},{"left":"Discount","right":"Reduced price"},{"left":"Cash","right":"Paper money"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_en_a2_3, 'What does "on sale" mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"A shirt is on sale. What does this mean?","options":["More expensive than usual","Cheaper than usual","Same price","Sold out"],"correctIndex":1,"explanation":"On sale means the price is reduced, making it cheaper."}'),
  4, 10, 15, NOW()),
(UUID(), @l_en_a2_3, 'Fill in: This jacket is too _____. I will not buy it', 'FILL_IN_BLANK',
  CONCAT('{"question":"This jacket is too _____. I will not buy it. (expensive)","answer":"expensive","hints":["opposite of cheap"],"explanation":"Too expensive means the price is too high for you to buy."}'),
  5, 10, 15, NOW());

-- English A2 Lesson 4: Present Continuous - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_en_a2_4, 'Choose the correct form', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"She _____ (read) a book right now.","options":["read","reads","is reading","are reading"],"correctIndex":2,"explanation":"Present continuous: am/is/are + verb-ing. She is reading."}'),
  1, 10, 20, NOW()),
(UUID(), @l_en_a2_4, 'Fill in: Look! The children _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Look! The children _____ (play) in the park.","answer":"are playing","hints":["action happening now"],"explanation":"Look! signals present continuous: are + playing."}'),
  2, 10, 20, NOW()),
(UUID(), @l_en_a2_4, 'Which sentence is present continuous?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Which sentence uses present continuous?","options":["I eat breakfast","I am eating breakfast","I ate breakfast","I eat breakfast every day"],"correctIndex":1,"explanation":"I am eating breakfast uses am + verb-ing, showing an action happening now."}'),
  3, 10, 15, NOW()),
(UUID(), @l_en_a2_4, 'Correct the error', 'FILL_IN_BLANK',
  CONCAT('{"question":"He is work ing hard. (fix the sentence)","answer":"He is working hard.","hints":["remove the space"],"explanation":"Working is one word: is + working (not work ing)."}'),
  4, 10, 20, NOW()),
(UUID(), @l_en_a2_4, 'Match with present continuous', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Right now","right":"Present continuous"},{"left":"Every day","right":"Present simple"},{"left":"Look!","right":"Present continuous"},{"left":"Usually","right":"Present simple"}]}'),
  5, 15, 30, NOW());

-- English A2 Lesson 5: Weather & Seasons - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_en_a2_5, 'What season has snow?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"In most countries, which season has snow?","options":["Spring","Summer","Autumn","Winter"],"correctIndex":3,"explanation":"Winter is typically the cold season when it snows in many countries."}'),
  1, 10, 15, NOW()),
(UUID(), @l_en_a2_5, 'Fill in: It is very _____ today', 'FILL_IN_BLANK',
  CONCAT('{"question":"It is very _____ today. Take an umbrella. (rain)","answer":"rainy","hints":["rain + y"],"explanation":"Rainy describes weather with rain."}'),
  2, 10, 15, NOW()),
(UUID(), @l_en_a2_5, 'Match weather to seasons', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Hot and sunny","right":"Summer"},{"left":"Cold and snowy","right":"Winter"},{"left":"Cool and colorful leaves","right":"Autumn"},{"left":"Warm and flowers blooming","right":"Spring"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_en_a2_5, 'What is a synonym for "hot"?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What is a synonym for hot weather?","options":["Cold","Warm","Cool","Freezing"],"correctIndex":1,"explanation":"Warm is similar to hot but less extreme."}'),
  4, 10, 15, NOW()),
(UUID(), @l_en_a2_5, 'Complete: The sun is _____ today', 'FILL_IN_BLANK',
  CONCAT('{"question":"The sun is _____ today. It is very bright. (shine)","answer":"shining","hints":["shine + ing"],"explanation":"The sun is shining means the sun is giving out light."}'),
  5, 10, 15, NOW());

-- English B1 Lesson 1: At the Restaurant - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_en_b1_1, 'Listen and choose the correct answer', 'LISTENING_CHOICE',
  CONCAT('{"question":"The customer ordered: A table for 2 and a glass of red wine. What did the customer order?","options":["Coffee and cake","Tea and sandwich","Water only","A table for 2 and red wine"],"correctIndex":3,"explanation":"The customer ordered a table for 2 and a glass of red wine."}'),
  1, 15, 45, NOW()),
(UUID(), @l_en_b1_1, 'Fill in: I would like to _____ a table', 'FILL_IN_BLANK',
  CONCAT('{"question":"I would like to _____ a table for tonight. (booking)","answer":"reserve","hints":["make a booking"],"explanation":"To reserve a table means to book it in advance."}'),
  2, 10, 20, NOW()),
(UUID(), @l_en_b1_1, 'Match restaurant phrases', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Can I see the menu?","right":"Request menu"},{"left":"The bill, please","right":"Payment"},{"left":"I have a reservation","right":"Booking"},{"left":"What do you recommend?","right":"Ask advice"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_en_b1_1, 'What does "service charge" mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"A restaurant adds a service charge. What is this?","options":["Tip for the waiter","Extra food","Music fee","Table rental"],"correctIndex":0,"explanation":"Service charge is an additional fee, usually a tip for the service staff."}'),
  4, 10, 20, NOW()),
(UUID(), @l_en_b1_1, 'Complete: Could I have the _____?', 'FILL_IN_BLANK',
  CONCAT('{"question":"Could I have the _____, please? I want to pay. (bill)","answer":"bill","hints":["payment"],"explanation":"The bill is the receipt with the total amount to pay."}'),
  5, 10, 15, NOW());

-- English B1 Lesson 2: Past Tense Narratives - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_en_b1_2, 'Choose past simple or past continuous', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"She _____ (watch) TV when the phone rang.","options":["watched","was watching","is watching","watches"],"correctIndex":1,"explanation":"Past continuous (was watching) for the ongoing action, past simple (rang) for the interruption."}'),
  1, 10, 25, NOW()),
(UUID(), @l_en_b1_2, 'Fill in: Yesterday, I _____ to school', 'FILL_IN_BLANK',
  CONCAT('{"question":"Yesterday, I _____ (go) to school by bus.","answer":"went","hints":["past of go"],"explanation":"Went is the past simple of go."}'),
  2, 10, 15, NOW()),
(UUID(), @l_en_b1_2, 'Correct the error', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"He goed to the market yesterday. Which is correct?","options":["He goed to the market","He went to the market","He goed at the market","He going to market"],"correctIndex":1,"explanation":"Went is the correct past simple of go."}'),
  3, 10, 15, NOW()),
(UUID(), @l_en_b1_2, 'Match verbs to past forms', 'MATCHING',
  CONCAT('{"pairs":[{"left":"go","right":"went"},{"left":"see","right":"saw"},{"left":"eat","right":"ate"},{"left":"take","right":"took"}]}'),
  4, 15, 30, NOW()),
(UUID(), @l_en_b1_2, 'Fill in: While I _____ (wait), it rained', 'FILL_IN_BLANK',
  CONCAT('{"question":"While I _____ (wait) for the bus, it rained heavily.","answer":"was waiting","hints":["past continuous with while"],"explanation":"While + past continuous shows an ongoing action interrupted by another event."}'),
  5, 10, 20, NOW());

-- English B1 Lesson 3: Future Plans - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_en_b1_3, 'Choose correct future form', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"I _____ (go) to Paris next week. It is already planned.","options":["will go","am going","go","went"],"correctIndex":1,"explanation":"Present continuous (am going) is used for definite future plans."}'),
  1, 10, 20, NOW()),
(UUID(), @l_en_b1_3, 'Fill in: I think it _____ rain tomorrow', 'FILL_IN_BLANK',
  CONCAT('{"question":"I think it _____ rain tomorrow. I am not sure.","answer":"will","hints":["prediction"],"explanation":"Will is used for predictions about the future, especially when not certain."}'),
  2, 10, 15, NOW()),
(UUID(), @l_en_b1_3, 'Match future expressions', 'MATCHING',
  CONCAT('{"pairs":[{"left":"I am meeting Sarah","right":"Planned arrangement"},{"left":"I will call you","right":"Instant decision"},{"left":"I am going to travel","right":"Intention"},{"left":"It might snow","right":"Possibility"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_en_b1_3, 'What is the difference: will vs going to?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"When do we use going to for plans and will for predictions?","options":["Going to for plans, will for predictions","Will for plans, going to for predictions","They are exactly the same","Neither is correct"],"correctIndex":0,"explanation":"Going to is for planned intentions. Will is for spontaneous decisions and predictions."}'),
  4, 10, 20, NOW()),
(UUID(), @l_en_b1_3, 'Fill in: We are _____ to visit our grandmother', 'FILL_IN_BLANK',
  CONCAT('{"question":"We are _____ to visit our grandmother next Sunday. It is a plan.","answer":"going","hints":["going to"],"explanation":"Are going to shows a planned arrangement for the future."}'),
  5, 10, 15, NOW());

-- English B1 Lesson 4: Giving Directions - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_en_b1_4, 'Turn left or right?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"I am facing north. I turn left. Which direction am I now facing?","options":["North","South","East","West"],"correctIndex":2,"explanation":"Facing north, turning left means you now face west."}'),
  1, 10, 15, NOW()),
(UUID(), @l_en_b1_4, 'Fill in: Go _____ the traffic light', 'FILL_IN_BLANK',
  CONCAT('{"question":"Go _____ the traffic light and turn right. (straight past)","answer":"past","hints":["continue past"],"explanation":"Go past the traffic light means continue straight past it."}'),
  2, 10, 15, NOW()),
(UUID(), @l_en_b1_4, 'Match directions', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Turn left","right":"90 degrees to the west"},{"left":"Go straight","right":"Continue forward"},{"left":"Turn right","right":"90 degrees to the east"},{"left":"At the corner","right":"On the bend"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_en_b1_4, 'What is opposite of north?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What direction is opposite to north?","options":["East","West","South","Northeast"],"correctIndex":2,"explanation":"South is opposite to north on a compass."}'),
  4, 10, 10, NOW()),
(UUID(), @l_en_b1_4, 'Fill in: The bank is _____ the supermarket', 'FILL_IN_BLANK',
  CONCAT('{"question":"The bank is _____ the supermarket. Next to means beside.","answer":"next to","hints":["beside"],"explanation":"Next to means beside or adjacent to."}'),
  5, 10, 15, NOW());

-- English B1 Lesson 5: Hobbies & Interests - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_en_b1_5, 'Which is a hobby?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Which of these is typically considered a hobby?","options":["Going to work","Cooking","Sleeping","Attending meetings"],"correctIndex":1,"explanation":"Cooking is a leisure activity and a common hobby."}'),
  1, 10, 15, NOW()),
(UUID(), @l_en_b1_5, 'Fill in: She enjoys _____ photos', 'FILL_IN_BLANK',
  CONCAT('{"question":"She enjoys _____ photos in her free time. (take)","answer":"taking","hints":["enjoy + verb-ing"],"explanation":"Enjoy is followed by a gerund (verb-ing). Taking photos."}'),
  2, 10, 15, NOW()),
(UUID(), @l_en_b1_5, 'Match hobbies to benefits', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Reading","right":"Knowledge"},{"left":"Swimming","right":"Physical fitness"},{"left":"Playing guitar","right":"Musical skill"},{"left":"Painting","right":"Creative expression"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_en_b1_5, 'What does "in my spare time" mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"I read books in my spare time. What does spare time mean?","options":["Working hours","Free time","Study time","Sleeping time"],"correctIndex":1,"explanation":"Spare time or free time means time not used for work or obligations."}'),
  4, 10, 15, NOW()),
(UUID(), @l_en_b1_5, 'Fill in: His hobby is _____ stamps', 'FILL_IN_BLANK',
  CONCAT('{"question":"His hobby is _____ stamps. It is called philately. (collect)","answer":"collecting","hints":["verb-ing after is"],"explanation":"A hobby can be expressed as verb-ing: collecting stamps."}'),
  5, 10, 15, NOW());

-- Business English Lesson 1: Business Email Writing - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_en_bus_1, 'Which is the best opening?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Which is the best opening for a formal business email?","options":["Hey there!","Hi friend","Dear Mr. Smith,","Yo John!"],"correctIndex":2,"explanation":"Dear Mr. Smith is the appropriate formal greeting for business emails."}'),
  1, 10, 20, NOW()),
(UUID(), @l_en_bus_1, 'Fill in: Thank you for your _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Thank you for your _____ regarding the project. (email)","answer":"email","hints":["letter"],"explanation":"Thank you for your email is a standard polite opening."}'),
  2, 10, 15, NOW()),
(UUID(), @l_en_bus_1, 'Match email phrases', 'MATCHING',
  CONCAT('{"pairs":[{"left":"I am writing to","right":"State purpose"},{"left":"Please find attached","right":"Attachment"},{"left":"I look forward to hearing","right":"Polite close"},{"left":"Best regards","right":"Sign-off"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_en_bus_1, 'Which sign-off is formal?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Which email sign-off is the most formal and professional?","options":["Cheers","Best wishes","Kind regards","Later"],"correctIndex":2,"explanation":"Kind regards is a professional and formal email sign-off."}'),
  4, 10, 15, NOW()),
(UUID(), @l_en_bus_1, 'Fill in: I am writing to _____ your order', 'FILL_IN_BLANK',
  CONCAT('{"question":"I am writing to _____ your order dated March 15th. (confirm)","answer":"confirm","hints":["make sure"],"explanation":"Confirm means to verify or make something officially definite."}'),
  5, 10, 20, NOW());

-- Business English Lesson 2: Meeting Vocabulary - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_en_bus_2, 'What is an agenda?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"A meeting agenda is:","options":["The meeting room","A list of topics to discuss","The list of attendees","A summary report"],"correctIndex":1,"explanation":"An agenda is a list of items to be discussed in a meeting."}'),
  1, 10, 15, NOW()),
(UUID(), @l_en_bus_2, 'Fill in: Let us move on to the next _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Let us move on to the next _____ on the agenda. (topic)","answer":"item","hints":["agenda item"],"explanation":"Item refers to each point on the agenda."}'),
  2, 10, 15, NOW()),
(UUID(), @l_en_bus_2, 'Match meeting vocabulary', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Minutes","right":"Written record"},{"left":"Adjourn","right":"End the meeting"},{"left":"Quorum","right":"Minimum attendees"},{"left":"Action item","right":"Task assigned"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_en_bus_2, 'What does "to take minutes" mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"The secretary takes minutes during the meeting. What does this mean?","options":["Make coffee","Write down what is said","Check attendance","Send invitations"],"correctIndex":1,"explanation":"Taking minutes means writing down the official record of what happens in the meeting."}'),
  4, 10, 20, NOW()),
(UUID(), @l_en_bus_2, 'Fill in: Can we _____ the meeting until 3 PM?', 'FILL_IN_BLANK',
  CONCAT('{"question":"Can we _____ the meeting until 3 PM? (postpone)","answer":"reschedule","hints":["change the time"],"explanation":"Reschedule means to change to a different time."}'),
  5, 10, 15, NOW());

-- Business English Lesson 3: Presentation Skills - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_en_bus_3, 'How do you start a presentation?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What is the best way to start a formal presentation?","options":["Start speaking immediately","Thank the audience and introduce yourself","Tell a joke","Check your phone"],"correctIndex":1,"explanation":"Start by thanking the audience and introducing yourself."}'),
  1, 10, 20, NOW()),
(UUID(), @l_en_bus_3, 'Fill in: Today I am going to _____ about', 'FILL_IN_BLANK',
  CONCAT('{"question":"Today I am going to _____ about our new product launch. (speak)","answer":"talk","hints":["present"],"explanation":"Talk about means to speak on a particular subject."}'),
  2, 10, 15, NOW()),
(UUID(), @l_en_bus_3, 'Match presentation phrases', 'MATCHING',
  CONCAT('{"pairs":[{"left":"As you can see","right":"Direct attention"},{"left":"Moving on to","right":"Change topic"},{"left":"In conclusion","right":"Summarize"},{"left":"Any questions?","right":"Open discussion"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_en_bus_3, 'What is a "slide deck"?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"A slide deck in a presentation refers to:","options":["The meeting room floor","A set of presentation slides","A drawer for papers","The presenter notes"],"correctIndex":1,"explanation":"A slide deck is a set of slides used in a presentation."}'),
  4, 10, 15, NOW()),
(UUID(), @l_en_bus_3, 'Fill in: In _____, let me summarize', 'FILL_IN_BLANK',
  CONCAT('{"question":"In _____, let me summarize the key points. (end)","answer":"conclusion","hints":["final part"],"explanation":"In conclusion is used to signal the final summary of a presentation."}'),
  5, 10, 15, NOW());

-- Business English Lesson 4: Negotiation Language - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_en_bus_4, 'Which phrase expresses disagreement politely?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Which phrase expresses polite disagreement in a negotiation?","options":["You are wrong","I am afraid I disagree","That is stupid","No way"],"correctIndex":1,"explanation":"I am afraid I disagree is a polite and professional way to express disagreement."}'),
  1, 10, 20, NOW()),
(UUID(), @l_en_bus_4, 'Fill in: Could we find a _____ solution?', 'FILL_IN_BLANK',
  CONCAT('{"question":"Could we find a _____ solution that works for both sides? (mutual)","answer":"mutual","hints":["shared"],"explanation":"A mutual solution benefits both parties equally."}'),
  2, 10, 15, NOW()),
(UUID(), @l_en_bus_4, 'Match negotiation phrases', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Our best offer","right":"Maximum we can give"},{"left":"We are flexible","right":"Open to changes"},{"left":"Let us split the difference","right":"Meet in middle"},{"left":"Non-negotiable","right":"Final position"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_en_bus_4, 'What does "bottom line" mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"The bottom line is the final price. What does this mean?","options":["The starting price","The most important factor","The hidden cost","The average price"],"correctIndex":1,"explanation":"Bottom line refers to the most important or final point after all considerations."}'),
  4, 10, 15, NOW()),
(UUID(), @l_en_bus_4, 'Fill in: We need to _____ our costs', 'FILL_IN_BLANK',
  CONCAT('{"question":"We need to _____ our costs to stay competitive. (reduce)","answer":"cut","hints":["lower"],"explanation":"Cut costs means to reduce spending."}'),
  5, 10, 15, NOW());

-- Business English Lesson 5: Telephoning & Conferencing - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_en_bus_5, 'How do you answer the phone professionally?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How should you answer the phone in a business setting?","options":["Hello?","Yeah?","Good morning, [Company name], how can I help you?","Who are you?"],"correctIndex":2,"explanation":"Professional phone answering includes greeting, company name, and offer to help."}'),
  1, 10, 20, NOW()),
(UUID(), @l_en_bus_5, 'Fill in: Could you hold, please?', 'FILL_IN_BLANK',
  CONCAT('{"question":"Could you hold, please? I will _____ you through. (connect)","answer":"put","hints":["transfer"],"explanation":"Put through means to connect someone to another person on the phone."}'),
  2, 10, 15, NOW()),
(UUID(), @l_en_bus_5, 'Match phone expressions', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Hold on","right":"Wait briefly"},{"left":"You are through","right":"Connected"},{"left":"Leave a message","right":"Record information"},{"left":"Call back","right":"Phone again later"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_en_bus_5, 'What does "bad line" mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Sorry, we have a bad line. What does this mean?","options":["The phone is broken","The connection is poor","Someone is offline","The meeting is cancelled"],"correctIndex":1,"explanation":"A bad line means poor telephone connection quality."}'),
  4, 10, 15, NOW()),
(UUID(), @l_en_bus_5, 'Fill in: I will _____ you back at 3 PM', 'FILL_IN_BLANK',
  CONCAT('{"question":"Mr. Johnson is not available. I will _____ you back at 3 PM. (phone)","answer":"call","hints":["phone again"],"explanation":"Call back means to telephone someone again later."}'),
  5, 10, 15, NOW());

-- IELTS Lesson 1: Reading Strategies - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_ielts_1, 'Which is NOT a reading strategy?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Which is NOT recommended as an IELTS reading strategy?","options":["Skim the text first","Read every word carefully","Scan for keywords","Guess meaning from context"],"correctIndex":1,"explanation":"Skimming and scanning are faster and more effective than reading every word."}'),
  1, 10, 20, NOW()),
(UUID(), @l_ielts_1, 'What is skimming?', 'FILL_IN_BLANK',
  CONCAT('{"question":"Skimming means reading _____ to get the main idea quickly.","answer":"quickly","hints":["fast"],"explanation":"Skimming is reading quickly to get the general idea."}'),
  2, 10, 15, NOW()),
(UUID(), @l_ielts_1, 'Match reading techniques', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Skimming","right":"Get overview quickly"},{"left":"Scanning","right":"Find specific details"},{"left":"Close reading","right":"Understand every word"},{"left":"Guessing","right":"Infer unknown words"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_ielts_1, 'How much time for reading?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"In IELTS Academic reading, how much time do you have for 40 questions?","options":["30 minutes","40 minutes","60 minutes","90 minutes"],"correctIndex":2,"explanation":"You have 60 minutes for 40 reading questions in IELTS Academic."}'),
  4, 10, 15, NOW()),
(UUID(), @l_ielts_1, 'Fill in: Read the _____ first', 'FILL_IN_BLANK',
  CONCAT('{"question":"In IELTS reading, read the _____ first to know what to look for.","answer":"questions","hints":["what to find"],"explanation":"Reading questions first helps you know what information to scan for."}'),
  5, 10, 15, NOW());

-- IELTS Lesson 2: Writing Task 1 - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_ielts_2, 'What should you include in Task 1?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"In IELTS Writing Task 1 (Academic), what should you summarize?","options":["Your opinion","Charts, graphs, or diagrams","A letter","A story"],"correctIndex":1,"explanation":"Task 1 Academic requires summarizing visual information like charts and graphs."}'),
  1, 10, 20, NOW()),
(UUID(), @l_ielts_2, 'Fill in: The chart _____ the number of', 'FILL_IN_BLANK',
  CONCAT('{"question":"The chart _____ the number of students from 2010 to 2020. (show)","answer":"shows","hints":["present simple for facts"],"explanation":"Use present simple to describe chart information that is always true."}'),
  2, 10, 15, NOW()),
(UUID(), @l_ielts_2, 'Match trend words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Increased","right":"Went up"},{"left":"Decreased","right":"Went down"},{"left":"Fluctuated","right":"Changed up and down"},{"left":"Remained stable","right":"Did not change much"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_ielts_2, 'How many words minimum?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What is the minimum word count for IELTS Writing Task 1?","options":["100 words","150 words","200 words","250 words"],"correctIndex":1,"explanation":"IELTS Writing Task 1 requires a minimum of 150 words."}'),
  4, 10, 15, NOW()),
(UUID(), @l_ielts_2, 'Fill in: The highest point was in _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"The _____ point was in 2015 at 500 units. (most)","answer":"highest","hints":["peak"],"explanation":"Highest point refers to the peak or maximum value."}'),
  5, 10, 15, NOW());

-- IELTS Lesson 3: Writing Task 2 - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_ielts_3, 'How many paragraphs?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"A typical IELTS Writing Task 2 essay should have how many paragraphs?","options":["2 paragraphs","3 paragraphs","4-5 paragraphs","6 paragraphs"],"correctIndex":2,"explanation":"An IELTS essay typically has 4-5 paragraphs: introduction, body (2-3), and conclusion."}'),
  1, 10, 20, NOW()),
(UUID(), @l_ielts_3, 'Fill in: In _____, I would like to argue', 'FILL_IN_BLANK',
  CONCAT('{"question":"In this essay, I would like to _____ that technology has more benefits than drawbacks.","answer":"argue","hints":["give opinion"],"explanation":"Argue means to present and support your opinion."}'),
  2, 10, 15, NOW()),
(UUID(), @l_ielts_3, 'Match essay parts', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Introduction","right":"Paraphrase question + thesis"},{"left":"Body paragraph 1","right":"First argument + example"},{"left":"Body paragraph 2","right":"Second argument + example"},{"left":"Conclusion","right":"Summarize + restate thesis"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_ielts_3, 'Minimum words for Task 2?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What is the minimum word count for IELTS Writing Task 2?","options":["150 words","200 words","250 words","300 words"],"correctIndex":2,"explanation":"IELTS Writing Task 2 requires a minimum of 250 words."}'),
  4, 10, 15, NOW()),
(UUID(), @l_ielts_3, 'Fill in: Some people believe that _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Some people believe that _____ others disagree. (however)","answer":"however","hints":["contrast word"],"explanation":"However is used to introduce a contrasting idea."}'),
  5, 10, 15, NOW());

-- IELTS Lesson 4: Listening Tips - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_ielts_4, 'How many sections in IELTS listening?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How many sections are there in IELTS listening?","options":["2 sections","3 sections","4 sections","5 sections"],"correctIndex":2,"explanation":"IELTS listening has 4 sections with increasing difficulty."}'),
  1, 10, 15, NOW()),
(UUID(), @l_ielts_4, 'Fill in: Read the questions _____ the recording plays', 'FILL_IN_BLANK',
  CONCAT('{"question":"Read the questions _____ the recording plays. (before)","answer":"before","hints":["preview first"],"explanation":"Always read questions before the recording plays to know what to listen for."}'),
  2, 10, 15, NOW()),
(UUID(), @l_ielts_4, 'Match listening section types', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Section 1","right":"Social situation"},{"left":"Section 2","right":"Monologue"},{"left":"Section 3","right":"Academic discussion"},{"left":"Section 4","right":"Academic lecture"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_ielts_4, 'Do you get extra time to transfer answers?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"In IELTS listening, do you get extra time to transfer answers to the answer sheet?","options":["Yes, 10 minutes","Yes, 5 minutes","No, transfer while listening","Only in reading"],"correctIndex":0,"explanation":"You get 10 minutes at the end to transfer answers from the question paper to the answer sheet."}'),
  4, 10, 20, NOW()),
(UUID(), @l_ielts_4, 'Fill in: Check your _____ carefully', 'FILL_IN_BLANK',
  CONCAT('{"question":"Check your _____ carefully: spelling, grammar, and word form. (answers)","answer":"answers","hints":["review"],"explanation":"Always review your spelling and grammar in the answer sheet."}'),
  5, 10, 15, NOW());

-- IELTS Lesson 5: Speaking Part 1-3 - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_ielts_5, 'How long is Part 1?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How long does IELTS Speaking Part 1 typically last?","options":["1-2 minutes","4-5 minutes","10-15 minutes","20 minutes"],"correctIndex":1,"explanation":"Part 1 lasts 4-5 minutes with introduction and familiar topics."}'),
  1, 10, 15, NOW()),
(UUID(), @l_ielts_5, 'Fill in: In Part 2, you speak for _____ minute', 'FILL_IN_BLANK',
  CONCAT('{"question":"In IELTS Speaking Part 2, you speak for _____ minute without interruption. (one/two)","answer":"one or two","hints":["1-2"],"explanation":"Part 2 is a long turn where you speak for 1-2 minutes on a topic."}'),
  2, 10, 15, NOW()),
(UUID(), @l_ielts_5, 'Match speaking parts', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Part 1","right":"Familiar topics Q&A"},{"left":"Part 2","right":"Long turn (1-2 min)"},{"left":"Part 3","right":"Discussion with examiner"},{"left":"Whole test","right":"11-14 minutes total"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_ielts_5, 'What should Part 3 focus on?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Part 3 of IELTS Speaking focuses on:","options":["Personal topics like hobbies","Abstract ideas and issues","Your family and home","Your daily routine"],"correctIndex":1,"explanation":"Part 3 discusses abstract topics and issues in more depth than Part 1."}'),
  4, 10, 20, NOW()),
(UUID(), @l_ielts_5, 'Fill in: Use _____ examples to support your points', 'FILL_IN_BLANK',
  CONCAT('{"question":"Use _____ examples to support your points in speaking. (specific)","answer":"specific","hints":["real"],"explanation":"Specific examples make your answers more convincing and natural."}'),
  5, 10, 15, NOW());

-- Get Japanese lesson IDs
SET @l_ja_n5_1 = (SELECT id FROM lessons WHERE title = 'Hiragana - Basic Syllabaries' LIMIT 1);
SET @l_ja_n5_2 = (SELECT id FROM lessons WHERE title = 'Katakana - Foreign Words' LIMIT 1);
SET @l_ja_n5_3 = (SELECT id FROM lessons WHERE title = 'Basic Grammar Patterns' LIMIT 1);
SET @l_ja_n5_4 = (SELECT id FROM lessons WHERE title = 'Numbers & Time' LIMIT 1);
SET @l_ja_n5_5 = (SELECT id FROM lessons WHERE title = 'N5 Kanji Part 1' LIMIT 1);
SET @l_ja_n4_1 = (SELECT id FROM lessons WHERE title = 'N4 Kanji Part 1' LIMIT 1);
SET @l_ja_n4_2 = (SELECT id FROM lessons WHERE title = 'Te-form Grammar' LIMIT 1);
SET @l_ja_n4_3 = (SELECT id FROM lessons WHERE title = 'N4 Grammar - Potential Form' LIMIT 1);
SET @l_ja_n4_4 = (SELECT id FROM lessons WHERE title = 'N4 Vocabulary' LIMIT 1);
SET @l_ja_n4_5 = (SELECT id FROM lessons WHERE title = 'N4 Kanji Part 2' LIMIT 1);
SET @l_ja_n3_1 = (SELECT id FROM lessons WHERE title = 'N3 Grammar - Volitional Form' LIMIT 1);
SET @l_ja_n3_2 = (SELECT id FROM lessons WHERE title = 'N3 Kanji' LIMIT 1);
SET @l_ja_n3_3 = (SELECT id FROM lessons WHERE title = 'N3 Passive & Causative' LIMIT 1);
SET @l_ja_n3_4 = (SELECT id FROM lessons WHERE title = 'N3 Vocabulary' LIMIT 1);
SET @l_ja_n3_5 = (SELECT id FROM lessons WHERE title = 'N3 Reading Comprehension' LIMIT 1);
SET @l_ja_conv_1 = (SELECT id FROM lessons WHERE title = 'Casual Greetings' LIMIT 1);
SET @l_ja_conv_2 = (SELECT id FROM lessons WHERE title = 'Making Plans' LIMIT 1);
SET @l_ja_conv_3 = (SELECT id FROM lessons WHERE title = 'Shopping & Ordering' LIMIT 1);
SET @l_ja_conv_4 = (SELECT id FROM lessons WHERE title = 'Travel Japanese' LIMIT 1);
SET @l_ja_conv_5 = (SELECT id FROM lessons WHERE title = 'Expressing Opinions' LIMIT 1);
SET @l_ja_bus_1 = (SELECT id FROM lessons WHERE title = 'Business Japanese Basics' LIMIT 1);
SET @l_ja_bus_2 = (SELECT id FROM lessons WHERE title = 'Keigo - Honorific Language' LIMIT 1);
SET @l_ja_bus_3 = (SELECT id FROM lessons WHERE title = 'Business Email Writing' LIMIT 1);
SET @l_ja_bus_4 = (SELECT id FROM lessons WHERE title = 'Business Meetings' LIMIT 1);
SET @l_ja_bus_5 = (SELECT id FROM lessons WHERE title = 'Phone & Video Conferences' LIMIT 1);

-- Japanese JLPT N5 Lesson 1: Hiragana - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_ja_n5_1, 'Which hiragana reads as ka?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Which hiragana character represents the sound ka?","options":["あ","か","さ","な"],"correctIndex":1,"explanation":"か is read as ka."}'),
  1, 10, 20, NOW()),
(UUID(), @l_ja_n5_1, 'Fill in: か is read as _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"The hiragana character か is read as _____.","answer":"ka","hints":["first syllable of katakata"],"explanation":"か represents the ka syllable in Hiragana."}'),
  2, 10, 15, NOW()),
(UUID(), @l_ja_n5_1, 'Match hiragana to romaji', 'MATCHING',
  CONCAT('{"pairs":[{"left":"あ","right":"a"},{"left":"い","right":"i"},{"left":"う","right":"u"},{"left":"え","right":"e"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_ja_n5_1, 'How do you write "ma"?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Which hiragana represents the syllable ma?","options":["な","ま","は","や"],"correctIndex":1,"explanation":"ま is read as ma."}'),
  4, 10, 15, NOW()),
(UUID(), @l_ja_n5_1, 'Fill in: The word "ねこ" means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"The word "ねこ" (neko) means _____ (animal).","answer":"cat","hints":["meow"],"explanation":"ねこ (neko) means cat in Japanese."}'),
  5, 10, 15, NOW());

-- Japanese JLPT N5 Lesson 2: Katakana - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_ja_n5_2, 'Which katakana is coffee?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Which katakana represents coffee? コーヒー","options":["tea","coffee","milk","water"],"correctIndex":1,"explanation":"コーヒー (koohii) means coffee in Japanese."}'),
  1, 10, 20, NOW()),
(UUID(), @l_ja_n5_2, 'Fill in: _____ is katakana for "su" syllable', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ is the katakana character for the su syllable. (ス)","answer":"ス","hints":["katakana su"],"explanation":"ス is the katakana for the su sound."}'),
  2, 10, 15, NOW()),
(UUID(), @l_ja_n5_2, 'Match katakana words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"テレビ","right":"TV"},{"left":"カメラ","right":"Camera"},{"left":"コーヒー","right":"Coffee"},{"left":"インターネット","right":"Internet"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_ja_n5_2, 'What is "テーブル" in English?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does テーブル (teeburu) mean in English?","options":["Chair","Table","Lamp","Bed"],"correctIndex":1,"explanation":"テーブル (teeburu) is the katakana word for table."}'),
  4, 10, 15, NOW()),
(UUID(), @l_ja_n5_2, 'Fill in: テレビ means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"テレビ (terebi) means _____ in English.","answer":"TV","hints":["television"],"explanation":"テレビ is katakana for television/TV."}'),
  5, 10, 15, NOW());

-- Japanese JLPT N5 Lesson 3: Basic Grammar - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_ja_n5_3, 'What does は indicate?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"In the sentence Watashi wa Nihonjin desu, what does は (wa) indicate?","options":["Subject marker","Object marker","Topic marker","Verb marker"],"correctIndex":2,"explanation":"は (wa) marks the topic of the sentence, not the subject."}'),
  1, 10, 20, NOW()),
(UUID(), @l_ja_n5_3, 'Fill in: Watashi _____ Nihonjin desu', 'FILL_IN_BLANK',
  CONCAT('{"question":"Watashi _____ Nihonjin desu. (topic marker)","answer":"wa","hints":["は particle"],"explanation":"は (wa) marks watashi as the topic of the sentence."}'),
  2, 10, 15, NOW()),
(UUID(), @l_ja_n5_3, 'Match particles', 'MATCHING',
  CONCAT('{"pairs":[{"left":"は (wa)","right":"Topic marker"},{"left":"が (ga)","right":"Subject marker"},{"left":"の (no)","right":"Possession"},{"left":"です (desu)","right":"Be verb"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_ja_n5_3, 'Which is correct?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Which sentence means I am a student?","options":["Sensei desu","Gakusei desu","Gakusei aru","Nihongo desu"],"correctIndex":1,"explanation":"Gakusei desu means I am a student. Sensei means teacher."}'),
  4, 10, 20, NOW()),
(UUID(), @l_ja_n5_3, 'Fill in: Kore _____ watashi no hon desu', 'FILL_IN_BLANK',
  CONCAT('{"question":"Kore _____ watashi no hon desu. This book is mine. (possession marker)","answer":"wa","hints":["は"],"explanation":"は (wa) marks the topic. The sentence means This is my book."}'),
  5, 10, 15, NOW());

-- Japanese JLPT N5 Lesson 4: Numbers & Time - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_ja_n5_4, 'What is "ichi" in number?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What number is "ichi" (いち)?","options":["0","1","2","3"],"correctIndex":1,"explanation":"ichi (一) means 1 in Japanese."}'),
  1, 10, 15, NOW()),
(UUID(), @l_ja_n5_4, 'Fill in: _____ is 100 in Japanese', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ is 100 in Japanese. (hyaku)","answer":"百","hints":["100"],"explanation":"百 (hyaku) means 100 in Japanese."}'),
  2, 10, 15, NOW()),
(UUID(), @l_ja_n5_4, 'Match numbers to kanji', 'MATCHING',
  CONCAT('{"pairs":[{"left":"一","right":"1"},{"left":"二","right":"2"},{"left":"三","right":"3"},{"left":"十","right":"10"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_ja_n5_4, 'What time is "gozen"?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Gozen 3-ji means:","options":["3 PM","3 AM","3 minutes","Afternoon"],"correctIndex":0,"explanation":"Gozen means AM/before noon. Gozen 3-ji is 3 AM."}'),
  4, 10, 20, NOW()),
(UUID(), @l_ja_n5_4, 'Fill in: _____ is Sunday', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ is Sunday in Japanese. (nichiyoubi)","answer":"日曜日","hints":["sun day"],"explanation":"日曜日 (nichiyoubi) means Sunday."}'),
  5, 10, 15, NOW());

-- Japanese JLPT N5 Lesson 5: N5 Kanji Part 1 - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_ja_n5_5, 'Which kanji means person?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Which kanji means person (hito)?","options":["大","小","人","山"],"correctIndex":2,"explanation":"人 (hito) means person in Japanese."}'),
  1, 10, 15, NOW()),
(UUID(), @l_ja_n5_5, 'Fill in: _____ means mountain', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ means mountain (yama).","answer":"山","hints":["mountain"],"explanation":"山 (yama) is the kanji for mountain."}'),
  2, 10, 15, NOW()),
(UUID(), @l_ja_n5_5, 'Match kanji meanings', 'MATCHING',
  CONCAT('{"pairs":[{"left":"日","right":"Day/Sun"},{"left":"月","right":"Month/Moon"},{"left":"火","right":"Fire"},{"left":"水","right":"Water"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_ja_n5_5, 'What does 木 mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does the kanji 木 (ki) mean?","options":["Water","Fire","Tree","Earth"],"correctIndex":2,"explanation":"木 (ki) means tree or wood in Japanese."}'),
  4, 10, 15, NOW()),
(UUID(), @l_ja_n5_5, 'Fill in: 大 means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"大 (dai/oo) means _____ (small opposite).","answer":"big","hints":["large"],"explanation":"大 means big or large, opposite of 小 (small)."}'),
  5, 10, 15, NOW());

-- Japanese JLPT N4 Lesson 1: N4 Kanji Part 1 - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_ja_n4_1, 'What does 食べる mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does 食べる (taberu) mean?","options":["To drink","To eat","To sleep","To run"],"correctIndex":1,"explanation":"食べる (taberu) means to eat in Japanese."}'),
  1, 10, 15, NOW()),
(UUID(), @l_ja_n4_1, 'Fill in: 飲む means to _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"飲む (nomu) means to _____ (drink).","answer":"drink","hints":["opposite of eat"],"explanation":"飲む (nomu) means to drink in Japanese."}'),
  2, 10, 15, NOW()),
(UUID(), @l_ja_n4_1, 'Match N4 kanji', 'MATCHING',
  CONCAT('{"pairs":[{"left":"食","right":"Eat"},{"left":"飲","right":"Drink"},{"left":"見","right":"See"},{"left":"聞","right":"Hear"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_ja_n4_1, 'Which kanji means book?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Which kanji means book (hon)?","options":["書く","読む","本","買う"],"correctIndex":2,"explanation":"本 (hon) means book in Japanese."}'),
  4, 10, 15, NOW()),
(UUID(), @l_ja_n4_1, 'Fill in: _____ means to write', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ means to write (kaku).","answer":"書く","hints":["write"],"explanation":"書く (kaku) means to write in Japanese."}'),
  5, 10, 15, NOW());

-- Japanese JLPT N4 Lesson 2: Te-form Grammar - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_ja_n4_2, 'What is the te-form of 食べる?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What is the te-form of 食べる (taberu - to eat)?","options":["食べって","食べて","食べるて","食べむ"],"correctIndex":1,"explanation":"The te-form of 食べる is 食べて (tabete)."}'),
  1, 10, 20, NOW()),
(UUID(), @l_ja_n4_2, 'Fill in: 見て _____ toimasu', 'FILL_IN_BLANK',
  CONCAT('{"question":"映画を見えて _____. I watched a movie. (finished)","answer":"しました","hints":["past of 見る"],"explanation":"Visibility te-form + しました shows the action is completed."}'),
  2, 10, 20, NOW()),
(UUID(), @l_ja_n4_2, 'Match te-form uses', 'MATCHING',
  CONCAT('{"pairs":[{"left":"~てください","right":"Please do"},{"left":"~てもいいですか","right":"May I do"},{"left":"~ています","right":"Currently doing"},{"left":"~てくださいました","right":"Did for me"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_ja_n4_2, 'Which te-form is correct?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Which is the correct te-form of 飲む (nomu)?","options":["飲みて","飲んで","飲むて","飲みて"],"correctIndex":1,"explanation":"んで group: 飲んで (nonde) is the te-form of 飲む."}'),
  4, 10, 15, NOW()),
(UUID(), @l_ja_n4_2, 'Fill in: _____ desu kara kudasai', 'FILL_IN_BLANK',
  CONCAT('{"question":"Please wait here. _____ desu kara kudasai. (this)","answer":"ここに","hints":["here"],"explanation":"ここに (koko ni) means here. ここに Desu kara kudasai means Please be here."}'),
  5, 10, 15, NOW());

-- Japanese JLPT N4 Lesson 3: Potential Form - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_ja_n4_3, 'What is the potential form of 読む?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What is the potential form of 読む (yomu - to read)?","options":["読めむ","読める","読んで","読める"],"correctIndex":1,"explanation":"Can read = 読める (yomeru). え auxiliary creates potential form."}'),
  1, 10, 20, NOW()),
(UUID(), @l_ja_n4_3, 'Fill in: Watashi wa Nihongo ga _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Watashi wa Nihongo ga _____. I can speak Japanese. (speak)","answer":"話せます","hints":["can speak"],"explanation":"話せます (hanasemasu) is the potential form of 話す."}'),
  2, 10, 20, NOW()),
(UUID(), @l_ja_n4_3, 'Match verb potential forms', 'MATCHING',
  CONCAT('{"pairs":[{"left":"書く →","right":"書ける"},{"left":"飲む →","right":"飲める"},{"left":"見る →","right":"見える"},{"left":"来る →","right":"来られる"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_ja_n4_3, 'Can vs might: 見える vs 見られる', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"見える (mieru) vs 見られる (mirareru): Which is about ability?","options":["見える only","見られる only","見える is ability, 来られる is possibility","見える is ability, 見られる is possibility"],"correctIndex":3,"explanation":"見える is natural ability. 見られる is something being possible/allowed."}'),
  4, 10, 20, NOW()),
(UUID(), @l_ja_n4_3, 'Fill in: Kono hon wa _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Kono hon wa _____. This book can be read easily. (read)","answer":"読めます","hints":["can read"],"explanation":"読めます (yomemasu) is the polite potential form of 読む."}'),
  5, 10, 15, NOW());

-- Japanese JLPT N4 Lesson 4: N4 Vocabulary - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_ja_n4_4, 'What does 便利 mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does 便利 (benri) mean?","options":["Beautiful","Convenient","Expensive","Dangerous"],"correctIndex":1,"explanation":"便利 (benri) means convenient or useful."}'),
  1, 10, 15, NOW()),
(UUID(), @l_ja_n4_4, 'Fill in: _____ means expensive', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ means expensive. (takai)","answer":"高い","hints":["price"],"explanation":"高い (takai) means expensive (for price) or tall."}'),
  2, 10, 15, NOW()),
(UUID(), @l_ja_n4_4, 'Match N4 vocabulary', 'MATCHING',
  CONCAT('{"pairs":[{"left":"不便","right":"Inconvenient"},{"left":"大切","right":"Important"},{"left":"大体","right":"About/Mostly"},{"left":"残念","right":"Regrettable"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_ja_n4_4, 'Which means "usually"?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Which word means usually (tsuujou)?","options":["不便","大切","通常","残念"],"correctIndex":2,"explanation":"通常 (tsuujou) means usually or normally."}'),
  4, 10, 15, NOW()),
(UUID(), @l_ja_n4_4, 'Fill in: _____ is inconvenient', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ is inconvenient. (fuben)","answer":"不便","hints":["opposite of convenient"],"explanation":"不便 (fuben) means inconvenient."}'),
  5, 10, 15, NOW());

-- Japanese JLPT N4 Lesson 5: N4 Kanji Part 2 - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_ja_n4_5, 'What does 駅 mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does the kanji 駅 (eki) mean?","options":["Airport","Station","Bus stop","Hospital"],"correctIndex":1,"explanation":"駅 (eki) means station (train station) in Japanese."}'),
  1, 10, 15, NOW()),
(UUID(), @l_ja_n4_5, 'Fill in: _____ means school', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ means school (gakkou).","answer":"学校","hints":["study place"],"explanation":"学校 (gakkou) means school. 学 = study, 校 = school."}'),
  2, 10, 15, NOW()),
(UUID(), @l_ja_n4_5, 'Match compound kanji', 'MATCHING',
  CONCAT('{"pairs":[{"left":"電話","right":"Telephone"},{"left":"病院","right":"Hospital"},{"left":"銀行","right":"Bank"},{"left":"食堂","right":"Cafeteria"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_ja_n4_5, 'What is 話?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does 話 (hanashi) mean?","options":["Listen","Speak/Story","Read","Write"],"correctIndex":1,"explanation":"話 (hanashi) means talk, story, or speaking."}'),
  4, 10, 15, NOW()),
(UUID(), @l_ja_n4_5, 'Fill in: _____ is bank', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ is bank (ginkou).","answer":"銀行","hints":["money institution"],"explanation":"銀行 (ginkou) means bank. 銀 = silver, 行 = go/manage."}'),
  5, 10, 15, NOW());

-- Japanese JLPT N3 Lesson 1: Volitional Form - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_ja_n3_1, 'Volitional of 行く?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What is the volitional form of 行く (iku - to go)?","options":["行こう","行きよう","行いる","行けう"],"correctIndex":0,"explanation":"Volitional of 行く is 行こう (ikou), meaning Let us go."}'),
  1, 10, 20, NOW()),
(UUID(), @l_ja_n3_1, 'Fill in: _____ tabemashou', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ tabemashou. Let us eat. (shall)","answer":"食べましょう","hints":["volitional of 食べる"],"explanation":"食べましょう is the polite volitional form of 食べる."}'),
  2, 10, 15, NOW()),
(UUID(), @l_ja_n3_1, 'Match volitional forms', 'MATCHING',
  CONCAT('{"pairs":[{"left":"食べよう","right":"Let us eat (casual)"},{"left":"行こう","right":"Let us go (casual)"},{"left":"しましょう","right":"Shall we do (polite)"},{"left":"来よう","right":"Let us come (casual)"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_ja_n3_1, 'Volitional + と思う?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"tabeyou to omou means:","options":["Let us eat","I think I should eat","They want to eat","Should we eat?"],"correctIndex":1,"explanation":"~おうと思う expresses the speakers intention: I think I will/I think I should."}'),
  4, 10, 20, NOW()),
(UUID(), @l_ja_n3_1, 'Fill in: _____ ga suki desu', 'FILL_IN_BLANK',
  CONCAT('{"question":"Sushi _____ ga suki desu. I like sushi. (particle)","answer":"が","hints":["subject marker for emotion"],"explanation":"が marks the subject of the emotion (好き = like)."}'),
  5, 10, 15, NOW());

-- Japanese JLPT N3 Lesson 2: N3 Kanji - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_ja_n3_2, 'What does 経験 mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does 経験 (keiken) mean?","options":["Examination","Experience","Experiment","Expression"],"correctIndex":1,"explanation":"経験 (keiken) means experience."}'),
  1, 10, 15, NOW()),
(UUID(), @l_ja_n3_2, 'Fill in: _____ means situation', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ means situation or circumstances. (joukyou)","answer":"状況","hints":["state"],"explanation":"状況 (joukyou) means situation or circumstances."}'),
  2, 10, 15, NOW()),
(UUID(), @l_ja_n3_2, 'Match N3 kanji compounds', 'MATCHING',
  CONCAT('{"pairs":[{"left":"方法","right":"Method"},{"left":"興味","right":"Interest"},{"left":"関係","right":"Relationship"},{"left":"計画","right":"Plan/Project"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_ja_n3_2, 'What does 環境 mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does 環境 (kankyou) mean?","options":["Environment","Encourage","Energy","Endurance"],"correctIndex":0,"explanation":"環境 (kankyou) means environment."}'),
  4, 10, 15, NOW()),
(UUID(), @l_ja_n3_2, 'Fill in: _____ means method', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ means method (houhou).","answer":"方法","hints":["way"],"explanation":"方法 (houhou) means method or way."}'),
  5, 10, 15, NOW());

-- Japanese JLPT N3 Lesson 3: Passive & Causative - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_ja_n3_3, 'Passive of 食べる?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What is the passive form of 食べる (taberu)?","options":["食べらる","食べられる","食べさせる","食べれる"],"correctIndex":1,"explanation":"られる is added: 食べられる (taberareru) means to be eaten."}'),
  1, 10, 20, NOW()),
(UUID(), @l_ja_n3_3, 'Fill in: Kodomo ni hon wo _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Kodomo ni hon wo _____. Make the child read the book. (read)","answer":"読ませた","hints":["causative past"],"explanation":"読ませた is causative past: make someone do something."}'),
  2, 10, 20, NOW()),
(UUID(), @l_ja_n3_3, 'Match passive and causative', 'MATCHING',
  CONCAT('{"pairs":[{"left":"食べられる","right":"Be eaten (passive)"},{"left":"食べさせる","right":"Make eat (causative)"},{"left":"読まれる","right":"Be read (passive)"},{"left":"読ませる","right":"Make read (causative)"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_ja_n3_3, 'Causative-passive of 行く?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What is the causative-passive of 行く (iku)?","options":["行かれる","行かせる","行かせられる","行かれる"],"correctIndex":2,"explanation":"行かせられる: be made to go. Sometimes shortened to 行かされる."}'),
  4, 10, 20, NOW()),
(UUID(), @l_ja_n3_3, 'Fill in: 友達に泣か_____', 'FILL_IN_BLANK',
  CONCAT('{"question":"友達に泣か_____. I was made to cry by my friend. (passive causative)","answer":"れた","hints":["was made to"],"explanation":"泣かせれた = was made to cry (causative-passive)."}'),
  5, 10, 20, NOW());

-- Japanese JLPT N3 Lesson 4: N3 Vocabulary - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_ja_n3_4, 'What does 具体的 mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does 具体的 (gutai-teki) mean?","options":["Abstract","Specific","General","Vague"],"correctIndex":1,"explanation":"具体的 means concrete, specific, or tangible."}'),
  1, 10, 15, NOW()),
(UUID(), @l_ja_n3_4, 'Fill in: _____ means to succeed', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ means to succeed (seichou).","answer":"成功する","hints":["achievement"],"explanation":"成功する (seichou suru) means to succeed."}'),
  2, 10, 15, NOW()),
(UUID(), @l_ja_n3_4, 'Match N3 vocabulary', 'MATCHING',
  CONCAT('{"pairs":[{"left":"成長","right":"Growth"},{"left":"現象","right":"Phenomenon"},{"left":"傾向","right":"Tendency"},{"left":"意識","right":"Consciousness"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_ja_n3_4, 'Which means attitude?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Which word means attitude (taido)?","options":["具体","態度","成長","傾向"],"correctIndex":1,"explanation":"態度 (taido) means attitude or posture."}'),
  4, 10, 15, NOW()),
(UUID(), @l_ja_n3_4, 'Fill in: _____ means phenomenon', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ means phenomenon (genshou).","answer":"現象","hints":["event"],"explanation":"現象 (genshou) means phenomenon."}'),
  5, 10, 15, NOW());

-- Japanese JLPT N3 Lesson 5: Reading Comprehension - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_ja_n3_5, 'Reading: Main idea?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"In a Japanese reading passage, what is most important to identify first?","options":["New vocabulary","Main idea/argument","Grammar patterns","Kanji readings"],"correctIndex":1,"explanation":"Identifying the main idea is the first step in reading comprehension."}'),
  1, 10, 20, NOW()),
(UUID(), @l_ja_n3_5, 'Fill in: _____ means conclusion', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ (ketsuron) means conclusion or summary.","answer":"結論","hints":["end"],"explanation":"結論 (ketsuron) means conclusion."}'),
  2, 10, 15, NOW()),
(UUID(), @l_ja_n3_5, 'Match reading strategies', 'MATCHING',
  CONCAT('{"pairs":[{"left":"最初","right":"First"},{"left":"結論","right":"Conclusion"},{"left":"しかし","right":"However"},{"left":"例えば","right":"For example"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_ja_n3_5, 'What does しかし mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"しかし at the beginning of a sentence means:","options":["Also","However","Therefore","For example"],"correctIndex":1,"explanation":"しかし means however, indicating a contrast."}'),
  4, 10, 15, NOW()),
(UUID(), @l_ja_n3_5, 'Fill in: _____ means for example', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ means for example (tatoeba).","answer":"例えば","hints":["example"],"explanation":"例えば (tatoeba) means for example."}'),
  5, 10, 15, NOW());

-- Japanese Conversation Lesson 1: Casual Greetings - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_ja_conv_1, 'Casual vs formal greeting?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Which is a casual greeting in Japanese?","options":["おはようございます","やあ","いただきます","失礼します"],"correctIndex":1,"explanation":"やあ (yaa) is a casual greeting. おはようございます is formal."}'),
  1, 10, 15, NOW()),
(UUID(), @l_ja_conv_1, 'Fill in: _____ is casual hello', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ is a casual way to say hello. (yoo)","answer":"よう","hints":["hi"],"explanation":"よう is a very casual greeting among friends."}'),
  2, 10, 15, NOW()),
(UUID(), @l_ja_conv_1, 'Match casual vs formal', 'MATCHING',
  CONCAT('{"pairs":[{"left":"やあ (casual)","right":"Hello"},{"left":"おはよう (semi-formal)","right":"Good morning"},{"left":"じゃあね (casual)","right":"See you"},{"left":"また (casual)","right":"Again/Until next time"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_ja_conv_1, 'How to say bye casually?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say goodbye casually?","options":["おはようございます","またね","さようなら","失礼します"],"correctIndex":1,"explanation":"またね (mata ne) is a casual way to say See you/Bye."}'),
  4, 10, 15, NOW()),
(UUID(), @l_ja_conv_1, 'Fill in: _____ yaa (casual greeting)', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ yaa means hey there, what is up? (casual)","answer":"おっ","hints":["interjection"],"explanation":"おっ might be なんて or just an informal exclamation."}'),
  5, 10, 15, NOW());

-- Japanese Conversation Lesson 2: Making Plans - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_ja_conv_2, 'How to suggest meeting?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you suggest meeting casually in Japanese?","options":["明日会おう","明日会ってください","明日会いました","明日会い"],"correctIndex":0,"explanation":"明日会おう (ashita auou) means Let us meet tomorrow (casual volitional)."}'),
  1, 10, 20, NOW()),
(UUID(), @l_ja_conv_2, 'Fill in: _____ ikou (where shall we go?)', 'FILL_IN_BLANK',
  CONCAT('{"question":"Doko ni _____? Where shall we go?","answer":"行こう","hints":["volitional"],"explanation":"行こう (ikou) is the volitional form meaning Let us go."}'),
  2, 10, 15, NOW()),
(UUID(), @l_ja_conv_2, 'Match plan expressions', 'MATCHING',
  CONCAT('{"pairs":[{"left":"会おう","right":"Let us meet"},{"left":"行こう","right":"Let us go"},{"left":"何時に？","right":"What time?"},{"left":"どこで？","right":"Where?"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_ja_conv_2, 'What does 約束 mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does 約束 (yakusoku) mean?","options":["Apology","Promise","Plan","Question"],"correctIndex":1,"explanation":"約束 (yakusoku) means promise or appointment."}'),
  4, 10, 15, NOW()),
(UUID(), @l_ja_conv_2, 'Fill in: _____ suru (to promise)', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ suru means to make a promise. (yakusoku)","answer":"約束する","hints":["promise"],"explanation":"約束する means to promise or to make an appointment."}'),
  5, 10, 15, NOW());

-- Japanese Conversation Lesson 3: Shopping & Ordering - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_ja_conv_3, 'How to say this please?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say I will take this one in a shop?","options":["これをください","これを買います","これにする","これを待つ"],"correctIndex":0,"explanation":"これをください means Please give me this / I will take this."}'),
  1, 10, 15, NOW()),
(UUID(), @l_ja_conv_3, 'Fill in: _____ kudasai (how much?)', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ kudasai? How much is this?","answer":"いくら","hints":["price"],"explanation":"いくら (ikura) means how much in casual Japanese."}'),
  2, 10, 15, NOW()),
(UUID(), @l_ja_conv_3, 'Match shopping phrases', 'MATCHING',
  CONCAT('{"pairs":[{"left":"これください","right":"This please"},{"left":"いくら","right":"How much"},{"left":"得です","right":"Good deal"},{"left":"カードで払えますか","right":"Can I pay by card"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_ja_conv_3, 'What does 払い mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"払い (barai) in 払えますか means:","options":["To wait","To pay","To exchange","To buy"],"correctIndex":1,"explanation":"払い (barai) means payment. 払えますか means Can I pay?"}'),
  4, 10, 15, NOW()),
(UUID(), @l_ja_conv_3, 'Fill in: _____ means discount', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ means discount. (waribiki)","answer":"割引","hints":["reduction"],"explanation":"割引 (waribiki) means discount (percentage off)."}'),
  5, 10, 15, NOW());

-- Japanese Conversation Lesson 4: Travel Japanese - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_ja_conv_4, 'How to ask where?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you ask where is the station in casual Japanese?","options":["駅はどこですか","駅はどこ？","駅にあります","駅へ行きます"],"correctIndex":1,"explanation":"駅はどこ？ is the casual way to ask Where is the station?"}'),
  1, 10, 15, NOW()),
(UUID(), @l_ja_conv_4, 'Fill in: _____ de imasu ka', 'FILL_IN_BLANK',
  CONCAT('{"question":"Tokyo Tower wa _____? Where is Tokyo Tower?","answer":"どこ","hints":["where"],"explanation":"どこ (doko) means where. 在哪里 de imasu ka = is where?"}'),
  2, 10, 15, NOW()),
(UUID(), @l_ja_conv_4, 'Match travel phrases', 'MATCHING',
  CONCAT('{"pairs":[{"left":"切符","right":"Ticket"},{"left":"降りる","right":"To get off"},{"left":"乗る","right":"To get on"},{"left":"目的地","right":"Destination"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_ja_conv_4, 'What does 降りる mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"降りる (oriru) means:","options":["To get on","To get off","To ride","To drive"],"correctIndex":1,"explanation":"降りる means to get off (bus, train) or descend."}'),
  4, 10, 15, NOW()),
(UUID(), @l_ja_conv_4, 'Fill in: _____ is ticket', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ is ticket (kippu).","answer":"切符","hints":["paper"],"explanation":"切符 (kippu) means ticket."}'),
  5, 10, 15, NOW());

-- Japanese Conversation Lesson 5: Expressing Opinions - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_ja_conv_5, 'How to express opinion casually?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say I think it is good casually?","options":[" хорош","良いと思う","良いでした","良いでしょう"],"correctIndex":1,"explanation":"良いと思う (yoi to omou) means I think it is good."}'),
  1, 10, 20, NOW()),
(UUID(), @l_ja_conv_5, 'Fill in: _____ wa ii totte imasu', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ wa ii totte imasu. I hear it is good. (this)","answer":"これ","hints":["this thing"],"explanation":"これ (kore) means this. It is often used in conversation."}'),
  2, 10, 15, NOW()),
(UUID(), @l_ja_conv_5, 'Match opinion expressions', 'MATCHING',
  CONCAT('{"pairs":[{"left":"~と思う","right":"I think"},{"left":"~と思う","right":"I believe"},{"left":"~
</h2>","right":"I hear"},{"left":"~
な~
</h2>","right":"I feel"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_ja_conv_5, 'What does ～
な mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"～
な opinion desu means:","options":["I am thinking","I feel that","I know","I remember"],"correctIndex":1,"explanation":"～
な opinion desu is used to express a soft opinion or impression."}'),
  4, 10, 15, NOW()),
(UUID(), @l_ja_conv_5, 'Fill in: _____ to omotte imasu', 'FILL_IN_BLANK',
  CONCAT('{"question":"Watashi wa _____. I think so. (sou)","answer":"そう","hints":["that way"],"explanation":"そう (sou) means so/that way. そう to omotte imasu means I think so."}'),
  5, 10, 15, NOW());

-- Japanese Business Lesson 1: Business Japanese Basics - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_ja_bus_1, 'How to greet in business?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What is the appropriate greeting in Japanese business settings?","options":["よう","おはようございます","やあ","っす"],"correctIndex":1,"explanation":"おはようございます is the polite/formal morning greeting used in business."}'),
  1, 10, 20, NOW()),
(UUID(), @l_ja_bus_1, 'Fill in: _____ wa irasshaimasu ka', 'FILL_IN_BLANK',
  CONCAT('{"question":"okaasan wa _____? Is your mother here? (honorific)","answer":"いらっしゃい","hints":["honorific of いる"],"explanation":"いらっしゃい (irasshai) is the honorific form of いる."}'),
  2, 10, 15, NOW()),
(UUID(), @l_ja_bus_1, 'Match business greetings', 'MATCHING',
  CONCAT('{"pairs":[{"left":"おはようございます","right":"Good morning (formal)"},{"left":"お疲れ様です","right":"Thank you for your work"},{"left":"失礼します","right":"Excuse me (formal)"},{"left":"お世話になります","right":"Thank you for your patronage"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_ja_bus_1, 'What does お疲れ様 mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does お疲れ様です (otsukaresama desu) mean?","options":["Good morning","Thank you for working hard","Goodbye","Please excuse me"],"correctIndex":1,"explanation":"お疲れ様 means Thank you for your hard work, used between colleagues."}'),
  4, 10, 15, NOW()),
(UUID(), @l_ja_bus_1, 'Fill in: _____ itashimasu (polite do)', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ itashimasu is the humble/polite form of します.","answer":"いたし","hints":["する humble"],"explanation":"いたし is the humble form used in business Japanese."}'),
  5, 10, 15, NOW());

-- Japanese Business Lesson 2: Keigo - Honorific Language - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_ja_bus_2, 'Polite form of 食べる?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What is the polite (sonkeigo) form of 食べる (taberu)?","options":["食べます","召し上がります","食べられる","食べさせる"],"correctIndex":1,"explanation":"召し上がります (meshiagarimasu) is the honorific form of 食べる."}'),
  1, 10, 20, NOW()),
(UUID(), @l_ja_bus_2, 'Fill in: _____ irasshaimasu (go honorific)', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ irasshaimasu is the honorific form of 行きます.","answer":"いらっしゃい","hints":["honorific go"],"explanation":"いらっしゃい is the honorific form of 来る/行く."}'),
  2, 10, 15, NOW()),
(UUID(), @l_ja_bus_2, 'Match keigo forms', 'MATCHING',
  CONCAT('{"pairs":[{"left":"する → いたします","right":"Humble"},{"left":"行く → いらっしゃい","right":"Honorific"},{"left":"来る → いらっしゃい","right":"Honorific"},{"left":"もらう → いただく","right":"Humble"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_ja_bus_2, 'Humble form of 渡す?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What is the humble form of お渡しします (otowashi shimasu)?","options":["差し上げます","顶戴します","お届けします","差し控え"],"correctIndex":2,"explanation":"お届けします (ododoki shimasu) is the humble form meaning to deliver."}'),
  4, 10, 20, NOW()),
(UUID(), @l_ja_bus_2, 'Fill in: 先生が _____ kudasaimashita', 'FILL_IN_BLANK',
  CONCAT('{"question":"Sensei ga _____ kudasaimashita. The teacher gave me. (receive honorific)","answer":"ください","hints":["kudasaru honorific"],"explanation":"ください (kudasaru) is the honorific form of くれる."}'),
  5, 10, 15, NOW());

-- Japanese Business Lesson 3: Business Email Writing - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_ja_bus_3, 'How to start a business email?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you start a formal business email in Japanese?","options":["よう","お忙しいところ失礼いたします","こんにちは"," Oi"],"correctIndex":1,"explanation":"お忙しいところ失礼いたします is a polite opening meaning Excuse me while you are busy."}'),
  1, 10, 20, NOW()),
(UUID(), @l_ja_bus_3, 'Fill in: _____ shite mo yoroshii desu ka', 'FILL_IN_BLANK',
  CONCAT('{"question":"~~~~~~ shite mo yoroshii desu ka? May I ask you to do this?","answer":"お願い","hints":["request"],"explanation":"お願い (onegai) means request. お願いしてもよろしいですか is polite."}'),
  2, 10, 15, NOW()),
(UUID(), @l_ja_bus_3, 'Match email expressions', 'MATCHING',
  CONCAT('{"pairs":[{"left":"お忙しいところ","right":"While you are busy"},{"left":"不起訴いたします","right":"Humble apology"},{"left":"ご確認のほど","right":"Request for confirmation"},{"left":"ご多忙のところ","right":"Despite being busy"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_ja_bus_3, 'Humble apology in email?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you humbly apologize in a Japanese business email?","options":["ごめんなさい","申し訳ございません","すみません","悪い"],"correctIndex":1,"explanation":"申し訳ございません (moushiwake arimasen) is the most formal humble apology."}'),
  4, 10, 15, NOW()),
(UUID(), @l_ja_bus_3, 'Fill in: _____ kudasaimasu', 'FILL_IN_BLANK',
  CONCAT('{"question":"Attached file. _____ kudasaimasu. (send polite)","answer":"お送り","hints":["send humble"],"explanation":"お送りします is the humble form meaning I will send."}'),
  5, 10, 15, NOW());

-- Japanese Business Lesson 4: Business Meetings - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_ja_bus_4, 'How to start a meeting?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you formally start a business meeting in Japanese?","options":["じゃあ、始めよう","それでは、会議を始めさせていただきます","始まる","始める"],"correctIndex":1,"explanation":"それでは、会議を始めさせていただきます means Let me begin the meeting (humble)."}'),
  1, 10, 20, NOW()),
(UUID(), @l_ja_bus_4, 'Fill in: _____ _____ desu (your opinion?)', 'FILL_IN_BLANK',
  CONCAT('{"question":"ご~~~
</h2> _____ _____ desu ka? What is your opinion? (honorific)","answer":"意見","hints":["opinion"],"explanation":"ご~
</h2> _____ desu ka? means May I ask for your opinion?"}'),
  2, 10, 15, NOW()),
(UUID(), @l_ja_bus_4, 'Match meeting vocabulary', 'MATCHING',
  CONCAT('{"pairs":[{"left":"議事堂","right":"Minutes"},{"left":"議題","right":"Agenda item"},{"left":"出席者","right":"Attendees"},{"left":"保留","right":"Table/Postpone"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_ja_bus_4, 'What does 保留 mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does 保留 (houryuu) mean in a meeting context?","options":["Approve","Postpone/Tabled","Reject","Discuss"],"correctIndex":1,"explanation":"保留 means to hold/table/postpone a decision for later."}'),
  4, 10, 15, NOW()),
(UUID(), @l_ja_bus_4, 'Fill in: _____ is agenda', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ is agenda (gidai).","answer":"議題","hints":["meeting topic"],"explanation":"議題 (gidai) means agenda topic in a meeting."}'),
  5, 10, 15, NOW());

-- Japanese Business Lesson 5: Phone & Video Conferences - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_ja_bus_5, 'Answer business phone?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you answer a business phone in Japanese?","options":["もしもし","はい、ABC株式会社の山田です","你好","ごきげんよう"],"correctIndex":1,"explanation":"はい、ABC株式会社の山田です means Yes, this is Yamada from ABC Company."}'),
  1, 10, 20, NOW()),
(UUID(), @l_ja_bus_5, 'Fill in: 一時_____ kudasai', 'FILL_IN_BLANK',
  CONCAT('{"question":"一時_____ kudasai. Please hold for a moment.","answer":"お待ち","hints":["wait"],"explanation":"お待ち (omachi) is the polite/honorific form of 待ち (wait)."}'),
  2, 10, 15, NOW()),
(UUID(), @l_ja_bus_5, 'Match phone expressions', 'MATCHING',
  CONCAT('{"pairs":[{"left":"はい","right":"Yes (answering)"},{"left":"お待たせしました","right":"Sorry to keep you waiting"},{"left":"取り消し","right":"Wrong number"},{"left":"かけ直す","right":"Call back"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_ja_bus_5, 'How to say wrong number?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say wrong number in Japanese business phone context?","options":["違います"," номер ошибки","ournagaidesu","間違い電話です"],"correctIndex":3,"explanation":"間違い電話です (machigai denwa desu) means this is the wrong number."}'),
  4, 10, 15, NOW()),
(UUID(), @l_ja_bus_5, 'Fill in: _____ shite moraemasu ka', 'FILL_IN_BLANK',
  CONCAT('{"question":"Can I leave a message? (dengon)","answer":"伝言","hints":["message"],"explanation":"伝言 (dengon) means message."}'),
  5, 10, 15, NOW());

-- Get remaining lesson IDs: Chinese
SET @l_zh_pinyin = (SELECT id FROM lessons WHERE title = 'Chinese Pinyin Basics' LIMIT 1);
SET @l_zh_greet  = (SELECT id FROM lessons WHERE title = 'Basic Greetings' LIMIT 1);
SET @l_zh_num    = (SELECT id FROM lessons WHERE title = 'Numbers & Time' LIMIT 1);
SET @l_zh_family = (SELECT id FROM lessons WHERE title = 'Family & People' LIMIT 1);
SET @l_zh_food   = (SELECT id FROM lessons WHERE title = 'Food & Drinks' LIMIT 1);
SET @l_zh_gram2  = (SELECT id FROM lessons WHERE title = 'HSK 2 Grammar' LIMIT 1);
SET @l_zh_shop   = (SELECT id FROM lessons WHERE title = 'Shopping & Prices' LIMIT 1);
SET @l_zh_dir    = (SELECT id FROM lessons WHERE title = 'Asking Directions' LIMIT 1);
SET @l_zh_daily  = (SELECT id FROM lessons WHERE title = 'Daily Activities' LIMIT 1);
SET @l_zh_vocab2 = (SELECT id FROM lessons WHERE title = 'HSK 2 Vocabulary' LIMIT 1);
SET @l_zh_gram3  = (SELECT id FROM lessons WHERE title = 'HSK 3 Grammar' LIMIT 1);
SET @l_zh_vocab3 = (SELECT id FROM lessons WHERE title = 'HSK 3 Vocabulary' LIMIT 1);
SET @l_zh_travel = (SELECT id FROM lessons WHERE title = 'Travel in China' LIMIT 1);
SET @l_zh_read   = (SELECT id FROM lessons WHERE title = 'Chinese Reading' LIMIT 1);
SET @l_zh_opin   = (SELECT id FROM lessons WHERE title = 'Expressing Opinions' LIMIT 1);
SET @l_zh_casual = (SELECT id FROM lessons WHERE title = 'Casual Conversations' LIMIT 1);
SET @l_zh_phone  = (SELECT id FROM lessons WHERE title = 'Making Phone Calls' LIMIT 1);
SET @l_zh_social = (SELECT id FROM lessons WHERE title = 'Chinese Social Media' LIMIT 1);
SET @l_zh_weather= (SELECT id FROM lessons WHERE title = 'Weather & Seasons' LIMIT 1);
SET @l_zh_emo    = (SELECT id FROM lessons WHERE title = 'Expressing Emotions' LIMIT 1);
SET @l_zh_busbase= (SELECT id FROM lessons WHERE title = 'Business Chinese Basics' LIMIT 1);
SET @l_zh_meet   = (SELECT id FROM lessons WHERE title = 'Business Meetings' LIMIT 1);
SET @l_zh_email  = (SELECT id FROM lessons WHERE title = 'Business Email Writing' LIMIT 1);
SET @l_zh_neg    = (SELECT id FROM lessons WHERE title = 'Negotiation Language' LIMIT 1);
SET @l_zh_culture= (SELECT id FROM lessons WHERE title = 'Chinese Business Culture' LIMIT 1);

-- Chinese HSK 1 Lesson 1: Pinyin Basics - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_pinyin, 'What is the tone for ma?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"The syllable ma with tone 1 (ma) sounds like:","options":["Mother","Horse","Scold","What"],"correctIndex":0,"explanation":"First tone (high level) ma = mother."}'),
  1, 10, 20, NOW()),
(UUID(), @l_zh_pinyin, 'Fill in: ma1 = _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"The pinyin ma with tone 1 represents the _____ tone. (high level)","answer":"first","hints":["tone 1"],"explanation":"First tone is a high level tone, marked with a straight line above."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_pinyin, 'Match tones to descriptions', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Tone 1","right":"High level"},{"left":"Tone 2","right":"Rising"},{"left":"Tone 3","right":"Low dipping"},{"left":"Tone 4","right":"Falling"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_pinyin, 'Which tone mark for ba3?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"The syllable ba with tone 3 (dipping) sounds like:","options":["Eight","Papa","爸 (father)","Bar"],"correctIndex":2,"explanation":"Third tone ba sounds like 爸 (father)."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_pinyin, 'Fill in: nǐ hǎo means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Nǐ hǎo (ni3 hao3) means _____ in English.","answer":"Hello","hints":["greeting"],"explanation":"Nǐ hǎo is the standard Chinese greeting meaning Hello."}'),
  5, 10, 15, NOW());

-- Chinese HSK 1 Lesson 2: Basic Greetings - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_greet, 'How do you say goodbye?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say goodbye in Chinese?","options":["Nǐ hǎo","Zàijiàn","Xièxie","Qǐng wèn"],"correctIndex":1,"explanation":"Zàijiàn (goodbye) literally means see you again."}'),
  1, 10, 20, NOW()),
(UUID(), @l_zh_greet, 'Fill in: Xièxie means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Xièxie (xie4 xie4) means _____ in English.","answer":"Thank you","hints":["polite"],"explanation":"Xièxie is the standard way to say thank you in Chinese."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_greet, 'Match greetings', 'MATCHING',
  CONCAT('{"pairs":[{"left":"早上好","right":"Good morning"},{"left":"晚上好","right":"Good evening"},{"left":"再见","right":"Goodbye"},{"left":"晚安","right":"Good night"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_greet, 'What does bu hǎo mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does bu hǎo (bù hǎo) mean?","options":["Very good","Not good","Good morning","Goodbye"],"correctIndex":1,"explanation":"Bu (not) + hǎo (good) = not good."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_greet, 'Fill in: Duì buqǐ means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Duì buqǐ (duì bu qǐ) means _____ in English.","answer":"Sorry","hints":["apologize"],"explanation":"Duì buqǐ means sorry or excuse me in Chinese."}'),
  5, 10, 15, NOW());

-- Chinese HSK 1 Lesson 3: Numbers & Time - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_num, 'What is èr in number?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What number is èr (二)?","options":["1","2","3","4"],"correctIndex":1,"explanation":"èr (二) means 2 in Chinese."}'),
  1, 10, 15, NOW()),
(UUID(), @l_zh_num, 'Fill in: shí means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Shí (十) in Chinese means _____ in English.","answer":"Ten","hints":["10"],"explanation":"Shí (十) means 10 in Chinese."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_num, 'Match numbers to pinyin', 'MATCHING',
  CONCAT('{"pairs":[{"left":"一","right":"yi (1)"},{"left":"三","right":"san (3)"},{"left":"五","right":"wu (5)"},{"left":"八","right":"ba (8)"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_num, 'How do you say 100 in Chinese?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say 100 in Chinese?","options":["Shí","Bái","Yī bǎi","Shí yī"],"correctIndex":2,"explanation":"100 = yī (1) + bǎi (hundred) = yī bǎi."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_num, 'Fill in: jīntiān is _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Jīntiān (jīn tiān) in Chinese means _____ today.","answer":"today","hints":["this day"],"explanation":"Jīntiān means today in Chinese."}'),
  5, 10, 15, NOW());

-- Chinese HSK 1 Lesson 4: Family & People - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_family, 'What does bàba mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does bàba (爸爸) mean?","options":["Mother","Father","Brother","Sister"],"correctIndex":1,"explanation":"爸爸 (bàba) means father or dad in Chinese."}'),
  1, 10, 15, NOW()),
(UUID(), @l_zh_family, 'Fill in: māma means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Māma (妈妈) in Chinese means _____ in English.","answer":"Mother","hints":["female parent"],"explanation":"妈妈 (māma) means mother or mom."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_family, 'Match family words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"哥哥","right":"Older brother"},{"left":"弟弟","right":"Younger brother"},{"left":"姐姐","right":"Older sister"},{"left":"妹妹","right":"Younger sister"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_family, 'What does péngyou mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does péngyou (朋友) mean?","options":["Family","Teacher","Friend","Student"],"correctIndex":2,"explanation":"朋友 (péngyou) means friend in Chinese."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_family, 'Fill in: lǎoshī means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Lǎoshī (老师) in Chinese means _____ in English.","answer":"Teacher","hints":["education"],"explanation":"老师 (lǎoshī) means teacher in Chinese."}'),
  5, 10, 15, NOW());

-- Chinese HSK 1 Lesson 5: Food & Drinks - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_food, 'What does mǐfàn mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does mǐfàn (米饭) mean?","options":["Noodles","Rice","Bread","Soup"],"correctIndex":1,"explanation":"米饭 (mǐfàn) means rice in Chinese."}'),
  1, 10, 15, NOW()),
(UUID(), @l_zh_food, 'Fill in: shuǐ means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Shuǐ (水) in Chinese means _____ in English.","answer":"Water","hints":["drink"],"explanation":"水 (shuǐ) means water in Chinese."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_food, 'Match food words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"米饭","right":"Rice"},{"left":"面条","right":"Noodles"},{"left":"苹果","right":"Apple"},{"left":"咖啡","right":"Coffee"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_food, 'What does chī mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does chī (吃) mean in Chinese?","options":["Drink","Eat","Buy","Sleep"],"correctIndex":1,"explanation":"吃 (chī) means to eat in Chinese."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_food, 'Fill in: hē means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Hē (喝) in Chinese means _____ in English.","answer":"Drink","hints":["consume"],"explanation":"喝 (hē) means to drink in Chinese."}'),
  5, 10, 15, NOW());

-- Chinese HSK 2 Lesson 1: HSK 2 Grammar - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_gram2, 'How to say have?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say I have a dog in Chinese?","options":["Wǒ yǒu yī zhī gǒu","Wǒ chī yī zhī gǒu","Wǒ shì yī zhī gǒu","Wǒ zài yī zhī gǒu"],"correctIndex":0,"explanation":"有 (yǒu) means to have. Wǒ yǒu yī zhī gǒu = I have a dog."}'),
  1, 10, 20, NOW()),
(UUID(), @l_zh_gram2, 'Fill in: Wǒ _____ kāfēi', 'FILL_IN_BLANK',
  CONCAT('{"question":"Wǒ _____ kāfēi. I want to drink coffee. (want)","answer":"xiǎng hē","hints":["want to drink"],"explanation":"想喝 means want to drink. Wǒ xiǎng hē kāfēi = I want to drink coffee."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_gram2, 'Match grammar patterns', 'MATCHING',
  CONCAT('{"pairs":[{"left":"有 (yǒu)","right":"Have"},{"left":"想 (xiǎng)","right":"Want"},{"left":"会 (huì)","right":"Can/Will"},{"left":"能 (néng)","right":"Able to"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_gram2, 'What does méi yǒu mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does méi yǒu (没有) mean?","options":["Have","Do not have","May have","Must have"],"correctIndex":1,"explanation":"没 (méi) = not, 有 (yǒu) = have. 没有 = do not have."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_gram2, 'Fill in: Tā _____ kāfēi', 'FILL_IN_BLANK',
  CONCAT('{"question":"Tā _____ kāfēi. He does not want coffee. (not want)","answer":"bù xiǎng hē","hints":["don't want"],"explanation":"不想要 = bù xiǎng yào. Tā bù xiǎng hē kāfēi = He does not want coffee."}'),
  5, 10, 15, NOW());

-- Chinese HSK 2 Lesson 2: Shopping & Prices - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_shop, 'How to ask price?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you ask How much is this? in Chinese?","options":["Zhè shì shénme?","Zhège duōshao qián?","Zhège hěn hǎo","Zhège yībān"],"correctIndex":1,"explanation":"多少钱 (duōshao qián) means how much money. Zhège duōshao qián? = How much is this?"}'),
  1, 10, 20, NOW()),
(UUID(), @l_zh_shop, 'Fill in: Piányi means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Piányi (便宜) in Chinese means _____ in English.","answer":"Cheap","hints":["low price"],"explanation":"便宜 (piányi) means cheap or inexpensive."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_shop, 'Match shopping words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"便宜","right":"Cheap"},{"left":"贵","right":"Expensive"},{"left":"买","right":"Buy"},{"left":"卖","right":"Sell"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_shop, 'What does mǎi mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does mǎi (买) mean in Chinese?","options":["Sell","Buy","Price","Money"],"correctIndex":1,"explanation":"买 (mǎi) means to buy in Chinese."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_shop, 'Fill in: Guì means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Guì (贵) in Chinese means _____ in English.","answer":"Expensive","hints":["high price"],"explanation":"贵 (guì) means expensive or noble."}'),
  5, 10, 15, NOW());

-- Chinese HSK 2 Lesson 3: Asking Directions - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_dir, 'How to ask where?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you ask Where is the bank? in Chinese?","options":["Yínháng zài nǎlǐ?","Yínháng zài duōshao?","Yínháng hěn yuǎn","Yínháng hěn jìn"],"correctIndex":0,"explanation":"在哪里 (zài nǎlǐ) means where is it. Yínháng zài nǎlǐ? = Where is the bank?"}'),
  1, 10, 20, NOW()),
(UUID(), @l_zh_dir, 'Fill in: Zuǒ means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Zuǒ (左) in Chinese means _____ in English.","answer":"Left","hints":["direction"],"explanation":"左 (zuǒ) means left in Chinese."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_dir, 'Match direction words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"左","right":"Left"},{"left":"右","right":"Right"},{"left":"前","right":"Front"},{"left":"后","right":"Back"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_dir, 'What does yuǎn mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does yuǎn (远) mean in Chinese?","options":["Near","Far","Left","Right"],"correctIndex":1,"explanation":"远 (yuǎn) means far or distant in Chinese."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_dir, 'Fill in: Jìn means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Jìn (近) in Chinese means _____ in English.","answer":"Near","hints":["close"],"explanation":"近 (jìn) means near or close in Chinese."}'),
  5, 10, 15, NOW());

-- Chinese HSK 2 Lesson 4: Daily Activities - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_daily, 'How to say I go to work?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say I go to work every day in Chinese?","options":["Wǒ qù xuéxiào","Wǒ qù shàngbān","Wǒ huí jiā","Wǒ shuìjiào"],"correctIndex":1,"explanation":"去上班 (qù shàngbān) means go to work. Wǒ měitiān qù shàngbān = I go to work every day."}'),
  1, 10, 20, NOW()),
(UUID(), @l_zh_daily, 'Fill in: Zuò means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Zuò (做) in Chinese means _____ in English.","answer":"Do/Make","hints":["action"],"explanation":"做 (zuò) means to do or to make in Chinese."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_daily, 'Match daily activities', 'MATCHING',
  CONCAT('{"pairs":[{"left":"起床","right":"Wake up"},{"left":"睡觉","right":"Sleep"},{"left":"吃饭","right":"Eat"},{"left":"工作","right":"Work"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_daily, 'What does shuìjiào mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does shuìjiào (睡觉) mean in Chinese?","options":["Wake up","Sleep","Work","Eat"],"correctIndex":1,"explanation":"睡觉 (shuìjiào) means to sleep in Chinese."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_daily, 'Fill in: Chīfàn means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Chīfàn (吃饭) in Chinese means _____ in English.","answer":"Eat","hints":["consume food"],"explanation":"吃饭 literally means eat rice/meal."}'),
  5, 10, 15, NOW());

-- Chinese HSK 2 Lesson 5: HSK 2 Vocabulary - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_vocab2, 'What does yǐjīng mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does yǐjīng (已经) mean?","options":["Still","Already","Not yet","Always"],"correctIndex":1,"explanation":"已经 (yǐjīng) means already in Chinese."}'),
  1, 10, 15, NOW()),
(UUID(), @l_zh_vocab2, 'Fill in: Zhème means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Zhème (这么) in Chinese means _____ in English.","answer":"So/This way","hints":["degree"],"explanation":"这么 (zhème) means so or this way, used for degree."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_vocab2, 'Match HSK 2 words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"经常","right":"Often"},{"left":"有时候","right":"Sometimes"},{"left":"然后","right":"Then"},{"left":"因为","right":"Because"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_vocab2, 'What does suǒyǐ mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does suǒyǐ (所以) mean?","options":["Because","Therefore/So","But","Or"],"correctIndex":1,"explanation":"所以 (suǒyǐ) means therefore or so in Chinese."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_vocab2, 'Fill in: Ránhòu means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Ránhòu (然后) in Chinese means _____ in English.","answer":"Then","hints":["after"],"explanation":"然后 (ránhòu) means then or after that in Chinese."}'),
  5, 10, 15, NOW());

-- Chinese HSK 3 Lesson 1: HSK 3 Grammar - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_gram3, 'What does bǎ construction mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"In Wǒ bǎ shū fàng zài zhuōzi shàng, what does bǎ indicate?","options":["Topic","Object moved","Action","Location"],"correctIndex":1,"explanation":"Bǎ construction is used to move the object to a new location. Wǒ bǎ shū fàng zài zhuōzi shàng = I put the book on the table."}'),
  1, 10, 25, NOW()),
(UUID(), @l_zh_gram3, 'Fill in: Bèi construction means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"The passive voice construction with bèi (被) in Chinese means _____ in English.","answer":"Passive voice","hints":["receive action"],"explanation":"被 construction indicates passive voice: the subject receives the action."}'),
  2, 10, 20, NOW()),
(UUID(), @l_zh_gram3, 'Match grammar patterns', 'MATCHING',
  CONCAT('{"pairs":[{"left":"把...放在...","right":"Put...on..."},{"left":"被...动词","right":"Be done by..."},{"left":"除了...以外","right":"Besides..."},{"left":"如果...的话","right":"If..."}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_gram3, 'What does suīrán...dànshì mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does suīrán...dànshì (虽然...但shi) mean?","options":["Because...so","Although...but","If...then","Either...or"],"correctIndex":1,"explanation":"虽然...但是 means although...but/however."}'),
  4, 10, 20, NOW()),
(UUID(), @l_zh_gram3, 'Fill in: Jiǎrú means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Jiǎrú (假如) in Chinese means _____ in English.","answer":"If/Suppose","hints":["condition"],"explanation":"假如 (jiǎrú) means if or suppose in Chinese."}'),
  5, 10, 15, NOW());

-- Chinese HSK 3 Lesson 2: HSK 3 Vocabulary - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_vocab3, 'What does zhìshǎo mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does zhìshǎo (至少) mean?","options":["At most","At least","Exactly","About"],"correctIndex":1,"explanation":"至少 (zhìshǎo) means at least or at minimum."}'),
  1, 10, 15, NOW()),
(UUID(), @l_zh_vocab3, 'Fill in: Gēnggǎi means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Gēnggǎi (更改) in Chinese means _____ in English.","answer":"Change/Modify","hints":["alter"],"explanation":"更改 (gēnggǎi) means to change or modify."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_vocab3, 'Match HSK 3 vocabulary', 'MATCHING',
  CONCAT('{"pairs":[{"left":"包括","right":"Include"},{"left":"否则","right":"Otherwise"},{"left":"实际","right":"Actual/Real"},{"left":"自从","right":"Since"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_vocab3, 'What does yǐhòu mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does yǐhòu (以后) mean in Chinese?","options":["Before","After","During","Now"],"correctIndex":1,"explanation":"以后 (yǐhòu) means after or in the future."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_vocab3, 'Fill in: Cǐwài means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Cǐwài (此外) in Chinese means _____ in English.","answer":"Besides/Moreover","hints":["additionally"],"explanation":"此外 (cǐwài) means besides or moreover."}'),
  5, 10, 15, NOW());

-- Chinese HSK 3 Lesson 3: Travel in China - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_travel, 'How to book a hotel?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say I want to book a room in Chinese?","options":["Wǒ yào zhǎo fángjiān","Wǒ yào dìng fángjiān","Wǒ yào mǎi fángjiān","Wǒ yào mài fángjiān"],"correctIndex":1,"explanation":"订房间 (dìng fángjiān) means to book a room."}'),
  1, 10, 20, NOW()),
(UUID(), @l_zh_travel, 'Fill in: Rùzhù means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Rùzhù (入住) in Chinese means _____ in English.","answer":"Check in","hints":["enter to stay"],"explanation":"入住 (rùzhù) means to check in to a hotel."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_travel, 'Match travel words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"订房间","right":"Book a room"},{"left":"退房","right":"Check out"},{"left":"入住","right":"Check in"},{"left":"前台","right":"Reception"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_travel, 'What does tuìfáng mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does tuìfáng (退房) mean in Chinese?","options":["Check in","Check out","Book room","Stay"],"correctIndex":1,"explanation":"退房 (tuìfáng) means to check out from a hotel."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_travel, 'Fill in: Qiántái means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Qiántái (前台) in Chinese means _____ in English.","answer":"Reception/Front desk","hints":["lobby"],"explanation":"前台 (qiántái) means reception or front desk."}'),
  5, 10, 15, NOW());

-- Chinese HSK 3 Lesson 4: Chinese Reading - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_read, 'Reading: Main idea?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"In Chinese reading comprehension, what should you identify first?","options":["Every character","Main idea of the passage","New vocabulary","Grammar points"],"correctIndex":1,"explanation":"Identifying the main idea is the first step in reading comprehension."}'),
  1, 10, 20, NOW()),
(UUID(), @l_zh_read, 'Fill in: Zhǔyào means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Zhǔyào (主要) in Chinese means _____ in English.","answer":"Main/Primary","hints":["most important"],"explanation":"主要 (zhǔyào) means main or primary."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_read, 'Match reading words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"主要","right":"Main"},{"left":"内容","right":"Content"},{"left":"主题","right":"Theme"},{"left":"段落","right":"Paragraph"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_read, 'What does jìnlù mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does jìnlù (进路) mean in Chinese reading context?","options":["Progress","Entrance","Path/Avenue","Chapter"],"correctIndex":2,"explanation":"进路 (jìnlù) means path or avenue in a reading context."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_read, 'Fill in: Nèiróng means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Nèiróng (内容) in Chinese means _____ in English.","answer":"Content","hints":["subject matter"],"explanation":"内容 (nèiróng) means content or subject matter."}'),
  5, 10, 15, NOW());

-- Chinese HSK 3 Lesson 5: Expressing Opinions - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_opin, 'How to express opinion?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say I think in Chinese?","options":["Wǒ juéde","Wǒ juéwàng","Wǒ juédìng","Wǒ juéde"],"correctIndex":0,"explanation":"觉得 (juéde) means to think or feel. 我觉得 = I think."}'),
  1, 10, 20, NOW()),
(UUID(), @l_zh_opin, 'Fill in: Wǒ rènwéi means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Wǒ rènwéi (我认为) in Chinese means _____ in English.","answer":"I think/believe","hints":["opinion"],"explanation":"认为 (rènwéi) means to think or believe, more formal than 觉得."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_opin, 'Match opinion expressions', 'MATCHING',
  CONCAT('{"pairs":[{"left":"我觉得","right":"I think"},{"left":"我认为","right":"I believe"},{"left":"据我所知","right":"As far as I know"},{"left":"一般来说","right":"Generally speaking"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_opin, 'What does jùtǐ mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does jùtǐ (具体) mean?","options":["Abstract","Specific","General","Vague"],"correctIndex":1,"explanation":"具体 (jùtǐ) means concrete or specific."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_opin, 'Fill in: Fǎnduì means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Fǎnduì (反对) in Chinese means _____ in English.","answer":"Oppose/Against","hints":["disagree"],"explanation":"反对 (fǎnduì) means to oppose or be against."}'),
  5, 10, 15, NOW());

-- Chinese Conversation Lesson 1: Casual Conversations - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_casual, 'Casual way to say hi?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Which is a casual way to say hi in Chinese?","options":["Nǐ hǎo (formal)","Hǎiya / Hi","Zàijiàn (formal)","Qǐng wèn"],"correctIndex":1,"explanation":"Hi / Hǎiya is a casual transliteration of hello used among young people."}'),
  1, 10, 15, NOW()),
(UUID(), @l_zh_casual, 'Fill in: Gēn means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Gēn (跟) in Chinese means _____ in English.","answer":"With/Follow","hints":["together"],"explanation":"跟 (gēn) means with or follow. Can also mean and when connecting nouns."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_casual, 'Match casual expressions', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Hi / 嗨","right":"Hey (casual)"},{"left":"咋了","right":"What is up"},{"left":"没事儿","right":"No problem"},{"left":"行吧","right":"Okay then"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_casual, 'What does zěnme means?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does zěnme (怎么) mean in Chinese?","options":["What","Why","How","Where"],"correctIndex":2,"explanation":"怎么 (zěnme) means how or why."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_casual, 'Fill in: Zěnmeyàng means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Zěnmeyàng (怎么样) in Chinese means _____ in English.","answer":"How about/How is it","hints":["opinion"],"explanation":"怎么样 (zěnmeyàng) means how about or how is it (asking for opinion)."}'),
  5, 10, 15, NOW());

-- Chinese Conversation Lesson 2: Making Phone Calls - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_phone, 'Answer phone casually?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you answer the phone casually in Chinese?","options":["Qǐng wèn","Wéi","Nín hǎo","Zàijiàn"],"correctIndex":1,"explanation":"喂 (wéi) is the common phone greeting in Chinese."}'),
  1, 10, 15, NOW()),
(UUID(), @l_zh_phone, 'Fill in: Dǎ diànhuà means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Dǎ diànhuà (打电话) in Chinese means _____ in English.","answer":"Make a phone call","hints":["call"],"explanation":"打电话 (dǎ diànhuà) means to make a phone call."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_phone, 'Match phone expressions', 'MATCHING',
  CONCAT('{"pairs":[{"left":"喂","right":"Hello (phone)"},{"left":"打电话","right":"Make a call"},{"left":"接电话","right":"Answer the phone"},{"left":"挂电话","right":"Hang up"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_phone, 'What does jiē diànhuà mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does jiē diànhuà (接电话) mean?","options":["Make a call","Answer the phone","Hang up","Miss a call"],"correctIndex":1,"explanation":"接电话 (jiē diànhuà) means to answer the phone."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_phone, 'Fill in: Guà diànhuà means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Guà diànhuà (挂电话) in Chinese means _____ in English.","answer":"Hang up","hints":["end call"],"explanation":"挂电话 (guà diànhuà) means to hang up the phone."}'),
  5, 10, 15, NOW());

-- Chinese Conversation Lesson 3: Chinese Social Media - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_social, 'What does fā wēibó mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does fā wēibó (发微博) mean?","options":["Read Weibo","Post on Weibo","Delete Weibo","Like Weibo"],"correctIndex":1,"explanation":"发微博 (fā wēibó) means to post on Weibo (Chinese social media)."}'),
  1, 10, 15, NOW()),
(UUID(), @l_zh_social, 'Fill in: Pīn means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Pīn (拼) in Chinese internet language means _____ (combining effort).","answer":"Collaborate/Team up","hints":["combine"],"explanation":"拼 (pīn) means to combine or team up in internet slang."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_social, 'Match social media terms', 'MATCHING',
  CONCAT('{"pairs":[{"left":"发微博","right":"Post on Weibo"},{"left":"点赞","right":"Like"},{"left":"转发","right":"Repost"},{"left":"评论","right":"Comment"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_social, 'What does diǎn zàn mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does diǎn zàn (点赞) mean in Chinese internet language?","options":["Unlike","Share","Like","Bookmark"],"correctIndex":2,"explanation":"点赞 (diǎn zàn) means to give a thumbs up or like a post."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_social, 'Fill in: Pínglùn means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Pínglùn (评论) in Chinese social media context means _____ in English.","answer":"Comment","hints":["response"],"explanation":"评论 (pínglùn) means to comment or a comment."}'),
  5, 10, 15, NOW());

-- Chinese Conversation Lesson 4: Weather & Seasons - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_weather, 'What does tiānqí hěn rè mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does tiānqí hěn rè (天气很热) mean?","options":["Weather is cold","Weather is hot","Weather is nice","Weather is bad"],"correctIndex":1,"explanation":"天气很热 = the weather is very hot."}'),
  1, 10, 15, NOW()),
(UUID(), @l_zh_weather, 'Fill in: Xiàjì means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Xiàjì (夏天) in Chinese means _____ in English.","answer":"Summer","hints":["hot season"],"explanation":"夏天 (xiàjì) means summer."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_weather, 'Match weather words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"春天","right":"Spring"},{"left":"夏天","right":"Summer"},{"left":"秋天","right":"Autumn"},{"left":"冬天","right":"Winter"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_weather, 'What does xià xuě mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does xià xuě (下雪) mean in Chinese?","options":["Heavy snow","Snowing","Snowman","Snowflake"],"correctIndex":1,"explanation":"下雪 (xià xuě) means to snow or it is snowing."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_weather, 'Fill in: Jìnié means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Jìnié (季节) in Chinese means _____ in English.","answer":"Season","hints":["time of year"],"explanation":"季节 (jìnié) means season."}'),
  5, 10, 15, NOW());

-- Chinese Conversation Lesson 5: Expressing Emotions - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_emo, 'How to say I am happy?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say I am very happy in Chinese?","options":["Wǒ hěn shāngxīn","Wǒ hěn kāixīn","Wǒ hěn hàipà","Wǒ hěn nánguò"],"correctIndex":1,"explanation":"很开心 (hěn kāixīn) = very happy. 开心 = happy."}'),
  1, 10, 15, NOW()),
(UUID(), @l_zh_emo, 'Fill in: Kāixīn means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Kāixīn (开心) in Chinese means _____ in English.","answer":"Happy","hints":["good mood"],"explanation":"开心 (kāixīn) means happy or cheerful."}'),
  Again, I'm noticing the same exercise is repeated. Let me verify I've covered all five Chinese lessons—I need to confirm that lessons 3 through 5 in the HSK 1 level and lessons 2 through 5 in HSK 2 are all included in my summary. I've finished the HSK 3 level with all 5 lessons covered, and now I'm moving into the Chinese conversation lessons—covering casual speech, phone calls, social media language, weather expressions, and emotional vocabulary, each with 5 exercises.

Now I'm starting the Chinese business section with basics like greetings and workplace communication, then moving into business meetings, email writing, negotiation language, and cultural etiquette. After that comes French A1 with foundational greetings and introductions.

Continuing through French A1 with numbers, family vocabulary, and calendar terms, then moving into A2 lessons covering clothing, restaurants, grammar, transportation, and vacation planning.

Now I'm mapping out the B1 level with grammar structures like the imparfait and subjunctive, vocabulary for opinions and press, and social relationships. The B2 curriculum continues with conditional tenses, reported speech, and advanced writing skills, while the travel-focused course covers practical scenarios like airports and emergency situations.

Moving into German, I'm establishing the foundational A1 level with greetings, self-introductions, and basic counting through to family and calendar vocabulary.

Now I'm continuing with the elementary and intermediate German courses—covering restaurant dining, shopping, grammar fundamentals like the Perfekt tense, and directional vocabulary. Then progressing through B1 and B2 levels where I'll be focusing on expressing opinions, health topics, cultural discussions, and advanced grammar structures such as conjunctive forms and complex sentence construction. I'm noticing some repetition in the exercise listings across the different language courses, so I'm doing a quick audit to make sure each language has exactly 5 courses with 5 lessons each and 5 exercises per lesson—that's 125 exercises per language, totaling 875 across all 7 languages. I'm also catching some duplicate exercise titles that need to be consolidated or adjusted. I'm catching a duplicate lesson title in the Chinese Conversation section, so I'll rename one of the "Expressing Emotions" lessons to "Emotion Vocabulary" instead. Now I need to write out all the exercises for the remaining language sections, starting with what I've already drafted for the Chinese lessons. I need to reconsider the structure here—since I'm making multiple separate edits to the file rather than one comprehensive replacement, I need to make sure each section gets properly inserted between the existing content. The key is targeting the right insertion points: the Chinese exercises go after the Japanese ones but before French, then French after Chinese, and so on. Since the file will expand significantly with all these additions, I should focus on getting the Chinese section right first as a foundation.
</think>

Tôi sẽ thêm phần Chinese và French exercises bằng cách chèn vào vị trí chính xác.
<tool_call>
<invoke name="StrReplace">
<parameter name="new_string">  5, 10, 15, NOW());

-- Get remaining lesson IDs: Chinese
SET @l_zh_pinyin = (SELECT id FROM lessons WHERE title = 'Chinese Pinyin Basics' LIMIT 1);
SET @l_zh_greet  = (SELECT id FROM lessons WHERE title = 'Basic Greetings' LIMIT 1);
SET @l_zh_num    = (SELECT id FROM lessons WHERE title = 'Numbers & Time' LIMIT 1);
SET @l_zh_family = (SELECT id FROM lessons WHERE title = 'Family & People' LIMIT 1);
SET @l_zh_food   = (SELECT id FROM lessons WHERE title = 'Food & Drinks' LIMIT 1);
SET @l_zh_gram2  = (SELECT id FROM lessons WHERE title = 'HSK 2 Grammar' LIMIT 1);
SET @l_zh_shop   = (SELECT id FROM lessons WHERE title = 'Shopping & Prices' LIMIT 1);
SET @l_zh_dir    = (SELECT id FROM lessons WHERE title = 'Asking Directions' LIMIT 1);
SET @l_zh_daily  = (SELECT id FROM lessons WHERE title = 'Daily Activities' LIMIT 1);
SET @l_zh_vocab2 = (SELECT id FROM lessons WHERE title = 'HSK 2 Vocabulary' LIMIT 1);
SET @l_zh_gram3  = (SELECT id FROM lessons WHERE title = 'HSK 3 Grammar' LIMIT 1);
SET @l_zh_vocab3 = (SELECT id FROM lessons WHERE title = 'HSK 3 Vocabulary' LIMIT 1);
SET @l_zh_travel = (SELECT id FROM lessons WHERE title = 'Travel in China' LIMIT 1);
SET @l_zh_read   = (SELECT id FROM lessons WHERE title = 'Chinese Reading' LIMIT 1);
SET @l_zh_opin   = (SELECT id FROM lessons WHERE title = 'Expressing Opinions' LIMIT 1);
SET @l_zh_casual = (SELECT id FROM lessons WHERE title = 'Casual Conversations' LIMIT 1);
SET @l_zh_phone  = (SELECT id FROM lessons WHERE title = 'Making Phone Calls' LIMIT 1);
SET @l_zh_social = (SELECT id FROM lessons WHERE title = 'Chinese Social Media' LIMIT 1);
SET @l_zh_weather= (SELECT id FROM lessons WHERE title = 'Weather & Seasons' LIMIT 1);
SET @l_zh_emo    = (SELECT id FROM lessons WHERE title = 'Expressing Emotions' LIMIT 1);
SET @l_zh_busbase= (SELECT id FROM lessons WHERE title = 'Business Chinese Basics' LIMIT 1);
SET @l_zh_meet   = (SELECT id FROM lessons WHERE title = 'Business Meetings' LIMIT 1);
SET @l_zh_email  = (SELECT id FROM lessons WHERE title = 'Business Email Writing' LIMIT 1);
SET @l_zh_neg    = (SELECT id FROM lessons WHERE title = 'Negotiation Language' LIMIT 1);
SET @l_zh_culture= (SELECT id FROM lessons WHERE title = 'Chinese Business Culture' LIMIT 1);

-- Chinese HSK 1 Lesson 1: Pinyin Basics - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_pinyin, 'What is the tone for ma1?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"The syllable ma with tone 1 (ma) sounds like:","options":["Mother","Horse","Scold","What"],"correctIndex":0,"explanation":"First tone (high level) ma = mother."}'),
  1, 10, 20, NOW()),
(UUID(), @l_zh_pinyin, 'Fill in: ma1 = _____ tone', 'FILL_IN_BLANK',
  CONCAT('{"question":"The pinyin ma with tone 1 represents the _____ tone. (high level)","answer":"first","hints":["tone 1"],"explanation":"First tone is a high level tone, marked with a straight line above."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_pinyin, 'Match tones to descriptions', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Tone 1","right":"High level"},{"left":"Tone 2","right":"Rising"},{"left":"Tone 3","right":"Low dipping"},{"left":"Tone 4","right":"Falling"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_pinyin, 'Which tone for ba3?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"The syllable ba with tone 3 (dipping) sounds like:","options":["Eight","Papa","Father","Bar"],"correctIndex":2,"explanation":"Third tone ba sounds like father."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_pinyin, 'Fill in: nǐ hǎo means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Nǐ hǎo (ni3 hao3) means _____ in English.","answer":"Hello","hints":["greeting"],"explanation":"Nǐ hǎo is the standard Chinese greeting meaning Hello."}'),
  5, 10, 15, NOW());

-- Chinese HSK 1 Lesson 2: Basic Greetings - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_greet, 'How do you say goodbye?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say goodbye in Chinese?","options":["Nǐ hǎo","Zàijiàn","Xièxie","Qǐng wèn"],"correctIndex":1,"explanation":"Zàijiàn (goodbye) literally means see you again."}'),
  1, 10, 20, NOW()),
(UUID(), @l_zh_greet, 'Fill in: Xièxie means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Xièxie (xie4 xie4) means _____ in English.","answer":"Thank you","hints":["polite"],"explanation":"Xièxie is the standard way to say thank you in Chinese."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_greet, 'Match greetings to pinyin', 'MATCHING',
  CONCAT('{"pairs":[{"left":"早上好","right":"Good morning"},{"left":"晚上好","right":"Good evening"},{"left":"再见","right":"Goodbye"},{"left":"晚安","right":"Good night"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_greet, 'What does bu hǎo mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does bu hǎo (bù hǎo) mean?","options":["Very good","Not good","Good morning","Goodbye"],"correctIndex":1,"explanation":"Bu (not) + hǎo (good) = not good."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_greet, 'Fill in: Duì buqǐ means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Duì buqǐ (duì bu qǐ) means _____ in English.","answer":"Sorry","hints":["apologize"],"explanation":"Duì buqǐ means sorry or excuse me in Chinese."}'),
  5, 10, 15, NOW());

-- Chinese HSK 1 Lesson 3: Numbers & Time - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_num, 'What is èr in number?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What number is èr (二)?","options":["1","2","3","4"],"correctIndex":1,"explanation":"èr (二) means 2 in Chinese."}'),
  1, 10, 15, NOW()),
(UUID(), @l_zh_num, 'Fill in: shí means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Shí (十) in Chinese means _____ in English.","answer":"Ten","hints":["10"],"explanation":"Shí (十) means 10 in Chinese."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_num, 'Match numbers to kanji', 'MATCHING',
  CONCAT('{"pairs":[{"left":"一","right":"yi (1)"},{"left":"三","right":"san (3)"},{"left":"五","right":"wu (5)"},{"left":"八","right":"ba (8)"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_num, 'How do you say 100 in Chinese?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say 100 in Chinese?","options":["Shí","Bái","Yī bǎi","Shí yī"],"correctIndex":2,"explanation":"100 = yī (1) + bǎi (hundred) = yī bǎi."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_num, 'Fill in: jīntiān is _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Jīntiān (jīn tiān) in Chinese means _____ today.","answer":"today","hints":["this day"],"explanation":"Jīntiān means today in Chinese."}'),
  5, 10, 15, NOW());

-- Chinese HSK 1 Lesson 4: Family & People - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_family, 'What does bàba mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does bàba (爸爸) mean?","options":["Mother","Father","Brother","Sister"],"correctIndex":1,"explanation":"爸爸 (bàba) means father or dad in Chinese."}'),
  1, 10, 15, NOW()),
(UUID(), @l_zh_family, 'Fill in: māma means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Māma (妈妈) in Chinese means _____ in English.","answer":"Mother","hints":["female parent"],"explanation":"妈妈 (māma) means mother or mom."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_family, 'Match family words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"哥哥","right":"Older brother"},{"left":"弟弟","right":"Younger brother"},{"left":"姐姐","right":"Older sister"},{"left":"妹妹","right":"Younger sister"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_family, 'What does péngyou mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does péngyou (朋友) mean?","options":["Family","Teacher","Friend","Student"],"correctIndex":2,"explanation":"朋友 (péngyou) means friend in Chinese."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_family, 'Fill in: lǎoshī means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Lǎoshī (老师) in Chinese means _____ in English.","answer":"Teacher","hints":["education"],"explanation":"老师 (lǎoshī) means teacher in Chinese."}'),
  5, 10, 15, NOW());

-- Chinese HSK 1 Lesson 5: Food & Drinks - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_food, 'What does mǐfàn mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does mǐfàn (米饭) mean?","options":["Noodles","Rice","Bread","Soup"],"correctIndex":1,"explanation":"米饭 (mǐfàn) means rice in Chinese."}'),
  1, 10, 15, NOW()),
(UUID(), @l_zh_food, 'Fill in: shuǐ means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Shuǐ (水) in Chinese means _____ in English.","answer":"Water","hints":["drink"],"explanation":"水 (shuǐ) means water in Chinese."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_food, 'Match food words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"米饭","right":"Rice"},{"left":"面条","right":"Noodles"},{"left":"苹果","right":"Apple"},{"left":"咖啡","right":"Coffee"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_food, 'What does chī mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does chī (吃) mean in Chinese?","options":["Drink","Eat","Buy","Sleep"],"correctIndex":1,"explanation":"吃 (chī) means to eat in Chinese."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_food, 'Fill in: hē means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Hē (喝) in Chinese means _____ in English.","answer":"Drink","hints":["consume"],"explanation":"喝 (hē) means to drink in Chinese."}'),
  5, 10, 15, NOW());

-- Chinese HSK 2 Lesson 1: HSK 2 Grammar - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_gram2, 'How to say have?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say I have a dog in Chinese?","options":["Wo yǒu yī zhī gǒu","Wo chī yī zhī gǒu","Wo shì yī zhī gǒu","Wo zài yī zhī gǒu"],"correctIndex":0,"explanation":"有 (yǒu) means to have. Wo yǒu yī zhī gǒu = I have a dog."}'),
  1, 10, 20, NOW()),
(UUID(), @l_zh_gram2, 'Fill in: Wo _____ kāfēi', 'FILL_IN_BLANK',
  CONCAT('{"question":"Wo _____ kāfēi. I want to drink coffee. (want)","answer":"xiǎng hē","hints":["want to drink"],"explanation":"想喝 means want to drink. Wo xiǎng hē kāfēi = I want to drink coffee."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_gram2, 'Match grammar patterns', 'MATCHING',
  CONCAT('{"pairs":[{"left":"有 (yǒu)","right":"Have"},{"left":"想 (xiǎng)","right":"Want"},{"left":"会 (huì)","right":"Can/Will"},{"left":"能 (néng)","right":"Able to"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_gram2, 'What does méi yǒu mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does méi yǒu (没有) mean?","options":["Have","Do not have","May have","Must have"],"correctIndex":1,"explanation":"没 (méi) = not, 有 (yǒu) = have. 没有 = do not have."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_gram2, 'Fill in: Tā _____ kāfēi', 'FILL_IN_BLANK',
  CONCAT('{"question":"Tā _____ kāfēi. He does not want coffee. (not want)","answer":"bù xiǎng hē","hints":["don't want"],"explanation":"不想要 = bù xiǎng yào. Tā bù xiǎng hē kāfēi = He does not want coffee."}'),
  5, 10, 15, NOW());

-- Chinese HSK 2 Lesson 2: Shopping & Prices - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_shop, 'How to ask price?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you ask How much is this? in Chinese?","options":["Zhè shì shénme?","Zhège duōshao qián?","Zhège hěn hǎo","Zhège yībān"],"correctIndex":1,"explanation":"多少钱 (duōshao qián) means how much money. Zhège duōshao qián? = How much is this?"}'),
  1, 10, 20, NOW()),
(UUID(), @l_zh_shop, 'Fill in: piányi means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Piányi (便宜) in Chinese means _____ in English.","answer":"Cheap","hints":["low price"],"explanation":"便宜 (piányi) means cheap or inexpensive."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_shop, 'Match shopping words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"便宜","right":"Cheap"},{"left":"贵","right":"Expensive"},{"left":"买","right":"Buy"},{"left":"卖","right":"Sell"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_shop, 'What does mǎi mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does mǎi (买) mean in Chinese?","options":["Sell","Buy","Price","Money"],"correctIndex":1,"explanation":"买 (mǎi) means to buy in Chinese."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_shop, 'Fill in: guì means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Guì (贵) in Chinese means _____ in English.","answer":"Expensive","hints":["high price"],"explanation":"贵 (guì) means expensive or noble."}'),
  5, 10, 15, NOW());

-- Chinese HSK 2 Lesson 3: Asking Directions - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_dir, 'How to ask where?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you ask Where is the bank? in Chinese?","options":["Yínháng zài nǎlǐ?","Yínháng zài duōshao?","Yínháng hěn yuǎn","Yínháng hěn jìn"],"correctIndex":0,"explanation":"在哪里 (zài nǎlǐ) means where is it. Yínháng zài nǎlǐ? = Where is the bank?"}'),
  1, 10, 20, NOW()),
(UUID(), @l_zh_dir, 'Fill in: zuǒ means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Zuǒ (左) in Chinese means _____ in English.","answer":"Left","hints":["direction"],"explanation":"左 (zuǒ) means left in Chinese."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_dir, 'Match direction words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"左","right":"Left"},{"left":"右","right":"Right"},{"left":"前","right":"Front"},{"left":"后","right":"Back"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_dir, 'What does yuǎn mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does yuǎn (远) mean in Chinese?","options":["Near","Far","Left","Right"],"correctIndex":1,"explanation":"远 (yuǎn) means far or distant in Chinese."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_dir, 'Fill in: jìn means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Jìn (近) in Chinese means _____ in English.","answer":"Near","hints":["close"],"explanation":"近 (jìn) means near or close in Chinese."}'),
  5, 10, 15, NOW());

-- Chinese HSK 2 Lesson 4: Daily Activities - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_daily, 'How to say I go to work?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say I go to work every day in Chinese?","options":["Wo qù xuéxiào","Wo qù shàngbān","Wo huí jiā","Wo shuìjiào"],"correctIndex":1,"explanation":"去上班 (qù shàngbān) means go to work. Wo měitiān qù shàngbān = I go to work every day."}'),
  1, 10, 20, NOW()),
(UUID(), @l_zh_daily, 'Fill in: zuò means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Zuò (做) in Chinese means _____ in English.","answer":"Do/Make","hints":["action"],"explanation":"做 (zuò) means to do or to make in Chinese."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_daily, 'Match daily activities', 'MATCHING',
  CONCAT('{"pairs":[{"left":"起床","right":"Wake up"},{"left":"睡觉","right":"Sleep"},{"left":"吃饭","right":"Eat"},{"left":"工作","right":"Work"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_daily, 'What does shuìjiào mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does shuìjiào (睡觉) mean in Chinese?","options":["Wake up","Sleep","Work","Eat"],"correctIndex":1,"explanation":"睡觉 (shuìjiào) means to sleep in Chinese."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_daily, 'Fill in: chīfàn means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Chīfàn (吃饭) in Chinese means _____ in English.","answer":"Eat","hints":["consume food"],"explanation":"吃饭 literally means eat rice/meal."}'),
  5, 10, 15, NOW());

-- Chinese HSK 2 Lesson 5: HSK 2 Vocabulary - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_vocab2, 'What does yǐjīng mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does yǐjīng (已经) mean?","options":["Still","Already","Not yet","Always"],"correctIndex":1,"explanation":"已经 (yǐjīng) means already in Chinese."}'),
  1, 10, 15, NOW()),
(UUID(), @l_zh_vocab2, 'Fill in: zhème means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Zhème (这么) in Chinese means _____ in English.","answer":"So/This way","hints":["degree"],"explanation":"这么 (zhème) means so or this way, used for degree."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_vocab2, 'Match HSK 2 words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"经常","right":"Often"},{"left":"有时候","right":"Sometimes"},{"left":"然后","right":"Then"},{"left":"因为","right":"Because"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_vocab2, 'What does suǒyǐ mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does suǒyǐ (所以) mean?","options":["Because","Therefore/So","But","Or"],"correctIndex":1,"explanation":"所以 (suǒyǐ) means therefore or so in Chinese."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_vocab2, 'Fill in: ránhòu means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Ránhòu (然后) in Chinese means _____ in English.","answer":"Then","hints":["after"],"explanation":"然后 (ránhòu) means then or after that in Chinese."}'),
  5, 10, 15, NOW());

-- Chinese HSK 3 Lesson 1: HSK 3 Grammar - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_gram3, 'What does bǎ construction mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"In Wo bǎ shū fàng zài zhuōzi shàng, what does bǎ indicate?","options":["Topic","Object moved","Action","Location"],"correctIndex":1,"explanation":"Bǎ construction is used to move the object to a new location."}'),
  1, 10, 25, NOW()),
(UUID(), @l_zh_gram3, 'Fill in: bèi means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"The passive voice construction with bèi (被) in Chinese means _____ in English.","answer":"Passive voice","hints":["receive action"],"explanation":"被 construction indicates passive voice: the subject receives the action."}'),
  2, 10, 20, NOW()),
(UUID(), @l_zh_gram3, 'Match grammar patterns', 'MATCHING',
  CONCAT('{"pairs":[{"left":"把...放在...","right":"Put...on..."},{"left":"被...动词","right":"Be done by..."},{"left":"除了...以外","right":"Besides..."},{"left":"如果...的话","right":"If..."}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_gram3, 'What does suīrán...dànshi mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does suīrán...dànshi (虽然...但是) mean?","options":["Because...so","Although...but","If...then","Either...or"],"correctIndex":1,"explanation":"虽然...但是 means although...but/however."}'),
  4, 10, 20, NOW()),
(UUID(), @l_zh_gram3, 'Fill in: jiǎrú means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Jiǎrú (假如) in Chinese means _____ in English.","answer":"If/Suppose","hints":["condition"],"explanation":"假如 (jiǎrú) means if or suppose in Chinese."}'),
  5, 10, 15, NOW());

-- Chinese HSK 3 Lesson 2: HSK 3 Vocabulary - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_vocab3, 'What does zhìshǎo mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does zhìshǎo (至少) mean?","options":["At most","At least","Exactly","About"],"correctIndex":1,"explanation":"至少 (zhìshǎo) means at least or at minimum."}'),
  1, 10, 15, NOW()),
(UUID(), @l_zh_vocab3, 'Fill in: gēnggǎi means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Gēnggǎi (更改) in Chinese means _____ in English.","answer":"Change/Modify","hints":["alter"],"explanation":"更改 (gēnggǎi) means to change or modify."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_vocab3, 'Match HSK 3 vocabulary', 'MATCHING',
  CONCAT('{"pairs":[{"left":"包括","right":"Include"},{"left":"否则","right":"Otherwise"},{"left":"实际","right":"Actual/Real"},{"left":"自从","right":"Since"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_vocab3, 'What does yǐhòu mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does yǐhòu (以后) mean in Chinese?","options":["Before","After","During","Now"],"correctIndex":1,"explanation":"以后 (yǐhòu) means after or in the future."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_vocab3, 'Fill in: cǐwài means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Cǐwài (此外) in Chinese means _____ in English.","answer":"Besides/Moreover","hints":["additionally"],"explanation":"此外 (cǐwài) means besides or moreover."}'),
  5, 10, 15, NOW());

-- Chinese HSK 3 Lesson 3: Travel in China - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_travel, 'How to book a hotel?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say I want to book a room in Chinese?","options":["Wo yào zhǎo fángjiān","Wo yào dìng fángjiān","Wo yào mǎi fángjiān","Wo yào mài fángjiān"],"correctIndex":1,"explanation":"订房间 (dìng fángjiān) means to book a room."}'),
  1, 10, 20, NOW()),
(UUID(), @l_zh_travel, 'Fill in: rùzhù means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Rùzhù (入住) in Chinese means _____ in English.","answer":"Check in","hints":["enter to stay"],"explanation":"入住 (rùzhù) means to check in to a hotel."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_travel, 'Match travel words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"订房间","right":"Book a room"},{"left":"退房","right":"Check out"},{"left":"入住","right":"Check in"},{"left":"前台","right":"Reception"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_travel, 'What does tuìfáng mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does tuìfáng (退房) mean in Chinese?","options":["Check in","Check out","Book room","Stay"],"correctIndex":1,"explanation":"退房 (tuìfáng) means to check out from a hotel."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_travel, 'Fill in: qiántái means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Qiántái (前台) in Chinese means _____ in English.","answer":"Reception/Front desk","hints":["lobby"],"explanation":"前台 (qiántái) means reception or front desk."}'),
  5, 10, 15, NOW());

-- Chinese HSK 3 Lesson 4: Chinese Reading - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_read, 'Reading: Main idea?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"In Chinese reading comprehension, what should you identify first?","options":["Every character","Main idea of the passage","New vocabulary","Grammar points"],"correctIndex":1,"explanation":"Identifying the main idea is the first step in reading comprehension."}'),
  1, 10, 20, NOW()),
(UUID(), @l_zh_read, 'Fill in: zhǔyào means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Zhǔyào (主要) in Chinese means _____ in English.","answer":"Main/Primary","hints":["most important"],"explanation":"主要 (zhǔyào) means main or primary."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_read, 'Match reading words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"主要","right":"Main"},{"left":"内容","right":"Content"},{"left":"主题","right":"Theme"},{"left":"段落","right":"Paragraph"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_read, 'What does jìnlù mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does jìnlù (进路) mean in Chinese reading context?","options":["Progress","Entrance","Path/Avenue","Chapter"],"correctIndex":2,"explanation":"进路 (jìnlù) means path or avenue in a reading context."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_read, 'Fill in: nèiróng means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Nèiróng (内容) in Chinese means _____ in English.","answer":"Content","hints":["subject matter"],"explanation":"内容 (nèiróng) means content or subject matter."}'),
  5, 10, 15, NOW());

-- Chinese HSK 3 Lesson 5: Expressing Opinions - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_opin, 'How to express opinion?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say I think in Chinese?","options":["Wo juéde","Wo juéwàng","Wo juédìng","Wo rènwéi"],"correctIndex":0,"explanation":"觉得 (juéde) means to think or feel. Wo juéde = I think."}'),
  1, 10, 20, NOW()),
(UUID(), @l_zh_opin, 'Fill in: wǒ rènwéi means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Wǒ rènwéi (我认为) in Chinese means _____ in English.","answer":"I think/believe","hints":["opinion"],"explanation":"认为 (rènwéi) means to think or believe, more formal than 觉得."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_opin, 'Match opinion expressions', 'MATCHING',
  CONCAT('{"pairs":[{"left":"我觉得","right":"I think"},{"left":"我认为","right":"I believe"},{"left":"据我所知","right":"As far as I know"},{"left":"一般来说","right":"Generally speaking"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_opin, 'What does jùtǐ mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does jùtǐ (具体) mean?","options":["Abstract","Specific","General","Vague"],"correctIndex":1,"explanation":"具体 (jùtǐ) means concrete or specific."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_opin, 'Fill in: fǎnduì means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Fǎnduì (反对) in Chinese means _____ in English.","answer":"Oppose/Against","hints":["disagree"],"explanation":"反对 (fǎnduì) means to oppose or be against."}'),
  5, 10, 15, NOW());

-- Chinese Conversation Lesson 1: Casual Conversations - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_casual, 'Casual way to say hi?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Which is a casual way to say hi in Chinese?","options":["Nǐ hǎo (formal)","Hǎiya / Hi","Zàijiàn (formal)","Qǐng wèn"],"correctIndex":1,"explanation":"Hi / Hǎiya is a casual transliteration of hello used among young people."}'),
  1, 10, 15, NOW()),
(UUID(), @l_zh_casual, 'Fill in: gēn means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Gēn (跟) in Chinese means _____ in English.","answer":"With/Follow","hints":["together"],"explanation":"跟 (gēn) means with or follow."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_casual, 'Match casual expressions', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Hi / 嗨","right":"Hey (casual)"},{"left":"咋了","right":"What is up"},{"left":"没事儿","right":"No problem"},{"left":"行吧","right":"Okay then"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_casual, 'What does zěnme mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does zěnme (怎么) mean in Chinese?","options":["What","Why","How","Where"],"correctIndex":2,"explanation":"怎么 (zěnme) means how or why."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_casual, 'Fill in: zěnmeyàng means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Zěnmeyàng (怎么样) in Chinese means _____ in English.","answer":"How about/How is it","hints":["opinion"],"explanation":"怎么样 (zěnmeyàng) means how about or how is it (asking for opinion)."}'),
  5, 10, 15, NOW());

-- Chinese Conversation Lesson 2: Making Phone Calls - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_phone, 'Answer phone casually?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you answer the phone casually in Chinese?","options":["Qǐng wèn","Wéi","Nín hǎo","Zàijiàn"],"correctIndex":1,"explanation":"喂 (wéi) is the common phone greeting in Chinese."}'),
  1, 10, 15, NOW()),
(UUID(), @l_zh_phone, 'Fill in: dǎ diànhuà means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Dǎ diànhuà (打电话) in Chinese means _____ in English.","answer":"Make a phone call","hints":["call"],"explanation":"打电话 (dǎ diànhuà) means to make a phone call."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_phone, 'Match phone expressions', 'MATCHING',
  CONCAT('{"pairs":[{"left":"喂","right":"Hello (phone)"},{"left":"打电话","right":"Make a call"},{"left":"接电话","right":"Answer the phone"},{"left":"挂电话","right":"Hang up"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_phone, 'What does jiē diànhuà mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does jiē diànhuà (接电话) mean?","options":["Make a call","Answer the phone","Hang up","Miss a call"],"correctIndex":1,"explanation":"接电话 (jiē diànhuà) means to answer the phone."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_phone, 'Fill in: guà diànhuà means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Guà diànhuà (挂电话) in Chinese means _____ in English.","answer":"Hang up","hints":["end call"],"explanation":"挂电话 (guà diànhuà) means to hang up the phone."}'),
  5, 10, 15, NOW());

-- Chinese Conversation Lesson 3: Chinese Social Media - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_social, 'What does fā wēibó mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does fā wēibó (发微博) mean?","options":["Read Weibo","Post on Weibo","Delete Weibo","Like Weibo"],"correctIndex":1,"explanation":"发微博 (fā wēibó) means to post on Weibo (Chinese social media)."}'),
  1, 10, 15, NOW()),
(UUID(), @l_zh_social, 'Fill in: pīn means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Pīn (拼) in Chinese internet language means _____ (combining effort).","answer":"Collaborate/Team up","hints":["combine"],"explanation":"拼 (pīn) means to combine or team up in internet slang."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_social, 'Match social media terms', 'MATCHING',
  CONCAT('{"pairs":[{"left":"发微博","right":"Post on Weibo"},{"left":"点赞","right":"Like"},{"left":"转发","right":"Repost"},{"left":"评论","right":"Comment"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_social, 'What does diǎn zàn mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does diǎn zàn (点赞) mean in Chinese internet language?","options":["Unlike","Share","Like","Bookmark"],"correctIndex":2,"explanation":"点赞 (diǎn zàn) means to give a thumbs up or like a post."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_social, 'Fill in: pínglùn means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Pínglùn (评论) in Chinese social media context means _____ in English.","answer":"Comment","hints":["response"],"explanation":"评论 (pínglùn) means to comment or a comment."}'),
  5, 10, 15, NOW());

-- Chinese Conversation Lesson 4: Weather & Seasons - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_weather, 'What does tiānqí hěn rè mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does tiānqí hěn rè (天气很热) mean?","options":["Weather is cold","Weather is hot","Weather is nice","Weather is bad"],"correctIndex":1,"explanation":"天气很热 = the weather is very hot."}'),
  1, 10, 15, NOW()),
(UUID(), @l_zh_weather, 'Fill in: xiàjì means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Xiàjì (夏天) in Chinese means _____ in English.","answer":"Summer","hints":["hot season"],"explanation":"夏天 (xiàjì) means summer."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_weather, 'Match weather words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"春天","right":"Spring"},{"left":"夏天","right":"Summer"},{"left":"秋天","right":"Autumn"},{"left":"冬天","right":"Winter"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_weather, 'What does xià xuě mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does xià xuě (下雪) mean in Chinese?","options":["Heavy snow","Snowing","Snowman","Snowflake"],"correctIndex":1,"explanation":"下雪 (xià xuě) means to snow or it is snowing."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_weather, 'Fill in: jìnié means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Jìnié (季节) in Chinese means _____ in English.","answer":"Season","hints":["time of year"],"explanation":"季节 (jìnié) means season."}'),
  5, 10, 15, NOW());

-- Chinese Conversation Lesson 5: Expressing Emotions - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_emo, 'How to say I am happy?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say I am very happy in Chinese?","options":["Wo hěn shāngxīn","Wo hěn kāixīn","Wo hěn hàipà","Wo hěn nánguò"],"correctIndex":1,"explanation":"很开心 (hěn kāixīn) = very happy. 开心 = happy."}'),
  1, 10, 15, NOW()),
(UUID(), @l_zh_emo, 'Fill in: kāixīn means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Kāixīn (开心) in Chinese means _____ in English.","answer":"Happy","hints":["good mood"],"explanation":"开心 (kāixīn) means happy or cheerful."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_emo, 'Match emotion words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"开心","right":"Happy"},{"left":"难过","right":"Sad"},{"left":"生气","right":"Angry"},{"left":"害怕","right":"Scared"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_emo, 'What does shāngxīn mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does shāngxīn (伤心) mean in Chinese?","options":["Happy","Sad","Angry","Tired"],"correctIndex":1,"explanation":"伤心 (shāngxīn) means sad or heartbroken."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_emo, 'Fill in: jǐnzhāng means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Jǐnzhāng (紧张) in Chinese means _____ in English.","answer":"Nervous","hints":["tense"],"explanation":"紧张 (jǐnzhāng) means nervous or tense."}'),
  5, 10, 15, NOW());

-- Chinese Business Lesson 1: Business Chinese Basics - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_busbase, 'How to greet in business?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What is the appropriate business greeting in Chinese?","options":["Nǐ hǎo (casual)","Nín hǎo (polite)","Zàijiàn","Xièxie"],"correctIndex":1,"explanation":"您 (nín) is the polite form of 你 (nǐ). 您好吗 is a polite business greeting."}'),
  1, 10, 20, NOW()),
(UUID(), @l_zh_busbase, 'Fill in: tuánduì means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Tuánduì (团队) in Chinese means _____ in English.","answer":"Team","hints":["group"],"explanation":"团队 (tuánduì) means team or group in a business context."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_busbase, 'Match business words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"公司","right":"Company"},{"left":"同事","right":"Colleague"},{"left":"客户","right":"Client"},{"left":"经理","right":"Manager"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_busbase, 'What does qǐyè mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does qǐyè (企业) mean?","options":["Enterprise/Company","Product","Market","Customer"],"correctIndex":0,"explanation":"企业 (qǐyè) means enterprise or company in business context."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_busbase, 'Fill in: hézuò means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Hézuò (合作) in Chinese business context means _____ in English.","answer":"Cooperation/Collaboration","hints":["work together"],"explanation":"合作 (hézuò) means to cooperate or collaborate."}'),
  5, 10, 15, NOW());

-- Chinese Business Lesson 2: Business Meetings - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_meet, 'How to start a meeting?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say Let us begin the meeting in Chinese?","options":["Kāishǐ yǐhòu","Kāishǐ huìyì","Jìnlù huìyì","Kāi huì ba"],"correctIndex":1,"explanation":"开始会议 (kāishǐ huìyì) means to start/begin a meeting."}'),
  1, 10, 20, NOW()),
(UUID(), @l_zh_meet, 'Fill in: yìchéng means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Yìchéng (议程) in Chinese business context means _____ in English.","answer":"Agenda","hints":["meeting schedule"],"explanation":"议程 (yìchéng) means agenda or meeting schedule."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_meet, 'Match meeting words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"议程","right":"Agenda"},{"left":"会议","right":"Meeting"},{"left":"主持人","right":"Host/Chairperson"},{"left":"投票","right":"Vote"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_meet, 'What does juéshì mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does juéshì (决议) mean in business Chinese?","options":["Discussion","Resolution/Decision","Report","Presentation"],"correctIndex":1,"explanation":"决议 (juéshì) means resolution or decision made in a meeting."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_meet, 'Fill in: jìnlù means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Jìnlù (纪略) in Chinese business context means _____ in English.","answer":"Minutes (of meeting)","hints":["record"],"explanation":"纪略 (jìnlù) means minutes of a meeting."}'),
  5, 10, 15, NOW());

-- Chinese Business Lesson 3: Business Email Writing - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_email, 'How to start business email?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you start a formal business email in Chinese?","options":["Nǐ hǎo","Zhìxīn de kèhù","Duìbuqǐ","Xièxie"],"correctIndex":1,"explanation":"尊敬的客户 (zūnjìng de kèhù) means Dear valued customer."}'),
  1, 10, 20, NOW()),
(UUID(), @l_zh_email, 'Fill in: fùjiàn means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Fùjiàn (附件) in Chinese email context means _____ in English.","answer":"Attachment","hints":["file"],"explanation":"附件 (fùjiàn) means attachment in an email."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_email, 'Match email words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"附件","right":"Attachment"},{"left":"主题","right":"Subject"},{"left":"抄送","right":"CC"},{"left":"收件人","right":"Recipient"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_email, 'What does zhǔtí mean in email?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does zhǔtí (主题) mean in a Chinese email?","options":["Attachment","Subject","Body","Signature"],"correctIndex":1,"explanation":"主题 (zhǔtí) means subject or theme of the email."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_email, 'Fill in: chāosòng means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Chāosòng (抄送) in Chinese email means _____ in English.","answer":"CC","hints":["carbon copy"],"explanation":"抄送 (chāosòng) means to CC someone in an email."}'),
  5, 10, 15, NOW());

-- Chinese Business Lesson 4: Negotiation Language - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_neg, 'How to make an offer?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say What is your offer? in Chinese business?","options":["Nǐ de jiàgé shì shénme?","Nǐmen yǒu shénme yāoqiú?","Wǒmen kěyǐ hésuàn","Zhège hěn guì"],"correctIndex":0,"explanation":"Your price/what is your price? 是 business negotiation language."}'),
  1, 10, 20, NOW()),
(UUID(), @l_zh_neg, 'Fill in: tǎolùn means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Tǎolùn (讨论) in Chinese means _____ in English.","answer":"Discuss/Negotiate","hints":["talk over"],"explanation":"讨论 (tǎolùn) means to discuss or negotiate."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_neg, 'Match negotiation words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"报价","right":"Quotation/Offer"},{"left":"折扣","right":"Discount"},{"left":"谈判","right":"Negotiate"},{"left":"合同","right":"Contract"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_neg, 'What does hétóng mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does hétóng (合同) mean in Chinese business?","options":["Price","Contract","Meeting","Decision"],"correctIndex":1,"explanation":"合同 (hétóng) means contract or agreement."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_neg, 'Fill in: zhékoù means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Zhékòu (折扣) in Chinese means _____ in English.","answer":"Discount","hints":["reduction"],"explanation":"折扣 (zhékòu) means discount or rebate."}'),
  5, 10, 15, NOW());

-- Chinese Business Lesson 5: Chinese Business Culture - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_zh_culture, 'Business card exchange?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"In Chinese business culture, how should you give and receive business cards?","options":["With one hand随便","With both hands respectfully","Throw them on the table","Keep them in your pocket"],"correctIndex":1,"explanation":"Always give and receive business cards with both hands as a sign of respect."}'),
  1, 10, 20, NOW()),
(UUID(), @l_zh_culture, 'Fill in: gèrén means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Gèrén (个人) in Chinese means _____ in English.","answer":"Individual/Personal","hints":["person"],"explanation":"个人 (gèrén) means individual or personal."}'),
  2, 10, 15, NOW()),
(UUID(), @l_zh_culture, 'Match culture words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"关系","right":"Guanxi/Relationship"},{"left":"面子","right":"Face"},{"left":"礼仪","right":"Etiquette"},{"left":"人情","right":"Human feelings"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_zh_culture, 'What does guānxi mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does guānxi (关系) mean in Chinese business culture?","options":["Position","Relationship/Connection","Money","Contract"],"correctIndex":1,"explanation":"关系 (guānxi) means relationship or connection, very important in Chinese business culture."}'),
  4, 10, 15, NOW()),
(UUID(), @l_zh_culture, 'Fill in: lǐmào means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Lǐmào (礼貌) in Chinese means _____ in English.","answer":"Politeness/Etiquette","hints":["manners"],"explanation":"礼貌 (lǐmào) means politeness or good manners."}'),
  5, 10, 15, NOW());

-- Get French lesson IDs
SET @l_fr_sal    = (SELECT id FROM lessons WHERE title = 'Les Salutations' LIMIT 1);
SET @l_fr_pres   = (SELECT id FROM lessons WHERE title = 'Se presenter' LIMIT 1);
SET @l_fr_nombre = (SELECT id FROM lessons WHERE title = 'Les Nombres' LIMIT 1);
SET @l_fr_famille= (SELECT id FROM lessons WHERE title = 'La Famille' LIMIT 1);
SET @l_fr_jours  = (SELECT id FROM lessons WHERE title = 'Les Jours et Mois' LIMIT 1);
SET @l_fr_vet    = (SELECT id FROM lessons WHERE title = 'Les Vetements' LIMIT 1);
SET @l_fr_rest   = (SELECT id FROM lessons WHERE title = 'Au Restaurant' LIMIT 1);
SET @l_fr_passe = (SELECT id FROM lessons WHERE title = 'Le Passe Compose' LIMIT 1);
SET @l_fr_trans = (SELECT id FROM lessons WHERE title = 'Les Transports' LIMIT 1);
SET @l_fr_vac   = (SELECT id FROM lessons WHERE title = 'Les Vacances' LIMIT 1);
SET @l_fr_impar = (SELECT id FROM lessons WHERE title = 'L Imparfait' LIMIT 1);
SET @l_fr_opin  = (SELECT id FROM lessons WHERE title = 'Exprimer son Opinion' LIMIT 1);
SET @l_fr_subj  = (SELECT id FROM lessons WHERE title = 'Le Subjonctif Present' LIMIT 1);
SET @l_fr_presse= (SELECT id FROM lessons WHERE title = 'La Presse Francaise' LIMIT 1);
SET @l_fr_relat = (SELECT id FROM lessons WHERE title = 'Les Relations Sociales' LIMIT 1);
SET @l_fr_cond  = (SELECT id FROM lessons WHERE title = 'Le Conditionnel Present' LIMIT 1);
SET @l_fr_disc  = (SELECT id FROM lessons WHERE title = 'Le Discours Rapporte' LIMIT 1);
SET @l_fr_litt  = (SELECT id FROM lessons WHERE title = 'Redaction Litteraire' LIMIT 1);
SET @l_fr_idiom = (SELECT id FROM lessons WHERE title = 'Expressions Idiomatiques' LIMIT 1);
SET @l_fr_debat = (SELECT id FROM lessons WHERE title = 'Debat et Argumentation' LIMIT 1);
SET @l_fr_aero  = (SELECT id FROM lessons WHERE title = 'A l Aeroport' LIMIT 1);
SET @l_fr_hotel = (SELECT id FROM lessons WHERE title = 'A l Hotel' LIMIT 1);
SET @l_fr_ville = (SELECT id FROM lessons WHERE title = 'En Ville' LIMIT 1);
SET @l_fr_achats= (SELECT id FROM lessons WHERE title = 'Les Achats' LIMIT 1);
SET @l_fr_urg   = (SELECT id FROM lessons WHERE title = 'Les Urgences' LIMIT 1);

-- French A1 Lesson 1: Les Salutations - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_fr_sal, 'How do you say goodbye?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say goodbye in French?","options":["Bonjour","Au revoir","Merci","Salut"],"correctIndex":1,"explanation":"Au revoir means goodbye in French."}'),
  1, 10, 15, NOW()),
(UUID(), @l_fr_sal, 'Fill in: Merci _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Merci _____ means thank you very much. (beaucoup)","answer":"beaucoup","hints":["very much"],"explanation":"Merci beaucoup means thank you very much."}'),
  2, 10, 15, NOW()),
(UUID(), @l_fr_sal, 'Match greetings', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Bonjour","right":"Hello/Good day"},{"left":"Bonsoir","right":"Good evening"},{"left":"Au revoir","right":"Goodbye"},{"left":"A bientot","right":"See you soon"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_fr_sal, 'What does salut mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Salut can mean:","options":["Good morning","Hi/Bye (informal)","Thank you","Please"],"correctIndex":1,"explanation":"Salut is an informal greeting and goodbye in French."}'),
  4, 10, 15, NOW()),
(UUID(), @l_fr_sal, 'Fill in: _____ beaucoup', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ beaucoup means thank you very much.","answer":"Merci","hints":["polite"],"explanation":"Merci beaucoup = thank you very much."}'),
  5, 10, 15, NOW());

-- French A1 Lesson 2: Se presenter - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_fr_pres, 'How to say my name is?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say my name is Marie in French?","options":["Je suis Marie","Je mappelle Marie","Je ai Marie","Je est Marie"],"correctIndex":1,"explanation":"Je mappelle Marie = My name is Marie."}'),
  1, 10, 20, NOW()),
(UUID(), @l_fr_pres, 'Fill in: Je _____ Marie', 'FILL_IN_BLANK',
  CONCAT('{"question":"Je _____ Marie. My name is Marie. (sappelle)","answer":"mappelle","hints":["name"],"explanation":"Je mappelle Marie = My name is Marie."}'),
  2, 10, 15, NOW()),
(UUID(), @l_fr_pres, 'Match introduction phrases', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Je mappelle","right":"My name is"},{"left":"Jai ans","right":"I am ... years old"},{"left":"Je viens de","right":"I come from"},{"left":"Jhabite a","right":"I live in"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_fr_pres, 'What does Enchanté mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Enchanté means:","options":["Goodbye","Nice to meet you","Thank you","Excuse me"],"correctIndex":1,"explanation":"Enchanté = Nice to meet you."}'),
  4, 10, 15, NOW()),
(UUID(), @l_fr_pres, 'Fill in: Jai _____ ans', 'FILL_IN_BLANK',
  CONCAT('{"question":"Jai _____ ans. I am 25 years old. (number)","answer":"vingt-cinq","hints":["25"],"explanation":"Jai vingt-cinq ans = I am 25 years old."}'),
  5, 10, 15, NOW());

-- French A1 Lesson 3: Les Nombres - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_fr_nombre, 'What is 3 in French?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What is 3 in French?","options":["Un","Deux","Trois","Quatre"],"correctIndex":2,"explanation":"Trois = 3 in French."}'),
  1, 10, 15, NOW()),
(UUID(), @l_fr_nombre, 'Fill in: Dix-sept = _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Dix-sept (17) in French means _____ in English.","answer":"Seventeen","hints":["10+7"],"explanation":"Dix (10) + sept (7) = 17 = dix-sept."}'),
  2, 10, 15, NOW()),
(UUID(), @l_fr_nombre, 'Match numbers to words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Un","right":"1"},{"left":"Cinq","right":"5"},{"left":"Dix","right":"10"},{"left":"Vingt","right":"20"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_fr_nombre, 'What is 70 in French?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What is 70 in French?","options":["Soixante-dix","Quatre-vingt-dix","Quatre-vingts","Septante"],"correctIndex":0,"explanation":"In French: 60+10 = 70 = soixante-dix."}'),
  4, 10, 20, NOW()),
(UUID(), @l_fr_nombre, 'Fill in: Mille = _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Mille (1000) in French means _____ in English.","answer":"Thousand","hints":["1000"],"explanation":"Mille = 1000 = thousand in French."}'),
  5, 10, 15, NOW());

-- French A1 Lesson 4: La Famille - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_fr_famille, 'What does pere mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does pere mean in French?","options":["Mother","Father","Brother","Sister"],"correctIndex":1,"explanation":"Pere = father in French."}'),
  1, 10, 15, NOW()),
(UUID(), @l_fr_famille, 'Fill in: Mere = _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Mere (mere) in French means _____ in English.","answer":"Mother","hints":["female parent"],"explanation":"Mere = mother in French."}'),
  2, 10, 15, NOW()),
(UUID(), @l_fr_famille, 'Match family words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Le pere","right":"Father"},{"left":"La mere","right":"Mother"},{"left":"Le frere","right":"Brother"},{"left":"La socur","right":"Sister"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_fr_famille, 'What does oncle mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does oncle mean in French?","options":["Nephew","Uncle","Aunt","Grandfather"],"correctIndex":1,"explanation":"Oncle = uncle in French."}'),
  4, 10, 15, NOW()),
(UUID(), @l_fr_famille, 'Fill in: _____ = grandfather', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ (grand-pere) in French means grandfather in English.","answer":"Grand-pere","hints":["grand"],"explanation":"Grand-pere = grandfather in French."}'),
  5, 10, 15, NOW());

-- French A1 Lesson 5: Les Jours et Mois - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_fr_jours, 'What day is today?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Quel jour sommes-nous? The answer: Nous sommes _____ (lundi).","options":["Mardi","Mercredi","Lundi","Jeudi"],"correctIndex":2,"explanation":"Lundi = Monday."}'),
  1, 10, 15, NOW()),
(UUID(), @l_fr_jours, 'Fill in: Janvier = _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Janvier (January) in French means _____ in English.","answer":"January","hints":["month 1"],"explanation":"Janvier = January."}'),
  2, 10, 15, NOW()),
(UUID(), @l_fr_jours, 'Match days', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Lundi","right":"Monday"},{"left":"Mardi","right":"Tuesday"},{"left":"Mercredi","right":"Wednesday"},{"left":"Jeudi","right":"Thursday"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_fr_jours, 'What month is aout?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Aout (maius) is which month in French?","options":["May","June","July","August"],"correctIndex":3,"explanation":"Aout = August."}'),
  4, 10, 15, NOW()),
(UUID(), @l_fr_jours, 'Fill in: Decembre = _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Decembre (December) in French means _____ in English.","answer":"December","hints":["month 12"],"explanation":"Decembre = December."}'),
  5, 10, 15, NOW());

-- French A2 Lesson 1: Les Vetements - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_fr_vet, 'What does vetements mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Vetements (clothing) includes:","options":["Food","Clothes","Cars","Books"],"correctIndex":1,"explanation":"Vetements means clothes or clothing in French."}'),
  1, 10, 15, NOW()),
(UUID(), @l_fr_vet, 'Fill in: Une robe = _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Une robe (a dress) in French means _____ in English.","answer":"A dress","hints":["clothing"],"explanation":"Une robe = a dress."}'),
  2, 10, 15, NOW()),
(UUID(), @l_fr_vet, 'Match clothing words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Une robe","right":"Dress"},{"left":"Une jupe","right":"Skirt"},{"left":"Un chemise","right":"Shirt"},{"left":"Un pantalons","right":"Pants"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_fr_vet, 'What does porter mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does porter (to wear) mean?","options":["To buy","To sell","To wear","To wash"],"correctIndex":2,"explanation":"Porter means to wear in French."}'),
  4, 10, 15, NOW()),
(UUID(), @l_fr_vet, 'Fill in: _____ = shoes', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ (chaussures) in French means shoes in English.","answer":"Chaussures","hints":["footwear"],"explanation":"Des chaussures = shoes."}'),
  5, 10, 15, NOW());

-- French A2 Lesson 2: Au Restaurant - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_fr_rest, 'How to order food?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say I would like the menu in French?","options":["Je veux la carte","Je voudrais la carte","Donnez-moi la carte","La carte sil vous plait"],"correctIndex":1,"explanation":"Je voudrais la carte = I would like the menu."}'),
  1, 10, 20, NOW()),
(UUID(), @l_fr_rest, 'Fill in: Laddition _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Laddition _____ means the bill please. (s il vous plait)","answer":"s il vous plait","hints":["please"],"explanation":"Laddition, sil vous plait = The bill please."}'),
  2, 10, 15, NOW()),
(UUID(), @l_fr_rest, 'Match restaurant phrases', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Je voudrais","right":"I would like"},{"left":"Laddition","right":"The bill"},{"left":"Le serveur","right":"The waiter"},{"left":"Un pourboire","right":"A tip"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_fr_rest, 'What does entitle mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does entitle (the menu) mean?","options":["The food","The menu","The table","The bill"],"correctIndex":1,"explanation":"La carte = the menu in French."}'),
  4, 10, 15, NOW()),
(UUID(), @l_fr_rest, 'Fill in: _____ = appetizer', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ (une entree) in French means appetizer in English.","answer":"Une entree","hints":["starter"],"explanation":"Une entree = appetizer/starter in French."}'),
  5, 10, 15, NOW());

-- French A2 Lesson 3: Le Passe Compose - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_fr_passe, 'How to make passe compose?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say I ate (passé composé) in French?","options":["Je mange","Je ai mange","Je suis mange","Jai eu mange"],"correctIndex":1,"explanation":"Passé composé: avoir/être + past participle. Jai mange = I ate."}'),
  1, 10, 20, NOW()),
(UUID(), @l_fr_passe, 'Fill in: Elle _____ allee', 'FILL_IN_BLANK',
  CONCAT('{"question":"Elle _____ allee au cinema. She went to the cinema. (est)","answer":"est","hints":["être"],"explanation":"Aller uses être: Elle est allée = She went."}'),
  2, 10, 15, NOW()),
(UUID(), @l_fr_passe, 'Match verbs to past participle', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Parler","right":"Parlé"},{"left":"Finir","right":"Fini"},{"left":"Aller","right":"Allé"},{"left":"Faire","right":"Fait"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_fr_passe, 'Avoir or etre?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Which verb uses être for passé composé?","options":["Manger","Finir","Aller","Vendre"],"correctIndex":2,"explanation":"Aller uses être as auxiliary. Others use avoir."}'),
  4, 10, 15, NOW()),
(UUID(), @l_fr_passe, 'Fill in: Jai _____ le film', 'FILL_IN_BLANK',
  CONCAT('{"question":"Jai _____ le film. I watched the film. (regarder)","answer":"regarde","hints":["past participle"],"explanation":"Regarder → regardé. Jai regardé = I watched."}'),
  5, 10, 15, NOW());

-- French A2 Lesson 4: Les Transports - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_fr_trans, 'How to say by train?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say by train in French?","options":["En bus","En train","En voiture","En avion"],"correctIndex":1,"explanation":"En train = by train."}'),
  1, 10, 15, NOW()),
(UUID(), @l_fr_trans, 'Fill in: Lavion = _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Lavion (the plane) in French means _____ in English.","answer":"The airplane","hints":["vehicle"],"explanation":"Lavion = the airplane."}'),
  2, 10, 15, NOW()),
(UUID(), @l_fr_trans, 'Match transport words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Le train","right":"Train"},{"left":"Le bus","right":"Bus"},{"left":"Le metro","right":"Subway"},{"left":"Le taxi","right":"Taxi"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_fr_trans, 'What does aeroport mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Aeroport means:","options":["Airport","Bus station","Train station","Port"],"correctIndex":0,"explanation":"Aeroport = airport in French."}'),
  4, 10, 15, NOW()),
(UUID(), @l_fr_trans, 'Fill in: _____ = bicycle', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ (un velo) in French means bicycle in English.","answer":"Un velo","hints":["two wheels"],"explanation":"Un véo = a bicycle."}'),
  5, 10, 15, NOW());

-- French A2 Lesson 5: Les Vacances - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_fr_vac, 'How to say I am on vacation?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say I am on vacation in French?","options":["Je travaille","Je suis en vacances","Je suis a la maison","Je etudie"],"correctIndex":1,"explanation":"Je suis en vacances = I am on holiday/vacation."}'),
  1, 10, 20, NOW()),
(UUID(), @l_fr_vac, 'Fill in: Partir = _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Partir (to leave) in French means _____ in English.","answer":"To leave/To go","hints":["depart"],"explanation":"Partir = to leave or to go away."}'),
  2, 10, 15, NOW()),
(UUID(), @l_fr_vac, 'Match vacation words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Les vacances","right":"Holidays"},{"left":"Voyager","right":"To travel"},{"left":"La plage","right":"Beach"},{"left":"La montagne","right":"Mountain"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_fr_vac, 'What does plage mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Plage means:","options":["Mountain","Beach","City","Forest"],"correctIndex":1,"explanation":"La plage = the beach in French."}'),
  4, 10, 15, NOW()),
(UUID(), @l_fr_vac, 'Fill in: _____ = suitcase', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ (une valise) in French means suitcase in English.","answer":"Une valise","hints":["travel"],"explanation":"Une valise = a suitcase."}'),
  5, 10, 15, NOW());

-- French B1 Lesson 1: L Imparfait - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_fr_impar, 'When to use imparfait?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"When do you use imparfait in French?","options":["Completed actions","Past habits and descriptions","Future events","Present actions"],"correctIndex":1,"explanation":"Imparfait is used for past habits, ongoing states, and descriptions."}'),
  1, 10, 20, NOW()),
(UUID(), @l_fr_impar, 'Fill in: Nous _____ (etre) contents', 'FILL_IN_BLANK',
  CONCAT('{"question":"Nous _____ contents. We were happy. (etre imparfait)","answer":"etions","hints":["imparfait of etre"],"explanation":"Nous etions = we were (imparfait)."}'),
  2, 10, 15, NOW()),
(UUID(), @l_fr_impar, 'Match imparfait uses', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Decrire","right":"Imparfait"},{"left":"Habitude","right":"Imparfait"},{"left":"Action finie","right":"Passe compose"},{"left":"En cours","right":"Imparfait"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_fr_impar, 'Il faisait vs Il a fait?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Il _____ beau. (habit in past) Il etait means:","options":["Il a fait","Il faisait","Il fait","Il faisait"],"correctIndex":1,"explanation":"Il faisait beau = It was nice weather (ongoing description)."}'),
  4, 10, 15, NOW()),
(UUID(), @l_fr_impar, 'Fill in: Quand j _____ petit', 'FILL_IN_BLANK',
  CONCAT('{"question":"Quand j _____ petit, jhabitais a Paris. When I was little (petit), past habit.","answer":"etais","hints":["imparfait of etre"],"explanation":"J etais petit = I was little (description/state)."}'),
  5, 10, 15, NOW());

-- French B1 Lesson 2: Exprimer son Opinion - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_fr_opin, 'How to say I think?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say I think in French?","options":["Je crois","Je pense","Je trouve","Toutes ces reponses"],"correctIndex":3,"explanation":"Je crois, je pense, and je trouve all mean I think."}'),
  1, 10, 20, NOW()),
(UUID(), @l_fr_opin, 'Fill in: A mon _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"A mon _____, this is not correct. (humble opinion)","answer":"avis","hints":["opinion"],"explanation":"A mon avis = in my opinion."}'),
  2, 10, 15, NOW()),
(UUID(), @l_fr_opin, 'Match opinion phrases', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Je pense que","right":"I think that"},{"left":"A mon avis","right":"In my opinion"},{"left":"Il me semble","right":"It seems to me"},{"left":"Dapres moi","right":"According to me"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_fr_opin, 'What does dunger mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What does dunee (dangereux) mean?","options":["Beautiful","Dangerous","Delicious","Boring"],"correctIndex":1,"explanation":"Dangereux = dangerous."}'),
  4, 10, 15, NOW()),
(UUID(), @l_fr_opin, 'Fill in: _____ que non', 'FILL_IN_BLANK',
  CONCAT('{"question":"Je ne _____ pas que non. I dont think so. (croit)","answer":"crois","hints":["believe"],"explanation":"Je ne crois pas = I dont think/believe."}'),
  5, 10, 15, NOW());

-- French B1 Lesson 3: Le Subjonctif Present - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_fr_subj, 'When to use subjonctif?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"When do you use subjonctif present in French?","options":["Facts only","After expressions of will and emotion","Past actions","Future actions"],"correctIndex":1,"explanation":"Subjonctif is used after expressions of will, emotion, doubt, and necessity."}'),
  1, 10, 20, NOW()),
(UUID(), @l_fr_subj, 'Fill in: Il faut que tu _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Il faut que tu _____ (finir). You must finish. (subjonctif)","answer":"finisses","hints":["-es ending"],"explanation":"Il faut que + subjonctif: tu finisses = you finish."}'),
  2, 10, 15, NOW()),
(UUID(), @l_fr_subj, 'Match subjonctif triggers', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Il faut que","right":"Necessity"},{"left":"Je veux que","right":"Will"},{"left":"Il est important que","right":"Importance"},{"left":"Je doute que","right":"Doubt"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_fr_subj, 'Subjonctif of faire?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What is the subjonctif present of faire (to do/make)?","options":["Fasses","Fasse","Fassions","Fassent"],"correctIndex":1,"explanation":"Que je fasse = subjonctif of faire."}'),
  4, 10, 20, NOW()),
(UUID(), @l_fr_subj, 'Fill in: Il est vrai que je _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Il est vrai que je _____ (pouvoir). It is true that I can. (subjonctif)","answer":"puisse","hints":["-e ending"],"explanation":"Que je puisse = subjonctif of pouvoir."}'),
  5, 10, 15, NOW());

-- French B1 Lesson 4: La Presse Francaise - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_fr_presse, 'What does presse mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Presse (la presse) in French means:","options":["Press/Publishing","Kitchen","Travel","Sports"],"correctIndex":0,"explanation":"La presse = the press/the publishing world."}'),
  1, 10, 15, NOW()),
(UUID(), @l_fr_presse, 'Fill in: Un journal = _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Un journal (a newspaper) in French means _____ in English.","answer":"A newspaper","hints":["news"],"explanation":"Un journal = a newspaper."}'),
  2, 10, 15, NOW()),
(UUID(), @l_fr_presse, 'Match press words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Un quotidien","right":"Daily newspaper"},{"left":"Un hebdomadaire","right":"Weekly magazine"},{"left":"Un titre","right":"Headline"},{"left":"Un article","right":"Article"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_fr_presse, 'What does enquete mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Enquete (une enquete) means:","options":["Survey","Investigation/Enquiry","Article","Interview"],"correctIndex":1,"explanation":"Une enquete = an investigation or enquiry."}'),
  4, 10, 15, NOW()),
(UUID(), @l_fr_presse, 'Fill in: _____ = headline', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ (un titre) in French means headline in English.","answer":"Un titre","hints":["newspaper"],"explanation":"Un titre = a headline/title."}'),
  5, 10, 15, NOW());

-- French B1 Lesson 5: Les Relations Sociales - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_fr_relat, 'How to say I get along with?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say I get along well with Marie in French?","options":["Je suis bien avec Marie","Je mintends bien avec Marie","Je parle bien a Marie","Je connais bien Marie"],"correctIndex":1,"explanation":"Je mintends bien avec Marie = I get along well with Marie."}'),
  1, 10, 20, NOW()),
(UUID(), @l_fr_relat, 'Fill in: Une _____ = friendship', 'FILL_IN_BLANK',
  CONCAT('{"question":"Une _____ (une amitie) in French means friendship in English.","answer":"Une amitie","hints":["friend"],"explanation":"Une amitie = a friendship."}'),
  2, 10, 15, NOW()),
(UUID(), @l_fr_relat, 'Match social words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Une amitie","right":"Friendship"},{"left":"Une connaissances","right":"Acquaintance"},{"left":"Une correspondance","right":"Correspondence"},{"left":"Un reseau","right":"Network"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_fr_relat, 'What does connaissance mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Connaissance (une connaissance) means:","options":["Close friend","Acquaintance","Family","Stranger"],"correctIndex":1,"explanation":"Une connaissance = an acquaintance (someone you know but not well)."}'),
  4, 10, 15, NOW()),
(UUID(), @l_fr_relat, 'Fill in: Se _____ avec = to argue with', 'FILL_IN_BLANK',
  CONCAT('{"question":"Se _____ avec Marie = to argue with Marie. (disputer)","answer":"disputer","hints":["quarrel"],"explanation":"Se disputer = to argue with someone."}'),
  5, 10, 15, NOW());

-- French B2 Lesson 1: Le Conditionnel Present - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_fr_cond, 'How to form conditionnel?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you form the conditionnel present of parler?","options":["Parlerais","Parlerais","Parlerions","Toutes ces reponses"],"correctIndex":3,"explanation":"Conditionnel = stem + ais/ais/ait/ions/iez/aient."}'),
  1, 10, 20, NOW()),
(UUID(), @l_fr_cond, 'Fill in: Si javais faim, je _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Si javais faim, je _____ (manger). If I were hungry, I would eat. (conditionnel)","answer":"mangerais","hints":["would eat"],"explanation":"Conditionnel = je mangerais = I would eat."}'),
  2, 10, 15, NOW()),
(UUID(), @l_fr_cond, 'Match conditionnel forms', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Je parlerais","right":"I would speak"},{"left":"Nous irions","right":"We would go"},{"left":"Ils viendraient","right":"They would come"},{"left":"Vous feriez","right":"You would do"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_fr_cond, 'What does il serait means?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Il serait means:","options":["He was","He is","He would be","He will be"],"correctIndex":2,"explanation":"Il serait = he would be (conditionnel of être)."}'),
  4, 10, 15, NOW()),
(UUID(), @l_fr_cond, 'Fill in: _____ + infinitive = polite request', 'FILL_IN_BLANK',
  CONCAT('{"question":"Conditionnel + infinitive = polite request. Vouloir → _____ (would like)","answer":"voudrais","hints":["je form"],"explanation":"Je voudrais = I would like (polite)."}'),
  5, 10, 15, NOW());

-- French B2 Lesson 2: Le Discours Rapporte - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_fr_disc, 'What is discours rapporte?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Le discours rapporté (reported speech) is:","options":["Direct quotes","Reporting what someone said","Formal speech","Written speech"],"correctIndex":1,"explanation":"Discourse rapporté = reporting what someone said."}'),
  1, 10, 20, NOW()),
(UUID(), @l_fr_disc, 'Fill in: Il a dit quil _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Il a dit quil _____ (venir). He said he would come. (imparfait)","answer":"viendrait","hints":["imparfait"],"explanation":"In discours rapporté: quil viendrait (imparfait for future in past)."}'),
  2, 10, 15, NOW()),
(UUID(), @l_fr_disc, 'Match reporting changes', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Ici → LA","right":"Here → There"},{"left":"Hier → La veille","right":"Yesterday → The day before"},{"left":"Demain → Le lendemain","right":"Tomorrow → The next day"},{"left":"Ce → CET","right":"This → That"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_fr_disc, 'Direct to indirect: Il a dit je pars?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Direct: Il a dit je pars. Indirect: Il a dit quil _____","options":["part","partait","partira","parte"],"correctIndex":1,"explanation":"In discours rapporté: imparfait after past reporting verb."}'),
  4, 10, 20, NOW()),
(UUID(), @l_fr_disc, 'Fill in: Elle a promis quelle _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Elle a promis quelle _____ (venir). She promised she would come. (imparfait)","answer":"viendrait","hints":["venir"],"explanation":"Promettre + futur dans le passé → imparfait: elle viendrait."}'),
  5, 10, 15, NOW());

-- French B2 Lesson 3: Redaction Litteraire - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_fr_litt, 'What is redaction?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Redaction (la redaction) in French means:","options":["Reading","Writing composition","Speaking","Translating"],"correctIndex":1,"explanation":"La rédaction = a writing composition or essay."}'),
  1, 10, 15, NOW()),
(UUID(), @l_fr_litt, 'Fill in: Un _____ = a story', 'FILL_IN_BLANK',
  CONCAT('{"question":"Un _____ (un recit) in French means a story in English.","answer":"Un recit","hints":["tale"],"explanation":"Un récit = a story or narrative."}'),
  2, 10, 15, NOW()),
(UUID(), @l_fr_litt, 'Match literary words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Un recit","right":"A story"},{"left":"Un personnage","right":"A character"},{"left":"Un contexte","right":"A setting"},{"left":"Une these","right":"A thesis"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_fr_litt, 'What does personnage mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Personnage means:","options":["A person","A character","A plot","A setting"],"correctIndex":1,"explanation":"Un personnage = a character in a literary work."}'),
  4, 10, 15, NOW()),
(UUID(), @l_fr_litt, 'Fill in: Le _____ = the plot', 'FILL_IN_BLANK',
  CONCAT('{"question":"Le _____ (le recit) in French means the plot in English.","answer":"Recit","hints":["narrative"],"explanation":"Le récit = the narrative/plot."}'),
  5, 10, 15, NOW());

-- French B2 Lesson 4: Expressions Idiocratiques - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_fr_idiom, 'What does avoir faim mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Avoir faim (to be hungry) literally means:","options":["Want food","Have hunger","Eat a lot","Be full"],"correctIndex":1,"explanation":"Avoir faim = literally to have hunger, meaning to be hungry."}'),
  1, 10, 15, NOW()),
(UUID(), @l_fr_idiom, 'Fill in: Il fait froid = it is _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Il fait froid = it is _____ in French. (cold)","answer":"Cold","hints":["weather"],"explanation":"Il fait froid = it is cold (weather expression)."}'),
  2, 10, 15, NOW()),
(UUID(), @l_fr_idiom, 'Match idioms', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Avoir raison","right":"To be right"},{"left":"Avoir tort","right":"To be wrong"},{"left":"Avoir chaud","right":"To be hot"},{"left":"Avoir peur","right":"To be afraid"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_fr_idiom, 'What does avoir lieu mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Avoir lieu (to take place) literally means:","options":["To have money","To have a place","To take place","To be at home"],"correctIndex":2,"explanation":"Avoir lieu = literally to have place, meaning to take place."}'),
  4, 10, 15, NOW()),
(UUID(), @l_fr_idiom, 'Fill in: Il fait _____ = it is hot', 'FILL_IN_BLANK',
  CONCAT('{"question":"Il fait _____ in French means it is hot. (weather)","answer":"Chaud","hints":["hot"],"explanation":"Il fait chaud = it is hot (weather expression)."}'),
  5, 10, 15, NOW());

-- French B2 Lesson 5: Debat et Argumentation - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_fr_debat, 'How to introduce a counterargument?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you introduce a counterargument in French?","options":["Dune part... dautre part","Tout dabord","En conclusion","Donc"],"correctIndex":0,"explanation":"Dune part... dautre part = on one hand... on the other hand."}'),
  1, 10, 20, NOW()),
(UUID(), @l_fr_debat, 'Fill in: dune part... _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Dune part... _____ = on the other hand. (autre part)","answer":"dautre part","hints":["the other"],"explanation":"Dune part... dautre part = on one hand... on the other hand."}'),
  2, 10, 15, NOW()),
(UUID(), @l_fr_debat, 'Match debate words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Dune part","right":"On one hand"},{"left":"Cependant","right":"However"},{"left":"Par consequent","right":"Therefore"},{"left":"A mon sens","right":"In my view"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_fr_debat, 'What does soutenir mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Soutenir (to support) an argument means:","options":["To reject","To defend","To change","To ignore"],"correctIndex":1,"explanation":"Soutenir = to support or defend an argument."}'),
  4, 10, 15, NOW()),
(UUID(), @l_fr_debat, 'Fill in: En _____ = in conclusion', 'FILL_IN_BLANK',
  CONCAT('{"question":"En _____ in French means in conclusion.","answer":"Conclusion","hints":["end"],"explanation":"En conclusion = in conclusion."}'),
  5, 10, 15, NOW());

-- French Travel Lesson 1: A l Aeroport - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_fr_aero, 'How to say where is gate 5?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say Where is gate 5? at a French airport?","options":["Ou est la porte 5?","Comment est la porte 5?","Quest-ce que la porte 5?","Qui est la porte 5?"],"correctIndex":0,"explanation":"Ou est la porte 5? = Where is gate 5?"}'),
  1, 10, 20, NOW()),
(UUID(), @l_fr_aero, 'Fill in: Lavion = _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Lavion (the plane) in French means _____ in English.","answer":"The airplane","hints":["flying"],"explanation":"Lavion = the airplane."}'),
  2, 10, 15, NOW()),
(UUID(), @l_fr_aero, 'Match airport words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Lavion","right":"The plane"},{"left":"Le vol","right":"The flight"},{"left":"La porte","right":"The gate"},{"left":"Lentretien","right":"The interview"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_fr_aero, 'What does embarquer mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Embarquer means:","options":["To land","To board","To check in","To buy a ticket"],"correctIndex":1,"explanation":"Embarquer = to board a plane."}'),
  4, 10, 15, NOW()),
(UUID(), @l_fr_aero, 'Fill in: Le _____ = the luggage', 'FILL_IN_BLANK',
  CONCAT('{"question":"Le _____ (les bagages) in French means the luggage in English.","answer":"Bagages","hints":["luggage"],"explanation":"Les bagages = luggage."}'),
  5, 10, 15, NOW());

-- French Travel Lesson 2: A l Hotel - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_fr_hotel, 'How to ask for room key?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you ask for your room key at a French hotel?","options":["Je veux la cle de ma chambre","Donnez-moi le hotel","Je reste ici","La chambre est ou?"],"correctIndex":0,"explanation":"Je voudrais la cle de ma chambre = I would like the key to my room."}'),
  1, 10, 20, NOW()),
(UUID(), @l_fr_hotel, 'Fill in: Une _____ = a room', 'FILL_IN_BLANK',
  CONCAT('{"question":"Une _____ (une chambre) in French means a room in English.","answer":"Une chambre","hints":["stay"],"explanation":"Une chambre = a room."}'),
  2, 10, 15, NOW()),
(UUID(), @l_fr_hotel, 'Match hotel words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Une chambre","right":"A room"},{"left":"La cle","right":"The key"},{"left":"Le reception","right":"The reception"},{"left":"Un ascenseur","right":"An elevator"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_fr_hotel, 'What does receptionist mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Receptionniste means:","options":["Guest","Receptionist","Manager","Cleaner"],"correctIndex":1,"explanation":"Receptionniste = receptionist."}'),
  4, 10, 15, NOW()),
(UUID(), @l_fr_hotel, 'Fill in: _____ = checkout', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ (le depart) in French means checkout in English.","answer":"Le depart","hints":["leaving"],"explanation":"Le depart = the departure/checkout."}'),
  5, 10, 15, NOW());

-- French Travel Lesson 3: En Ville - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_fr_ville, 'How to ask for directions?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you ask How do I get to the station? in French?","options":["Ou est la gare?","Comment aller a la gare?","La gare est ici?","Quest-ce que la gare?"],"correctIndex":1,"explanation":"Comment aller a la gare? = How do I get to the station?"}'),
  1, 10, 20, NOW()),
(UUID(), @l_fr_ville, 'Fill in: Tourner a _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Tourner a _____ = turn left. (gauche)","answer":"gauche","hints":["left"],"explanation":"Tourner a gauche = to turn left."}'),
  2, 10, 15, NOW()),
(UUID(), @l_fr_ville, 'Match direction words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Tout droit","right":"Straight ahead"},{"left":"A gauche","right":"To the left"},{"left":"A droite","right":"To the right"},{"left":"Lendroit","right":"The place"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_fr_ville, 'What does carrefour mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Carrefour (un carrefour) means:","options":["Straight road","Crossroads/Intersection","Building","Park"],"correctIndex":1,"explanation":"Un carrefour = a crossroads or intersection."}'),
  4, 10, 15, NOW()),
(UUID(), @l_fr_ville, 'Fill in: _____ = square (place)', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ (une place) in French means square (public area) in English.","answer":"Une place","hints":["public area"],"explanation":"Une place = a square or plaza."}'),
  5, 10, 15, NOW());

-- French Travel Lesson 4: Les Achats - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_fr_achats, 'How to ask the price?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you ask How much does this cost? in French?","options":["Quest-ce que cest?","Cest combien?","Ou est-ce?","Comment est-ce?"],"correctIndex":1,"explanation":"Cest combien? = How much is it?"}'),
  1, 10, 15, NOW()),
(UUID(), @l_fr_achats, 'Fill in: _____ = to buy', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ (acheter) in French means to buy in English.","answer":"Acheter","hints":["purchase"],"explanation":"Acheter = to buy."}'),
  2, 10, 15, NOW()),
(UUID(), @l_fr_achats, 'Match shopping words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Acheter","right":"To buy"},{"left":"Vendre","right":"To sell"},{"left":"Le marche","right":"The market"},{"left":"Les soldes","right":"The sales"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_fr_achats, 'What does soldes mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Soldes (les soldes) means:","options":["The market","The sales/discounts","The shop","The price"],"correctIndex":1,"explanation":"Les soldes = the sales or discounted items."}'),
  4, 10, 15, NOW()),
(UUID(), @l_fr_achats, 'Fill in: _____ = to sell', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ (vendre) in French means to sell in English.","answer":"Vendre","hints":["opposite of buy"],"explanation":"Vendre = to sell."}'),
  5, 10, 15, NOW());

-- French Travel Lesson 5: Les Urgences - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_fr_urg, 'Emergency number in France?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What is the emergency number in France?","options":["911","112","15 (SAMU)","All of these"],"correctIndex":3,"explanation":"112 is EU-wide, 15 is SAMU medical, 18 is fire, 17 is police."}'),
  1, 10, 15, NOW()),
(UUID(), @l_fr_urg, 'Fill in: _____ = ambulance', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ (une ambulance) in French means ambulance in English.","answer":"Une ambulance","hints":["medical"],"explanation":"Une ambulance = an ambulance."}'),
  2, 10, 15, NOW()),
(UUID(), @l_fr_urg, 'Match emergency words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Une ambulance","right":"Ambulance"},{"left":"La police","right":"Police"},{"left":"Les pompiers","right":"Firefighters"},{"left":"Un hopital","right":"Hospital"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_fr_urg, 'What does pompier mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Pompier (un pompier) means:","options":["Police officer","Doctor","Firefighter","Paramedic"],"correctIndex":2,"explanation":"Un pompier = a firefighter."}'),
  4, 10, 15, NOW()),
(UUID(), @l_fr_urg, 'Fill in: La _____ = the hospital', 'FILL_IN_BLANK',
  CONCAT('{"question":"La _____ (un hopital) in French means the hospital in English.","answer":"Un hopital","hints":["medical"],"explanation":"Un hopital = a hospital."}'),
  5, 10, 15, NOW());

-- Get German lesson IDs
SET @l_de_greet = (SELECT id FROM lessons WHERE title = 'Deutsche Begrussungen' LIMIT 1);
SET @l_de_intro = (SELECT id FROM lessons WHERE title = 'Sich Vorstellen' LIMIT 1);
SET @l_de_zahl  = (SELECT id FROM lessons WHERE title = 'Zahlen 1-100' LIMIT 1);
SET @l_de_fam   = (SELECT id FROM lessons WHERE title = 'Die Familie' LIMIT 1);
SET @l_de_tag   = (SELECT id FROM lessons WHERE title = 'Wochentage und Monate' LIMIT 1);
SET @l_de_rest  = (SELECT id FROM lessons WHERE title = 'Im Restaurant' LIMIT 1);
SET @l_de_shop  = (SELECT id FROM lessons WHERE title = 'Einkaufen' LIMIT 1);
SET @l_de_perf  = (SELECT id FROM lessons WHERE title = 'Das Perfekt' LIMIT 1);
SET @l_de_ort   = (SELECT id FROM lessons WHERE title = 'Ortsangaben' LIMIT 1);
SET @l_de_hobby = (SELECT id FROM lessons WHERE title = 'Freizeit und Hobbys' LIMIT 1);
SET @l_de_opin  = (SELECT id FROM lessons WHERE title = 'Meinungen aussern' LIMIT 1);
SET @l_de_past  = (SELECT id FROM lessons WHERE title = 'Die Vergangenheit' LIMIT 1);
SET @l_de_read  = (SELECT id FROM lessons WHERE title = 'Deutsch lesen' LIMIT 1);
SET @l_de_health= (SELECT id FROM lessons WHERE title = 'Gesundheit' LIMIT 1);
SET @l_de_kult  = (SELECT id FROM lessons WHERE title = 'Kultur und Kunst' LIMIT 1);
SET @l_de_konj  = (SELECT id FROM lessons WHERE title = 'Konjunktiv II' LIMIT 1);
SET @l_de_neben = (SELECT id FROM lessons WHERE title = 'Nebensatze' LIMIT 1);
SET @l_de_aufs  = (SELECT id FROM lessons WHERE title = 'Aufsatzschreiben' LIMIT 1);
SET @l_de_rede  = (SELECT id FROM lessons WHERE title = 'Redewendungen' LIMIT 1);
SET @l_de_debat  = (SELECT id FROM lessons WHERE title = 'Debatte und Argumentation' LIMIT 1);
SET @l_de_busbase= (SELECT id FROM lessons WHERE title = 'Geschaftsdeutsch Grundlagen' LIMIT 1);
SET @l_de_letter= (SELECT id FROM lessons WHERE title = 'Geschaftsbriefe' LIMIT 1);
SET @l_de_besprec= (SELECT id FROM lessons WHERE title = 'Besprechungen' LIMIT 1);
SET @l_de_verh  = (SELECT id FROM lessons WHERE title = 'Verhandeln' LIMIT 1);
SET @l_de_buero = (SELECT id FROM lessons WHERE title = 'Deutsch im BUro' LIMIT 1);

-- German A1 Lesson 1: Begrussungen - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_de_greet, 'How to say goodbye in German?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say goodbye in German?","options":["Guten Tag","Auf Wiedersehen","Danke schon","Bitte schon"],"correctIndex":1,"explanation":"Auf Wiedersehen is the formal goodbye in German."}'),
  1, 10, 15, NOW()),
(UUID(), @l_de_greet, 'Fill in: Guten _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Guten _____ means good morning. (Morgen)","answer":"Morgen","hints":["morning"],"explanation":"Guten Morgen means good morning in German."}'),
  2, 10, 15, NOW()),
(UUID(), @l_de_greet, 'Match greetings', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Guten Morgen","right":"Good morning"},{"left":"Guten Tag","right":"Good day"},{"left":"Guten Abend","right":"Good evening"},{"left":"Auf Wiedersehen","right":"Goodbye"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_de_greet, 'What does danke schon mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Danke schon means:","options":["Please","Thank you","Excuse me","Sorry"],"correctIndex":1,"explanation":"Danke schon means thank you very much."}'),
  4, 10, 15, NOW()),
(UUID(), @l_de_greet, 'Fill in: _____ schon = please', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ schon means please in German. (bitte)","answer":"Bitte","hints":["polite"],"explanation":"Bitte schon means please."}'),
  5, 10, 15, NOW());

-- German A1 Lesson 2: Sich Vorstellen - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_de_intro, 'How to say my name is?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say my name is Hans in German?","options":["Ich bin Hans","Ich habe Hans","Ich komme Hans","Ich heisse Hans"],"correctIndex":3,"explanation":"Ich heisse Hans = My name is Hans."}'),
  1, 10, 20, NOW()),
(UUID(), @l_de_intro, 'Fill in: Ich _____ aus Berlin', 'FILL_IN_BLANK',
  CONCAT('{"question":"Ich _____ aus Berlin. I come from Berlin. (bin)","answer":"bin","hints":["be verb"],"explanation":"Ich bin aus Berlin = I am from Berlin."}'),
  2, 10, 15, NOW()),
(UUID(), @l_de_intro, 'Match introduction phrases', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Ich heisse","right":"My name is"},{"left":"Ich bin","right":"I am"},{"left":"Ich komme aus","right":"I come from"},{"left":"Freut mich","right":"Nice to meet you"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_de_intro, 'What does freut mich mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Freut mich means:","options":["Goodbye","Good morning","Nice to meet you","Thank you"],"correctIndex":2,"explanation":"Freut mich means nice to meet you."}'),
  4, 10, 15, NOW()),
(UUID(), @l_de_intro, 'Fill in: Ich _____ Student', 'FILL_IN_BLANK',
  CONCAT('{"question":"Ich _____ Student. I am a student. (bin)","answer":"bin","hints":["be verb"],"explanation":"Ich bin Student = I am a student."}'),
  5, 10, 15, NOW());

-- German A1 Lesson 3: Zahlen - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_de_zahl, 'What is 7 in German?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What is 7 in German?","options":["Funf","Sechs","Sieben","Acht"],"correctIndex":2,"explanation":"Sieben = 7 in German."}'),
  1, 10, 15, NOW()),
(UUID(), @l_de_zahl, 'Fill in: Elf = _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Elf (11) in German means _____ in English.","answer":"Eleven","hints":["11"],"explanation":"Elf = 11 in German."}'),
  2, 10, 15, NOW()),
(UUID(), @l_de_zahl, 'Match numbers to words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Eins","right":"1"},{"left":"Zehn","right":"10"},{"left":"Zwanzig","right":"20"},{"left":"Hundert","right":"100"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_de_zahl, 'What is 21 in German?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say 21 in German?","options":["Einundzwanzig","Zwanzigeins","Zwanzig-eins","Eins-zwanzig"],"correctIndex":0,"explanation":"German reverses: 21 = einundzwanzig (one-and-twenty)."}'),
  4, 10, 20, NOW()),
(UUID(), @l_de_zahl, 'Fill in: Hundert = _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Hundert (100) in German means _____ in English.","answer":"One hundred","hints":["100"],"explanation":"Hundert = 100 in German."}'),
  5, 10, 15, NOW());

-- German A1 Lesson 4: Die Familie - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_de_fam, 'What does Vater mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Vater means:","options":["Mother","Father","Brother","Sister"],"correctIndex":1,"explanation":"Vater = father in German."}'),
  1, 10, 15, NOW()),
(UUID(), @l_de_fam, 'Fill in: Mutter = _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Mutter (mother) in German means _____ in English.","answer":"Mother","hints":["female parent"],"explanation":"Mutter = mother in German."}'),
  2, 10, 15, NOW()),
(UUID(), @l_de_fam, 'Match family words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Der Vater","right":"Father"},{"left":"Die Mutter","right":"Mother"},{"left":"Der Bruder","right":"Brother"},{"left":"Die Schwester","right":"Sister"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_de_fam, 'What does Geschwister mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Geschwister means:","options":["Parents","Siblings","Children","Grandparents"],"correctIndex":1,"explanation":"Geschwister = siblings (brothers and sisters)."}'),
  4, 10, 15, NOW()),
(UUID(), @l_de_fam, 'Fill in: _____ = sister', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ (Schwester) in German means sister in English.","answer":"Schwester","hints":["female sibling"],"explanation":"Schwester = sister in German."}'),
  5, 10, 15, NOW());

-- German A1 Lesson 5: Wochentage - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_de_tag, 'What is Monday in German?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What is Monday in German?","options":["Dienstag","Mittwoch","Montag","Donnerstag"],"correctIndex":2,"explanation":"Montag = Monday in German."}'),
  1, 10, 15, NOW()),
(UUID(), @l_de_tag, 'Fill in: Januar = _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Januar (January) in German means _____ in English.","answer":"January","hints":["month 1"],"explanation":"Januar = January in German."}'),
  2, 10, 15, NOW()),
(UUID(), @l_de_tag, 'Match days of week', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Montag","right":"Monday"},{"left":"Dienstag","right":"Tuesday"},{"left":"Mittwoch","right":"Wednesday"},{"left":"Donnerstag","right":"Thursday"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_de_tag, 'What month is Dezember?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Dezember is which month?","options":["November","December","October","January"],"correctIndex":1,"explanation":"Dezember = December."}'),
  4, 10, 15, NOW()),
(UUID(), @l_de_tag, 'Fill in: _____ = July', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ (Juli) in German means July in English.","answer":"Juli","hints":["summer month"],"explanation":"Juli = July in German."}'),
  5, 10, 15, NOW());

-- German A2 Lesson 1: Im Restaurant - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_de_rest, 'How to order in German?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say I would like a coffee in German?","options":["Ich will einen Kaffee","Ich mochte einen Kaffee","Ich habe einen Kaffee","Ich esse einen Kaffee"],"correctIndex":1,"explanation":"Ich mochte = I would like."}'),
  1, 10, 20, NOW()),
(UUID(), @l_de_rest, 'Fill in: Die _____ bitte', 'FILL_IN_BLANK',
  CONCAT('{"question":"Die _____, bitte means the bill please. (Rechnung)","answer":"Rechnung","hints":["payment"],"explanation":"Die Rechnung, bitte = The bill, please."}'),
  2, 10, 15, NOW()),
(UUID(), @l_de_rest, 'Match restaurant phrases', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Ich mochte","right":"I would like"},{"left":"Die Rechnung","right":"The bill"},{"left":"Ein Bier bitte","right":"A beer please"},{"left":"Guten Appetit","right":"Enjoy your meal"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_de_rest, 'What does guten Appetit mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Guten Appetit means:","options":["Thank you","Enjoy your meal","Good morning","Goodbye"],"correctIndex":1,"explanation":"Guten Appetit = enjoy your meal."}'),
  4, 10, 15, NOW()),
(UUID(), @l_de_rest, 'Fill in: Ich _____ einen Kaffee', 'FILL_IN_BLANK',
  CONCAT('{"question":"Ich _____ einen Kaffee. I want a coffee. (mochte)","answer":"mochte","hints":["would like"],"explanation":"mochte = would like."}'),
  5, 10, 15, NOW());

-- German A2 Lesson 2: Einkaufen - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_de_shop, 'How to ask the price?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you ask How much does this cost? in German?","options":["Was ist das?","Wie viel kostet das?","Wo ist das?","Wer ist das?"],"correctIndex":1,"explanation":"Wie viel kostet das? = How much does that cost?"}'),
  1, 10, 20, NOW()),
(UUID(), @l_de_shop, 'Fill in: Das ist zu _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Das ist zu _____. This is too expensive. (teuer)","answer":"teuer","hints":["expensive"],"explanation":"teuer = expensive. Zu teuer = too expensive."}'),
  2, 10, 15, NOW()),
(UUID(), @l_de_shop, 'Match shopping words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Wie viel kostet das?","right":"How much?"},{"left":"Das ist zu teuer","right":"Too expensive"},{"left":"Ich nehme das","right":"I will take it"},{"left":"Die Kreditkarte","right":"Credit card"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_de_shop, 'What does anprobieren mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Anprobieren means:","options":["To buy","To try on","To pay","To sell"],"correctIndex":1,"explanation":"Anprobieren = to try on (clothes)."}'),
  4, 10, 15, NOW()),
(UUID(), @l_de_shop, 'Fill in: Ich _____ das', 'FILL_IN_BLANK',
  CONCAT('{"question":"Ich _____ das. I will take this. (nehme)","answer":"nehme","hints":["take"],"explanation":"Ich nehme das = I will take that."}'),
  5, 10, 15, NOW());

-- German A2 Lesson 3: Das Perfekt - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_de_perf, 'How to form Perfekt?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you form Perfekt in German?","options":["haben/sein + infinitive","haben/sein + past participle","war + past participle","hatte + past participle"],"correctIndex":1,"explanation":"Perfekt = haben/sein + past participle (ge-verb-t)."}'),
  1, 10, 20, NOW()),
(UUID(), @l_de_perf, 'Fill in: Ich _____ Kaffee getrunken', 'FILL_IN_BLANK',
  CONCAT('{"question":"Ich _____ Kaffee getrunken. I drank coffee. (habe)","answer":"habe","hints":["haben auxiliary"],"explanation":"Perfekt: haben + past participle. Ich habe Kaffee getrunken."}'),
  2, 10, 15, NOW()),
(UUID(), @l_de_perf, 'Match verbs to past participle', 'MATCHING',
  CONCAT('{"pairs":[{"left":"spielen","right":"gespielt"},{"left":"machen","right":"gemacht"},{"left":"sprechen","right":"gesprochen"},{"left":"trinken","right":"getrunken"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_de_perf, 'Which verb uses sein?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Which verb uses sein (not haben) in Perfekt?","options":["spielen","trinken","fahren","machen"],"correctIndex":2,"explanation":"fahren uses sein: Er ist gefahren."}'),
  4, 10, 15, NOW()),
(UUID(), @l_de_perf, 'Fill in: Er _____ nach Hause gegangen', 'FILL_IN_BLANK',
  CONCAT('{"question":"Er _____ nach Hause gegangen. He went home. (ist)","answer":"ist","hints":["sein auxiliary"],"explanation":"gehen uses sein: Er ist gegangen."}'),
  5, 10, 15, NOW());

-- German A2 Lesson 4: Ortsangaben - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_de_ort, 'How to say go straight?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say go straight ahead in German?","options":["Gehen Sie links","Gehen Sie geradeaus","Gehen Sie rechts","Gehen Sie zuruck"],"correctIndex":1,"explanation":"Geradeaus = straight ahead."}'),
  1, 10, 20, NOW()),
(UUID(), @l_de_ort, 'Fill in: Links means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Links (left) in German means _____ in English.","answer":"Left","hints":["direction"],"explanation":"Links = left in German."}'),
  2, 10, 15, NOW()),
(UUID(), @l_de_ort, 'Match direction words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Links","right":"Left"},{"left":"Rechts","right":"Right"},{"left":"Geradeaus","right":"Straight ahead"},{"left":"Zuruck","right":"Back"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_de_ort, 'What does nach rechts mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Nach rechts means:","options":["To the left","To the right","Straight ahead","Back"],"correctIndex":1,"explanation":"Nach rechts = to the right."}'),
  4, 10, 15, NOW()),
(UUID(), @l_de_ort, 'Fill in: Die Ampel ist _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Die Ampel ist _____. The traffic light is green. (grun)","answer":"grun","hints":["color"],"explanation":"grun = green. Die Ampel ist grun."}'),
  5, 10, 15, NOW());

-- German A2 Lesson 5: Freizeit - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_de_hobby, 'How to say I like reading?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say I like reading in German?","options":["Ich habe lesen gern","Ich lese gern","Ich lese gern","Ich mochte lesen"],"correctIndex":2,"explanation":"Ich lese gern = I like reading."}'),
  1, 10, 20, NOW()),
(UUID(), @l_de_hobby, 'Fill in: Lesen means _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Lesen (to read) in German means _____ in English.","answer":"To read","hints":["read"],"explanation":"Lesen = to read in German."}'),
  2, 10, 15, NOW()),
(UUID(), @l_de_hobby, 'Match hobby words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Lesen","right":"Reading"},{"left":"Schwimmen","right":"Swimming"},{"left":"Kochen","right":"Cooking"},{"left":"Reisen","right":"Traveling"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_de_hobby, 'What does wandern mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Wandern means:","options":["Swimming","Hiking","Running","Cycling"],"correctIndex":1,"explanation":"Wandern = to hike in German."}'),
  4, 10, 15, NOW()),
(UUID(), @l_de_hobby, 'Fill in: Ich _____ gern Schwimmen', 'FILL_IN_BLANK',
  CONCAT('{"question":"Ich _____ gern Schwimmen. I like swimming. (schwimme)","answer":"schwimme","hints":["verb form"],"explanation":"schwimme = I swim. Ich schwimme gern."}'),
  5, 10, 15, NOW());

-- German B1 Lesson 1: Meinungen - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_de_opin, 'How to say I think?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say I think in German?","options":["Ich finde","Ich glaube","Ich meine","Alle drei"],"correctIndex":3,"explanation":"Ich finde, ich glaube, and ich meine all mean I think."}'),
  1, 10, 20, NOW()),
(UUID(), @l_de_opin, 'Fill in: _____ meiner Meinung nach', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ meiner Meinung nach means in my opinion. (nach)","answer":"Nach","hints":["according to"],"explanation":"Nach meiner Meinung nach = in my opinion."}'),
  2, 10, 15, NOW()),
(UUID(), @l_de_opin, 'Match opinion phrases', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Ich glaube","right":"I believe"},{"left":"Ich finde","right":"I find/think"},{"left":"Meiner Meinung nach","right":"In my opinion"},{"left":"Ich bin der Meinung","right":"I am of the opinion"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_de_opin, 'What does meiner Meinung mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Meiner Meinung nach means:","options":["In my hand","In my opinion","On my way","By my means"],"correctIndex":1,"explanation":"Meiner Meinung nach = in my opinion."}'),
  4, 10, 15, NOW()),
(UUID(), @l_de_opin, 'Fill in: Ich _____ dass', 'FILL_IN_BLANK',
  CONCAT('{"question":"Ich _____ dass es regnet. I think that it is raining. (glaube)","answer":"glaube","hints":["believe"],"explanation":"glaube = believe/think. Ich glaube dass..."}'),
  5, 10, 15, NOW());

-- German B1 Lesson 2: Vergangenheit - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_de_past, 'Prateritum vs Perfekt?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"When do you use Prateritum in German?","options":["Spoken language only","Written/formal language only","Both equally","Neither"],"correctIndex":1,"explanation":"Prateritum is mainly used in written German. Spoken uses Perfekt."}'),
  1, 10, 20, NOW()),
(UUID(), @l_de_past, 'Fill in: Er _____ (Prateritum of sein)', 'FILL_IN_BLANK',
  CONCAT('{"question":"Er _____ in Prateritum = Er war in Perfekt. (war)","answer":"war","hints":["war"],"explanation":"Prateritum of sein: war = was. Er war glucklich = He was happy."}'),
  2, 10, 15, NOW()),
(UUID(), @l_de_past, 'Match Prateritum forms', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Ich war","right":"I was"},{"left":"Du hattest","right":"You had"},{"left":"Er machte","right":"He did"},{"left":"Wir kamen","right":"We came"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_de_past, 'Prateritum of haben?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What is the Prateritum of haben?","options":["Hatte","Hatte","Hatten","Hattest"],"correctIndex":1,"explanation":"Prateritum of haben: ich/er/sie/es hatte, wir/sie/Sie hatten."}'),
  4, 10, 15, NOW()),
(UUID(), @l_de_past, 'Fill in: Wir _____ nach Hause gefahren', 'FILL_IN_BLANK',
  CONCAT('{"question":"Wir _____ nach Hause gefahren. We drove home. (Prateritum: sind)","answer":"waren","hints":["fahren Prateritum"],"explanation":"fahren uses sein: Wir waren gefahren."}'),
  5, 10, 15, NOW());

-- German B1 Lesson 3: Deutsch lesen - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_de_read, 'Reading strategy?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What is the best reading strategy for German texts?","options":["Read every word","Skim for main idea then scan for details","Start from the end","Translate word by word"],"correctIndex":1,"explanation":"Skim for main idea, then scan for specific details."}'),
  1, 10, 20, NOW()),
(UUID(), @l_de_read, 'Fill in: Der _____ = the text', 'FILL_IN_BLANK',
  CONCAT('{"question":"Der _____ (Text) in German means the text in English.","answer":"Text","hints":["reading"],"explanation":"Der Text = the text."}'),
  2, 10, 15, NOW()),
(UUID(), @l_de_read, 'Match reading words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Der Text","right":"The text"},{"left":"Der Absatz","right":"The paragraph"},{"left":"Die Uberschrift","right":"The heading"},{"left":"Das Thema","right":"The topic"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_de_read, 'What does ubersetzen mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Ubersetzen means:","options":["Read","Translate","Write","Speak"],"correctIndex":1,"explanation":"Ubersetzen = to translate."}'),
  4, 10, 15, NOW()),
(UUID(), @l_de_read, 'Fill in: Das _____ = the topic', 'FILL_IN_BLANK',
  CONCAT('{"question":"Das _____ (Thema) in German means the topic in English.","answer":"Thema","hints":["subject"],"explanation":"Das Thema = the topic."}'),
  5, 10, 15, NOW());

-- German B1 Lesson 4: Gesundheit - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_de_health, 'How to say I have a headache?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say I have a headache in German?","options":["Ich bin Kopfschmerzen","Ich habe Kopfschmerzen","Ich habe eine Krankheit","Ich bin krank"],"correctIndex":1,"explanation":"Ich habe Kopfschmerzen = I have a headache."}'),
  1, 10, 20, NOW()),
(UUID(), @l_de_health, 'Fill in: Der _____ = the doctor', 'FILL_IN_BLANK',
  CONCAT('{"question":"Der _____ (Arzt) in German means the doctor in English.","answer":"Arzt","hints":["medical"],"explanation":"Der Arzt = the doctor."}'),
  2, 10, 15, NOW()),
(UUID(), @l_de_health, 'Match health words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Kopfschmerzen","right":"Headache"},{"left":"Fieber","right":"Fever"},{"left":"Husten","right":"Cough"},{"left":"Die Apotheke","right":"Pharmacy"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_de_health, 'What does krank mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Krank means:","options":["Healthy","Strong","Sick","Tired"],"correctIndex":2,"explanation":"Krank = sick/ill."}'),
  4, 10, 15, NOW()),
(UUID(), @l_de_health, 'Fill in: Ich brauche einen _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Ich brauche einen _____. I need a doctor. (Arzt)","answer":"Arzt","hints":["medical"],"explanation":"Der Arzt = the doctor."}'),
  5, 10, 15, NOW());

-- German B1 Lesson 5: Kultur - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_de_kult, 'What does die Kultur mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Die Kultur means:","options":["History","Culture","Language","Geography"],"correctIndex":1,"explanation":"Die Kultur = culture."}'),
  1, 10, 15, NOW()),
(UUID(), @l_de_kult, 'Fill in: Die _____ = the tradition', 'FILL_IN_BLANK',
  CONCAT('{"question":"Die _____ (Tradition) in German means the tradition in English.","answer":"Tradition","hints":["custom"],"explanation":"Die Tradition = the tradition."}'),
  2, 10, 15, NOW()),
(UUID(), @l_de_kult, 'Match culture words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Die Kultur","right":"Culture"},{"left":"Die Tradition","right":"Tradition"},{"left":"Das Denkmal","right":"Monument"},{"left":"Die Kunst","right":"Art"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_de_kult, 'What does das Denkmal mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Das Denkmal means:","options":["Museum","Monument","Building","Temple"],"correctIndex":1,"explanation":"Das Denkmal = the monument."}'),
  4, 10, 15, NOW()),
(UUID(), @l_de_kult, 'Fill in: Die _____ = art', 'FILL_IN_BLANK',
  CONCAT('{"question":"Die _____ (Kunst) in German means art in English.","answer":"Kunst","hints":["creative"],"explanation":"Die Kunst = art."}'),
  5, 10, 15, NOW());

-- German B2 Lesson 1: Konjunktiv II - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_de_konj, 'How to form Konjunktiv II?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you form Konjunktiv II of regular verbs?","options":["verb + te + en","Stem + te + en","haben/waren + past participle","wurde + infinitive"],"correctIndex":1,"explanation":"Konjunktiv II: Stem + te + en. E.g., ware, hatte, konnte."}'),
  1, 10, 20, NOW()),
(UUID(), @l_de_konj, 'Fill in: Wenn ich Geld _____, wurde ich reisen', 'FILL_IN_BLANK',
  CONCAT('{"question":"Wenn ich Geld _____, wurde ich reisen. If I had money, I would travel. (hatte)","answer":"hatte","hints":["Konjunktiv II"],"explanation":"Konjunktiv II: ich hatte = I would have."}'),
  2, 10, 15, NOW()),
(UUID(), @l_de_konj, 'Match Konjunktiv II forms', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Ware","right":"I would be"},{"left":"Hatte","right":"I would have"},{"left":"Konnte","right":"I could"},{"left":"Wurde","right":"I would become"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_de_konj, 'Konjunktiv II of sein?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What is the Konjunktiv II of sein?","options":["Sein","War","Ware","Wurde"],"correctIndex":2,"explanation":"Ware = Konjunktiv II of sein."}'),
  4, 10, 15, NOW()),
(UUID(), @l_de_konj, 'Fill in: Ich _____ gern Deutscher', 'FILL_IN_BLANK',
  CONCAT('{"question":"Ich _____ gern Deutscher. I would like to be German. (ware)","answer":"ware","hints":["Konjunktiv II of sein"],"explanation":"ware = would be (Konjunktiv II)."}'),
  5, 10, 15, NOW());

-- German B2 Lesson 2: Nebensatze - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_de_neben, 'What does weil clause need?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"In a Nebensatz (subordinate clause), where does the verb go?","options":["At the end","At the beginning","In the middle","After the subject"],"correctIndex":0,"explanation":"In Nebensatze, the verb goes at the end of the clause."}'),
  1, 10, 20, NOW()),
(UUID(), @l_de_neben, 'Fill in: _____ ich krank bin, gehe ich zum Arzt', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____ ich krank bin, gehe ich zum Arzt. Because I am sick, I go to the doctor. (Weil)","answer":"Weil","hints":["because"],"explanation":"Weil introduces a Nebensatz with verb at the end: weil ich krank bin."}'),
  2, 10, 15, NOW()),
(UUID(), @l_de_neben, 'Match subordinating conjunctions', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Weil","right":"Because"},{"left":"Obwohl","right":"Although"},{"left":"Dass","right":"That"},{"left":"Wenn","right":"If/When"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_de_neben, 'Verb position in Nebensatz?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"In a Nebensatz introduced by obwohl, where is the verb?","options":["At the beginning","At the end","After the conjunction","Before the subject"],"correctIndex":1,"explanation":"Verb at the end of the Nebensatz: obwohl ich很累 bin."}'),
  4, 10, 15, NOW()),
(UUID(), @l_de_neben, 'Fill in: Er kam nicht, _____ er krank war', 'FILL_IN_BLANK',
  CONCAT('{"question":"Er kam nicht, _____ er krank war. He did not come because he was sick. (obwohl)","answer":"obwohl","hints":["although"],"explanation":"obwohl = although/even though."}'),
  5, 10, 15, NOW());

-- German B2 Lesson 3: Aufsatzschreiben - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_de_aufs, 'Essay structure?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"A standard German essay has how many parts?","options":["2 parts","3 parts","4 parts","5 parts"],"correctIndex":1,"explanation":"Standard German essay: Einleitung (introduction), Hauptteil (body), Schluss (conclusion) = 3 parts."}'),
  1, 10, 20, NOW()),
(UUID(), @l_de_aufs, 'Fill in: Die _____ = the introduction', 'FILL_IN_BLANK',
  CONCAT('{"question":"Die _____ (Einleitung) in German means the introduction in English.","answer":"Einleitung","hints":["beginning"],"explanation":"Die Einleitung = the introduction."}'),
  2, 10, 15, NOW()),
(UUID(), @l_de_aufs, 'Match essay parts', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Die Einleitung","right":"Introduction"},{"left":"Der Hauptteil","right":"Main body"},{"left":"Der Schluss","right":"Conclusion"},{"left":"Das Fazit","right":"Final remark"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_de_aufs, 'What does der Schluss mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Der Schluss means:","options":["Introduction","Main body","Conclusion","Summary only"],"correctIndex":2,"explanation":"Der Schluss = the conclusion."}'),
  4, 10, 15, NOW()),
(UUID(), @l_de_aufs, 'Fill in: Im _____ sollte man zusammenfassen', 'FILL_IN_BLANK',
  CONCAT('{"question":"Im _____ sollte man zusammenfassen. In the conclusion one should summarize. (Schluss)","answer":"Schluss","hints":["end"],"explanation":"Der Schluss = the conclusion."}'),
  5, 10, 15, NOW());

-- German B2 Lesson 4: Redewendungen - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_de_rede, 'Was ist los means?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Was ist los means:","options":["What is wrong","Where is it","What is going on","Who is there"],"correctIndex":2,"explanation":"Was ist los? = What is going on? / What is wrong?"}'),
  1, 10, 15, NOW()),
(UUID(), @l_de_rede, 'Fill in: Es _____ mir gut', 'FILL_IN_BLANK',
  CONCAT('{"question":"Es _____ mir gut. It is going well with me. (geht)","answer":"geht","hints":["go"],"explanation":"Es geht mir gut = I am doing well."}'),
  2, 10, 15, NOW()),
(UUID(), @l_de_rede, 'Match idioms', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Was ist los?","right":"What is going on?"},{"left":"Es geht mir gut","right":"I am doing well"},{"left":"Das ist mir egal","right":"I dont care"},{"left":"Ich habe keine Ahnung","right":"I have no idea"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_de_rede, 'What does ich habe keine Ahnung mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Ich habe keine Ahnung means:","options":["I dont know well","I have no idea","I think so","I am not sure"],"correctIndex":1,"explanation":"Ich habe keine Ahnung = I have no idea."}'),
  4, 10, 15, NOW()),
(UUID(), @l_de_rede, 'Fill in: Das ist mir _____', 'FILL_IN_BLANK',
  CONCAT('{"question":"Das ist mir _____. I dont care. (egal)","answer":"egal","hints":["same"],"explanation":"egal = the same (used idiomatically as I dont care)."}'),
  5, 10, 15, NOW());

-- German B2 Lesson 5: Debatte - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_de_debat, 'How to introduce argument?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you introduce an argument in German formal debate?","options":["Ich finde","Einerseits...andererseits","Das ist falsch","Ich weiss nicht"],"correctIndex":1,"explanation":"Einerseits...andererseits = on one hand...on the other hand."}'),
  1, 10, 20, NOW()),
(UUID(), @l_de_debat, 'Fill in: _____ sollte man argumentieren', 'FILL_IN_BLANK',
  CONCAT('{"question":"In einer Debatte _____ man argumentieren. In a debate one should argue. (sollte)","answer":"sollte","hints":["should"],"explanation":"sollte = should (Konjunktiv II of sollen)."}'),
  2, 10, 15, NOW()),
(UUID(), @l_de_debat, 'Match debate words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Einerseits","right":"On one hand"},{"left":"Andererseits","right":"On the other hand"},{"left":"Daher","right":"Therefore"},{"left":"Zusammenfassend","right":"In summary"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_de_debat, 'What does daher mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Daher means:","options":["However","Therefore","Because","Moreover"],"correctIndex":1,"explanation":"Daher = therefore/consequently."}'),
  4, 10, 15, NOW()),
(UUID(), @l_de_debat, 'Fill in: _____fassend lasse ich mich sagen', 'FILL_IN_BLANK',
  CONCAT('{"question":"_____fassend lasse ich mich sagen... In conclusion, let me say... (zu)","answer":"Zusammen","hints":["together"],"explanation":"Zusammenfassend = in summary."}'),
  5, 10, 15, NOW());

-- German Business Lesson 1: Grundlagen - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_de_busbase, 'Business German greeting?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you greet in German business email?","options":["Hallo Herr Muller","Sehr geehrter Herr Muller","Lieber Herr Muller","Hey Herr Muller"],"correctIndex":1,"explanation":"Sehr geehrter Herr Muller = Dear Mr. Muller (formal)."}'),
  1, 10, 20, NOW()),
(UUID(), @l_de_busbase, 'Fill in: Die _____ = the company', 'FILL_IN_BLANK',
  CONCAT('{"question":"Die _____ (Firma) in German business means the company in English.","answer":"Firma","hints":["business"],"explanation":"Die Firma = the company."}'),
  2, 10, 15, NOW()),
(UUID(), @l_de_busbase, 'Match business words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Die Firma","right":"Company"},{"left":"Der Geschaftspartner","right":"Business partner"},{"left":"Die Besprechung","right":"Meeting"},{"left":"Der Termin","right":"Appointment"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_de_busbase, 'What does der Geschaftspartner mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Der Geschaftspartner means:","options":["Customer","Business partner","Employee","Manager"],"correctIndex":1,"explanation":"Der Geschaftspartner = the business partner."}'),
  4, 10, 15, NOW()),
(UUID(), @l_de_busbase, 'Fill in: Ich mochte einen _____ machen', 'FILL_IN_BLANK',
  CONCAT('{"question":"Ich mochte einen _____ machen. I would like to make an appointment. (Termin)","answer":"Termin","hints":["appointment"],"explanation":"Der Termin = the appointment."}'),
  5, 10, 15, NOW());

-- German Business Lesson 2: Geschaftsbriefe - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_de_letter, 'Formal closing?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"What is the formal closing in a German business letter?","options":["Viele Grusse","Mit freundlichen Grussen","Liebe Grusse","Tschuss"],"correctIndex":1,"explanation":"Mit freundlichen Grussen = With kind regards (formal)."}'),
  1, 10, 20, NOW()),
(UUID(), @l_de_letter, 'Fill in: _____ Frau Schmidt,', 'FILL_IN_BLANK',
  CONCAT('{"question":"Sehr geehrte _____ Schmidt, Dear Mrs. Schmidt, (geehrte)","answer":"geehrte","hints":["formal"],"explanation":"Sehr geehrte Frau Schmidt = Dear Mrs. Schmidt (formal)."}'),
  2, 10, 15, NOW()),
(UUID(), @l_de_letter, 'Match letter phrases', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Sehr geehrte","right":"Dear (formal female)"},{"left":"Sehr geehrter","right":"Dear (formal male)"},{"left":"Mit freundlichen Grussen","right":"With kind regards"},{"left":"Hochachtungsvoll","right":"Yours faithfully"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_de_letter, 'Anrede =?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Anrede (die Anrede) in a letter means:","options":["Closing","Salutation/Greeting","Signature","Date"],"correctIndex":1,"explanation":"Die Anrede = the salutation or greeting in a letter."}'),
  4, 10, 15, NOW()),
(UUID(), @l_de_letter, 'Fill in: Ich _____ Sie auf einen Kaffee ein', 'FILL_IN_BLANK',
  CONCAT('{"question":"Ich _____ Sie auf einen Kaffee ein. I invite you for a coffee. (lade)","answer":"lade","hints":["invite"],"explanation":"einladen = to invite. Ich lade Sie ein."}'),
  5, 10, 15, NOW());

-- German Business Lesson 3: Besprechungen - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_de_besprec, 'Start meeting?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you start a formal meeting in German?","options":["Fangen wir an","Ich begrusse alle Anwesenden","Wir sind vollzahlig","Lasst uns reden"],"correctIndex":1,"explanation":"Ich begrusse alle Anwesenden = I welcome all those present (formal meeting opener)."}'),
  1, 10, 20, NOW()),
(UUID(), @l_de_besprec, 'Fill in: Die _____ = the agenda', 'FILL_IN_BLANK',
  CONCAT('{"question":"Die _____ (Tagesordnung) in German means the agenda in English.","answer":"Tagesordnung","hints":["day order"],"explanation":"Die Tagesordnung = the agenda."}'),
  2, 10, 15, NOW()),
(UUID(), @l_de_besprec, 'Match meeting words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Die Tagesordnung","right":"Agenda"},{"left":"Das Protokoll","right":"Minutes"},{"left":"Die Abstimmung","right":"Vote"},{"left":"Der Beschluss","right":"Resolution"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_de_besprec, 'What does das Protokoll mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Das Protokoll in a meeting context means:","options":["The agenda","The minutes","The vote","The resolution"],"correctIndex":1,"explanation":"Das Protokoll = the minutes (written record of a meeting)."}'),
  4, 10, 15, NOW()),
(UUID(), @l_de_besprec, 'Fill in: Gibt es _____ zu diesem Thema?', 'FILL_IN_BLANK',
  CONCAT('{"question":"Gibt es _____ zu diesem Thema? Are there any questions on this topic? (Fragen)","answer":"Fragen","hints":["questions"],"explanation":"Fragen = questions. Gibt es Fragen? = Are there questions?"}'),
  5, 10, 15, NOW());

-- German Business Lesson 4: Verhandeln - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_de_verh, 'How to make an offer?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say We can offer you 5 percent discount in German?","options":["Wir bieten funf Prozent Rabatt","Wir mochten funf Prozent","Wir haben funf Prozent","Wir geben funf Prozent"],"correctIndex":0,"explanation":"Wir bieten = we offer. Wir konnen Ihnen funf Prozent Rabatt anbieten."}'),
  1, 10, 20, NOW()),
(UUID(), @l_de_verh, 'Fill in: Der _____ = the price', 'FILL_IN_BLANK',
  CONCAT('{"question":"Der _____ (Preis) in German business means the price in English.","answer":"Preis","hints":["cost"],"explanation":"Der Preis = the price."}'),
  2, 10, 15, NOW()),
(UUID(), @l_de_verh, 'Match negotiation words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Anbieten","right":"To offer"},{"left":"Verhandeln","right":"To negotiate"},{"left":"Der Rabatt","right":"The discount"},{"left":"Der Vertrag","right":"The contract"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_de_verh, 'What does der Vertrag mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Der Vertrag means:","options":["Price","Contract","Discount","Offer"],"correctIndex":1,"explanation":"Der Vertrag = the contract."}'),
  4, 10, 15, NOW()),
(UUID(), @l_de_verh, 'Fill in: Wir _____ diesen Preis nicht', 'FILL_IN_BLANK',
  CONCAT('{"question":"Wir _____ diesen Preis nicht akzeptieren. We cannot accept this price. (konnen)","answer":"konnen","hints":["can"],"explanation":"konnen = can. Wir konnen diesen Preis nicht akzeptieren."}'),
  5, 10, 15, NOW());

-- German Business Lesson 5: BUro - 5 exercises
INSERT INTO exercises (id, lesson_id, title, type, question_data, order_index, points, time_limit_seconds, created_at) VALUES
(UUID(), @l_de_buero, 'How to schedule meeting?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"How do you say I would like to schedule an appointment in German?","options":["Ich mochte einen Termin verschieben","Ich mochte einen Termin vereinbaren","Ich brauche einen Kalender","Ich habe Zeit"],"correctIndex":1,"explanation":"einen Termin vereinbaren = to schedule an appointment."}'),
  1, 10, 20, NOW()),
(UUID(), @l_de_buero, 'Fill in: Der _____ = the calendar', 'FILL_IN_BLANK',
  CONCAT('{"question":"Der _____ (Kalender) in German means the calendar in English.","answer":"Kalender","hints":["schedule"],"explanation":"Der Kalender = the calendar."}'),
  2, 10, 15, NOW()),
(UUID(), @l_de_buero, 'Match office words', 'MATCHING',
  CONCAT('{"pairs":[{"left":"Der Kalender","right":"Calendar"},{"left":"Der Schreibtisch","right":"Desk"},{"left":"Die E-Mail","right":"Email"},{"left":"Die Besprechung","right":"Meeting"}]}'),
  3, 15, 30, NOW()),
(UUID(), @l_de_buero, 'What does die E-Mail mean?', 'MULTIPLE_CHOICE',
  CONCAT('{"question":"Die E-Mail means:","options":["Letter","Email","Fax","Phone call"],"correctIndex":1,"explanation":"Die E-Mail = the email."}'),
  4, 10, 15, NOW()),
(UUID(), @l_de_buero, 'Fill in: Bitte _____ Sie mir den Bericht', 'FILL_IN_BLANK',
  CONCAT('{"question":"Bitte _____ Sie mir den Bericht per E-Mail. Please send me the report. (senden)","answer":"senden","hints":["send"],"explanation":"senden = to send. Bitte senden Sie mir den Bericht."}'),
  5, 10, 15, NOW());

-- ============================================================
-- 7. LEARNING_PATHS
-- ============================================================
SET @lang_en2 = (SELECT id FROM languages WHERE code = 'en' LIMIT 1);
SET @lang_ja2 = (SELECT id FROM languages WHERE code = 'ja' LIMIT 1);
SET @lang_ko2 = (SELECT id FROM languages WHERE code = 'ko' LIMIT 1);
SET @lang_zh2 = (SELECT id FROM languages WHERE code = 'zh' LIMIT 1);
SET @lang_fr2 = (SELECT id FROM languages WHERE code = 'fr' LIMIT 1);

INSERT INTO learning_paths (id, language_id, created_by, title, description, thumbnail_url, target_level, goal, estimated_hours, is_published, is_official, created_at, updated_at) VALUES
(UUID(), @lang_en2, @admin_id, 'English Mastery: 0 to B2', 'Lộ trình học tiếng Anh từ con số 0 đến trình độ B2, giao tiếp lưu loát.', 'https://images.unsplash.com/photo-1546410531-bb4caa6b424d?w=500', 'INTERMEDIATE', 'Đạt B2 Cambridge, giao tiếp tự tin', 400, true, true, NOW(), NOW()),
(UUID(), @lang_en2, @admin_id, 'IELTS 7.0 Target', 'Lộ trình luyện thi IELTS từ đầu đến Band 7.0.', 'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?w=500', 'ADVANCED', 'Đạt IELTS 7.0', 600, true, true, NOW(), NOW()),
(UUID(), @lang_en2, @admin_id, 'Business English Pro', 'Tiếng Anh thương mại cho người đi làm, giao tiếp chuyên nghiệp.', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500', 'INTERMEDIATE', 'Giao tiếp thương mại B2-C1', 300, true, true, NOW(), NOW()),
(UUID(), @lang_ja2, @admin_id, 'JLPT N5 to N3 Journey', 'Từ số 0 đến JLPT N3 - Lộ trình tiếng Nhật chuẩn.', 'https://images.unsplash.com/photo-1528164344705-47542687000d?w=500', 'INTERMEDIATE', 'Đạt JLPT N3', 800, true, true, NOW(), NOW()),
(UUID(), @lang_ja2, @teacher_id, 'JLPT N5 Special', 'Khóa học tập trung JLPT N5 cho người mới bắt đầu học tiếng Nhật.', 'https://images.unsplash.com/photo-1580191947416-62d35a55e71d?w=500', 'BEGINNER', 'Đạt JLPT N5', 350, true, false, NOW(), NOW()),
(UUID(), @lang_ko2, @admin_id, 'Korean from Zero', 'Học tiếng Hàn từ Hangul đến giao tiếp cơ bản.', 'https://images.unsplash.com/photo-1601342630235-d7bd4c7b6105?w=500', 'BEGINNER', 'Giao tiếp cơ bản tiếng Hàn', 400, true, true, NOW(), NOW()),
(UUID(), @lang_zh2, @admin_id, 'Chinese HSK 1-3 Complete', 'Lộ trình tiếng Trung từ HSK 1 đến HSK 3.', 'https://images.unsplash.com/photo-1508804185872-d7badad00f7d?w=500', 'INTERMEDIATE', 'Đạt HSK 3', 500, true, true, NOW(), NOW()),
(UUID(), @lang_fr2, @teacher_id, 'French A1 to B1 Journey', 'Từ Debutant đến intermediate trong tiếng Pháp.', 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=500', 'INTERMEDIATE', 'Đạt DELF B1', 450, true, false, NOW(), NOW()),
(UUID(), @lang_en2, @admin_id, 'Kids English Fun', 'Lộ trình tiếng Anh vui nhộn cho trẻ em từ 6-12 tuổi.', 'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=500', 'BEGINNER', 'Cơ bản tiếng Anh cho trẻ', 300, true, true, NOW(), NOW()),
(UUID(), @lang_en2, @teacher_id, 'Travel English Essentials', 'Tiếng Anh giao tiếp cho người đi du lịch, 100 câu thiết yếu.', 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=500', 'BEGINNER', 'Giao tiếp khi đi du lịch', 100, true, false, NOW(), NOW());

-- ============================================================
-- 8. LEARNING_PATH_STEPS
-- ============================================================
SET @lp_en_b2   = (SELECT id FROM learning_paths WHERE title = 'English Mastery: 0 to B2' LIMIT 1);
SET @lp_ielts   = (SELECT id FROM learning_paths WHERE title = 'IELTS 7.0 Target' LIMIT 1);
SET @lp_bus     = (SELECT id FROM learning_paths WHERE title = 'Business English Pro' LIMIT 1);
SET @lp_ja_n3   = (SELECT id FROM learning_paths WHERE title = 'JLPT N5 to N3 Journey' LIMIT 1);
SET @lp_ja_n5   = (SELECT id FROM learning_paths WHERE title = 'JLPT N5 Special' LIMIT 1);
SET @lp_ko      = (SELECT id FROM learning_paths WHERE title = 'Korean from Zero' LIMIT 1);
SET @lp_zh      = (SELECT id FROM learning_paths WHERE title = 'Chinese HSK 1-3 Complete' LIMIT 1);
SET @lp_fr      = (SELECT id FROM learning_paths WHERE title = 'French A1 to B1 Journey' LIMIT 1);
SET @lp_travel  = (SELECT id FROM learning_paths WHERE title = 'Travel English Essentials' LIMIT 1);

SET @c_en_a1_b  = (SELECT id FROM courses WHERE title = 'English for Beginners A1' LIMIT 1);
SET @c_en_a2_b  = (SELECT id FROM courses WHERE title = 'English Elementary A2' LIMIT 1);
SET @c_en_b1_b  = (SELECT id FROM courses WHERE title = 'English Intermediate B1' LIMIT 1);
SET @c_en_bus_b = (SELECT id FROM courses WHERE title = 'Business English B2' LIMIT 1);
SET @c_ielts_b  = (SELECT id FROM courses WHERE title = 'IELTS Preparation' LIMIT 1);
SET @c_ja_n5_b  = (SELECT id FROM courses WHERE title = 'Japanese JLPT N5' LIMIT 1);
SET @c_ja_n4_b  = (SELECT id FROM courses WHERE title = 'Japanese JLPT N4' LIMIT 1);
SET @c_ja_n3_b  = (SELECT id FROM courses WHERE title = 'Japanese JLPT N3' LIMIT 1);
SET @c_ko_beg_b = (SELECT id FROM courses WHERE title = 'Korean for Beginners' LIMIT 1);
SET @c_ko_ele_b = (SELECT id FROM courses WHERE title = 'Korean Elementary' LIMIT 1);
SET @c_ko_int_b = (SELECT id FROM courses WHERE title = 'Korean Intermediate' LIMIT 1);
SET @c_zh_hsk1_b= (SELECT id FROM courses WHERE title = 'Chinese HSK 1' LIMIT 1);
SET @c_zh_hsk2_b= (SELECT id FROM courses WHERE title = 'Chinese HSK 2' LIMIT 1);
SET @c_zh_hsk3_b= (SELECT id FROM courses WHERE title = 'Chinese HSK 3' LIMIT 1);
SET @c_fr_a1_b  = (SELECT id FROM courses WHERE title = 'French A1 - Debutant' LIMIT 1);
SET @c_fr_a2_b  = (SELECT id FROM courses WHERE title = 'French A2 - Elementaire' LIMIT 1);

INSERT INTO learning_path_steps (id, learning_path_id, course_id, step_order, note, is_required) VALUES
(UUID(), @lp_en_b2,  @c_en_a1_b,  1, 'Bắt đầu từ bảng chữ cái và từ vựng cơ bản', true),
(UUID(), @lp_en_b2,  @c_en_a2_b,  2, 'Nâng cao ngữ pháp và mở rộng từ vựng', true),
(UUID(), @lp_en_b2,  @c_en_b1_b,  3, 'Phát triển kỹ năng giao tiếp lưu loát', true),
(UUID(), @lp_ielts,  @c_en_a2_b,  1, 'Xây dựng nền tảng trước khi luyện đề', true),
(UUID(), @lp_ielts,  @c_ielts_b,  2, 'Luyện đề IELTS chuyên sâu', true),
(UUID(), @lp_bus,    @c_en_b1_b,  1, 'Nền tảng B1 trước khi chuyên sâu business', true),
(UUID(), @lp_bus,    @c_en_bus_b, 2, 'Tiếng Anh thương mại chuyên nghiệp', true),
(UUID(), @lp_ja_n3,  @c_ja_n5_b, 1, 'Hoàn thành N5 là bắt buộc', true),
(UUID(), @lp_ja_n3,  @c_ja_n4_b, 2, 'Nâng cấp lên N4', true),
(UUID(), @lp_ja_n3,  @c_ja_n3_b, 3, 'Tiến lên N3', true),
(UUID(), @lp_ja_n5,  @c_ja_n5_b, 1, 'Khóa chính JLPT N5', true),
(UUID(), @lp_ko,     @c_ko_beg_b,1, 'Bắt đầu từ Hangul', true),
(UUID(), @lp_ko,     @c_ko_ele_b,2, 'Mở rộng từ vựng và ngữ pháp', true),
(UUID(), @lp_ko,     @c_ko_int_b,3, 'Giao tiếp trung cấp', true),
(UUID(), @lp_zh,     @c_zh_hsk1_b,1,'Bắt đầu HSK 1 - 150 từ đầu tiên', true),
(UUID(), @lp_zh,     @c_zh_hsk2_b,2,'Nâng cấp HSK 2', true),
(UUID(), @lp_zh,     @c_zh_hsk3_b,3,'Hoàn thành HSK 3', true),
(UUID(), @lp_fr,     @c_fr_a1_b, 1, 'Nền tảng A1 tiếng Pháp', true),
(UUID(), @lp_fr,     @c_fr_a2_b, 2, 'Nâng cấp A2', true),
(UUID(), @lp_travel, @c_en_a1_b, 1, 'Cơ bản tiếng Anh du lịch', true);

-- ============================================================
-- 9. USER_LEARNING_PATHS
-- ============================================================
SET @user_levan   = (SELECT id FROM users WHERE email = 'student.levan@langapp.com' LIMIT 1);
SET @user_tran    = (SELECT id FROM users WHERE email = 'student.tran@langapp.com' LIMIT 1);
SET @user_hoang   = (SELECT id FROM users WHERE email = 'student.hoang@langapp.com' LIMIT 1);
SET @user_linh    = (SELECT id FROM users WHERE email = 'student.linh@langapp.com' LIMIT 1);
SET @user_minh    = (SELECT id FROM users WHERE email = 'student.minh@langapp.com' LIMIT 1);
SET @user_hue     = (SELECT id FROM users WHERE email = 'student.hue@langapp.com' LIMIT 1);
SET @user_hanoi   = (SELECT id FROM users WHERE email = 'student.hanoi@langapp.com' LIMIT 1);
SET @user_saigon  = (SELECT id FROM users WHERE email = 'student.saigon@langapp.com' LIMIT 1);
SET @user_teacher = (SELECT id FROM users WHERE email = 'teacher.nguyen@langapp.com' LIMIT 1);

INSERT INTO user_learning_paths (id, user_id, learning_path_id, current_step, progress_percent, status, enrolled_at, updated_at) VALUES
(UUID(), @user_levan,   @lp_en_b2,  2, 66,  'IN_PROGRESS', NOW(), NOW()),
(UUID(), @user_tran,    @lp_ielts,  1, 50,  'IN_PROGRESS', NOW(), NOW()),
(UUID(), @user_hoang,   @lp_en_b2,  1, 33,  'IN_PROGRESS', NOW(), NOW()),
(UUID(), @user_linh,    @lp_ja_n5,  1, 100, 'COMPLETED',   NOW(), NOW()),
(UUID(), @user_minh,    @lp_ko,     1, 50,  'IN_PROGRESS', NOW(), NOW()),
(UUID(), @user_hue,     @lp_bus,    2, 50,  'PAUSED',       NOW(), NOW()),
(UUID(), @user_hanoi,   @lp_zh,     1, 100, 'COMPLETED',   NOW(), NOW()),
(UUID(), @user_saigon,  @lp_fr,     1, 50,  'IN_PROGRESS', NOW(), NOW()),
(UUID(), @user_teacher, @lp_ja_n3,  2, 33,  'IN_PROGRESS', NOW(), NOW()),
(UUID(), @user_levan,   @lp_travel, 1, 100, 'COMPLETED',   NOW(), NOW());

-- ============================================================
-- 10. USER_PROGRESS
-- ============================================================
SET @l_en_a1_greet = (SELECT id FROM lessons WHERE title = 'Greetings & Introductions' LIMIT 1);
SET @l_en_a1_num   = (SELECT id FROM lessons WHERE title = 'Numbers & Counting' LIMIT 1);
SET @l_en_a1_color = (SELECT id FROM lessons WHERE title = 'Colors & Shapes' LIMIT 1);
SET @l_en_a2_rout  = (SELECT id FROM lessons WHERE title = 'Daily Routines' LIMIT 1);
SET @l_ielts_rest = (SELECT id FROM lessons WHERE title = 'At the Restaurant' LIMIT 1);
SET @l_ja_n5_hira = (SELECT id FROM lessons WHERE title = 'Hiragana - Basic Syllabaries' LIMIT 1);
SET @l_ja_n5_gram = (SELECT id FROM lessons WHERE title = 'Basic Grammar Patterns' LIMIT 1);

INSERT INTO user_progress (id, user_id, course_id, lesson_id, status, score, attempts, time_spent_seconds, started_at, completed_at, updated_at) VALUES
(UUID(), @user_levan,  @c_en_a1_b, @l_en_a1_greet, 'COMPLETED',   90, 2, 600,  NOW() - INTERVAL 5 DAY, NOW() - INTERVAL 4 DAY, NOW()),
(UUID(), @user_levan,  @c_en_a1_b, @l_en_a1_num,  'COMPLETED',   80, 1, 480,  NOW() - INTERVAL 3 DAY, NOW() - INTERVAL 3 DAY, NOW()),
(UUID(), @user_levan,  @c_en_a1_b, @l_en_a1_color,'IN_PROGRESS', 60, 1, 300,  NOW() - INTERVAL 1 DAY, NULL, NOW()),
(UUID(), @user_tran,   @c_ielts_b, @l_ielts_rest, 'COMPLETED',   85, 2, 900,  NOW() - INTERVAL 7 DAY, NOW() - INTERVAL 6 DAY, NOW()),
(UUID(), @user_hoang,  @c_en_a2_b, @l_en_a2_rout, 'COMPLETED',   95, 1, 720,  NOW() - INTERVAL 2 DAY, NOW() - INTERVAL 1 DAY, NOW()),
(UUID(), @user_linh,   @c_ja_n5_b, @l_ja_n5_hira, 'COMPLETED',  100, 1, 1200, NOW() - INTERVAL 10 DAY, NOW() - INTERVAL 9 DAY, NOW()),
(UUID(), @user_linh,   @c_ja_n5_b, @l_ja_n5_gram,'COMPLETED',   75, 2, 900,  NOW() - INTERVAL 8 DAY, NOW() - INTERVAL 7 DAY, NOW()),
(UUID(), @user_tran,   @c_ielts_b, @l_ielts_rest, 'IN_PROGRESS', 0, 0, 0,    NOW(), NULL, NOW()),
(UUID(), @user_hoang,  @c_en_a2_b, @l_en_a2_rout,  'NOT_STARTED', 0, 0, 0,    NULL, NULL, NOW());

-- ============================================================
-- 11. USER_ONBOARDINGS
-- ============================================================
SET @lang_en3 = (SELECT id FROM languages WHERE code = 'en' LIMIT 1);
SET @lang_ja3 = (SELECT id FROM languages WHERE code = 'ja' LIMIT 1);
SET @lang_ko3 = (SELECT id FROM languages WHERE code = 'ko' LIMIT 1);
SET @lang_zh3 = (SELECT id FROM languages WHERE code = 'zh' LIMIT 1);
SET @lang_fr3 = (SELECT id FROM languages WHERE code = 'fr' LIMIT 1);
SET @user_admin3 = (SELECT id FROM users WHERE email = 'admin@langapp.com' LIMIT 1);

INSERT INTO user_onboardings (id, user_id, target_language_id, native_language_code, self_level, goal, daily_time, age_group, heard_from, completed, recommended_path_id, created_at, updated_at) VALUES
(UUID(), @user_levan,   @lang_en3, 'vi', 'BEGINNER',          'WORK',           'THIRTY_MIN', '18-24', 'Google Search',  true, @lp_en_b2,  NOW(), NOW()),
(UUID(), @user_tran,    @lang_en3, 'vi', 'INTERMEDIATE',       'SKILL_IMPROVEMENT', 'FIFTEEN_MIN', '25-34', 'Friend',         true, @lp_ielts,  NOW(), NOW()),
(UUID(), @user_hoang,   @lang_en3, 'vi', 'BEGINNER',          'TRAVEL',          'FIFTEEN_MIN', '18-24', 'Instagram',      true, @lp_travel, NOW(), NOW()),
(UUID(), @user_linh,    @lang_ja3, 'vi', 'COMPLETE_BEGINNER', 'WORK',           'THIRTY_MIN', '18-24', 'Facebook',        true, @lp_ja_n5,  NOW(), NOW()),
(UUID(), @user_minh,    @lang_ko3, 'vi', 'COMPLETE_BEGINNER', 'TRAVEL',         'FIFTEEN_MIN', '18-24', 'YouTube',         true, @lp_ko,     NOW(), NOW()),
(UUID(), @user_hue,     @lang_en3, 'vi', 'INTERMEDIATE',       'SKILL_IMPROVEMENT', 'SIXTY_MIN', '25-34', 'Google Search',  true, @lp_bus,    NOW(), NOW()),
(UUID(), @user_hanoi,   @lang_zh3, 'vi', 'BEGINNER',          'WORK',           'THIRTY_MIN', '18-24', 'Friend',          true, @lp_zh,     NOW(), NOW()),
(UUID(), @user_saigon,  @lang_fr3, 'vi', 'BEGINNER',          'FAMILY_FRIENDS',  'FIFTEEN_MIN', '18-24', 'Instagram',       true, @lp_fr,     NOW(), NOW()),
(UUID(), @user_admin3,  @lang_en3, 'vi', 'ADVANCED',          'SKILL_IMPROVEMENT', 'SIXTY_MIN', '35-44', 'Newsletter',     true, @lp_ielts,  NOW(), NOW()),
(UUID(), @user_teacher, @lang_ja3, 'vi', 'INTERMEDIATE',       'WORK',           'THIRTY_MIN', '25-34', 'Facebook',        true, @lp_ja_n3,  NOW(), NOW());

-- ============================================================
-- 12. SUBSCRIPTION_PLANS
-- ============================================================
INSERT INTO subscription_plans (id, name, description, price, duration_days, is_active) VALUES
(UUID(), 'FREE',        'Gói miễn phí cơ bản, truy cập một số bài học preview.', 0, 0, true),
(UUID(), 'PREMIUM',     'Gói Premium 1 tháng, truy cập tất cả bài học MONTHLY tier.', 99000, 30, true),
(UUID(), 'PRO_3MONTHS', 'Gói Pro 3 tháng, tiết kiệm 15%, truy cập UNLIMITED.', 249000, 90, true),
(UUID(), 'PRO_YEARLY',  'Gói Pro 1 năm, tiết kiệm 30%, truy cập toàn bộ nội dung.', 799000, 365, true),
(UUID(), 'STUDENT',     'Gói Student 6 tháng dành cho học sinh sinh viên.', 179000, 180, true),
(UUID(), 'TEACHER',     'Gói Teacher 1 năm dành cho giáo viên, tạo content.', 599000, 365, true),
(UUID(), 'FAMILY',      'Gói Family 1 năm cho gia đình 4 người.', 999000, 365, true),
(UUID(), 'ENTERPRISE',  'Gói doanh nghiệp tùy chỉnh theo nhu cầu công ty.', 2999000, 365, true),
(UUID(), 'TRIAL_7DAY',  'Dùng thử 7 ngày, truy cập tất cả tính năng premium.', 0, 7, true),
(UUID(), 'LIFETIME',    'Gói trọn đời, truy cập vĩnh viễn tất cả nội dung hiện tại và tương lai.', 2999000, 9999, true);

-- ============================================================
-- 13. SUBSCRIPTIONS
-- ============================================================
SET @plan_premium = (SELECT id FROM subscription_plans WHERE name = 'PREMIUM' LIMIT 1);
SET @plan_pro3    = (SELECT id FROM subscription_plans WHERE name = 'PRO_3MONTHS' LIMIT 1);
SET @plan_yearly  = (SELECT id FROM subscription_plans WHERE name = 'PRO_YEARLY' LIMIT 1);
SET @plan_free    = (SELECT id FROM subscription_plans WHERE name = 'FREE' LIMIT 1);

INSERT INTO subscriptions (id, user_id, plan, status, start_date, end_date, auto_renew, external_subscription_id, created_at, updated_at) VALUES
(UUID(), @user_levan,   'MONTHLY',     'ACTIVE',   NOW() - INTERVAL 5 DAY,  NOW() + INTERVAL 25 DAY,  true,  'vnpay_sub_001',  NOW(), NOW()),
(UUID(), @user_tran,    'THREE_MONTHS','ACTIVE',   NOW() - INTERVAL 20 DAY, NOW() + INTERVAL 70 DAY,  true,  'paypal_sub_002', NOW(), NOW()),
(UUID(), @user_hoang,  'FREE',       'ACTIVE',   NOW() - INTERVAL 60 DAY, NULL,                    false, NULL,             NOW(), NOW()),
(UUID(), @user_linh,   'YEARLY',      'ACTIVE',   NOW() - INTERVAL 100 DAY, NOW() + INTERVAL 265 DAY, true, 'vnpay_sub_003', NOW(), NOW()),
(UUID(), @user_minh,   'FREE',        'ACTIVE',   NOW() - INTERVAL 10 DAY, NULL,                    false, NULL,             NOW(), NOW()),
(UUID(), @user_hue,    'MONTHLY',     'EXPIRED',  NOW() - INTERVAL 45 DAY, NOW() - INTERVAL 15 DAY, false, 'vnpay_sub_004', NOW(), NOW()),
(UUID(), @user_hanoi,  'THREE_MONTHS','ACTIVE',   NOW() - INTERVAL 30 DAY, NOW() + INTERVAL 60 DAY, false, NULL,             NOW(), NOW()),
(UUID(), @user_saigon, 'FREE',        'ACTIVE',   NOW() - INTERVAL 3 DAY,  NULL,                    false, NULL,             NOW(), NOW()),
(UUID(), @user_teacher,'YEARLY',      'ACTIVE',   NOW() - INTERVAL 200 DAY, NOW() + INTERVAL 165 DAY, true, 'paypal_sub_005', NOW(), NOW()),
(UUID(), @user_admin3, 'YEARLY',      'ACTIVE',   NOW() - INTERVAL 300 DAY, NOW() + INTERVAL 65 DAY,  true, 'vnpay_sub_006', NOW(), NOW());

-- ============================================================
-- 14. USER_GAME_PROFILES
-- ============================================================
INSERT INTO user_game_profiles (id, user_id, total_xp, level, weekly_xp, weekly_xp_reset_at, current_streak, longest_streak, last_activity_at, streak_freeze_count, created_at, updated_at) VALUES
(UUID(), @user_levan,   1500,  5,  300, NOW() - INTERVAL 2 DAY, 7,  10, NOW() - INTERVAL 1 DAY, 2, NOW(), NOW()),
(UUID(), @user_tran,    3200,  8,  150, NOW() - INTERVAL 3 DAY, 3,  15, NOW() - INTERVAL 2 DAY, 3, NOW(), NOW()),
(UUID(), @user_hoang,   500,  3,  100, NOW() - INTERVAL 1 DAY, 1,   5, NOW(),                  3, NOW(), NOW()),
(UUID(), @user_linh,   8500, 18,  500, NOW() - INTERVAL 4 DAY, 30, 30, NOW() - INTERVAL 3 DAY, 1, NOW(), NOW()),
(UUID(), @user_minh,    750,  4,  200, NOW() - INTERVAL 1 DAY, 5,   7, NOW() - INTERVAL 1 DAY, 3, NOW(), NOW()),
(UUID(), @user_hue,    2200,  7,    0, NOW() - INTERVAL 6 DAY, 0,  12, NOW() - INTERVAL 6 DAY, 3, NOW(), NOW()),
(UUID(), @user_hanoi,  4100, 11,  350, NOW() - INTERVAL 2 DAY, 10, 20, NOW() - INTERVAL 2 DAY, 2, NOW(), NOW()),
(UUID(), @user_saigon,  300,  2,   80, NOW() - INTERVAL 1 DAY, 2,   3, NOW() - INTERVAL 1 DAY, 3, NOW(), NOW()),
(UUID(), @user_teacher, 9500, 20,  600, NOW() - INTERVAL 1 DAY, 45, 45, NOW() - INTERVAL 1 DAY, 3, NOW(), NOW()),
(UUID(), @user_admin3,   12000, 25,  800, NOW() - INTERVAL 1 DAY, 60, 60, NOW(),                  3, NOW(), NOW());

-- ============================================================
-- 15. USER_BADGES
-- ============================================================
INSERT INTO user_badges (id, user_id, badge_type, earned_at) VALUES
(UUID(), @user_levan,   'FIRST_LESSON',  NOW() - INTERVAL 20 DAY),
(UUID(), @user_levan,   'LESSONS_10',    NOW() - INTERVAL 10 DAY),
(UUID(), @user_levan,   'STREAK_7',      NOW() - INTERVAL 7 DAY),
(UUID(), @user_levan,   'XP_1000',       NOW() - INTERVAL 5 DAY),
(UUID(), @user_levan,   'HIGH_SCORER',   NOW() - INTERVAL 3 DAY),
(UUID(), @user_tran,    'FIRST_LESSON',  NOW() - INTERVAL 30 DAY),
(UUID(), @user_tran,    'LESSONS_50',    NOW() - INTERVAL 15 DAY),
(UUID(), @user_tran,    'STREAK_30',     NOW() - INTERVAL 10 DAY),
(UUID(), @user_tran,    'XP_5000',       NOW() - INTERVAL 8 DAY),
(UUID(), @user_tran,    'FIRST_COURSE',  NOW() - INTERVAL 5 DAY),
(UUID(), @user_hoang,   'FIRST_LESSON',  NOW() - INTERVAL 10 DAY),
(UUID(), @user_hoang,   'LESSONS_10',    NOW() - INTERVAL 5 DAY),
(UUID(), @user_hoang,   'EARLY_BIRD',    NOW() - INTERVAL 3 DAY),
(UUID(), @user_linh,    'FIRST_LESSON',  NOW() - INTERVAL 50 DAY),
(UUID(), @user_linh,    'LESSONS_50',    NOW() - INTERVAL 30 DAY),
(UUID(), @user_linh,    'STREAK_30',     NOW() - INTERVAL 25 DAY),
(UUID(), @user_linh,    'XP_5000',       NOW() - INTERVAL 20 DAY),
(UUID(), @user_linh,    'LESSONS_100',   NOW() - INTERVAL 10 DAY),
(UUID(), @user_linh,    'PERFECT_SCORE', NOW() - INTERVAL 5 DAY),
(UUID(), @user_minh,    'FIRST_LESSON',  NOW() - INTERVAL 15 DAY),
(UUID(), @user_minh,    'LESSONS_10',    NOW() - INTERVAL 7 DAY),
(UUID(), @user_minh,    'STREAK_7',      NOW() - INTERVAL 5 DAY),
(UUID(), @user_hue,     'FIRST_LESSON',  NOW() - INTERVAL 40 DAY),
(UUID(), @user_hue,     'LESSONS_50',    NOW() - INTERVAL 20 DAY),
(UUID(), @user_hue,     'STREAK_30',     NOW() - INTERVAL 12 DAY),
(UUID(), @user_hue,     'XP_5000',       NOW() - INTERVAL 10 DAY),
(UUID(), @user_hanoi,   'FIRST_LESSON',  NOW() - INTERVAL 60 DAY),
(UUID(), @user_hanoi,   'LESSONS_100',   NOW() - INTERVAL 40 DAY),
(UUID(), @user_hanoi,   'STREAK_30',     NOW() - INTERVAL 35 DAY),
(UUID(), @user_hanoi,   'XP_10000',      NOW() - INTERVAL 20 DAY),
(UUID(), @user_hanoi,   'FIRST_COURSE',  NOW() - INTERVAL 15 DAY),
(UUID(), @user_saigon,  'FIRST_LESSON',  NOW() - INTERVAL 5 DAY),
(UUID(), @user_saigon,  'LESSONS_10',    NOW() - INTERVAL 3 DAY),
(UUID(), @user_teacher, 'FIRST_LESSON',  NOW() - INTERVAL 100 DAY),
(UUID(), @user_teacher, 'LESSONS_100',   NOW() - INTERVAL 80 DAY),
(UUID(), @user_teacher, 'STREAK_100',    NOW() - INTERVAL 60 DAY),
(UUID(), @user_teacher, 'XP_10000',      NOW() - INTERVAL 50 DAY),
(UUID(), @user_teacher, 'FIRST_COURSE',  NOW() - INTERVAL 40 DAY),
(UUID(), @user_teacher, 'COURSES_5',     NOW() - INTERVAL 30 DAY),
(UUID(), @user_teacher, 'HIGH_SCORER',   NOW() - INTERVAL 20 DAY),
(UUID(), @user_teacher, 'POLYGLOT',      NOW() - INTERVAL 15 DAY),
(UUID(), @user_admin3,  'STREAK_100',    NOW() - INTERVAL 200 DAY),
(UUID(), @user_admin3,  'XP_10000',      NOW() - INTERVAL 180 DAY),
(UUID(), @user_admin3,  'LESSONS_100',   NOW() - INTERVAL 150 DAY),
(UUID(), @user_admin3,  'COURSES_5',     NOW() - INTERVAL 120 DAY),
(UUID(), @user_admin3,  'PERFECT_SCORE', NOW() - INTERVAL 100 DAY),
(UUID(), @user_admin3,  'POLYGLOT',      NOW() - INTERVAL 90 DAY),
(UUID(), @user_admin3,  'NIGHT_OWL',     NOW() - INTERVAL 80 DAY),
(UUID(), @user_admin3,  'HIGH_SCORER',   NOW() - INTERVAL 60 DAY);

-- ============================================================
-- 16. STUDY_LOGS
-- ============================================================
SET @l_en_a1_greet2 = (SELECT id FROM lessons WHERE title = 'Greetings & Introductions' LIMIT 1);
SET @l_en_a1_num2   = (SELECT id FROM lessons WHERE title = 'Numbers & Counting' LIMIT 1);
SET @l_en_a2_rout2  = (SELECT id FROM lessons WHERE title = 'Daily Routines' LIMIT 1);
SET @l_ja_n5_hira2 = (SELECT id FROM lessons WHERE title = 'Hiragana - Basic Syllabaries' LIMIT 1);
SET @l_ko_hangul   = (SELECT id FROM lessons WHERE title = 'Hangul - Korean Alphabet' LIMIT 1);
SET @l_zh_num       = (SELECT id FROM lessons WHERE title = 'Chinese Pinyin Basics' LIMIT 1);

INSERT INTO study_logs (id, user_id, lesson_id, study_date, duration_seconds, score, activity_type, created_at) VALUES
(UUID(), @user_levan,   @l_en_a1_greet2,  CURDATE() - INTERVAL 5 DAY, 900,  90, 'LESSON_VIEW',           NOW() - INTERVAL 5 DAY),
(UUID(), @user_levan,   @l_en_a1_num2,    CURDATE() - INTERVAL 4 DAY, 600,  80, 'EXERCISE_SUBMIT',       NOW() - INTERVAL 4 DAY),
(UUID(), @user_tran,    @l_en_a2_rout2,   CURDATE() - INTERVAL 7 DAY, 1200, 85, 'LESSON_VIEW',           NOW() - INTERVAL 7 DAY),
(UUID(), @user_tran,    @l_en_a2_rout2,   CURDATE() - INTERVAL 6 DAY, 300,  85, 'AI_CHAT',               NOW() - INTERVAL 6 DAY),
(UUID(), @user_hoang,   @l_en_a1_greet2,  CURDATE() - INTERVAL 3 DAY, 450,  70, 'EXERCISE_SUBMIT',       NOW() - INTERVAL 3 DAY),
(UUID(), @user_linh,    @l_ja_n5_hira2,   CURDATE() - INTERVAL 10 DAY, 1800, 100, 'LESSON_VIEW',          NOW() - INTERVAL 10 DAY),
(UUID(), @user_linh,    @l_ja_n5_hira2,   CURDATE() - INTERVAL 9 DAY, 900,  75, 'PRONUNCIATION_PRACTICE', NOW() - INTERVAL 9 DAY),
(UUID(), @user_minh,    @l_ko_hangul,     CURDATE() - INTERVAL 2 DAY, 1200, 95, 'LESSON_VIEW',           NOW() - INTERVAL 2 DAY),
(UUID(), @user_hanoi,   @l_zh_num,         CURDATE() - INTERVAL 15 DAY, 1500, 80, 'EXERCISE_SUBMIT',       NOW() - INTERVAL 15 DAY),
(UUID(), @user_teacher, @l_ja_n5_hira2,   CURDATE() - INTERVAL 20 DAY, 2400, 100, 'LESSON_VIEW',          NOW() - INTERVAL 20 DAY);

-- ============================================================
-- 17. USER_EXERCISE_ATTEMPTS
-- ============================================================
SET @ex_greet_mc   = (SELECT id FROM exercises WHERE title = 'Choose correct greeting at 3 PM' LIMIT 1);
SET @ex_greet_fill = (SELECT id FROM exercises WHERE title = 'Complete: My name _____ John' LIMIT 1);
SET @ex_num        = (SELECT id FROM exercises WHERE title = 'What comes after 15?' LIMIT 1);
SET @ex_color      = (SELECT id FROM exercises WHERE title = 'Match colors to objects' LIMIT 1);
SET @ex_rout       = (SELECT id FROM exercises WHERE title = 'Complete with correct verb' LIMIT 1);
SET @ex_rest       = (SELECT id FROM exercises WHERE title = 'Listen and choose the correct answer' LIMIT 1);
SET @ex_hira       = (SELECT id FROM exercises WHERE title = 'Which hiragana reads as ka?' LIMIT 1);
SET @ex_hangul     = (SELECT id FROM exercises WHERE title = 'Match Hangul to sound' LIMIT 1);
SET @ex_zh         = (SELECT id FROM exercises WHERE title = 'What is "ichi" in number?' LIMIT 1);
SET @ex_fr_sal     = (SELECT id FROM exercises WHERE title = 'Les Salutations' LIMIT 1);

INSERT INTO user_exercise_attempts (id, user_id, exercise_id, lesson_id, selected_answer, is_correct, score, time_spent_seconds, submitted_at) VALUES
(UUID(), @user_levan,   @ex_greet_mc,   @l_en_a1_greet2, 'Good afternoon', true,  10, 20, NOW() - INTERVAL 5 DAY),
(UUID(), @user_levan,   @ex_greet_fill, @l_en_a1_greet2, 'is',              true,  10, 15, NOW() - INTERVAL 5 DAY),
(UUID(), @user_levan,   @ex_num,         @l_en_a1_num2,  'Sixteen',         true,  10, 10, NOW() - INTERVAL 4 DAY),
(UUID(), @user_tran,    @ex_rout,       @l_en_a2_rout2,  'wakes up',        true,  10, 25, NOW() - INTERVAL 7 DAY),
(UUID(), @user_tran,    @ex_rest,        @l_ielts_rest,  'Coffee and cake', true,  15, 40, NOW() - INTERVAL 6 DAY),
(UUID(), @user_hoang,   @ex_greet_mc,   @l_en_a1_greet2, 'Good morning',    false, 0,  20, NOW() - INTERVAL 3 DAY),
(UUID(), @user_linh,    @ex_hira,         @l_ja_n5_hira2,  'か',              true,  10, 18, NOW() - INTERVAL 10 DAY),
(UUID(), @user_minh,    @ex_hangul,      @l_ko_hangul,   'g or k, n, d or t, m', true, 15, 35, NOW() - INTERVAL 2 DAY),
(UUID(), @user_saigon,  @ex_fr_sal,      @l_en_a1_greet2, 'Maria',           true,  10, 20, NOW() - INTERVAL 1 DAY),
(UUID(), @user_hanoi,   @ex_zh,          @l_zh_num,       '1',                true,  10, 28, NOW() - INTERVAL 15 DAY);

-- ============================================================
-- 18. AI_INTERACTION_LOGS
-- ============================================================
SET @ll_model = 'llama-3.3-70b-versatile';

INSERT INTO ai_interaction_logs (id, user_id, interaction_type, model, prompt, response, input_tokens, output_tokens, total_tokens, cost, status, latency_ms, lesson_id, created_at) VALUES
(UUID(), @user_levan,   'CHAT_EXPLAIN',       @ll_model, 'Explain the difference between who and whom in English', 'Who is the subject form and whom is the object form. Use whom after a preposition or when it sounds more formal.', 120, 280, 400, 0.0004, 'SUCCESS', 1200, @l_en_a1_greet2, NOW() - INTERVAL 4 DAY),
(UUID(), @user_tran,    'GRAMMAR_CHECK',       @ll_model, 'Check grammar: She does not like coffee', 'Correct version: She does not like coffee. Use does not (not do not) with third person singular (she/he/it).', 80, 200, 280, 0.0003, 'SUCCESS', 900, @l_en_a2_rout2, NOW() - INTERVAL 6 DAY),
(UUID(), @user_hoang,   'RECOMMENDATION',       @ll_model, 'I want to improve my English speaking. Recommend me a course.', 'Based on your level (A2), I recommend the English Elementary A2 course, focusing on vocabulary and daily conversation patterns.', 150, 350, 500, 0.0005, 'SUCCESS', 1500, NULL, NOW() - INTERVAL 3 DAY),
(UUID(), @user_linh,    'PRONUNCIATION',        'whisper-1', 'Practice: Watashi wa nihongo wo benkyou shimasu', 'Good pronunciation. Your pitch accent needs work on benkyou. The second syllable should be higher.', 60, 180, 240, 0.0002, 'SUCCESS', 3000, @l_ja_n5_hira2, NOW() - INTERVAL 9 DAY),
(UUID(), @user_minh,    'CHAT_EXPLAIN',         @ll_model, 'How do I introduce myself in Korean?', 'Say: Annyeonghaseyo, [name]-imnida for formal, or Annyeong, [name]-eyo for casual. Use -imnida for formal business introductions.', 90, 250, 340, 0.0004, 'SUCCESS', 1100, @l_ko_hangul, NOW() - INTERVAL 2 DAY),
(UUID(), @user_hue,     'GRAMMAR_CHECK',        @ll_model, 'Check: If I would have money I would travel', 'Correct: If I had money, I would travel. Second conditional: past simple + would + infinitive.', 70, 190, 260, 0.0003, 'SUCCESS', 800, NULL, NOW() - INTERVAL 12 DAY),
(UUID(), @user_hanoi,   'PLACEMENT_TEST',       @ll_model, 'Test my Chinese level with this sentence: Wo hen xihuan chi pingguo', 'Your Chinese is HSK 1 level. The sentence is grammatically correct. Next step: HSK 2 vocabulary.', 110, 300, 410, 0.0005, 'SUCCESS', 1400, @l_zh_num, NOW() - INTERVAL 15 DAY),
(UUID(), @user_saigon,  'CHAT_EXPLAIN',         @ll_model, 'How do I say Where is the bathroom? in French?', 'Say: Où sont les toilettes, s il vous plaît? (formal) or C est où les toilettes? (informal).', 100, 220, 320, 0.0004, 'SUCCESS', 1000, @l_en_a1_greet2, NOW() - INTERVAL 1 DAY),
(UUID(), @user_teacher, 'PRONUNCIATION',         'whisper-1', 'Student practice: Kore wa ii desu ne', 'Excellent. Clear pronunciation with proper pitch patterns. Minor issue: desu ending could be slightly softer.', 50, 150, 200, 0.0002, 'SUCCESS', 2500, @l_ja_n5_gram, NOW() - INTERVAL 20 DAY),
(UUID(), @user_admin3,  'RECOMMENDATION',        @ll_model, 'Build a personalized 6-month learning plan for B2 English', 'Month 1-2: Focus on B1+ grammar (passive voice, modals). Month 3-4: Business vocabulary and email writing. Month 5-6: Speaking fluency and IELTS strategies.', 200, 600, 800, 0.0008, 'SUCCESS', 2000, NULL, NOW() - INTERVAL 50 DAY);

-- ============================================================
-- XONG! Seed data hoàn tất.
-- ============================================================
-- Cấu trúc: 10 languages × 5 courses × 5 lessons × 5 exercises = 1,250 exercises
-- Chạy file này sau khi đã tạo bảng trong database

