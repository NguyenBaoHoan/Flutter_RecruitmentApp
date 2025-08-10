-- =================================================================
-- SCRIPT TẠO DATABASE VÀ CHUẨN BỊ DỮ LIỆU TEST CHO JOBHUNTER API (ĐÃ SỬA LỖI)
-- =================================================================

DROP DATABASE IF EXISTS jobhunter;
CREATE DATABASE jobhunter CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE jobhunter;

-- =================================================================
-- 1. TẠO CẤU TRÚC BẢNG (CREATE TABLES)
-- =================================================================

CREATE TABLE companies (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    address VARCHAR(255),
    logo VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- <<< SỬA ĐỔI >>> Thêm AUTO_INCREMENT cho cột id của bảng users
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY, 
    name VARCHAR(255),
    email VARCHAR(255) NOT NULL UNIQUE,
    passWord VARCHAR(255),
    age INT,
    gender VARCHAR(10),
    address VARCHAR(255),
    refresh_token MEDIUMTEXT,
    created_at TIMESTAMP,
    update_at TIMESTAMP,
    created_by VARCHAR(255),
    updated_by VARCHAR(255),
    display_name VARCHAR(255),
    photo_url VARCHAR(255),
    user_type VARCHAR(50),
    company_id BIGINT,
    FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE SET NULL
);

CREATE TABLE chat_rooms (
    id VARCHAR(255) PRIMARY KEY,
    last_updated TIMESTAMP
);

