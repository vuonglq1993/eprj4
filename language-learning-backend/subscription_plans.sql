-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th4 21, 2026 lúc 05:23 AM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `language_learning`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `subscription_plans`
--

CREATE TABLE `subscription_plans` (
  `id` varchar(36) NOT NULL,
  `description` text DEFAULT NULL,
  `duration_days` int(11) NOT NULL,
  `is_active` bit(1) NOT NULL,
  `name` varchar(100) NOT NULL,
  `price` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `subscription_plans`
--

INSERT INTO `subscription_plans` (`id`, `description`, `duration_days`, `is_active`, `name`, `price`) VALUES
('3d5db2f3-2cd2-11f1-9729-586c2541c3a9', 'Gói miễn phí - truy cập bài học cơ bản, giới hạn AI', 0, b'1', 'FREE', 0),
('3d5dc5f2-2cd2-11f1-9729-586c2541c3a9', 'Gói tháng - truy cập toàn bộ tính năng Premium', 30, b'1', 'MONTHLY', 99000),
('3d5dc686-2cd2-11f1-9729-586c2541c3a9', 'Gói năm - tiết kiệm hơn 30% so với gói tháng', 365, b'1', 'YEARLY', 799000),
('ac74e138-7a35-46a5-9128-8a149fdc328a', NULL, 300, b'1', 'WEEKLY', 700);

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `subscription_plans`
--
ALTER TABLE `subscription_plans`
  ADD PRIMARY KEY (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
