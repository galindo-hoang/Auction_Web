SET NAMES utf8mb4;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS users;
CREATE TABLE users ( -- Bảng thông tin của các user
    UserID int NOT NULL AUTO_INCREMENT,
    UserEmail varchar(50) DEFAULT NULL,
    UserPassword varchar(100) DEFAULT NULL,
    UserName varchar(50) DEFAULT NULL,
    UserRole tinyint(1) DEFAULT NULL, -- vai trò của user (ví dụ: 0 là admin, 1 là seller, ...)
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

DROP TABLE IF EXISTS categoriesDetail;
CREATE TABLE categoriesDetail ( -- Sản phẩm cụ thể từ một danh mục đã INSERT bên dưới
    CatDeID int(11) unsigned NOT NULL AUTO_INCREMENT,
    CatDeName varchar(50) COLLATE utf8_general_ci NOT NULL,
    CatID int(11) unsigned NOT NULL, -- ID lấy từ bảng categories
    PRIMARY KEY (CatDeID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

INSERT INTO categoriesDetail VALUES (1, 'Điện thoại', 1);
INSERT INTO categoriesDetail VALUES (2, 'Laptop', 1);
INSERT INTO categoriesDetail VALUES (3, 'Bàn ghế', 2);
INSERT INTO categoriesDetail VALUES (4, 'Thiết bị nhà bếp', 2);
INSERT INTO categoriesDetail VALUES (5, 'Mặt', 3);
INSERT INTO categoriesDetail VALUES (6, 'Tóc', 3);
INSERT INTO categoriesDetail VALUES (7, 'Quần áo', 4);
INSERT INTO categoriesDetail VALUES (8, 'Giày', 4);

DROP TABLE IF EXISTS products;
CREATE TABLE products ( -- Bảng product được đăng bán cụ thể
    ProID int(11) unsigned NOT NULL AUTO_INCREMENT,
    ProName varchar(50) COLLATE utf8_general_ci NOT NULL,
    TinyDes varchar(100) COLLATE utf8_general_ci NOT NULL, -- mô tả ngắn gọn
    FullDes text COLLATE utf8_general_ci NOT NULL, -- mô tả chi tiết
    BeginPrice int(11) NOT NULL, -- Giá khởi điểm
    StepPrice int(11) NOT NULL, -- Bước giá
    CurPrice int(11) NOT NULL, -- Giá hiện tại
    BuyNowPrice int(11) NOT NULL, -- giá mua ngay
    CatID int(11) NOT NULL, -- ID lấy từ bảng categories
    CatDeID int(11) NOT NULL, -- ID lấy từ bảng categoriesDetail
    StartDate datetime, -- ngày giờ bắt đầu
    EndDate datetime, -- ngày giờ kết thúc
    SellerID int NOT NULL, -- ID người bán
    HighestBidderID int NOT NULL, -- ID bidder đặt giá cao nhất hiện tại
    AutoExtend tinyint(1) NOT NULL, -- Có tự động gia hạn không
    Status tinyint(1) NOT NULL, -- Sản phẩm đang được đấu giá hay đã bán (Vd: 0 là đang đấu giá, 1 là đã bán)
    PRIMARY KEY (ProID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS products_history;
CREATE TABLE products_history ( -- Bảng lịch sử đấu giá của sản phẩm
    ProID int(11) unsigned NOT NULL, -- ID của sản phẩm được đăng bán
    BidDate datetime NOT NULL , -- Thời điểm bidder đặt giá
    Price int(11) NOT NULL, -- Giá mà bidder đặt
    BidderID int NOT NULL, -- ID của bidder
    PRIMARY KEY (ProID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS rating_list;
CREATE TABLE rating_list ( -- Bảng chi tiết các lần được đánh giá
    UserID int NOT NULL, -- ID của USER ĐƯỢC ĐÁNH GIÁ
    UserRateID int NOT NULL, -- ID của USER ĐÁNH GIÁ
    Rate tinyint(1) NOT NULL, -- rating của người đánh giá (VD: 0 là chê, 1 là khen)
    Comment varchar(100) NOT NULL, -- đoạn nhận xét không quá 100 ký tự
    PRIMARY KEY (UserID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS favorite_list;
CREATE TABLE favorite_list( -- Bảng sản phẩm yêu thích
    UserID int NOT NULL, -- ID của bidder
    ProID int(11) unsigned NOT NULL, -- ID danh sách sản phẩm yêu thích
    PRIMARY KEY (UserID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS bidding_list;
CREATE TABLE bidding_list( -- Bảng sản phẩm đang tham gia đấu giá
    UserID int NOT NULL, -- ID của bidder
    ProID int(11) unsigned NOT NULL, -- ID danh sách sản phẩm đang tham gia đấu giá
    PRIMARY KEY (UserID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS win_list;
CREATE TABLE win_list( -- Bảng sản phẩm đã thắng
    UserID int NOT NULL, -- ID của bidder
    ProID int(11) unsigned NOT NULL, -- ID danh sách sản phẩm đã thắng
    PRIMARY KEY (UserID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS banned_list;
CREATE TABLE banned_list( -- Bảng danh sách bidder bị cấm đáu giá ở sản phẩm tương ứng
    UserID int NOT NULL, -- ID của bidder bị banned
    ProID int(11) unsigned NOT NULL, -- ID sản phẩm mà bidder bị banned
    PRIMARY KEY (UserID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS update_users;
CREATE TABLE update_users ( -- Danh sách bidder xin nâng cấp tài khoản
    UserID int NOT NULL, -- ID của bidder xin nâng cấp tài khoản
    PRIMARY KEY (UserID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

SET FOREIGN_KEY_CHECKS = 1;