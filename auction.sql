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
    PRIMARY KEY (CatDeID),
    FULLTEXT KEY (CatDeName)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

INSERT INTO categories_detail (CatDeID, CatDeName, CatID) VALUES (1, 'Điện thoại', 1);
INSERT INTO categories_detail (CatDeID, CatDeName, CatID) VALUES (2, 'Laptop', 1);
INSERT INTO categories_detail (CatDeID, CatDeName, CatID) VALUES (3, 'Lò vi sóng', 2);
INSERT INTO categories_detail (CatDeID, CatDeName, CatID) VALUES (4, 'Máy làm bánh', 2);
INSERT INTO categories_detail (CatDeID, CatDeName, CatID) VALUES (5, 'Máy làm kem', 2);
INSERT INTO categories_detail (CatDeID, CatDeName, CatID) VALUES (6, 'Máy pha cà phê', 2);
INSERT INTO categories_detail (CatDeID, CatDeName, CatID) VALUES (7, 'Máy xay', 2);
INSERT INTO categories_detail (CatDeID, CatDeName, CatID) VALUES (8, 'Chăm sóc da mặt', 3);
INSERT INTO categories_detail (CatDeID, CatDeName, CatID) VALUES (9, 'Nước hoa', 3);
INSERT INTO categories_detail (CatDeID, CatDeName, CatID) VALUES (10, 'Trang điểm', 3);
INSERT INTO categories_detail (CatDeID, CatDeName, CatID) VALUES (11, 'Áo thun', 4);
INSERT INTO categories_detail (CatDeID, CatDeName, CatID) VALUES (12, 'Đồ bơi', 4);
INSERT INTO categories_detail (CatDeID, CatDeName, CatID) VALUES (13, 'Quần', 4);

