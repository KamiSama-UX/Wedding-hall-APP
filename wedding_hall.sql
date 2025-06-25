-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 23, 2025 at 09:09 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `wedding hall`
--

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `hall_id` int(11) NOT NULL,
  `guest_count` int(11) NOT NULL,
  `event_date` date NOT NULL,
  `status` enum('pending','confirmed','declined','cancelled') DEFAULT 'pending',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `event_time` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`id`, `customer_id`, `hall_id`, `guest_count`, `event_date`, `status`, `created_at`, `updated_at`, `event_time`) VALUES
(1, 4, 1, 150, '2025-06-25', 'confirmed', '2025-05-16 21:01:32', '2025-05-16 21:01:32', '18:00:00'),
(2, 5, 2, 300, '2025-06-26', 'declined', '2025-05-16 21:01:32', '2025-06-19 15:13:39', '17:00:00'),
(3, 4, 3, 100, '2025-06-27', 'declined', '2025-05-16 21:01:32', '2025-06-19 16:10:22', '20:00:00'),
(4, 11, 8, 180, '2025-07-10', 'confirmed', '2025-06-19 02:08:22', '2025-06-19 02:08:22', '17:30:00'),
(5, 12, 9, 220, '2025-07-15', 'pending', '2025-06-19 02:08:22', '2025-06-19 02:08:22', '19:00:00'),
(6, 5, 10, 150, '2025-07-20', 'confirmed', '2025-06-19 02:08:22', '2025-06-19 02:08:22', '18:00:00'),
(7, 6, 11, 300, '2025-08-05', 'pending', '2025-06-19 02:08:22', '2025-06-19 02:08:22', '20:00:00'),
(8, 14, 12, 200, '2025-08-12', 'confirmed', '2025-06-19 02:08:22', '2025-06-19 02:08:22', '17:00:00'),
(9, 14, 1, 100, '2025-07-01', 'pending', '2025-06-21 18:30:20', '2025-06-21 18:30:20', '18:00:00'),
(10, 14, 1, 100, '2025-07-03', 'pending', '2025-06-21 18:47:14', '2025-06-21 18:47:14', '18:00:00'),
(11, 14, 1, 100, '2025-07-04', 'pending', '2025-06-21 18:47:48', '2025-06-21 18:47:48', '18:00:00'),
(13, 14, 10, 100, '2025-07-04', 'pending', '2025-06-21 18:49:18', '2025-06-21 18:49:18', '18:00:00'),
(14, 14, 10, 100, '2025-07-05', 'declined', '2025-06-21 18:49:48', '2025-06-23 20:05:50', '18:00:00'),
(19, 14, 10, 100, '2025-07-09', 'confirmed', '2025-06-21 19:29:52', '2025-06-23 20:05:47', '18:00:00'),
(20, 14, 10, 100, '2025-07-11', 'pending', '2025-06-21 19:33:20', '2025-06-21 19:33:20', '18:00:00'),
(21, 14, 10, 100, '2025-07-21', 'declined', '2025-06-21 19:41:03', '2025-06-23 20:05:41', '18:00:00'),
(22, 14, 10, 100, '2025-07-01', 'confirmed', '2025-06-21 19:44:57', '2025-06-21 19:46:29', '18:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `booking_services`
--

CREATE TABLE `booking_services` (
  `id` int(11) NOT NULL,
  `booking_id` int(11) NOT NULL,
  `service_id` int(11) NOT NULL,
  `price_at_booking` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `booking_services`
--

INSERT INTO `booking_services` (`id`, `booking_id`, `service_id`, `price_at_booking`) VALUES
(1, 4, 23, 100.00),
(2, 5, 26, 100.00),
(3, 6, 24, 100.00),
(4, 7, 27, 100.00),
(5, 8, 25, 100.00),
(8, 4, 30, 75.00),
(9, 4, 31, 500.00),
(10, 5, 32, 1200.00),
(11, 6, 34, 350.00),
(12, 7, 36, 700.00),
(13, 8, 38, 8.00),
(14, 14, 34, 350.00),
(17, 19, 34, 350.00),
(18, 20, 34, 350.00),
(19, 21, 34, 350.00),
(20, 22, 34, 350.00);

-- --------------------------------------------------------

--
-- Table structure for table `email_verification_codes`
--

CREATE TABLE `email_verification_codes` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `code` varchar(10) NOT NULL,
  `expires_at` datetime NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hall_photos`
--

CREATE TABLE `hall_photos` (
  `id` int(11) NOT NULL,
  `hall_id` int(11) NOT NULL,
  `photo_url` varchar(255) NOT NULL,
  `uploaded_at` datetime DEFAULT current_timestamp(),
  `is_cover` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hall_photos`
--

INSERT INTO `hall_photos` (`id`, `hall_id`, `photo_url`, `uploaded_at`, `is_cover`) VALUES
(53, 1, '/uploads/1750333439922-526524139.png', '2025-06-19 15:44:00', 1),
(54, 1, '/uploads/1750333460509-466163985.png', '2025-06-19 15:44:20', 0),
(55, 2, '/uploads/1750333548445-736392176.png', '2025-06-19 15:45:48', 1),
(56, 2, '/uploads/1750333680975-836715116.png', '2025-06-19 15:48:00', 0),
(57, 3, '/uploads/1750333708898-3433158.png', '2025-06-19 15:48:28', 0),
(58, 3, '/uploads/1750333726611-891803169.png', '2025-06-19 15:48:46', 1),
(59, 8, '/uploads/1750333786405-352477162.png', '2025-06-19 15:49:46', 0),
(60, 8, '/uploads/1750333815738-161177944.png', '2025-06-19 15:50:15', 1),
(61, 9, '/uploads/1750333886006-244125164.png', '2025-06-19 15:51:26', 1),
(62, 9, '/uploads/1750333900363-254890005.png', '2025-06-19 15:51:40', 0),
(63, 10, '/uploads/1750333938493-926157066.png', '2025-06-19 15:52:18', 0),
(64, 10, '/uploads/1750333961311-551664130.png', '2025-06-19 15:52:41', 1),
(65, 11, '/uploads/1750334025008-8166001.png', '2025-06-19 15:53:45', 0),
(66, 11, '/uploads/1750334050528-638826629.png', '2025-06-19 15:54:10', 1),
(67, 12, '/uploads/1750334070681-844478068.png', '2025-06-19 15:54:30', 0),
(68, 12, '/uploads/1750334086742-554297920.png', '2025-06-19 15:54:46', 1),
(69, 13, '/uploads/1750334225797-874174302.png', '2025-06-19 15:57:05', 1),
(70, 13, '/uploads/1750334340791-677004337.png', '2025-06-19 15:59:00', 0);

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

CREATE TABLE `logs` (
  `id` int(11) NOT NULL,
  `actor_id` int(11) NOT NULL,
  `action` varchar(255) NOT NULL,
  `target_type` varchar(50) DEFAULT NULL,
  `target_id` int(11) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `logs`
--

INSERT INTO `logs` (`id`, `actor_id`, `action`, `target_type`, `target_id`, `description`, `created_at`) VALUES
(1, 1, 'confirmed_booking', 'booking', 1, 'Booking 1 marked as confirmed by admin 1', '2025-05-16 21:01:32'),
(2, 1, 'reassigned_hall', 'hall', 1, 'Hall 1 reassigned to sub_admin 2', '2025-05-16 21:01:32'),
(3, 1, 'deleted_user', 'user', 6, 'User 6 deleted by admin 1', '2025-05-16 21:01:32'),
(6, 1, 'confirmed_booking', 'booking', 2, 'Booking 2 marked as confirmed by admin 1', '2025-06-15 16:21:06'),
(7, 1, 'pending_booking', 'booking', 2, 'Booking 2 marked as pending by admin 1', '2025-06-15 16:21:28'),
(8, 1, 'confirmed_booking', 'booking', 2, 'Booking 2 marked as confirmed by admin 1', '2025-06-15 16:21:34'),
(9, 1, 'pending_booking', 'booking', 2, 'Booking 2 marked as pending by admin 1', '2025-06-15 16:21:40'),
(10, 1, 'declined_booking', 'booking', 2, 'Booking 2 marked as declined by admin 1', '2025-06-15 16:21:47'),
(11, 1, 'pending_booking', 'booking', 2, 'Booking 2 marked as pending by admin 1', '2025-06-15 16:21:51'),
(12, 1, 'confirmed_booking', 'booking', 2, 'Booking 2 marked as confirmed by admin 1', '2025-06-15 16:21:59'),
(13, 1, 'pending_booking', 'booking', 2, 'Booking 2 marked as pending by admin 1', '2025-06-15 16:28:46'),
(14, 1, 'pending_booking', 'booking', 1, 'Booking 1 marked as pending by admin 1', '2025-06-15 18:19:21'),
(15, 1, 'declined_booking', 'booking', 1, 'Booking 1 marked as declined by admin 1', '2025-06-15 18:19:25'),
(16, 1, 'cancelled_booking', 'booking', 1, 'Booking 1 marked as cancelled by admin 1', '2025-06-15 18:19:29'),
(17, 1, 'confirmed_booking', 'booking', 1, 'Booking 1 marked as confirmed by admin 1', '2025-06-15 18:37:38'),
(18, 1, 'confirmed_booking', 'booking', 1, 'Booking 1 marked as confirmed by admin 1', '2025-06-15 18:38:23'),
(19, 1, 'declined_booking', 'booking', 3, 'Booking 3 marked as declined by admin 1', '2025-06-15 18:38:36'),
(20, 1, 'pending_booking', 'booking', 3, 'Booking 3 marked as pending by admin 1', '2025-06-15 18:43:31'),
(21, 1, 'declined_booking', 'booking', 2, 'Booking 2 marked as declined by admin 1', '2025-06-15 18:47:39'),
(22, 1, 'cancelled_booking', 'booking', 3, 'Booking 3 marked as cancelled by admin 1', '2025-06-15 18:48:03'),
(23, 1, 'pending_booking', 'booking', 3, 'Booking 3 marked as pending by admin 1', '2025-06-15 18:56:17'),
(24, 1, 'cancelled_booking', 'booking', 2, 'Booking 2 marked as cancelled by admin 1', '2025-06-15 19:04:47'),
(25, 1, 'confirmed_booking', 'booking', 3, 'Booking 3 marked as confirmed by admin 1', '2025-06-15 19:13:04'),
(26, 1, 'confirmed_booking', 'booking', 2, 'Booking 2 marked as confirmed by admin 1', '2025-06-15 19:13:19'),
(27, 1, 'declined_booking', 'booking', 3, 'Booking 3 marked as declined by admin 1', '2025-06-15 19:14:03'),
(28, 1, 'declined_booking', 'booking', 2, 'Booking 2 marked as declined by admin 1', '2025-06-15 19:14:06'),
(29, 1, 'confirmed_booking', 'booking', 3, 'Booking 3 marked as confirmed by admin 1', '2025-06-15 19:51:51'),
(30, 1, 'declined_booking', 'booking', 3, 'Booking 3 marked as declined by admin 1', '2025-06-15 19:51:54'),
(31, 1, 'pending_booking', 'booking', 3, 'Booking 3 marked as pending by admin 1', '2025-06-15 19:51:57'),
(32, 1, 'confirmed_booking', 'booking', 3, 'Booking 3 marked as confirmed by admin 1', '2025-06-16 20:10:17'),
(33, 1, 'pending_booking', 'booking', 3, 'Booking 3 marked as pending by admin 1', '2025-06-16 20:10:20'),
(34, 1, 'pending_booking', 'booking', 1, 'Booking 1 marked as pending by admin 1', '2025-06-16 20:15:13'),
(35, 1, 'confirmed_booking', 'booking', 1, 'Booking 1 marked as confirmed by admin 1', '2025-06-16 20:15:16'),
(36, 1, 'declined_booking', 'booking', 3, 'Booking 3 marked as declined by admin 1', '2025-06-16 20:15:19'),
(37, 1, 'confirmed_booking', 'booking', 3, 'Booking 3 marked as confirmed by admin 1', '2025-06-16 20:15:21'),
(38, 1, 'created_hall', 'hall', 8, 'Created new hall: Crystal Ballroom', '2025-06-19 02:08:22'),
(39, 3, 'updated_service', 'service', 16, 'Updated pricing for Premium Catering', '2025-06-19 02:08:22'),
(40, 1, 'confirmed_booking', 'booking', 4, 'Confirmed booking #4', '2025-06-19 02:08:22'),
(41, 4, 'uploaded_photo', 'hall_photo', 50, 'Added venue photos', '2025-06-19 02:08:22'),
(42, 1, 'processed_payment', 'payment', 1, 'Payment received for booking #4', '2025-06-19 02:08:22'),
(43, 1, 'declined_booking', 'booking', 3, 'Booking 3 marked as declined by admin 1', '2025-06-19 15:13:19'),
(44, 1, 'pending_booking', 'booking', 3, 'Booking 3 marked as pending by admin 1', '2025-06-19 15:13:25'),
(45, 1, 'declined_booking', 'booking', 2, 'Booking 2 marked as declined by admin 1', '2025-06-19 15:13:39'),
(46, 1, 'pending_booking', 'booking', 3, 'Booking 3 marked as pending by admin 1', '2025-06-19 15:13:41'),
(47, 1, 'declined_booking', 'booking', 3, 'Booking 3 marked as declined by admin 1', '2025-06-19 16:10:22'),
(48, 1, 'declined_booking', 'booking', 21, 'Booking 21 marked as declined by admin 1', '2025-06-23 20:05:41'),
(49, 1, 'confirmed_booking', 'booking', 19, 'Booking 19 marked as confirmed by admin 1', '2025-06-23 20:05:47'),
(50, 1, 'declined_booking', 'booking', 14, 'Booking 14 marked as declined by admin 1', '2025-06-23 20:05:50');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `type` enum('booking','system') DEFAULT 'booking',
  `message` text NOT NULL,
  `related_booking_id` int(11) DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `type`, `message`, `related_booking_id`, `is_read`, `created_at`) VALUES
(1, 2, 'booking', 'New booking received for Emerald Palace', 1, 0, '2025-05-16 21:01:32'),
(2, 3, 'booking', 'New booking received for Royal Garden', 2, 0, '2025-05-16 21:01:32'),
(3, 3, 'booking', 'New booking request for Golden Gate Venue', 5, 0, '2025-06-19 02:08:22'),
(4, 4, 'booking', 'Booking confirmed for Azure Gardens', 8, 0, '2025-06-19 02:08:22'),
(5, 5, 'system', 'Your payment for Crystal Ballroom was received', 4, 0, '2025-06-19 02:08:22'),
(6, 3, 'booking', 'New booking for Hall ID 10 on 2025-07-05 at 18:00', 14, 0, '2025-06-21 18:49:52'),
(7, 14, '', 'Booking #19 for 2025-07-09 at 18:00 is pending', 19, 0, '2025-06-21 19:29:52'),
(8, 3, '', 'New booking #19 for Hall 10 on 2025-07-09 at 18:00', 19, 0, '2025-06-21 19:29:52'),
(9, 14, '', 'Booking #20 for 2025-07-11 at 18:00 is pending', 20, 0, '2025-06-21 19:33:20'),
(10, 3, '', 'New booking #20 for Hall 10 on 2025-07-11 at 18:00', 20, 0, '2025-06-21 19:33:20'),
(11, 14, '', 'Booking #21 for 2025-07-21 at 18:00 is pending', 21, 0, '2025-06-21 19:41:03'),
(12, 3, '', 'New booking #21 for Hall 10 on 2025-07-21 at 18:00', 21, 0, '2025-06-21 19:41:03'),
(13, 14, '', 'Booking #22 for 2025-07-01 at 18:00 is pending', 22, 0, '2025-06-21 19:44:57'),
(14, 3, '', 'New booking #22 for Hall 10 on 2025-07-01 at 18:00', 22, 0, '2025-06-21 19:44:57');

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_codes`
--

CREATE TABLE `password_reset_codes` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `code` varchar(10) NOT NULL,
  `expires_at` datetime NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` int(11) NOT NULL,
  `booking_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `status` enum('pending','paid','failed','refunded') DEFAULT 'pending',
  `payment_method` varchar(50) DEFAULT NULL,
  `paid_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`id`, `booking_id`, `amount`, `status`, `payment_method`, `paid_at`, `created_at`) VALUES
(1, 4, 18000.00, 'paid', 'credit_card', '2025-06-20 14:30:00', '2025-06-19 02:08:22'),
(2, 6, 15000.00, 'paid', 'bank_transfer', '2025-06-25 11:15:00', '2025-06-19 02:08:22'),
(3, 8, 20000.00, 'paid', 'credit_card', '2025-07-01 09:45:00', '2025-06-19 02:08:22');

-- --------------------------------------------------------

--
-- Table structure for table `saved_halls`
--

CREATE TABLE `saved_halls` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `hall_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `saved_halls`
--

INSERT INTO `saved_halls` (`id`, `user_id`, `hall_id`, `created_at`) VALUES
(1, 5, 8, '2025-06-19 02:08:22'),
(2, 5, 3, '2025-06-19 02:08:22'),
(3, 6, 9, '2025-06-19 02:08:22'),
(4, 11, 1, '2025-06-19 02:08:22'),
(5, 12, 12, '2025-06-19 02:08:22'),
(6, 14, 10, '2025-06-19 02:08:22'),
(7, 14, 2, '2025-06-19 02:08:22');

-- --------------------------------------------------------

--
-- Table structure for table `services`
--

CREATE TABLE `services` (
  `id` int(11) NOT NULL,
  `hall_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `price_per_person` decimal(10,2) NOT NULL,
  `pricing_type` enum('static','invitation_based') DEFAULT 'invitation_based',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `services`
--

INSERT INTO `services` (`id`, `hall_id`, `name`, `price_per_person`, `pricing_type`, `created_at`, `updated_at`) VALUES
(9, 1, 'Cost per person reservation', 100.00, 'invitation_based', '2025-06-15 20:41:55', '2025-06-19 16:17:28'),
(17, 2, 'Cost per person reservation', 100.00, 'invitation_based', '2025-06-19 02:05:43', '2025-06-19 02:05:43'),
(18, 3, 'Cost per person reservation', 100.00, 'invitation_based', '2025-06-19 02:05:43', '2025-06-19 02:05:43'),
(23, 8, 'Cost per person reservation', 100.00, 'invitation_based', '2025-06-19 02:08:22', '2025-06-19 02:08:22'),
(24, 10, 'Cost per person reservation', 100.00, 'invitation_based', '2025-06-19 02:08:22', '2025-06-19 02:08:22'),
(25, 12, 'Cost per person reservation', 100.00, 'invitation_based', '2025-06-19 02:08:22', '2025-06-19 02:08:22'),
(26, 9, 'Cost per person reservation', 100.00, 'invitation_based', '2025-06-19 02:08:22', '2025-06-19 02:08:22'),
(27, 11, 'Cost per person reservation', 100.00, 'invitation_based', '2025-06-19 02:08:22', '2025-06-19 02:08:22'),
(30, 8, 'Premium Catering', 75.00, 'invitation_based', '2025-06-19 02:08:22', '2025-06-19 02:08:22'),
(31, 8, 'Floral Arrangements', 500.00, 'static', '2025-06-19 02:08:22', '2025-06-19 02:08:22'),
(32, 9, 'Live Band', 1200.00, 'static', '2025-06-19 02:08:22', '2025-06-19 02:08:22'),
(33, 9, 'Photography Package', 800.00, 'static', '2025-06-19 02:08:22', '2025-06-19 02:08:22'),
(34, 10, 'Vintage Decor', 350.00, 'static', '2025-06-19 02:08:22', '2025-06-19 02:08:22'),
(35, 10, 'Dessert Bar', 12.00, 'invitation_based', '2025-06-19 02:08:22', '2025-06-19 02:08:22'),
(36, 11, 'Lighting Effects', 700.00, 'static', '2025-06-19 02:08:22', '2025-06-19 02:08:22'),
(37, 11, 'Custom Cake', 400.00, 'static', '2025-06-19 02:08:22', '2025-06-19 02:08:22'),
(38, 12, 'Valet Service', 8.00, 'invitation_based', '2025-06-19 02:08:22', '2025-06-19 02:08:22'),
(39, 12, 'toast', 10.00, 'invitation_based', '2025-06-19 02:08:22', '2025-06-19 16:18:29'),
(40, 13, 'Cost per person reservation', 100.00, 'invitation_based', '2025-06-19 15:14:32', '2025-06-19 16:18:14'),
(41, 3, 'Fake invited Croud to look popular', 1000.00, 'static', '2025-06-19 16:19:30', '2025-06-22 17:05:37'),
(42, 1, 'Golden AXE', 500.00, 'static', '2025-06-22 17:01:17', '2025-06-22 17:05:51');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('admin','sub_admin','customer') NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_verified` tinyint(1) DEFAULT 0,
  `token_version` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password_hash`, `role`, `created_at`, `updated_at`, `is_verified`, `token_version`) VALUES
