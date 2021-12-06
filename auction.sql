SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS users;
CREATE TABLE users ( -- Bảng thông tin của các user
    UserID int NOT NULL AUTO_INCREMENT,
    UserEmail varchar(50) DEFAULT NULL,
    UserPassword varchar(100) DEFAULT NULL,
    UserName varchar(50) DEFAULT NULL,
    UserRole tinyint(1) DEFAULT NULL, -- vai trò của user (ví dụ: 0 là admin, 1 là seller, 2 bidder)
    UserRating float NOT NULL, -- tỉ lệ rating của user
    DOB datetime,
    PRIMARY KEY (UserID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS categories;
CREATE TABLE categories ( -- Bảng danh mục gồm 4 danh mục đã INSERT bên dưới
    CatID int(11) unsigned NOT NULL AUTO_INCREMENT,
    CatName varchar(50) COLLATE utf8_general_ci NOT NULL,
    PRIMARY KEY (CatID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

INSERT INTO categories VALUES (1, 'Điện tử');
INSERT INTO categories VALUES (2, 'Gia dụng');
INSERT INTO categories VALUES (3, 'Làm đẹp');
INSERT INTO categories VALUES (4, 'Thời trang');

DROP TABLE IF EXISTS categories_detail;
CREATE TABLE categories_detail ( -- Sản phẩm cụ thể từ một danh mục đã INSERT bên dưới
    CatDeID int(11) unsigned NOT NULL AUTO_INCREMENT,
    CatDeName varchar(50) COLLATE utf8_general_ci NOT NULL,
    CatID int(11) unsigned NOT NULL, -- ID lấy từ bảng categories
    PRIMARY KEY (CatDeID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

INSERT INTO categories_detail VALUES (1, 'Điện thoại', 1);
INSERT INTO categories_detail VALUES (2, 'Laptop', 1);
INSERT INTO categories_detail VALUES (3, 'Bàn ghế', 2);
INSERT INTO categories_detail VALUES (4, 'Thiết bị nhà bếp', 2);
INSERT INTO categories_detail VALUES (5, 'Mặt', 3);
INSERT INTO categories_detail VALUES (6, 'Tóc', 3);
INSERT INTO categories_detail VALUES (7, 'Quần áo', 4);
INSERT INTO categories_detail VALUES (8, 'Giày', 4);

DROP TABLE IF EXISTS products;
CREATE TABLE products ( -- Bảng product được đăng bán cụ thể
    ProID int(11) unsigned NOT NULL AUTO_INCREMENT,
    ProName varchar(50) COLLATE utf8_general_ci NOT NULL,
    TinyDes varchar(100) COLLATE utf8_general_ci NOT NULL, -- mô tả ngắn gọn
    FullDes text COLLATE utf8_general_ci NOT NULL, -- mô tả chi tiết
    StepPrice int(11) NOT NULL, -- Bước giá
    CurPrice int(11) NOT NULL, -- Giá hiện tại (giá khởi điểm lúc đầu)
    BuyNowPrice int(11) NOT NULL, -- giá mua ngay
    CatDeID int(11) NOT NULL, -- ID lấy từ bảng categories_detail
    StartDate datetime, -- ngày giờ bắt đầu
    EndDate datetime, -- ngày giờ kết thúc
    SellerID int NOT NULL, -- ID người bán
    AutoExtend tinyint(1) NOT NULL, -- Có tự động gia hạn không
    Status tinyint(1) NOT NULL, -- Sản phẩm đang được đấu giá hay đã bán (Vd: 0 là đang đấu giá, 1 là đã bán)
    PRIMARY KEY (ProID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS products_history;
CREATE TABLE products_history ( -- Bảng lịch sử đấu giá của sản phẩm
    BidID int(11) unsigned NOT NULL AUTO_INCREMENT,
    ProID int(11) unsigned NOT NULL, -- ID của sản phẩm được đăng bán
    BidDate datetime NOT NULL , -- Thời điểm bidder đặt giá
    Price int(11) NOT NULL, -- Giá mà bidder đặt
    BidderID int NOT NULL, -- ID của bidder
    PRIMARY KEY (BidID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS rating_list;
CREATE TABLE rating_list ( -- Bảng chi tiết các lần được đánh giá
    RateID int(11) unsigned NOT NULL AUTO_INCREMENT,
    UserID int NOT NULL, -- ID của USER ĐƯỢC ĐÁNH GIÁ
    UserRateID int NOT NULL, -- ID của USER ĐÁNH GIÁ
    Rate tinyint(1) NOT NULL, -- rating của người đánh giá (VD: 0 là chê, 1 là khen)
    Comment varchar(100) NOT NULL, -- đoạn nhận xét không quá 100 ký tự
    PRIMARY KEY (RateID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS favorite_list;
CREATE TABLE favorite_list( -- Bảng sản phẩm yêu thích
    UserID int NOT NULL, -- ID của bidder
    ProID int(11) unsigned NOT NULL, -- ID danh sách sản phẩm yêu thích
    PRIMARY KEY (UserID, ProID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS win_list;
CREATE TABLE win_list( -- Bảng sản phẩm đã thắng
    UserID int NOT NULL, -- ID của bidder
    ProID int(11) unsigned NOT NULL, -- ID danh sách sản phẩm đã thắng
    PRIMARY KEY (UserID, ProID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS banned_list;
CREATE TABLE banned_list( -- Bảng danh sách bidder bị cấm đáu giá ở sản phẩm tương ứng
    UserID int NOT NULL, -- ID của bidder bị banned
    ProID int(11) unsigned NOT NULL, -- ID sản phẩm mà bidder bị banned
    PRIMARY KEY (UserID, ProID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS update_users;
CREATE TABLE update_users ( -- Danh sách bidder xin nâng cấp tài khoản
    UserID int NOT NULL, -- ID của bidder xin nâng cấp tài khoản
    PRIMARY KEY (UserID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO products VALUES (1, 'Điện thoại', 'TinyDes', 'FullDes', 1, 2000000, 100000, 1, '2021-12-01 12:00:00', '2021-12-31 12:00:00', 1, 1, 0);
INSERT INTO products VALUES (2, 'Laptop', 'TinyDes', 'FullDes', 1, 2000000, 100000, 2, '2021-12-01 12:00:00', '2021-12-31 12:00:00', 1, 1, 0);
INSERT INTO products VALUES (3, 'Bàn ghế', 'TinyDes', 'FullDes', 1, 2000000, 100000, 3, '2021-12-01 12:00:00', '2021-12-31 12:00:00', 1, 1, 0);
INSERT INTO products VALUES (4, 'Thiết bị nhà bếp', 'TinyDes', 'FullDes', 1, 2000000, 100000, 4, '2021-12-01 12:00:00', '2021-12-31 12:00:00', 1, 1, 0);
INSERT INTO products VALUES (5, 'Mặt', 'TinyDes', 'FullDes', 1, 2000000, 100000, 5, '2021-12-01 12:00:00', '2021-12-31 12:00:00', 1, 1, 0);
INSERT INTO products VALUES (6, 'Tóc', 'TinyDes', 'FullDes', 1, 2000000, 100000, 6, '2021-12-01 12:00:00', '2021-12-31 12:00:00', 1, 1, 0);
INSERT INTO products VALUES (7, 'Quần áo', 'TinyDes', 'FullDes', 1, 2000000, 100000, 7, '2021-12-01 12:00:00', '2021-12-31 12:00:00', 1, 1, 0);
INSERT INTO products VALUES (8, 'Giày', 'TinyDes', 'FullDes', 1, 2000000, 100000, 8, '2021-12-01 12:00:00', '2021-12-31 12:00:00', 1, 1, 0);

INSERT INTO products VALUES (9, 'Điện thoại', 'TinyDes', 'FullDes', 1, 2000000, 100000, 1, '2021-12-01 12:00:00', '2021-12-31 12:00:00', 1, 1, 0);
INSERT INTO products VALUES (10, 'Laptop', 'TinyDes', 'FullDes', 1, 2000000, 100000, 2, '2021-12-01 12:00:00', '2021-12-31 12:00:00', 1, 1, 0);
INSERT INTO products VALUES (11, 'Điện thoại', 'TinyDes', 'FullDes', 1, 2000000, 100000, 1, '2021-12-01 12:00:00', '2021-12-31 12:00:00', 1, 1, 0);
INSERT INTO products VALUES (12, 'Laptop', 'TinyDes', 'FullDes', 1, 2000000, 100000, 2, '2021-12-01 12:00:00', '2021-12-31 12:00:00', 1, 1, 0);
INSERT INTO products VALUES (13, 'Điện thoại', 'TinyDes', 'FullDes', 1, 2000000, 100000, 1, '2021-12-01 12:00:00', '2021-12-31 12:00:00', 1, 1, 0);
INSERT INTO products VALUES (14, 'Laptop', 'TinyDes', 'FullDes', 1, 2000000, 100000, 2, '2021-12-01 12:00:00', '2021-12-31 12:00:00', 1, 1, 0);
INSERT INTO products VALUES (15, 'Điện thoại', 'TinyDes', 'FullDes', 1, 2000000, 100000, 1, '2021-12-01 12:00:00', '2021-12-31 12:00:00', 1, 1, 0);
INSERT INTO products VALUES (16, 'Laptop', 'TinyDes', 'FullDes', 1, 2000000, 100000, 2, '2021-12-01 12:00:00', '2021-12-31 12:00:00', 1, 1, 0);