DROP TABLE IF EXISTS products;
CREATE TABLE products ( -- Bảng product được đăng bán cụ thể
    ProID int(11) unsigned NOT NULL AUTO_INCREMENT,
    ProName varchar(50) COLLATE utf8_general_ci NOT NULL,
    TinyDes varchar(100) COLLATE utf8_general_ci NOT NULL, -- mô tả ngắn gọn
    FullDes text COLLATE utf8_general_ci NOT NULL, -- mô tả chi tiết
    StepPrice int(11) NOT NULL, -- Bước giá
    StartPrice int(11) NOT NULL, -- Giá khởi điểm lúc đầu
    CurPrice int(11) NOT NULL, -- Giá hiện tại
    BuyNowPrice int(11) NOT NULL, -- giá mua ngay
    CatDeID int(11) NOT NULL, -- ID lấy từ bảng categories_detail
    StartDate datetime, -- ngày giờ bắt đầu
    EndDate datetime, -- ngày giờ kết thúc
    SellerID int NOT NULL, -- ID người bán
    AutoExtend tinyint(1) NOT NULL, -- Có tự động gia hạn không
    Status tinyint(1) NOT NULL, -- Sản phẩm đang được đấu giá hay đã bán (Vd: 0 là đang đấu giá, 1 là đã bán)
    Mail tinyint(1) NOT NULL, -- kiểm tra sản phẩm hết hạn đã mail chưa
    PRIMARY KEY (ProID),
    FULLTEXT KEY (ProName)
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
    ProID int(11) unsigned NOT NULL, -- ID của sản phẩm được đăng bán
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



DROP TABLE IF EXISTS pending_list;
CREATE TABLE pending_list( -- Bảng danh sách bidder đang trong hàng chờ để được đấu giá
                            UserID int NOT NULL, -- ID của bidder trong hàng chờ
                            ProID int(11) unsigned NOT NULL, -- ID sản phẩm bidder đang chờ được đấu giá
                            PRIMARY KEY (UserID, ProID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


DROP TABLE IF EXISTS accepted_list;
CREATE TABLE accepted_list( -- Bảng danh sách bidder được chấp nhận đấu giá
                            UserID int NOT NULL, -- ID của bidder được chấp nhận đấu giá
                            ProID int(11) unsigned NOT NULL, -- ID sản phẩm mà bidder được đấu giá
                            PRIMARY KEY (UserID, ProID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS update_users;
CREATE TABLE update_users ( -- Danh sách bidder xin nâng cấp tài khoản
    UserID int NOT NULL, -- ID của bidder xin nâng cấp tài khoản
    PRIMARY KEY (UserID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

SET FOREIGN_KEY_CHECKS = 1;

insert into products (ProID, ProName, TinyDes, FullDes, StepPrice, StartPrice, CurPrice, BuyNowPrice, CatDeID, StartDate, EndDate, SellerID, AutoExtend, Status, Mail)
values  (1, 'Laptop HP Pavilion x360 14-DW1018TU 2H3N6PA', 'Đây là mẫu laptop cấu hình mạnh với thiết kế hiện đại.
', '<div class="box-content">
<table id="tskt">
<tbody>
<tr>
<th>Loại CPU</th>
<th>Intel Core i5-1135G7, tốc độ 2.4GHz tối đa lên đến 4.2GHz, bộ nhớ đệm 8MB</th>
</tr>
<tr>
<th>Loại card đồ họa</th>
<th>Intel Iris Xe Graphics</th>
</tr>
<tr>
<th>Dung lượng RAM</th>
<th>8GB</th>
</tr>
<tr>
<th>Ổ cứng</th>
 <th>512 GB PCIe NVMe M.2 SSD</th>
</tr>
<tr>
<th>Kích thước màn hình</th>
<th>14 inches</th>
</tr>
<tr>
<th>Độ phân giải màn hình</th>
<th>1920 x 1080 pixels (FullHD)</th>
</tr>
<tr>
<th>Cổng giao tiếp</th>
<th>1 cổng USB Type-C SuperSpeed hỗ trợ Power Delivery, DisplayPort™ 1.4, HP Sleep and Charge<br> 2 cổng USB Type-A SuperSpeed<br> 1 cổng HDMI 2.0<br> 1 cổng sạc AC<br> 1 cổng combo tai nghe 3.5mm</th>
</tr>
<tr>
<th>Hệ điều hành</th>
<th>Windows 10 Home SL</th>
</tr>
<tr>
<th>Pin</th>
<th>3 Cell 43WHr</th>
</tr>
<tr>
<th>Kích thước</th>
<th>32.4 x 22.1 x 1.87 cm</th>
</tr>
<tr>
<th>Công nghệ màn hình</th>
<th>Độ sáng 250 nits <br>45% NTSC</th>
</tr>
</tbody>
</table>
</div>', 200000, 15000000, 15000000, 19000000, 2, '2021-12-05 21:14:52', '2022-01-16 21:14:58', 1, 0, 1, 0),
        (2, 'Laptop HP 15-DY2045 2Q1H3UA', 'Laptop HP luôn là lựa chọn được nhiều người dùng tin tưởng lựa chọn', '<div class="box-content">
<table id="tskt">
<tbody>
<tr>
<th>Loại CPU</th>
<th>Intel® Core™ i5-1135G7 (up to 4.2 GHz with Intel® Turbo Boost Technology, 8 MB L3 cache, 4 cores)</th>
 </tr>
<tr>
<th>Loại card đồ họa</th>
<th>Intel® Iris® Xᵉ Graphics</th>
</tr>
<tr>
<th>Dung lượng RAM</th>
<th>8GB</th>
</tr>
<tr>
<th>Ổ cứng</th>
<th>256 GB PCIe® NVMe™ M.2 SSD</th>
</tr>
<tr>
<th>Kích thước màn hình</th>
<th>15.6 inches</th>
</tr>
<tr>
<th>Độ phân giải màn hình</th>
<th>1366 x 768 pixels (HD+)</th>
</tr>
<tr>
<th>Cổng giao tiếp</th>
<th>1 SuperSpeed USB Type-C® 5Gbps signaling rate<br> 2 SuperSpeed USB Type-A 5Gbps signaling rate<br> 1 HDMI 1.4b<br> 1 AC smart pin<br> 1 headphone/microphone combo</th>
</tr>
<tr>
<th>Hệ điều hành</th>
<th>Windows 10 Home SL </th>
</tr>
<tr>
<th>Pin</th>
<th>3-cell, 41 Wh Li-ion</th>
</tr>
<tr>
<th>Kích thước</th>
<th>35.85 x 24.2 x 1.79 cm</th>
</tr>
<tr>
<th>Công nghệ màn hình</th>
<th>250 nits, 45% NTSC</th>
</tr>
</tbody>
</table>
</div>', 200000, 14000000, 14000000, 18000000, 2, '2021-12-01 21:20:27', '2022-01-11 21:20:35', 1, 0, 1, 0),
        (3, 'Laptop HP 15-DW1001WN 4J238UA', 'hiệu năng ổn định cùng một mức giá hợp lý.', '<div class="box-content">
<table id="tskt">
<tbody>
<tr>
<th>Loại CPU</th>
<th>Intel® Celeron® N4020 (1.1 GHz - 2.8 GHz, 4 MB L2 cache)</th>
</tr>
<tr>
<th>Loại card đồ họa</th>
<th>Intel® UHD Graphics 600</th>
</tr>
<tr>
<th>Dung lượng RAM</th>
<th>4GB</th>
</tr>
<tr>
<th>Ổ cứng</th>
<th>128 GB SATA 3 TLC M.2 SSD</th>
</tr>
<tr>
<th>Kích thước màn hình</th>
<th>15.6 inches</th>
</tr>
<tr>
<th>Độ phân giải màn hình</th>
<th>1920 x 1080 pixels (FullHD)</th>
</tr>
<tr>
<th>Cổng giao tiếp</th>
<th>1 SuperSpeed USB Type-C® 5Gbps signaling rate<br> 2 SuperSpeed USB Type-A 5Gbps signaling rate<br> 1 HDMI 1.4b<br> 1 RJ-45<br> 1 AC smart pin<br> 1 headphone/microphone combo</th>
</tr>
<tr>
 <th>Hệ điều hành</th>
<th>Windows 10 Home SL </th>
</tr>
<tr>
<th>Pin</th>
<th>3-cell, 41 Wh Li-ion</th>
</tr>
<tr>
<th>Kích thước</th>
<th>35.85 x 24.2 x 1.99 cm</th>
</tr>
<tr>
<th>Công nghệ màn hình</th>
<th>Màn hình chống loá, 250 nits, 45% NTSC</th>
</tr>
</tbody>
</table>
</div>', 100000, 5000000, 5000000, 10000000, 2, '2021-12-05 21:23:34', '2022-01-07 01:09:38', 1, 0, 1, 0),
        (4, 'Laptop HP Probook 430 G8 2H0N6PA', 'Chiếc laptop HP Probook 430 G8 2H0N6PA hỗ trợ đa dạng công việc văn phòng học tập. ', '<div class="box-content">
<table id="tskt">
<tbody>
<tr>
<th>Loại CPU</th>
<th>Intel Core i5-1135G7 Processor (4 x 2.40 GHz), Max Turbo Frequency : 4.20 GHz</th>
</tr>
<tr>
<th>Loại card đồ họa</th>
<th>Intel Iris Xe Graphics</th>
</tr>
<tr>
<th>Dung lượng RAM</th>
<th>4GB</th>
</tr>
<tr>
<th>Ổ cứng</th>
<th>256GB SSD PCIe (M.2 2280)</th>
</tr>
<tr>
<th>Kích thước màn hình</th>
<th>13.3 inches</th>
</tr>
<tr>
<th>Độ phân giải màn hình</th>
<th>1920 x 1080 pixels (FullHD)</th>
</tr>
<tr>
<th>Cổng giao tiếp</th>
<th>1 x USB 3.1 Gen 1 Type-A (supports power port)<br> 1 x USB 3.1 Gen 1 Type-A (supports charging)<br> 1 x USB 3.1 Gen 1 Type-C (supports DisplayPort)<br> 1 x HDMI<br> 1 x Headphone/Microphone combo audio jack</th>
</tr>
<tr>
<th>Hệ điều hành</th>
<th>Windows 10 Home SL</th>
</tr>
<tr>
<th>Pin</th>
<th>3 Cell Int (45Wh)</th>
</tr>
<tr>
<th>Kích thước</th>
<th>30.69 x 20.84 x 1.59 cm (W x D x H)</th>
</tr>
<tr>
<th>Công nghệ màn hình</th>
<th>Màn hình chống loá</th>
</tr>
</tbody>
</table>
</div>', 300000, 16000000, 16000000, 21000000, 2, '2021-12-07 21:26:03', '2022-01-15 21:26:07', 1, 0, 1, 0),
        (5, 'Laptop HP Probook 430 G8 2H0N6PA', '15s-fq2602TU 4B6D3PA là một sản phẩm mới đến từ thương hiệu HP.', '<div class="box-content">
<table id="tskt">
<tbody>
<tr>
<th>Loại CPU</th>
<th>Intel Core i5-1135G7 (up to 4.20 GHz, 8MB)</th>
</tr>
<tr>
<th>Loại card đồ họa</th>
<th>Intel UHD Graphics</th>
</tr>
<tr>
<th>Dung lượng RAM</th>
<th>8GB</th>
</tr>
<tr>
<th>Ổ cứng</th>
<th>256GB PCIe® NVMe™ M.2 SSD</th>
</tr>
<tr>
<th>Kích thước màn hình</th>
<th>15.6 inches</th>
</tr>
<tr>
<th>Độ phân giải màn hình</th>
<th>1366 x 768 pixels (HD+)</th>
</tr>
<tr>
<th>Cổng giao tiếp</th>
<th>1 x USB Type-C<br> 2 x USB Type-A<br> 1 x HDMI<br> 1 x headphone/microphone jack</th>
</tr>
<tr>
<th>Hệ điều hành</th>
<th>Windows 11 Home SL </th>
</tr>
<tr>
<th>Pin</th>
<th>3-cell, 41 Wh</th>
</tr>
<tr>
<th>Kích thước</th>
<th>35.85 x 24.2 x 1.79 cm</th>
</tr>
<tr>
<th>Công nghệ màn hình</th>
<th>250 nits, 45% NTSC</th>
</tr>
</tbody>
</table>
</div>', 200000, 13000000, 13000000, 17000000, 2, '2021-12-06 21:28:29', '2021-12-25 21:28:33', 1, 0, 1, 0),
        (6, 'iPhone 13 | Chính hãng VN/A', ' Sau đó, mọi sự quan tâm lại đổ dồn vào iPhone 13.', '<div class="box-content">
<table id="tskt">
<tbody>
<tr>
<th>Kích thước màn hình</th>
<th>6.1 inches</th>
</tr>
<tr>
<th>Công nghệ màn hình</th>
<th>OLED</th>
</tr>
<tr>
<th>Camera sau</th>
<th>Camera góc rộng: 12MP, f/1.6 <br> Camera góc siêu rộng: 12MP, ƒ/2.4 </th>
</tr>
<tr>
<th>Camera trước</th>
<th>12MP, f/2.2</th>
</tr>
<tr>
<th>Chipset</th>
<th>Apple A15</th>
</tr>
<tr>
<th>Dung lượng RAM</th>
<th>4 GB</th>
</tr>
<tr>
<th>Bộ nhớ trong</th>
<th>128 GB</th>
</tr>
<tr>
<th>Pin</th>
<th>Khoảng 3.200mAh</th>
</tr>
<tr>
<th>Hệ điều hành</th>
<th> iOS 15</th>
</tr>
<tr>
<th>Độ phân giải màn hình</th>
<th>2532 x 1170 pixels</th>
</tr>
<tr>
<th>Kích thước</th>
<th>146,7 x 71,5 x 7,65mm</th>
</tr>
</tbody>
</table>
</div>', 400000, 20000000, 20000000, 25000000, 1, '2021-12-03 21:31:35', '2022-02-27 21:31:42', 1, 0, 1, 0),
        (7, 'Samsung Galaxy Note 20 Ultra 5G', 'Bên cạnh biên bản Galaxy Note 20 thường, Samsung còn cho ra mắt Note 20 Ultra 5G.', '<div class="box-content">
<table id="tskt">
<tbody>
<tr>
<th>Kích thước màn hình</th>
<th>6.9 inches</th>
</tr>
<tr>
<th>Công nghệ màn hình</th>
<th>Dynamic AMOLED</th>
</tr>
<tr>
<th>Camera sau</th>
<th>108 MP, f/1.8, 26mm (wide), 1/1.33", 0.8µm, PDAF, Laser AF, OIS<br> 12 MP, f/3.0, 103mm (periscope telephoto), 1.0µm, PDAF, OIS, 5x optical zoom, 50x hybrid zoom<br> 12 MP, f/2.2, 13mm (ultrawide), 1/2.55", 1.4µm</th>
</tr>
<tr>
<th>Camera trước</th>
<th>10 MP, f/2.2, 26mm (wide), 1/3.2", 1.22µm, Dual Pixel PDAF</th>
</tr>
<tr>
<th>Chipset</th>
<th>Exynos 990 (7 nm+)</th>
</tr>
<tr>
<th>Dung lượng RAM</th>
<th>12 GB</th>
</tr>
<tr>
<th>Bộ nhớ trong</th>
<th>256 GB</th>
</tr>
<tr>
<th>Pin</th>
<th>Non-removable Li-Ion 4500 mAh battery<br> Fast charging 25W<br> USB Power Delivery 3.0<br> Fast Qi/PMA wireless charging<br> Reverse wireless charging 9W</th>
</tr>
<tr>
<th>Thẻ SIM</th>
<th>2 SIM (Nano-SIM)</th>
</tr>
<tr>
<th>Hệ điều hành</th>
<th>Android 10, One UI 2.1</th>
</tr>
<tr>
<th>Độ phân giải màn hình</th>
<th>1440 x 3088 pixels (QHD+)</th>
</tr>
<tr>
<th>Loại CPU</th>
<th>Octa-core (2x2.73 GHz Mongoose M5 &amp; 2x2.50 GHz Cortex-A76 &amp; 4x2.0 GHz Cortex-A55)</th>
</tr>
<tr>
<th>Kích thước</th>
<th>164.8 x 77.2 x 8.1 mm</th>
</tr>
</tbody>
</table>
</div>', 190000, 19000000, 19000000, 22000000, 1, '2021-12-05 21:33:38', '2021-12-06 18:33:41', 1, 0, 1, 0),
        (8, 'Xiaomi Mi 11 Lite 5G', 'Mi 11 Lite 5G và 4G là bộ đôi vừa được Xiaomi trình làng.', '<div class="box-content">
<table id="tskt">
<tbody>
<tr>
<th>Kích thước màn hình</th>
<th>6.55 inches</th>
</tr>
<tr>
<th>Công nghệ màn hình</th>
<th>AMOLED</th>
</tr>
<tr>
<th>Camera sau</th>
<th>Camera chính: 64 MP, f/1.8<br> Camera góc rộng: 8 MP, f/2.2, 119˚ <br> Camera cận cảnh: 5 MP, f/2.4</th>
</tr>
<tr>
<th>Camera trước</th>
<th>20 MP, f/2.5</th>
</tr>
<tr>
<th>Chipset</th>
<th>Snapdragon 780G (5 nm)</th>
</tr>
<tr>
<th>Dung lượng RAM</th>
<th>8 GB</th>
</tr>
<tr>
<th>Bộ nhớ trong</th>
<th>128 GB</th>
</tr>
<tr>
<th>Pin</th>
<th>Li-Po 4250 mAh</th>
</tr>
<tr>
<th>Thẻ SIM</th>
<th>2 SIM (Nano-SIM)</th>
</tr>
<tr>
<th>Hệ điều hành</th>
<th>Android 11, MIUI 12</th>
</tr>
<tr>
<th>Độ phân giải màn hình</th>
<th>1080 x 2400 pixels (FullHD+)</th>
</tr>
<tr>
<th>Loại CPU</th>
<th>8 nhân (1x2.4 GHz Kryo 670 &amp; 3x2.2 GHz Kryo 670 &amp; 4x1.90 GHz Kryo 670)</th>
</tr>
<tr>
<th>Kích thước</th>
<th>160.5 x 75.7 x 6.8 mm</th>
</tr>
</tbody>
</table>
</div>', 100000, 6000000, 6000000, 10000000, 1, '2021-12-05 21:34:50', '2022-02-05 21:34:53', 1, 0, 1, 0),
        (9, 'OPPO Reno6 5G', 'Tiếp theo phần ra mắt của series Reno 5 thì Oppo lại chuẩn bị trình làng.', '<div class="box-content">
<table id="tskt">
<tbody>
<tr>
<th>Kích thước màn hình</th>
<th>6.43 inches</th>
</tr>
<tr>
<th>Công nghệ màn hình</th>
<th>AMOLED</th>
</tr>
<tr>
<th>Camera sau</th>
<th>Camera góc rộng: 64 MP, f/1.7, PDAF <br> Camera góc siêu rộng: 8 MP, f/2.2 <br> Camera macro: 2 MP, f/2.4 </th>
</tr>
<tr>
<th>Camera trước</th>
<th>32 MP, f/2.4</th>
 </tr>
<tr>
<th>Chipset</th>
<th>MT6877 Dimensity 900 5G (6 nm)</th>
</tr>
<tr>
<th>Dung lượng RAM</th>
<th>8 GB</th>
</tr>
<tr>
<th>Bộ nhớ trong</th>
<th>128 GB</th>
</tr>
<tr>
<th>Pin</th>
<th> Li-P0 4300 mAh</th>
</tr>
<tr>
<th>Thẻ SIM</th>
<th>2 SIM (Nano-SIM)</th>
</tr>
<tr>
<th>Hệ điều hành</th>
<th>Android 11, ColorOS 11.3</th>
</tr>
<tr>
<th>Độ phân giải màn hình</th>
<th>1080 x 2400 pixels (FullHD+)</th>
</tr>
<tr>
<th>Loại CPU</th>
<th>2x2.4 GHz Cortex-A78 &amp; 6x2.0 GHz Cortex-A55</th>
</tr>
<tr>
<th>Kích thước</th>
<th>156.8 x 72.1 x 7.59 mm</th>
</tr>
</tbody>
</table>
</div>', 150000, 9000000, 9000000, 12000000, 1, '2021-12-05 21:36:03', '2022-01-12 21:36:05', 1, 0, 1, 0),
        (10, 'Nokia 5.4', 'Nokia chắc chắn là một trong những thương hiệu không còn xa lạ với người dùng', '<div class="box-content">
<table id="tskt">
<tbody>
<tr>
<th>Kích thước màn hình</th>
<th>6.39 inches</th>
</tr>
<tr>
<th>Công nghệ màn hình</th>
<th>IPS LCD</th>
</tr>
<tr>
<th>Camera sau</th>
<th>48 MP, f/1.8, (wide), PDAF<br> 5 MP, 13mm (ultrawide)<br> 2 MP, (macro)<br> 2 MP, (depth)</th>
</tr>
<tr>
<th>Camera trước</th>
<th>16 MP, f/2.0, (wide)</th>
</tr>
<tr>
<th>Chipset</th>
<th>Qualcomm SM6115 Snapdragon 662 (11 nm)</th>
</tr>
<tr>
<th>Dung lượng RAM</th>
<th>4 GB</th>
</tr>
<tr>
<th>Bộ nhớ trong</th>
<th>128 GB</th>
</tr>
<tr>
<th>Pin</th>
<th>Li-Po 4000 mAh</th>
</tr>
<tr>
<th>Thẻ SIM</th>
<th>2 SIM (Nano-SIM)</th>
</tr>
<tr>
<th>Hệ điều hành</th>
<th>Android 10</th>
</tr>
<tr>
<th>Độ phân giải màn hình</th>
<th>720 x 1560 pixes</th>
</tr>
<tr>
<th>Loại CPU</th>
<th>Octa-core (4x2.0 GHz Kryo 260 Gold &amp; 4x1.8 GHz Kryo 260 Silver)</th>
</tr>
<tr>
<th>Kích thước</th>
<th>161 x 76 x 8.7 mm</th>
</tr>
</tbody>
</table>
</div>', 50000, 2000000, 2000000, 5000000, 1, '2021-12-05 21:37:18', '2022-01-11 15:37:19', 1, 0, 1, 0),
        (11, 'Realme 6', 'Realme 6 ra mắt mới đây cùng với Realme 6 Pro tiếp nối sự thành công', '<div class="box-content">
<table id="tskt">
<tbody>
<tr>
<th>Kích thước màn hình</th>
<th>6.5 inches</th>
</tr>
<tr>
<th>Camera sau</th>
<th>Chính 64 MP &amp; Phụ 8 MP, 2 MP, 2 MP</th>
</tr>
<tr>
<th>Camera trước</th>
<th>16 MP</th>
</tr>
<tr>
<th>Chipset</th>
<th>Mediatek Helio G90T</th>
</tr>
<tr>
<th>Dung lượng RAM</th>
<th>4 GB</th>
</tr>
<tr>
<th>Bộ nhớ trong</th>
<th>128 GB</th>
</tr>
<tr>
<th>Pin</th>
<th>4300 mAh, Sạc nhanh VOOC 4.0(30W)</th>
</tr>
<tr>
<th>Thẻ SIM</th>
<th>2 SIM (Nano-SIM)</th>
</tr>
<tr>
<th>Hệ điều hành</th>
<th>Android v10 (Q)</th>
</tr>
<tr>
<th>Độ phân giải màn hình</th>
<th>1080 x 2400 pixels (FullHD+)</th>
</tr>
<tr>
<th>Loại CPU</th>
<th>2.05 GHz</th>
</tr>
<tr>
<th>Kích thước</th>
<th>162.1 x 74.8 x 8.9 mm</th>
</tr>
</tbody>
</table>
</div>', 70000, 3000000, 3000000, 6000000, 1, '2021-12-05 21:38:57', '2022-01-31 21:39:02', 1, 0, 1, 0),
        (12, 'Lò Vi Sóng Có Nướng Hafele HW-F23B', ' có kích thước nhỏ gọn với dung tích 23 lít. Công suất nướng 1.000W.', '<div class="box-content">
<table id="tskt">
<tbody>
<tr>
<th>Kích thước màn hình</th>
<th>6.5 inches</th>
</tr>
<tr>
<th>Camera sau</th>
<th>Chính 64 MP &amp; Phụ 8 MP, 2 MP, 2 MP</th>
</tr>
<tr>
<th>Camera trước</th>
<th>16 MP</th>
</tr>
<tr>
<th>Chipset</th>
<th>Mediatek Helio G90T</th>
</tr>
<tr>
<th>Dung lượng RAM</th>
<th>4 GB</th>
</tr>
<tr>
<th>Bộ nhớ trong</th>
<th>128 GB</th>
</tr>
<tr>
<th>Pin</th>
<th>4300 mAh, Sạc nhanh VOOC 4.0(30W)</th>
</tr>
<tr>
<th>Thẻ SIM</th>
<th>2 SIM (Nano-SIM)</th>
</tr>
<tr>
<th>Hệ điều hành</th>
<th>Android v10 (Q)</th>
</tr>
<tr>
<th>Độ phân giải màn hình</th>
<th>1080 x 2400 pixels (FullHD+)</th>
</tr>
<tr>
<th>Loại CPU</th>
<th>2.05 GHz</th>
</tr>
<tr>
<th>Kích thước</th>
<th>162.1 x 74.8 x 8.9 mm</th>
</tr>
</tbody>
</table>
</div>', 50000, 1500000, 1500000, 4000000, 3, '2021-12-05 21:42:36', '2022-01-11 15:42:39', 1, 0, 1, 0),
        (13, 'Lò Vi Sóng Electrolux EMM2026MX', 'tông màu đen chủ đạo kết hợp viền thép không gỉ, tạo nên nét sang trọng.', '<div class="box-content">
<table id="tskt">
<tbody>
<tr>
<th>Kích thước màn hình</th>
<th>6.5 inches</th>
</tr>
<tr>
<th>Camera sau</th>
<th>Chính 64 MP &amp; Phụ 8 MP, 2 MP, 2 MP</th>
</tr>
<tr>
<th>Camera trước</th>
<th>16 MP</th>
</tr>
<tr>
<th>Chipset</th>
<th>Mediatek Helio G90T</th>
</tr>
<tr>
<th>Dung lượng RAM</th>
<th>4 GB</th>
</tr>
<tr>
<th>Bộ nhớ trong</th>
<th>128 GB</th>
</tr>
<tr>
<th>Pin</th>
<th>4300 mAh, Sạc nhanh VOOC 4.0(30W)</th>
</tr>
<tr>
<th>Thẻ SIM</th>
<th>2 SIM (Nano-SIM)</th>
</tr>
<tr>
<th>Hệ điều hành</th>
<th>Android v10 (Q)</th>
</tr>
<tr>
<th>Độ phân giải màn hình</th>
<th>1080 x 2400 pixels (FullHD+)</th>
</tr>
<tr>
<th>Loại CPU</th>
<th>2.05 GHz</th>
</tr>
<tr>
<th>Kích thước</th>
<th>162.1 x 74.8 x 8.9 mm</th>
</tr>
</tbody>
</table>
</div>', 30000, 800000, 800000, 3000000, 3, '2021-12-05 21:43:54', '2021-12-29 21:43:58', 1, 0, 1, 0),
        (14, 'Sharp R-205VN', 'Thiết kế nhỏ gọn với những đường nét tính tế và hiện đại.', '<div class="box-content">
<table id="tskt">
<tbody>
<tr>
<th>Kích thước màn hình</th>
<th>6.5 inches</th>
</tr>
<tr>
<th>Camera sau</th>
<th>Chính 64 MP &amp; Phụ 8 MP, 2 MP, 2 MP</th>
</tr>
<tr>
<th>Camera trước</th>
<th>16 MP</th>
</tr>
<tr>
<th>Chipset</th>
<th>Mediatek Helio G90T</th>
</tr>
<tr>
<th>Dung lượng RAM</th>
<th>4 GB</th>
</tr>
<tr>
<th>Bộ nhớ trong</th>
<th>128 GB</th>
</tr>
<tr>
<th>Pin</th>
<th>4300 mAh, Sạc nhanh VOOC 4.0(30W)</th>
</tr>
<tr>
<th>Thẻ SIM</th>
<th>2 SIM (Nano-SIM)</th>
</tr>
<tr>
<th>Hệ điều hành</th>
<th>Android v10 (Q)</th>
</tr>
<tr>
<th>Độ phân giải màn hình</th>
<th>1080 x 2400 pixels (FullHD+)</th>
</tr>
<tr>
<th>Loại CPU</th>
<th>2.05 GHz</th>
</tr>
<tr>
<th>Kích thước</th>
<th>162.1 x 74.8 x 8.9 mm</th>
</tr>
</tbody>
</table>
</div>', 20000, 800000, 800000, 2000000, 3, '2021-12-05 21:44:57', '2022-03-05 21:44:59', 1, 0, 1, 0),
        (15, 'Máy Làm Bánh BIYI BM1513F', 'Sản phẩm không tiết ra các chất độc hại trong quá trình sử dụng, ngoài ra khuôn nướng.', '<div class="box-content">
<table id="tskt">
<tbody>
<tr>
<th>Kích thước màn hình</th>
<th>6.5 inches</th>
</tr>
<tr>
<th>Camera sau</th>
<th>Chính 64 MP &amp; Phụ 8 MP, 2 MP, 2 MP</th>
</tr>
<tr>
<th>Camera trước</th>
<th>16 MP</th>
</tr>
<tr>
<th>Chipset</th>
<th>Mediatek Helio G90T</th>
</tr>
<tr>
<th>Dung lượng RAM</th>
<th>4 GB</th>
</tr>
<tr>
<th>Bộ nhớ trong</th>
<th>128 GB</th>
</tr>
<tr>
<th>Pin</th>
<th>4300 mAh, Sạc nhanh VOOC 4.0(30W)</th>
</tr>
<tr>
<th>Thẻ SIM</th>
<th>2 SIM (Nano-SIM)</th>
</tr>
<tr>
<th>Hệ điều hành</th>
<th>Android v10 (Q)</th>
</tr>
<tr>
<th>Độ phân giải màn hình</th>
<th>1080 x 2400 pixels (FullHD+)</th>
</tr>
<tr>
<th>Loại CPU</th>
<th>2.05 GHz</th>
</tr>
<tr>
<th>Kích thước</th>
<th>162.1 x 74.8 x 8.9 mm</th>
</tr>
</tbody>
</table>
</div>', 10000, 200000, 200000, 1000000, 4, '2021-12-05 21:47:39', '2022-02-08 21:47:43', 1, 0, 1, 0),
        (16, 'Máy làm bánh nướng hình thú ngộ nghĩnh.', 'Máy có kiểu dáng nhỏ gọn, trọng lượng chỉ 1.6kg để bạn có thể dễ dàng chi chuyển.', '<div class="box-content">
<table id="tskt">
<tbody>
<tr>
<th>Kích thước màn hình</th>
<th>6.5 inches</th>
</tr>
<tr>
<th>Camera sau</th>
<th>Chính 64 MP &amp; Phụ 8 MP, 2 MP, 2 MP</th>
</tr>
<tr>
<th>Camera trước</th>
<th>16 MP</th>
</tr>
<tr>
<th>Chipset</th>
<th>Mediatek Helio G90T</th>
</tr>
<tr>
<th>Dung lượng RAM</th>
<th>4 GB</th>
</tr>
<tr>
<th>Bộ nhớ trong</th>
<th>128 GB</th>
</tr>
<tr>
<th>Pin</th>
<th>4300 mAh, Sạc nhanh VOOC 4.0(30W)</th>
</tr>
<tr>
<th>Thẻ SIM</th>
<th>2 SIM (Nano-SIM)</th>
</tr>
<tr>
<th>Hệ điều hành</th>
<th>Android v10 (Q)</th>
</tr>
<tr>
<th>Độ phân giải màn hình</th>
<th>1080 x 2400 pixels (FullHD+)</th>
</tr>
<tr>
<th>Loại CPU</th>
<th>2.05 GHz</th>
</tr>
<tr>
<th>Kích thước</th>
<th>162.1 x 74.8 x 8.9 mm</th>
</tr>
</tbody>
</table>
</div>', 10000, 200000, 200000, 400000, 4, '2021-12-05 21:48:37', '2022-01-12 11:48:38', 1, 0, 1, 0),
        (17, '3 Trong 1 Tiross TS513', 'Máy làm bánh Tiross TS513 với 3 loại vỉ nướng đi kèm, bạn có thể làm các loại bánh.', '<div class="box-content">
<table id="tskt">
<tbody>
<tr>
<th>Kích thước màn hình</th>
<th>6.5 inches</th>
</tr>
<tr>
<th>Camera sau</th>
<th>Chính 64 MP &amp; Phụ 8 MP, 2 MP, 2 MP</th>
</tr>
<tr>
<th>Camera trước</th>
<th>16 MP</th>
</tr>
<tr>
<th>Chipset</th>
<th>Mediatek Helio G90T</th>
</tr>
<tr>
<th>Dung lượng RAM</th>
<th>4 GB</th>
</tr>
<tr>
<th>Bộ nhớ trong</th>
<th>128 GB</th>
</tr>
<tr>
<th>Pin</th>
<th>4300 mAh, Sạc nhanh VOOC 4.0(30W)</th>
</tr>
<tr>
<th>Thẻ SIM</th>
<th>2 SIM (Nano-SIM)</th>
</tr>
<tr>
<th>Hệ điều hành</th>
<th>Android v10 (Q)</th>
</tr>
<tr>
<th>Độ phân giải màn hình</th>
<th>1080 x 2400 pixels (FullHD+)</th>
</tr>
<tr>
<th>Loại CPU</th>
<th>2.05 GHz</th>
</tr>
<tr>
<th>Kích thước</th>
<th>162.1 x 74.8 x 8.9 mm</th>
</tr>
</tbody>
</table>
</div>', 15000, 400000, 400000, 700000, 4, '2021-12-05 21:49:39', '2022-01-13 21:49:40', 1, 0, 1, 0),
        (18, 'Máy Bào Đá Kahchan EP5178_Đ', 'nhỏ gọn dễ sử dụng. Công suất máy hoạt động chỉ với 300W không lo điện năng.', '<div class="box-content">
<table id="tskt">
<tbody>
<tr>
<th>Kích thước màn hình</th>
<th>6.5 inches</th>
</tr>
<tr>
<th>Camera sau</th>
<th>Chính 64 MP &amp; Phụ 8 MP, 2 MP, 2 MP</th>
</tr>
<tr>
<th>Camera trước</th>
<th>16 MP</th>
</tr>
<tr>
<th>Chipset</th>
<th>Mediatek Helio G90T</th>
</tr>
<tr>
<th>Dung lượng RAM</th>
<th>4 GB</th>
</tr>
<tr>
<th>Bộ nhớ trong</th>
<th>128 GB</th>
</tr>
<tr>
<th>Pin</th>
<th>4300 mAh, Sạc nhanh VOOC 4.0(30W)</th>
</tr>
<tr>
<th>Thẻ SIM</th>
<th>2 SIM (Nano-SIM)</th>
</tr>
<tr>
<th>Hệ điều hành</th>
<th>Android v10 (Q)</th>
</tr>
<tr>
<th>Độ phân giải màn hình</th>
<th>1080 x 2400 pixels (FullHD+)</th>
</tr>
<tr>
<th>Loại CPU</th>
<th>2.05 GHz</th>
</tr>
<tr>
<th>Kích thước</th>
<th>162.1 x 74.8 x 8.9 mm</th>
</tr>
</tbody>
</table>
</div>', 200000, 1400000, 1400000, 1700000, 5, '2021-12-05 21:51:18', '2022-01-14 21:51:19', 1, 0, 1, 0),
        (19, 'Tự Động Tiross TS9090 (Xanh) - Hàng Chính Hãng', 'màu sắc đẹp mắt và sở hữu tính năng hiện đại, giúp bạn tự làm món kem thơm ngon. ', '<div class="box-content">
<table id="tskt">
<tbody>
<tr>
<th>Kích thước màn hình</th>
<th>6.5 inches</th>
</tr>
<tr>
<th>Camera sau</th>
<th>Chính 64 MP &amp; Phụ 8 MP, 2 MP, 2 MP</th>
</tr>
<tr>
<th>Camera trước</th>
<th>16 MP</th>
</tr>
<tr>
<th>Chipset</th>
<th>Mediatek Helio G90T</th>
</tr>
<tr>
<th>Dung lượng RAM</th>
<th>4 GB</th>
</tr>
<tr>
<th>Bộ nhớ trong</th>
<th>128 GB</th>
</tr>
<tr>
<th>Pin</th>
<th>4300 mAh, Sạc nhanh VOOC 4.0(30W)</th>
</tr>
<tr>
<th>Thẻ SIM</th>
<th>2 SIM (Nano-SIM)</th>
</tr>
<tr>
<th>Hệ điều hành</th>
<th>Android v10 (Q)</th>
</tr>
<tr>
<th>Độ phân giải màn hình</th>
<th>1080 x 2400 pixels (FullHD+)</th>
</tr>
<tr>
<th>Loại CPU</th>
<th>2.05 GHz</th>
</tr>
<tr>
<th>Kích thước</th>
<th>162.1 x 74.8 x 8.9 mm</th>
</tr>
</tbody>
</table>
</div>', 250000, 2000000, 2000000, 2500000, 5, '2021-12-05 21:52:34', '2022-01-19 06:52:35', 1, 0, 1, 0),
        (20, 'UNOLD 48895 Dung Tích 1.5 Lít', 'Công nghệ được đóng gói trong một vỏ thép không gỉ thanh lịch, bền.', '<ul>
<li>Công suất định mức: 150 W, 220-240 V ~, 50 Hz</li>
<li>Kích thước (LxWxH): 42.5 x 28.5 x 26.2 cm</li>
<li>Dung tích ca kem: 1.4L~1.5L</li>
<li>Chất liệu: Inox cao cấp không gỉ, sáng bóng</li>
<li>Phạm vi làm mát: ± -18 ° C đến ± -35 ° C</li>
<li>Hẹn giờ kỹ thuật số có thể điều chỉnh trong khoảng từ 5 đến 60 phút</li>
<li>Nhập khẩu tại Đức</li>
<li>Phụ kiện: Tập sách công thức với công thức làm kem Schuhbeck, hướng dẫn sử dụng với công thức nấu ăn</li>
</ul>', 300000, 7000000, 7000000, 9000000, 5, '2021-12-05 21:55:05', '2022-01-15 21:55:06', 1, 0, 1, 0),
        (21, 'Bear JA02N1 240ml', 'Máy Cafe Gia Đình Bear JA02N1 240ml có ngăn chứa dung tích 240ml', '<ul>
<li>Công suất định mức: 150 W, 220-240 V ~, 50 Hz</li>
<li>Kích thước (LxWxH): 42.5 x 28.5 x 26.2 cm</li>
<li>Dung tích ca kem: 1.4L~1.5L</li>
<li>Chất liệu: Inox cao cấp không gỉ, sáng bóng</li>
<li>Phạm vi làm mát: ± -18 ° C đến ± -35 ° C</li>
<li>Hẹn giờ kỹ thuật số có thể điều chỉnh trong khoảng từ 5 đến 60 phút</li>
<li>Nhập khẩu tại Đức</li>
<li>Phụ kiện: Tập sách công thức với công thức làm kem Schuhbeck, hướng dẫn sử dụng với công thức nấu ăn</li>
</ul>', 50000, 800000, 800000, 1500000, 6, '2021-12-05 21:56:59', '2022-01-18 15:17:00', 1, 0, 1, 0),
        (22, 'L-Beans 900A công suất 360W', 'Máy xay cafe chuyên nghiệp của L-Beans luôn được đánh giá cao vì sự bền bỉ.', '<ul>
<li>Công suất định mức: 150 W, 220-240 V ~, 50 Hz</li>
<li>Kích thước (LxWxH): 42.5 x 28.5 x 26.2 cm</li>
<li>Dung tích ca kem: 1.4L~1.5L</li>
<li>Chất liệu: Inox cao cấp không gỉ, sáng bóng</li>
<li>Phạm vi làm mát: ± -18 ° C đến ± -35 ° C</li>
<li>Hẹn giờ kỹ thuật số có thể điều chỉnh trong khoảng từ 5 đến 60 phút</li>
<li>Nhập khẩu tại Đức</li>
<li>Phụ kiện: Tập sách công thức với công thức làm kem Schuhbeck, hướng dẫn sử dụng với công thức nấu ăn</li>
</ul>', 200000, 9000000, 9000000, 12000000, 6, '2021-12-05 21:57:58', '2022-02-13 13:57:59', 1, 0, 1, 0),
        (23, 'Espresso Tiross TS-621', 'Chế độ đánh bọt giúp pha chế cà phê Cappuccino theo phong cách Ý.', '<ul>
<li>Công suất định mức: 150 W, 220-240 V ~, 50 Hz</li>
<li>Kích thước (LxWxH): 42.5 x 28.5 x 26.2 cm</li>
<li>Dung tích ca kem: 1.4L~1.5L</li>
<li>Chất liệu: Inox cao cấp không gỉ, sáng bóng</li>
<li>Phạm vi làm mát: ± -18 ° C đến ± -35 ° C</li>
<li>Hẹn giờ kỹ thuật số có thể điều chỉnh trong khoảng từ 5 đến 60 phút</li>
<li>Nhập khẩu tại Đức</li>
<li>Phụ kiện: Tập sách công thức với công thức làm kem Schuhbeck, hướng dẫn sử dụng với công thức nấu ăn</li>
</ul>', 30000, 700000, 700000, 1200000, 6, '2021-12-05 21:59:04', '2022-02-05 21:59:05', 1, 0, 1, 0),
        (24, 'Máy xay tích điện mini', ' hình thức và địa chỉ giao hàng mà có thể phát sinh thêm chi phí khác như phí vận chuyển', '<ul>
<li>Công suất định mức: 150 W, 220-240 V ~, 50 Hz</li>
<li>Kích thước (LxWxH): 42.5 x 28.5 x 26.2 cm</li>
<li>Dung tích ca kem: 1.4L~1.5L</li>
<li>Chất liệu: Inox cao cấp không gỉ, sáng bóng</li>
<li>Phạm vi làm mát: ± -18 ° C đến ± -35 ° C</li>
<li>Hẹn giờ kỹ thuật số có thể điều chỉnh trong khoảng từ 5 đến 60 phút</li>
<li>Nhập khẩu tại Đức</li>
<li>Phụ kiện: Tập sách công thức với công thức làm kem Schuhbeck, hướng dẫn sử dụng với công thức nấu ăn</li>
</ul>', 10000, 70000, 70000, 200000, 7, '2021-12-05 22:05:24', '2021-12-28 15:05:25', 1, 0, 1, 0),
        (25, 'Máy Xay Thịt 2 Lưỡi Kép Nonostyle', 'Máy xay thịt Nonostyle với nhiều công dụng và tính năng ưu việt, là trợ thủ đắc lực.', '<ul>
<li>Công suất định mức: 150 W, 220-240 V ~, 50 Hz</li>
<li>Kích thước (LxWxH): 42.5 x 28.5 x 26.2 cm</li>
<li>Dung tích ca kem: 1.4L~1.5L</li>
<li>Chất liệu: Inox cao cấp không gỉ, sáng bóng</li>
<li>Phạm vi làm mát: ± -18 ° C đến ± -35 ° C</li>
<li>Hẹn giờ kỹ thuật số có thể điều chỉnh trong khoảng từ 5 đến 60 phút</li>
<li>Nhập khẩu tại Đức</li>
<li>Phụ kiện: Tập sách công thức với công thức làm kem Schuhbeck, hướng dẫn sử dụng với công thức nấu ăn</li>
</ul>', 10000, 200000, 200000, 400000, 7, '2021-12-05 22:13:40', '2022-01-16 05:13:41', 1, 0, 1, 0),
        (26, 'Some By Mi Super Matcha Pore Clean Clay Mask 100g', 'Mặt Nạ Đất Sét Some By Mi Super Matcha Pore Clean Clay Mask với thành phần đất sét và trà xanh', '<ul>
<li>Công suất định mức: 150 W, 220-240 V ~, 50 Hz</li>
<li>Kích thước (LxWxH): 42.5 x 28.5 x 26.2 cm</li>
<li>Dung tích ca kem: 1.4L~1.5L</li>
<li>Chất liệu: Inox cao cấp không gỉ, sáng bóng</li>
<li>Phạm vi làm mát: ± -18 ° C đến ± -35 ° C</li>
<li>Hẹn giờ kỹ thuật số có thể điều chỉnh trong khoảng từ 5 đến 60 phút</li>
<li>Nhập khẩu tại Đức</li>
<li>Phụ kiện: Tập sách công thức với công thức làm kem Schuhbeck, hướng dẫn sử dụng với công thức nấu ăn</li>
</ul>', 10000, 200000, 200000, 400000, 8, '2021-12-05 22:32:26', '2022-02-05 22:32:27', 1, 0, 1, 0),
        (27, 'Vitamin C SAP Neogen Dermalogy Real Vita Serum 32g', 'Tinh chất sở hữu bộ đôi vàng Vitamin C dạng SAP + niacinamide hàm lượng cao giúp giảm thâm.', '<ul>
<li>Công suất định mức: 150 W, 220-240 V ~, 50 Hz</li>
<li>Kích thước (LxWxH): 42.5 x 28.5 x 26.2 cm</li>
<li>Dung tích ca kem: 1.4L~1.5L</li>
<li>Chất liệu: Inox cao cấp không gỉ, sáng bóng</li>
<li>Phạm vi làm mát: ± -18 ° C đến ± -35 ° C</li>
<li>Hẹn giờ kỹ thuật số có thể điều chỉnh trong khoảng từ 5 đến 60 phút</li>
<li>Nhập khẩu tại Đức</li>
<li>Phụ kiện: Tập sách công thức với công thức làm kem Schuhbeck, hướng dẫn sử dụng với công thức nấu ăn</li>
</ul>', 50000, 460000, 460000, 860000, 8, '2021-12-05 22:33:22', '2022-02-01 17:33:22', 1, 0, 1, 0),
        (28, 'Kem Dưỡng Ẩm Hỗ Trợ Trị Nám', 'Được đặc chế hòa nhịp với quá trình thay đổi sinh học của làn da.', '<ul>
<li>Công suất định mức: 150 W, 220-240 V ~, 50 Hz</li>
<li>Kích thước (LxWxH): 42.5 x 28.5 x 26.2 cm</li>
<li>Dung tích ca kem: 1.4L~1.5L</li>
<li>Chất liệu: Inox cao cấp không gỉ, sáng bóng</li>
<li>Phạm vi làm mát: ± -18 ° C đến ± -35 ° C</li>
<li>Hẹn giờ kỹ thuật số có thể điều chỉnh trong khoảng từ 5 đến 60 phút</li>
<li>Nhập khẩu tại Đức</li>
<li>Phụ kiện: Tập sách công thức với công thức làm kem Schuhbeck, hướng dẫn sử dụng với công thức nấu ăn</li>
</ul>', 60000, 700000, 700000, 900000, 8, '2021-12-05 22:34:33', '2022-02-02 22:34:33', 1, 0, 1, 0),
        (29, 'Nước hoa nam Dynik hương biển sành điệu 50ml', 'Bên cạnh đó, tuỳ vào loại sản phẩm, hình thức và địa chỉ giao hàng mà có thể phát sinh', '<ul>
<li>Công suất định mức: 150 W, 220-240 V ~, 50 Hz</li>
<li>Kích thước (LxWxH): 42.5 x 28.5 x 26.2 cm</li>
<li>Dung tích ca kem: 1.4L~1.5L</li>
<li>Chất liệu: Inox cao cấp không gỉ, sáng bóng</li>
<li>Phạm vi làm mát: ± -18 ° C đến ± -35 ° C</li>
<li>Hẹn giờ kỹ thuật số có thể điều chỉnh trong khoảng từ 5 đến 60 phút</li>
<li>Nhập khẩu tại Đức</li>
<li>Phụ kiện: Tập sách công thức với công thức làm kem Schuhbeck, hướng dẫn sử dụng với công thức nấu ăn</li>
</ul>', 55000, 300000, 300000, 700000, 9, '2021-12-05 22:35:35', '2022-01-14 22:35:36', 1, 0, 1, 0),
       (30, 'Áo Thun Nam Cổ Tròn', 'Áo Thun Trơn Nam Tsimple được may bằng chất liệu cotton, thấm hút mồ hôi tốt, ít nhăn',
    '<ul>
    <li><span style="font-weight: 400;">Áo Thun Nam Cotton Ngắn Tay Cổ Tròn Nhiều Màu Trẻ trung, thoáng mát, thấm hút mồ
        hôi nhiều màu có thiết kế kiểu cơ bản với dáng ôm vừa phải, cổ tròn, tay ngắn</span></li>
    <li><span style="font-weight: 400;">Áo Thun Nam Cotton Ngắn Tay Cổ Tròn Nhiều Màu dễ dàng phối cùng quần jeans hoặc
        shorts, giày thể thao hoặc giày lười, thích hợp sử dụng trong các dịp đi chơi, gặp gỡ bạn bè.</span></li>
    <li><span style="font-weight: 400;">Thiết kế đơn giản, trẻ trung phù hợp cho cả nam và nữ, có thể mang đôi, mang
        nhóm.</span></li>
    <li><span style="font-weight: 400;">Nhiều màu cơ bản cũng như lạ mắt giúp biến hóa phong cách cũng như phối đồ thể
        hiện cá tính.</span></li>
    <li><span style="font-weight: 400;">Giúp người mặc có cảm giác mát mẻ, thoải mái vận động cả ngày, có thể mặc nhà,
        đi học, đi chơi, đi làm, tập thể thao.</span></li>
  </ul>
  <p> </p>
  <p><span style="font-weight: 400;">Cách bảo quản</span></p>
  <p><span style="font-weight: 400;">✓ Không nên để áo thun ở những nơi ẩm ướt, với tính chất hút ẩm, hút nước tốt, áo
      thun dễ bị ẩm mốc, thậm chí để lại những vết ố trên vải áo.</span></p>
  <p><span style="font-weight: 400;">✓ Sau khi mặc áo thun đi chơi, vận động nhiều ra mồ hôi, tốt nhất là bạn nên giặt
      liền vì để lâu áo thun sẽ có mùi hôi và ẩm mốc.</span></p>
  <p><span style="font-weight: 400;">✓ Khi phơi áo, bạn nên lộn trái áo và phơi ở chỗ mát vì ánh mặt trời cũng là một
      nguyên nhân khiến hình in và màu áo mau phai màu.</span></p>
  <p><span style="font-weight: 400;">✓ Và nên phơi ngang áo trên dây, vì sớ vải của áo thun thường có xu hướng chảy xệ
      xuống dưới, nếu bạn phơi bằng móc áo có thể khiến áo bị chảy dài làm biến dạng form áo ban đầu.</span></p>
  <p> </p>', 5000, 39000, 39000, 70000, 11, '2022-01-07 22:35:35', '2022-01-31 22:35:36', 1, 0, 1, 0),
       (31, 'Đồ Bơi Nam Và Nữ Couple', 'Thiết kế mạnh mẽ, kiểu dáng thể thao tôn dáng. Chất liệu thun co giãn, bền chắc',
        '<p>- Màu chủ đạo: trắng và đen</p>
<p>- Thiết kế 2 mảnh khỏe khoắn, đồ bơi nữ có sẵn mút ngực. Tay dài che nắng, bảo vệ tia UV (chuẩn UPF 50+) cho làn da tay của bạn.</p>
<p>- Là bộ đồ bơi cho các cặp đôi khi đi cùng nhau, hoặc cá nhân có thể mua riêng mẫu ưng ý.</p>
<p>- Chất liệu thun lạnh co giãn tốt, bền chắc, đường may đẹp.</p>
<p>- Là một trong các sản phẩm đồ bơi áo tắm bikiki đồ bơi một mảnh đồ bơi hai mảnh đồ bơi cặp đồ bơi nam nữ được yêu thích năm nay.</p>', 50000, 369000, 369000, 500000, 12, '2022-01-07 22:30:35', '2022-01-31 22:33:36', 1, 0, 1, 0),
        (32, 'Quần jogger nam RFE', 'Quần jogger nam túi hộp chất kaki mềm mịn, phong cách đường phố RFE',
         '<p>✧ Kiểu dáng trẻ trung, năng động màu sắc đẹp dễ mix đồ với giày, áo ba lỗ, áo thun, mũ lưỡi trai,</p>
<p>✧ Chất kaki đẹp, mềm mịn, thấm hút mồ hôi tốt tạo cảm giác thoải mái dễ chịu khi mặc</p>
<p>✧ Đường chỉ may tỉ mỉ, khóa túi chắc chắn, không bai, không xù, không bám dính</p>
<p>✧ Bền màu vĩnh viễn, an toàn tuyệt đối với người mặc</p>
<p>✧ Phù hợp mặc đi chơi, đi dạo, chơi thể thao, tập thể dục,</p>', 20000, 180000, 180000, 325000, 13, '2022-01-05 22:30:35', '2022-01-31 22:40:36', 1, 0, 1, 0);