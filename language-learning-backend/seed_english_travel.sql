-- ==============================================================
-- Seed: English for Travel (A1)
-- 1 Course | 1 Lesson | 3 Exercises
-- Không trùng ID / tiêu đề với dữ liệu có sẵn
-- ==============================================================
-- Yêu cầu trước khi chạy:
--   language_id  = e486a571-4952-11f1-a796-e00af6a25786  (English)
--   created_by   = e48a01bc-4952-11f1-a796-e00af6a25786  (admin)
-- ==============================================================

SET NAMES utf8mb4;
SET foreign_key_checks = 0;

-- ──────────────────────────────────────────────────────────────
-- 1. COURSE
-- ──────────────────────────────────────────────────────────────
INSERT IGNORE INTO `courses`
  (`id`, `created_at`, `description`, `is_published`, `level`,
   `thumbnail_url`, `title`, `total_lessons`, `updated_at`,
   `created_by`, `language_id`)
VALUES (
  'f9a00001-f9a0-4000-9000-f9a000000001',
  '2026-05-13 10:00:00.000000',
  'Tiếng Anh du lịch thực chiến: sân bay, khách sạn, nhà hàng — giao tiếp tự tin khi đi nước ngoài.',
  b'1',
  'BEGINNER',
  'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=500',
  'English for Travel',
  5,
  '2026-05-13 10:00:00.000000',
  'e48a01bc-4952-11f1-a796-e00af6a25786',
  'e486a571-4952-11f1-a796-e00af6a25786'
);

-- ──────────────────────────────────────────────────────────────
-- 2. LESSON
-- ──────────────────────────────────────────────────────────────
INSERT IGNORE INTO `lessons`
  (`id`, `access_tier`, `audio_url`, `content`, `created_at`,
   `duration_minutes`, `is_free`, `order_index`, `title`, `type`,
   `updated_at`, `video_url`, `course_id`)
VALUES (
  'f9b00001-f9b0-4000-9000-f9b000000001',
  'PREVIEW',
  'https://audio.example.com/en_travel_airport.mp3',
  '<h2>At the Airport</h2>
<p>Learn essential phrases for checking in, finding gates, and handling common airport situations.</p>
<h3>Key Vocabulary</h3>
<ul>
  <li><strong>boarding pass</strong> — thẻ lên máy bay</li>
  <li><strong>departure gate</strong> — cổng khởi hành</li>
  <li><strong>check-in desk</strong> — quầy check-in</li>
  <li><strong>carry-on luggage</strong> — hành lý xách tay</li>
  <li><strong>delayed</strong> — bị trễ</li>
</ul>
<h3>Useful Phrases</h3>
<ul>
  <li>Where is gate 12? — Cổng 12 ở đâu?</li>
  <li>My flight is delayed. — Chuyến bay của tôi bị trễ.</li>
  <li>I have only carry-on luggage. — Tôi chỉ có hành lý xách tay.</li>
</ul>',
  '2026-05-13 10:00:00.000000',
  20,
  b'1',
  1,
  'At the Airport',
  'LISTENING',
  '2026-05-13 10:00:00.000000',
  'https://www.youtube.com/watch?v=example_en_travel_airport',
  'f9a00001-f9a0-4000-9000-f9a000000001'
);

-- ──────────────────────────────────────────────────────────────
-- 3. EXERCISES (3 bài — không trùng ID có sẵn)
-- ──────────────────────────────────────────────────────────────
INSERT IGNORE INTO `exercises`
  (`id`, `created_at`, `order_index`, `points`, `question_data`,
   `time_limit_seconds`, `title`, `type`, `lesson_id`)
VALUES

-- Bài 1: MULTIPLE_CHOICE
(
  'f9c00001-f9c0-4000-9000-f9c000000001',
  '2026-05-13 10:00:00.000000',
  1, 10,
  '{"question":"\"Boarding pass\" trong tiếng Việt nghĩa là gì?","options":["Hộ chiếu","Thẻ lên máy bay","Vé máy bay","Thẻ hành lý"],"correctIndex":1,"explanation":"Boarding pass = thẻ lên máy bay. Passport = hộ chiếu. Ticket = vé."}',
  20,
  'Boarding pass có nghĩa là gì?',
  'MULTIPLE_CHOICE',
  'f9b00001-f9b0-4000-9000-f9b000000001'
),

-- Bài 2: FILL_IN_BLANK
(
  'f9c00001-f9c0-4000-9000-f9c000000002',
  '2026-05-13 10:00:00.000000',
  2, 10,
  '{"question":"\"Excuse me, where is the departure _____?\" (cổng khởi hành)","answer":"gate","hints":["nơi lên máy bay"],"explanation":"Departure gate = cổng khởi hành. Ví dụ: Gate 12, Gate 5A."}',
  20,
  'Điền: where is the departure _____?',
  'FILL_IN_BLANK',
  'f9b00001-f9b0-4000-9000-f9b000000001'
),

-- Bài 3: MATCHING
(
  'f9c00001-f9c0-4000-9000-f9c000000003',
  '2026-05-13 10:00:00.000000',
  3, 10,
  '{"pairs":[{"left":"check-in desk","right":"quầy làm thủ tục"},{"left":"delayed","right":"bị trễ"},{"left":"carry-on luggage","right":"hành lý xách tay"},{"left":"boarding pass","right":"thẻ lên máy bay"}],"explanation":"Từ vựng sân bay cơ bản — cần thuộc lòng trước khi đi du lịch."}',
  30,
  'Nối từ vựng sân bay',
  'MATCHING',
  'f9b00001-f9b0-4000-9000-f9b000000001'
);

SET foreign_key_checks = 1;

-- ==============================================================
-- FORMAT JSON cho LISTENING_CHOICE (để riêng, chưa INSERT)
-- Dùng khi bài tập yêu cầu nghe audio rồi chọn đáp án
-- ==============================================================
--
-- INSERT IGNORE INTO `exercises`
--   (`id`, `created_at`, `order_index`, `points`, `question_data`,
--    `time_limit_seconds`, `title`, `type`, `lesson_id`)
-- VALUES (
--   'f9c00001-f9c0-4000-9000-f9c000000004',
--   '2026-05-13 10:00:00.000000',
--   4, 15,
--   '{
--     "audioUrl": "https://audio.example.com/en_airport_announcement.mp3",
--     "transcript": "Attention passengers: Flight VN302 to Da Nang is now boarding at Gate 7B. Please have your boarding pass and passport ready.",
--     "question": "Chuyến bay VN302 đang lên máy bay ở cổng nào?",
--     "options": ["Gate 2B", "Gate 7A", "Gate 7B", "Gate 3B"],
--     "correctIndex": 2,
--     "explanation": "Thông báo nói: boarding at Gate 7B."
--   }',
--   45,
--   'Nghe thông báo sân bay — chọn đáp án đúng',
--   'LISTENING_CHOICE',
--   'f9b00001-f9b0-4000-9000-f9b000000001'
-- );
--
-- Giải thích các field của LISTENING_CHOICE:
--   audioUrl    — URL file audio (.mp3) phát cho học viên nghe
--   transcript  — nội dung lời thoại (có thể ẩn hoặc hiện sau khi trả lời)
--   question    — câu hỏi sau khi nghe
--   options[]   — 4 lựa chọn
--   correctIndex — chỉ số đáp án đúng (0-based)
--   explanation — giải thích sau khi trả lời
-- ==============================================================
