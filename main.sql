/* 
PROJECT:     HungerStationDB
VERSION:     1.0
AUTHOR:      Anwar, Abdullah, Wajid
DATE:        15-MAY-2026
*/

-- Create Database
CREATE DATABASE IF NOT EXISTS HungerStationDB;
USE HungerStationDB;

-- 1. Customer Table
CREATE TABLE IF NOT EXISTS Customer (
    User_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Phone VARCHAR(20)
);

-- 1a. Customer_Address Table (For the multi-valued 'Address' attribute)
CREATE TABLE IF NOT EXISTS Customer_Address (
    User_ID INT,
    Address VARCHAR(255),
    PRIMARY KEY (User_ID, Address),
    FOREIGN KEY (User_ID) REFERENCES Customer(User_ID) ON DELETE CASCADE
);

-- 2. Restaurant Table
CREATE TABLE IF NOT EXISTS Restaurant (
    Restaurant_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Food_Type VARCHAR(100),
    Rating DECIMAL(3, 2)
);

-- 2a. Restaurant_Location Table (For the multi-valued 'Location' attribute)
CREATE TABLE IF NOT EXISTS Restaurant_Location (
    Restaurant_ID INT,
    Location VARCHAR(255),
    PRIMARY KEY (Restaurant_ID, Location),
    FOREIGN KEY (Restaurant_ID) REFERENCES Restaurant(Restaurant_ID) ON DELETE CASCADE
);

-- 3. Driver Table
CREATE TABLE IF NOT EXISTS Driver (
    Driver_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Phone VARCHAR(20),
    Vehicle_Type VARCHAR(100),
    Availability BOOLEAN DEFAULT TRUE
);

-- 4. Menu Table (Weak Entity connected to Restaurant via "Offers")
CREATE TABLE IF NOT EXISTS Menu (
    Item_ID INT PRIMARY KEY AUTO_INCREMENT,
    Restaurant_ID INT NOT NULL,
    Name VARCHAR(255) NOT NULL,
    Description TEXT,
    Price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (Restaurant_ID) REFERENCES Restaurant(Restaurant_ID) ON DELETE CASCADE
);

-- 5. Review Table (Weak Entity connected to Customer and Restaurant)
CREATE TABLE IF NOT EXISTS Review (
    Review_ID INT PRIMARY KEY AUTO_INCREMENT,
    User_ID INT,
    Restaurant_ID INT NOT NULL,
    Rating INT CHECK (Rating >= 1 AND Rating <= 5),
    Comment TEXT,
    FOREIGN KEY (User_ID) REFERENCES Customer(User_ID) ON DELETE SET NULL,
    FOREIGN KEY (Restaurant_ID) REFERENCES Restaurant(Restaurant_ID) ON DELETE CASCADE
);

-- 6. Order Table
CREATE TABLE IF NOT EXISTS `Order` (
    Order_ID INT PRIMARY KEY AUTO_INCREMENT,
    User_ID INT NOT NULL,
    Driver_ID INT,
    Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    Total DECIMAL(10, 2) NOT NULL,
    Status VARCHAR(50) DEFAULT 'Pending',
    FOREIGN KEY (User_ID) REFERENCES Customer(User_ID) ON DELETE CASCADE,
    FOREIGN KEY (Driver_ID) REFERENCES Driver(Driver_ID) ON DELETE SET NULL
);

-- 7. Payment Table (Connected to Order via "Generates")
CREATE TABLE IF NOT EXISTS Payment (
    Payment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Order_ID INT NOT NULL,
    Method VARCHAR(50),
    Amount DECIMAL(10, 2) NOT NULL,
    Transaction_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Order_ID) REFERENCES `Order`(Order_ID) ON DELETE CASCADE
);

-- 8. Order_Menu Junction Table 
CREATE TABLE IF NOT EXISTS Order_Menu (
    Order_ID INT,
    Item_ID INT,
    PRIMARY KEY (Order_ID, Item_ID),
    FOREIGN KEY (Order_ID) REFERENCES `Order`(Order_ID) ON DELETE CASCADE,
    FOREIGN KEY (Item_ID) REFERENCES Menu(Item_ID) ON DELETE CASCADE
);

-- Logging
SELECT 'SUCCESS: Database schema created successfully!' AS Status;

-- DML Part

USE HungerStationDB;

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE Order_Menu;
TRUNCATE TABLE Payment;
TRUNCATE TABLE `Order`;
TRUNCATE TABLE Review;
TRUNCATE TABLE Menu;
TRUNCATE TABLE Driver;
TRUNCATE TABLE Restaurant_Location;
TRUNCATE TABLE Restaurant;
TRUNCATE TABLE Customer_Address;
TRUNCATE TABLE Customer;

SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO Customer (Name, Email, Phone) VALUES
('Alice Johnson', 'alice.j@email.com', '555-0101'),
('Bob Smith', 'bob.smith@provider.net', '555-0102'),
('Charlie Davis', 'charlie.d@webmail.com', '555-0103');

INSERT INTO Customer_Address (User_ID, Address) VALUES
(1, '123 Maple St, Apt 4B'),
(1, 'Work: 900 Business Pkwy'),
(2, '456 Oak Lane'),
(3, '789 Pine Rd');

INSERT INTO Restaurant (Name, Food_Type, Rating) VALUES
('Burger Galaxy', 'Fast Food', 4.5),
('Sushi Zen', 'Japanese', 4.8),
('Pasta Palace', 'Italian', 4.2);

INSERT INTO Restaurant_Location (Restaurant_ID, Location) VALUES
(1, 'Downtown Mall'),
(1, 'North Suburb'),
(2, 'East Waterfront'),
(3, 'City Center');

INSERT INTO Menu (Restaurant_ID, Name, Description, Price) VALUES
(1, 'Supernova Burger', 'Double patty with secret sauce', 12.99),
(1, 'Cosmic Fries', 'Seasoned with stardust salt', 3.50),
(2, 'Dragon Roll', 'Eel and avocado with spicy mayo', 15.00),
(3, 'Fettuccine Alfredo', 'Creamy white sauce with parsley', 14.50);

INSERT INTO Driver (Name, Phone, Vehicle_Type, Availability) VALUES
('Speedy Sam', '555-9999', 'Bicycle', TRUE),
('Van Vanessa', '555-8888', 'Car', TRUE),
('Moto Mike', '555-7777', 'Motorcycle', FALSE);

INSERT INTO `Order` (User_ID, Driver_ID, Total, Status) VALUES
(1, 1, 16.49, 'Delivered'),
(2, 2, 15.00, 'On the way');

INSERT INTO Order_Menu (Order_ID, Item_ID) VALUES
(1, 1), -- Supernova Burger
(1, 2), -- Cosmic Fries
(2, 3); -- Dragon Roll

INSERT INTO Payment (Order_ID, Method, Amount) VALUES
(1, 'Credit Card', 16.49),
(2, 'Digital Wallet', 15.00);

INSERT INTO Review (User_ID, Restaurant_ID, Rating, Comment) VALUES
(1, 1, 5, 'Best burger in the galaxy!'),
(2, 2, 4, 'Very fresh, but delivery took a while.');

-- Final Success Message
SELECT 'SUCCESS: Database reset and populated with realistic data!' AS Status;