-- THis is a database model file for our project
-- THis is for MariaDB

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(20),
  password_hash VARCHAR(128) NOT NULL,
  role ENUM('vendor', 'consumer') NOT NULL,
  bio TEXT,
  profile_picture TEXT,
  is_verified BOOLEAN DEFAULT FALSE,
  govt_id_url TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE listings (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  title VARCHAR(200) NOT NULL,
  description TEXT NOT NULL,
  listing_type ENUM('product', 'service', 'donation') NOT NULL,
  price_per_day FLOAT,
  location TEXT,
  images JSON,
  is_active BOOLEAN DEFAULT TRUE,
  available_from TIMESTAMP NULL,
  available_to TIMESTAMP NULL,
  extra_details JSON,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE donation_requests (
  id INT AUTO_INCREMENT PRIMARY KEY,
  listing_id INT,
  user_id INT,
  message TEXT,
  status ENUM('pending', 'accepted', 'rejected') DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (listing_id) REFERENCES listings(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE transactions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  listing_id INT,
  vendor_id INT,
  consumer_id INT,
  start_date TIMESTAMP NOT NULL,
  end_date TIMESTAMP NOT NULL,
  total_price FLOAT NOT NULL,
  status ENUM('pending', 'active', 'completed', 'cancelled', 'disputed') DEFAULT 'pending',
  is_refunded BOOLEAN DEFAULT FALSE,
  payment_hold_expires TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (listing_id) REFERENCES listings(id),
  FOREIGN KEY (vendor_id) REFERENCES users(id),
  FOREIGN KEY (consumer_id) REFERENCES users(id)
);

CREATE TABLE reviews (
  id INT AUTO_INCREMENT PRIMARY KEY,
  reviewer_id INT,
  reviewed_id INT,
  rating FLOAT NOT NULL,
  comment TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE (reviewer_id, reviewed_id),
  FOREIGN KEY (reviewer_id) REFERENCES users(id),
  FOREIGN KEY (reviewed_id) REFERENCES users(id),
  CHECK (rating >= 0 AND rating <= 5)
);

CREATE TABLE disputes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  transaction_id INT,
  raised_by INT,
  reason TEXT NOT NULL,
  status ENUM('open', 'resolved', 'rejected') DEFAULT 'open',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (transaction_id) REFERENCES transactions(id),
  FOREIGN KEY (raised_by) REFERENCES users(id)
);