CREATE TABLE messages (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    content TEXT,
    created_at TIMESTAMP,
    message_type VARCHAR(20),
    is_read BOOLEAN DEFAULT FALSE,
    chat_room_id VARCHAR(255),
    sender_id BIGINT,
    FOREIGN KEY (chat_room_id) REFERENCES chat_rooms(id) ON DELETE CASCADE,
    FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE chat_room_participants (
    chat_room_id VARCHAR(255),
    user_id BIGINT,
    PRIMARY KEY (chat_room_id, user_id),
    FOREIGN KEY (chat_room_id) REFERENCES chat_rooms(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- =================================================================
-- 2. CHÈN DỮ LIỆU TEST (INSERT DATA)
-- =================================================================

INSERT INTO companies (id, name, description, address) VALUES
(1, 'Example Corp', 'A sample company for testing purposes.', '123 Test Street');

-- <<< SỬA ĐỔI >>> Bỏ cột 'id' ra khỏi lệnh INSERT để MySQL tự động gán giá trị
INSERT INTO users (name, email, passWord, age, gender, address, created_at, display_name, user_type, company_id) VALUES
('John Doe', 'john@example.com', '$2a$10$example', 30, 'MALE', '123 John St', NOW(), 'JohnD', 'USER', 1),
('Jane Smith', 'jane@example.com', '$2a$10$example', 28, 'FEMALE', '456 Jane Ave', NOW(), 'JaneS', 'USER', 1),
('Bob Wilson', 'bob@example.com', '$2a$10$example', 35, 'MALE', '789 Bob Blvd', NOW(), 'BobW', 'USER', NULL);
-- ON DUPLICATE KEY UPDATE không cần thiết nữa khi INSERT user mới

-- Lấy ID của các user vừa được tạo tự động
SET @john_id = (SELECT id FROM users WHERE email = 'john@example.com');
SET @jane_id = (SELECT id FROM users WHERE email = 'jane@example.com');
SET @bob_id = (SELECT id FROM users WHERE email = 'bob@example.com');

INSERT INTO chat_rooms (id, last_updated) VALUES
(CONCAT(LEAST(@john_id, @jane_id), '_', GREATEST(@john_id, @jane_id)), NOW()),
(CONCAT(LEAST(@john_id, @bob_id), '_', GREATEST(@john_id, @bob_id)), NOW()),
(CONCAT(LEAST(@jane_id, @bob_id), '_', GREATEST(@jane_id, @bob_id)), NOW());

INSERT INTO chat_room_participants (chat_room_id, user_id) VALUES
(CONCAT(LEAST(@john_id, @jane_id), '_', GREATEST(@john_id, @jane_id)), @john_id),
(CONCAT(LEAST(@john_id, @jane_id), '_', GREATEST(@john_id, @jane_id)), @jane_id),
(CONCAT(LEAST(@john_id, @bob_id), '_', GREATEST(@john_id, @bob_id)), @john_id),
(CONCAT(LEAST(@john_id, @bob_id), '_', GREATEST(@john_id, @bob_id)), @bob_id),
(CONCAT(LEAST(@jane_id, @bob_id), '_', GREATEST(@jane_id, @bob_id)), @jane_id),
(CONCAT(LEAST(@jane_id, @bob_id), '_', GREATEST(@jane_id, @bob_id)), @bob_id);

INSERT INTO messages (content, created_at, message_type, is_read, chat_room_id, sender_id) VALUES
('Hello Jane! How are you?', DATE_SUB(NOW(), INTERVAL 1 HOUR), 'TEXT', false, CONCAT(LEAST(@john_id, @jane_id), '_', GREATEST(@john_id, @jane_id)), @john_id),
('Hi John! I am fine, thank you!', DATE_SUB(NOW(), INTERVAL 30 MINUTE), 'TEXT', false, CONCAT(LEAST(@john_id, @jane_id), '_', GREATEST(@john_id, @jane_id)), @jane_id),
('Great! Do you want to grab coffee?', DATE_SUB(NOW(), INTERVAL 15 MINUTE), 'TEXT', false, CONCAT(LEAST(@john_id, @jane_id), '_', GREATEST(@john_id, @jane_id)), @john_id),
('Hey Bob!', DATE_SUB(NOW(), INTERVAL 2 HOUR), 'TEXT', false, CONCAT(LEAST(@john_id, @bob_id), '_', GREATEST(@john_id, @bob_id)), @john_id),
('Hi John!', DATE_SUB(NOW(), INTERVAL 1 HOUR), 'TEXT', false, CONCAT(LEAST(@john_id, @bob_id), '_', GREATEST(@john_id, @bob_id)), @bob_id),
('Hello Bob!', DATE_SUB(NOW(), INTERVAL 3 HOUR), 'TEXT', false, CONCAT(LEAST(@jane_id, @bob_id), '_', GREATEST(@jane_id, @bob_id)), @jane_id),
('Hi Jane!', DATE_SUB(NOW(), INTERVAL 2 HOUR), 'TEXT', false, CONCAT(LEAST(@jane_id, @bob_id), '_', GREATEST(@jane_id, @bob_id)), @bob_id),
('https://example.com/image1.jpg', DATE_SUB(NOW(), INTERVAL 10 MINUTE), 'IMAGE', false, CONCAT(LEAST(@john_id, @jane_id), '_', GREATEST(@john_id, @jane_id)), @john_id),
('https://example.com/audio1.mp3', DATE_SUB(NOW(), INTERVAL 5 MINUTE), 'AUDIO', false, CONCAT(LEAST(@john_id, @jane_id), '_', GREATEST(@john_id, @jane_id)), @jane_id),
('Check out this file!', DATE_SUB(NOW(), INTERVAL 2 MINUTE), 'FILE', false, CONCAT(LEAST(@john_id, @bob_id), '_', GREATEST(@john_id, @bob_id)), @john_id);


-- =================================================================
-- 3. KIỂM TRA DỮ LIỆU ĐÃ TẠO
-- =================================================================
-- (Các lệnh SELECT của bạn giữ nguyên)

-- =================================================================
-- 3. KIỂM TRA DỮ LIỆU ĐÃ TẠO
-- =================================================================

SELECT 'Users:' as info;
SELECT id, display_name, email FROM users WHERE id IN (1,2,3);

SELECT 'Chat Rooms:' as info;
SELECT id, last_updated FROM chat_rooms WHERE id IN ('1_2', '1_3', '2_3');

SELECT 'Chat Room Participants:' as info;
SELECT crp.chat_room_id, u.display_name
FROM chat_room_participants crp
JOIN users u ON crp.user_id = u.id
WHERE crp.chat_room_id IN ('1_2', '1_3', '2_3')
ORDER BY crp.chat_room_id, u.display_name;

SELECT 'Messages:' as info;
SELECT m.id, m.content, m.message_type, m.created_at,
       u.display_name as sender, m.chat_room_id
FROM messages m
JOIN users u ON m.sender_id = u.id
WHERE m.chat_room_id IN ('1_2', '1_3', '2_3')
ORDER BY m.chat_room_id, m.created_at DESC;