(1, 'abdulhamied', 'abdulhamied_203997@example.com', '$2b$10$zHA19eWPsyS.ewhffOJi5OBcXkIox7PFEnZXG69IPxCaPKxFg0BCe', 'admin', '2025-05-15 22:29:55', '2025-06-19 16:13:11', 1, 0),
(2, 'Aasem', 'Aasem_187587@example.com', '$2b$10$zHA19eWPsyS.ewhffOJi5OBcXkIox7PFEnZXG69IPxCaPKxFg0BCe', 'admin', '2025-05-16 21:01:32', '2025-06-23 23:06:59', 1, 0),
(3, 'abdulhamied', 'subadmin1@example.com', '$2b$10$zHA19eWPsyS.ewhffOJi5OBcXkIox7PFEnZXG69IPxCaPKxFg0BCe', 'sub_admin', '2025-05-16 21:01:32', '2025-06-23 23:08:01', 1, 0),
(4, 'Aasem', 'subadmin2@example.com', '$2b$10$zHA19eWPsyS.ewhffOJi5OBcXkIox7PFEnZXG69IPxCaPKxFg0BCe', 'sub_admin', '2025-05-16 21:01:32', '2025-06-23 23:08:27', 1, 0),
(5, 'Raneem', 'Raneem_205774@example.com', '$2b$10$zHA19eWPsyS.ewhffOJi5OBcXkIox7PFEnZXG69IPxCaPKxFg0BCe', 'customer', '2025-05-16 21:01:32', '2025-06-23 23:07:48', 1, 0),
(6, 'Customer B', 'customer2@example.com', '$2b$10$zHA19eWPsyS.ewhffOJi5OBcXkIox7PFEnZXG69IPxCaPKxFg0BCe', 'customer', '2025-05-16 21:01:32', '2025-06-19 16:08:08', 1, 0),
(7, 'Test User', 'testuser@example.com', '$2b$10$zHA19eWPsyS.ewhffOJi5OBcXkIox7PFEnZXG69IPxCaPKxFg0BCe', 'customer', '2025-05-17 00:57:40', '2025-06-19 16:08:12', 0, 0),
(8, 'Test User332', 'testu2ser@example.com', '$2b$10$zHA19eWPsyS.ewhffOJi5OBcXkIox7PFEnZXG69IPxCaPKxFg0BCe', 'customer', '2025-05-17 01:01:47', '2025-06-19 16:08:16', 0, 0),
(9, 'Aeswswswm', 'A2em@ewsmple.com', '$2b$10$zHA19eWPsyS.ewhffOJi5OBcXkIox7PFEnZXG69IPxCaPKxFg0BCe', 'customer', '2025-05-20 19:20:20', '2025-06-19 16:08:18', 0, 0),
(10, 'abdulhamied', 'futuerforus.8@gmail.com', '$2b$10$zHA19eWPsyS.ewhffOJi5OBcXkIox7PFEnZXG69IPxCaPKxFg0BCe', 'admin', '2025-05-20 19:23:22', '2025-06-19 16:08:21', 1, 0),
(11, 'Aasem', 'Aasem.8@gmail.com', '$2b$10$zHA19eWPsyS.ewhffOJi5OBcXkIox7PFEnZXG69IPxCaPKxFg0BCe', 'customer', '2025-05-21 11:10:39', '2025-06-19 16:08:23', 1, 0),
(12, 'John Doe', 'johndoe@gmail.com', '$2b$10$zHA19eWPsyS.ewhffOJi5OBcXkIox7PFEnZXG69IPxCaPKxFg0BCe', 'customer', '2025-05-23 01:13:15', '2025-06-19 16:08:26', 1, 0),
(13, 'John T.Doe', 'john23doe@gmail.com', '$2b$10$zHA19eWPsyS.ewhffOJi5OBcXkIox7PFEnZXG69IPxCaPKxFg0BCe', 'customer', '2025-06-18 16:09:12', '2025-06-19 16:08:30', 0, 0),
(14, 'customer', 'customer@test.com', '$2b$10$zHA19eWPsyS.ewhffOJi5OBcXkIox7PFEnZXG69IPxCaPKxFg0BCe', 'customer', '2025-06-19 01:07:35', '2025-06-19 16:08:35', 1, 0),
(15, 'Admin Alex', 'admin1@fake.com', '$2b$10$zHA19eWPsyS.ewhffOJi5OBcXkIox7PFEnZXG69IPxCaPKxFg0BCe', 'admin', '2025-06-19 02:08:22', '2025-06-19 16:08:39', 1, 0),
(16, 'Admin Taylor', 'admin2@fake.com', '$2b$10$zHA19eWPsyS.ewhffOJi5OBcXkIox7PFEnZXG69IPxCaPKxFg0BCe', 'admin', '2025-06-19 02:08:22', '2025-06-19 16:08:43', 1, 0),
(17, 'SubAdmin Jordan', 'subadmin3@fake.com', '$2b$10$zHA19eWPsyS.ewhffOJi5OBcXkIox7PFEnZXG69IPxCaPKxFg0BCe', 'sub_admin', '2025-06-19 02:08:22', '2025-06-19 16:08:45', 1, 0),
(18, 'SubAdmin Morgan', 'subadmin4@fake.com', '$2b$10$zHA19eWPsyS.ewhffOJi5OBcXkIox7PFEnZXG69IPxCaPKxFg0BCe', 'sub_admin', '2025-06-19 02:08:22', '2025-06-19 16:08:51', 1, 0),
(19, 'Customer Chris', 'customer3@fake.com', '$2b$10$zHA19eWPsyS.ewhffOJi5OBcXkIox7PFEnZXG69IPxCaPKxFg0BCe', 'customer', '2025-06-19 02:08:22', '2025-06-19 16:08:54', 1, 0),
(20, 'Customer Riley', 'customer4@fake.com', '$2b$10$zHA19eWPsyS.ewhffOJi5OBcXkIox7PFEnZXG69IPxCaPKxFg0BCe', 'customer', '2025-06-19 02:08:22', '2025-06-19 16:08:58', 1, 0),
(21, 'Customer Casey', 'customer5@fake.com', '$2b$10$zHA19eWPsyS.ewhffOJi5OBcXkIox7PFEnZXG69IPxCaPKxFg0BCe', 'customer', '2025-06-19 02:08:22', '2025-06-19 16:09:01', 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `wedding_halls`
--

CREATE TABLE `wedding_halls` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `location` varchar(255) DEFAULT NULL,
  `capacity` int(11) NOT NULL,
  `description` text DEFAULT NULL,
  `sub_admin_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `wedding_halls`
--

INSERT INTO `wedding_halls` (`id`, `name`, `location`, `capacity`, `description`, `sub_admin_id`, `created_at`, `updated_at`) VALUES
(1, 'Emerald Palace', 'Downtown', 300, 'Elegant modern hall', 2, '2025-05-16 21:01:32', '2025-05-16 21:01:32'),
(2, 'Royal Garden', 'Uptown', 500, 'Luxury with outdoor space', 3, '2025-05-16 21:01:32', '2025-05-16 21:01:32'),
(3, 'Sunset Venue', 'Beachfront', 200, 'Scenic beachside weddings', 3, '2025-05-16 21:01:32', '2025-05-16 21:01:32'),
(8, 'Crystal Ballroom', 'Financial District', 400, 'Grand crystal chandeliers', 3, '2025-06-19 02:08:22', '2025-06-19 02:08:22'),
(9, 'Golden Gate Venue', 'Harbor Front', 350, 'Panoramic water views', 4, '2025-06-19 02:08:22', '2025-06-19 02:08:22'),
(10, 'Sapphire Pavilion', 'Historic District', 250, 'Victorian architecture', 3, '2025-06-19 02:08:22', '2025-06-19 02:08:22'),
(11, 'Ivory Tower Hall', 'University Area', 500, 'Academic elegance', 4, '2025-06-19 02:08:22', '2025-06-19 02:08:22'),
(12, 'Azure Gardens', 'Riverside', 300, 'Floral paradise', 3, '2025-06-19 02:08:22', '2025-06-19 02:08:22'),
(13, 'yuusha', '123456', 400, 'Elegant modern hall0', 3, '2025-06-19 15:14:17', '2025-06-19 15:14:17');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_hall_booking` (`hall_id`,`event_date`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `event_date` (`event_date`,`hall_id`);

--
-- Indexes for table `booking_services`
--
ALTER TABLE `booking_services`
  ADD PRIMARY KEY (`id`),
  ADD KEY `booking_id` (`booking_id`),
  ADD KEY `service_id` (`service_id`);

--
-- Indexes for table `email_verification_codes`
--
ALTER TABLE `email_verification_codes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `hall_photos`
--
ALTER TABLE `hall_photos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `hall_id` (`hall_id`);

--
-- Indexes for table `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_reset_codes`
--
ALTER TABLE `password_reset_codes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `booking_id` (`booking_id`);

--
-- Indexes for table `saved_halls`
--
ALTER TABLE `saved_halls`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_favorite` (`user_id`,`hall_id`),
  ADD KEY `hall_id` (`hall_id`);

--
-- Indexes for table `services`
--
ALTER TABLE `services`
  ADD PRIMARY KEY (`id`),
  ADD KEY `hall_id` (`hall_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `wedding_halls`
--
ALTER TABLE `wedding_halls`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sub_admin_id` (`sub_admin_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `booking_services`
--
ALTER TABLE `booking_services`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `email_verification_codes`
--
ALTER TABLE `email_verification_codes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `hall_photos`
--
ALTER TABLE `hall_photos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=71;

--
-- AUTO_INCREMENT for table `logs`
--
ALTER TABLE `logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `password_reset_codes`
--
ALTER TABLE `password_reset_codes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `saved_halls`
--
ALTER TABLE `saved_halls`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `services`
--
ALTER TABLE `services`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `wedding_halls`
--
ALTER TABLE `wedding_halls`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`hall_id`) REFERENCES `wedding_halls` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `booking_services`
--
ALTER TABLE `booking_services`
  ADD CONSTRAINT `booking_services_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `booking_services_ibfk_2` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `email_verification_codes`
--
ALTER TABLE `email_verification_codes`
  ADD CONSTRAINT `email_verification_codes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `hall_photos`
--
ALTER TABLE `hall_photos`
  ADD CONSTRAINT `hall_photos_ibfk_1` FOREIGN KEY (`hall_id`) REFERENCES `wedding_halls` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `password_reset_codes`
--
ALTER TABLE `password_reset_codes`
  ADD CONSTRAINT `password_reset_codes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `saved_halls`
--
ALTER TABLE `saved_halls`
  ADD CONSTRAINT `saved_halls_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `saved_halls_ibfk_2` FOREIGN KEY (`hall_id`) REFERENCES `wedding_halls` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `services`
--
ALTER TABLE `services`
  ADD CONSTRAINT `services_ibfk_1` FOREIGN KEY (`hall_id`) REFERENCES `wedding_halls` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `wedding_halls`
--
ALTER TABLE `wedding_halls`
  ADD CONSTRAINT `wedding_halls_ibfk_1` FOREIGN KEY (`sub_admin_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
