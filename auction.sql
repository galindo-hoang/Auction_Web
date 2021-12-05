SET NAMES utf8mb4;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id int NOT NULL AUTO_INCREMENT,
    email varchar(50) DEFAULT NULL,
    password varchar(100) DEFAULT NULL,
    name varchar(50) DEFAULT NULL,
    role tinyint(1) DEFAULT NULL,
    DOB datetime,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS categories;
CREATE TABLE categories (
    CatID int(11) unsigned NOT NULL AUTO_INCREMENT,
    CatName varchar(50) COLLATE utf8_general_ci NOT NULL,
    PRIMARY KEY (CatID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

INSERT INTO categories VALUES (1, 'Điện tử');
INSERT INTO categories VALUES (2, 'Gia dụng');
INSERT INTO categories VALUES (3, 'Làm đẹp');
INSERT INTO categories VALUES (4, 'Thời trang');

DROP TABLE IF EXISTS products;
CREATE TABLE products (
    ProID int(11) unsigned NOT NULL AUTO_INCREMENT,
    ProName varchar(50) COLLATE utf8_general_ci NOT NULL,
    TinyDes varchar(100) COLLATE utf8_general_ci NOT NULL,
    FullDes text COLLATE utf8_general_ci NOT NULL,
    Price int(11) NOT NULL,
    CatID int(11) NOT NULL,
    CatDeID int(11) NOT NULL,
    PRIMARY KEY (ProID)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS categoriesDetail;
CREATE TABLE categoriesDetail (
    CatDeID int(11) unsigned NOT NULL AUTO_INCREMENT,
    ProTypeName varchar(50) COLLATE utf8_general_ci NOT NULL,
    CatID int(11) NOT NULL,
    PRIMARY KEY (CatDeID)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

INSERT INTO categoriesDetail VALUES (1, 'Điện thoại', 1);
INSERT INTO categoriesDetail VALUES (2, 'Laptop', 1);
INSERT INTO categoriesDetail VALUES (3, 'Bàn ghế', 2);
INSERT INTO categoriesDetail VALUES (4, 'Thiết bị nhà bếp', 2);
INSERT INTO categoriesDetail VALUES (5, 'Mặt', 3);
INSERT INTO categoriesDetail VALUES (6, 'Tóc', 3);
INSERT INTO categoriesDetail VALUES (7, 'Quần áo', 4);
INSERT INTO categoriesDetail VALUES (8, 'Giày', 4);

SET FOREIGN_KEY_CHECKS = 1;