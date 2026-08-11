CREATE DATABASE IF NOT EXISTS tourism
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE tourism;

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS tours;
DROP TABLE IF EXISTS services;
DROP TABLE IF EXISTS tour_types;
DROP TABLE IF EXISTS clients;

CREATE TABLE clients (
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    phone VARCHAR(30) NOT NULL UNIQUE,
    email VARCHAR(120) UNIQUE,
    passport_no VARCHAR(30) UNIQUE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE tour_types (
    tour_type_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(80) NOT NULL UNIQUE,
    description VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE services (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    price DECIMAL(10,2) NOT NULL,
    CONSTRAINT chk_service_price CHECK (price >= 0)
) ENGINE=InnoDB;

CREATE TABLE tours (
    tour_id INT AUTO_INCREMENT PRIMARY KEY,
    tour_type_id INT NOT NULL,
    service_id INT NULL,
    name VARCHAR(150) NOT NULL,
    destination VARCHAR(120) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    seats_total INT NOT NULL DEFAULT 1,
    CONSTRAINT fk_tours_type
        FOREIGN KEY (tour_type_id) REFERENCES tour_types(tour_type_id),
    CONSTRAINT fk_tours_service
        FOREIGN KEY (service_id) REFERENCES services(service_id)
        ON DELETE SET NULL,
    CONSTRAINT chk_tour_dates CHECK (end_date >= start_date),
    CONSTRAINT chk_tour_price CHECK (price >= 0),
    CONSTRAINT chk_tour_seats CHECK (seats_total > 0)
) ENGINE=InnoDB;

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    tour_id INT NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    persons INT NOT NULL DEFAULT 1,
    status ENUM('Новый','Подтвержден','Оплачен','Отменен') NOT NULL DEFAULT 'Новый',
    total_amount DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_orders_client
        FOREIGN KEY (client_id) REFERENCES clients(client_id),
    CONSTRAINT fk_orders_tour
        FOREIGN KEY (tour_id) REFERENCES tours(tour_id),
    CONSTRAINT chk_orders_persons CHECK (persons > 0),
    CONSTRAINT chk_orders_amount CHECK (total_amount >= 0)
) ENGINE=InnoDB;

CREATE INDEX idx_tours_destination ON tours(destination);
CREATE INDEX idx_tours_start_date ON tours(start_date);
CREATE INDEX idx_orders_client ON orders(client_id);
CREATE INDEX idx_orders_tour ON orders(tour_id);

INSERT INTO tour_types (name, description) VALUES
('Пляжный отдых', 'Отдых на море'),
('Экскурсионный', 'Экскурсии и культурные программы'),
('Горный', 'Активный отдых в горах');

INSERT INTO services (name, price) VALUES
('Трансфер', 50.00),
('Страховка', 25.00),
('Экскурсия', 80.00);

INSERT INTO clients (full_name, phone, email, passport_no) VALUES
('Иванов Иван Иванович', '+7-700-111-22-33', 'ivanov@example.com', 'N1234567'),
('Петрова Анна Сергеевна', '+7-700-222-33-44', 'petrova@example.com', 'N2345678');

INSERT INTO tours
(tour_type_id, service_id, name, destination, start_date, end_date, price, seats_total)
VALUES
(1, 1, 'Отдых в Анталье', 'Анталья', '2026-06-10', '2026-06-17', 850.00, 30),
(2, 3, 'Экскурсия по Праге', 'Прага', '2026-07-05', '2026-07-10', 720.00, 20),
(3, 2, 'Горный тур', 'Алматы', '2026-08-15', '2026-08-18', 450.00, 15);

INSERT INTO orders (client_id, tour_id, persons, status, total_amount) VALUES
(1, 1, 2, 'Оплачен', 1700.00),
(2, 3, 1, 'Подтвержден', 450.00);

-- Проверочный запрос
SELECT
    o.order_id,
    c.full_name AS client,
    t.name AS tour,
    o.persons,
    o.status,
    o.total_amount
FROM orders o
JOIN clients c ON c.client_id = o.client_id
JOIN tours t ON t.tour_id = o.tour_id
ORDER BY o.order_id;
