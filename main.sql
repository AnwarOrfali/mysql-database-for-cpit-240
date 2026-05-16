/* 
PROJECT:     HungerStationDB
VERSION:     1.0
AUTHOR:      Anwar, Abdullah, Wajid
DATE:        15-MAY-2026
*/

CREATE DATABASE IF NOT EXISTS HungerStationDB;
USE HungerStationDB;

CREATE TABLE IF NOT EXISTS Customer (
    User_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Phone VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS Customer_Address (
    User_ID INT,
    Address VARCHAR(255),
    PRIMARY KEY (User_ID, Address),
    FOREIGN KEY (User_ID) REFERENCES Customer(User_ID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Restaurant (
    Restaurant_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Food_Type VARCHAR(100),
    Rating DECIMAL(3, 2)
);

CREATE TABLE IF NOT EXISTS Restaurant_Location (
    Restaurant_ID INT,
    Location VARCHAR(255),
    PRIMARY KEY (Restaurant_ID, Location),
    FOREIGN KEY (Restaurant_ID) REFERENCES Restaurant(Restaurant_ID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Driver (
    Driver_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Phone VARCHAR(20),
    Vehicle_Type VARCHAR(100),
    Availability BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS Menu (
    Item_ID INT PRIMARY KEY AUTO_INCREMENT,
    Restaurant_ID INT NOT NULL,
    Name VARCHAR(255) NOT NULL,
    Description TEXT,
    Price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (Restaurant_ID) REFERENCES Restaurant(Restaurant_ID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Review (
    Review_ID INT PRIMARY KEY AUTO_INCREMENT,
    User_ID INT,
    Restaurant_ID INT NOT NULL,
    Rating INT CHECK (Rating >= 1 AND Rating <= 5),
    Comment TEXT,
    FOREIGN KEY (User_ID) REFERENCES Customer(User_ID) ON DELETE SET NULL,
    FOREIGN KEY (Restaurant_ID) REFERENCES Restaurant(Restaurant_ID) ON DELETE CASCADE
);

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

CREATE TABLE IF NOT EXISTS Payment (
    Payment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Order_ID INT NOT NULL,
    Method VARCHAR(50),
    Amount DECIMAL(10, 2) NOT NULL,
    Transaction_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Order_ID) REFERENCES `Order`(Order_ID) ON DELETE CASCADE
);

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
('Alice Johnson', 'alice.j@gmail.com', '555-0101'),
('Bob Smith', 'bob.smith@gmail.net', '555-0102'),
('Charlie Davis', 'charlie.d@gmail.com', '555-0103');

INSERT INTO Customer_Address (User_ID, Address) VALUES
(1, 'Unit 12, 7894 Sadi Ibn Wahb St, As Salamah Dist'),
(1, '4902 Amr Ibn Al Aas Street, Al Hamra Dist.'),
(2, '3885 Al Bandariyyah Street, Al Falah Dist'),
(3, '6687 Al Adel Street, As Sukhayrat Dist');

INSERT INTO Restaurant (Name, Food_Type, Rating) VALUES
('Al Baik', 'Fast Food', 4.5),
('Sushi Den', 'Japanese', 4.8),
('Starbucks', 'Fast Food', 4.2);

INSERT INTO Restaurant_Location (Restaurant_ID, Location) VALUES
(1, '2391 Prince Muhammad Ibn Abd Al Aziz Rd, Al Olaya Dist.'),
(1, '3110 Prince Turki Ibn Abdulaziz Al Awwal Rd, Hittin Dist.'),
(2, '8459 Corniche Rd, Al Shati Dist.'),
(3, '2884 King Salman Bin Abdulaziz Rd, Al Hizam Al Dhahabi Dist.');

INSERT INTO Menu (Restaurant_ID, Name, Description, Price) VALUES
(1, '4-Piece Chicken Meal', 'The ultimate signature dish. It features four pieces of perfectly broasted, bone-in chicken (breast and wing or thigh and drumstick) injected with Al Baiks legendary secret spice blend. It comes served with a side of French fries, a bun, and their iconic, deeply addictive garlic sauce.', 16.99),
(1, 'Big Baik Sandwich', 'A massive, satisfying chicken sandwich featuring a large, juicy fillet of chicken breast cooked to a golden crisp. It is layered with pickles and Al Baik’s special proprietary sauce, all tucked into a long, soft seed bun.', 17.50),
(2, 'Bad Boy Roll', 'A premium house-special maki roll that packs a punch of premium proteins. It combines fresh tuna, ebi (shrimp) tempura, and rich salmon with avocado, wrapped beautifully and drizzled with Sushi Dens signature house special savory sauce.', 15.00),
(3, 'Iced White Chocolate Mocha', 'A smooth and sweet espresso-based favorite. It blends Starbucks’ signature rich espresso with white chocolate mocha sauce, milk, and ice. The beverage is completed with a generous topping of sweetened whipped cream for a creamy, dessert-like finish.', 14.50);

INSERT INTO Driver (Name, Phone, Vehicle_Type, Availability) VALUES
('Anwar', '555-9999', 'Bicycle', TRUE),
('Wajid', '555-8888', 'Plane', TRUE),
('Abdullah', '555-7777', 'Helicopter', FALSE);

INSERT INTO `Order` (User_ID, Driver_ID, Total, Status) VALUES
(1, 1, 16.49, 'Delivered'),
(2, 2, 15.00, 'On the way');

INSERT INTO Order_Menu (Order_ID, Item_ID) VALUES
(1, 1),
(1, 2),
(2, 3);

INSERT INTO Payment (Order_ID, Method, Amount) VALUES
(1, 'Credit Card', 16.49),
(2, 'Digital Wallet', 15.00);

INSERT INTO Review (User_ID, Restaurant_ID, Rating, Comment) VALUES
(1, 1, 5, 'Best burgers in the KSA!'),
(2, 2, 4, 'Very fresh, but delivery took a while.');

-- Final Success Message
SELECT 'SUCCESS: Database reset and populated with realistic data!' AS Status;
