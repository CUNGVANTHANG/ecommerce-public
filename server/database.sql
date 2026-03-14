-- Chat tables for customer <-> store messaging
-- Run this file in MySQL (same database as the ecommerce server)

CREATE TABLE IF NOT EXISTS `chat_threads` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `customer_user_id` INT NOT NULL,
  `store_id` INT NOT NULL,
  `store_code` VARCHAR(20) NULL,
  `last_message_at` DATETIME NULL,
  `last_message_preview` VARCHAR(255) NULL,
  `customer_unread_count` INT NOT NULL DEFAULT 0,
  `store_unread_count` INT NOT NULL DEFAULT 0,
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '1=active, 0=archived',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_chat_threads_customer_store` (`customer_user_id`, `store_id`),
  KEY `idx_chat_threads_customer_user_id` (`customer_user_id`),
  KEY `idx_chat_threads_store_id` (`store_id`),
  KEY `idx_chat_threads_last_message_at` (`last_message_at`),
  CONSTRAINT `fk_chat_threads_customer_user`
    FOREIGN KEY (`customer_user_id`) REFERENCES `users` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_chat_threads_store`
    FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `chat_messages` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `thread_id` BIGINT NOT NULL,
  `sender_type` ENUM('customer','store','system') NOT NULL DEFAULT 'customer',
  `sender_user_id` INT NULL,
  `message_type` ENUM('text','media','mixed') NOT NULL DEFAULT 'text',
  `content` TEXT NULL,
  `attachments` JSON NULL,
  `is_read` TINYINT NOT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_chat_messages_thread_id` (`thread_id`),
  KEY `idx_chat_messages_sender_type` (`sender_type`),
  KEY `idx_chat_messages_created_at` (`created_at`),
  CONSTRAINT `fk_chat_messages_thread`
    FOREIGN KEY (`thread_id`) REFERENCES `chat_threads` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
-- Create store_reviews table for shop-based ratings (not product-based)
CREATE TABLE IF NOT EXISTS `store_reviews` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `store_id` INT NOT NULL,
  `seller_code` VARCHAR(20) NOT NULL,
  `rating` TINYINT NOT NULL DEFAULT 5,
  `content` TEXT NULL,
  `user_uid` VARCHAR(20) NOT NULL,
  `status` TINYINT NOT NULL DEFAULT 0 COMMENT '0=Visible, 1=Hidden, 2=Pending',
  `account_type` TINYINT NOT NULL DEFAULT 1 COMMENT '0=Demo account, 1=Real account',
  `create_time` DATETIME NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_store_reviews_store_user` (`store_id`, `user_uid`),
  KEY `idx_store_reviews_store_id` (`store_id`),
  KEY `idx_store_reviews_seller_code` (`seller_code`),
  KEY `idx_store_reviews_rating` (`rating`),
  KEY `idx_store_reviews_status` (`status`),
  KEY `idx_store_reviews_user_uid` (`user_uid`),
  KEY `idx_store_reviews_created_at` (`created_at`),
  CONSTRAINT `fk_store_reviews_store_id` FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
