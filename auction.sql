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
</div>', 200000, 14000000, 14000000, 18000000, 2, '2021-12-01 21:20:27', '2022-01-16 21:20:35', 1, 0, 1, 0),
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
</div>', 100000, 5000000, 5000000, 10000000, 2, '2021-12-05 21:23:34', '2022-01-14 09:50:38', 1, 0, 1, 0),
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
</div>', 200000, 13000000, 13000000, 17000000, 2, '2021-12-06 21:28:29', '2022-01-25 21:28:33', 1, 0, 1, 0),
        (6, 'iPhone 13 | Chính hãng VN/A', 'Sau đó, mọi sự quan tâm lại đổ dồn vào iPhone 13.', '<div class="box-content">
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
</div>', 190000, 19000000, 19000000, 22000000, 1, '2021-12-05 21:33:38', '2021-12-06 18:33:41', 1, 0, 0, 1),
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
</div>', 150000, 9000000, 9000000, 12000000, 1, '2021-12-05 21:36:03', '2022-01-16 21:36:05', 1, 0, 1, 0),
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
</div>', 50000, 2000000, 2000000, 5000000, 1, '2021-12-05 21:37:18', '2022-01-15 15:37:19', 1, 0, 1, 0),
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
        (12, 'Lò Vi Sóng Có Nướng Hafele HW-F23B', 'Có kích thước nhỏ gọn với dung tích 23 lít. Công suất nướng 1.000W.', '<table><tbody><tr><td>Bảng điều khiển</td><td>Nút nhấn kết hợp nút vặn</td></tr><tr><td>Thương hiệu</td><td>HAFELE</td></tr><tr><td>Dung tích</td><td>28L</td></tr><tr><td>Công suất</td><td>Đầu vào: 1450W; Đầu ra: 900W; Nướng: 1100W</td></tr><tr><td>Kích thước</td><td>520 x 500 x 326 mm</td></tr><tr><td>Trọng lượng</td><td>208kg</td></tr></tbody></table>', 50000, 1500000, 1500000, 4000000, 3, '2021-12-05 21:42:36', '2022-01-17 15:42:39', 1, 0, 1, 0),
        (13, 'Lò Vi Sóng Electrolux EMM2026MX', 'tông màu đen chủ đạo kết hợp viền thép không gỉ, tạo nên nét sang trọng.', '<table><tbody><tr><td>Bảng điều khiển</td><td>Nút vặn</td></tr><tr><td>Thương hiệu</td><td>Electrolux</td></tr><tr><td>Dung tích</td><td>20L</td></tr><tr><td>Công suất</td><td>1000W</td></tr><tr><td>Kích thước</td><td><p>(R x D x C) 43.95 x 33 x 25.82 cm</p></td></tr><tr><td>Trọng lượng</td><td>5.5kg</td></tr></tbody></table>', 30000, 800000, 800000, 3000000, 3, '2021-12-05 21:43:54', '2022-01-29 21:43:58', 1, 0, 1, 0),
        (14, 'Sharp R-205VN', 'Thiết kế nhỏ gọn với những đường nét tính tế và hiện đại.', '<div>
<p><span style="font-size: medium; color: #008ab7;"><strong>Lò Vi Sóng Cơ Sharp R-G302VN-S - 23 Lít</strong></span></p>
<p><strong>Thông số kỹ thuật</strong></p>
<p>- Dòng nướng cơ</p>
<p>- Dung tích (L): 23</p>
<p>- Kiểu mở cửa lò: Nhấn</p>
<p>- Kiểu thanh nướng: Thạch anh</p>
<p>- Mức công suất vi sóng: 5</p>
<p>- Trọng lượng (Kg): 14kg</p>
<p>- Kích thước đĩa xoay (mm): 270</p>
<p>- Công suất tiêu thụ: 1270W</p>
<p>- Công suất vi sóng: 800W</p>
<p>- Nướng trên: 1000W</p>
<p>- Chế độ hẹn giờ (phút): 35</p>
<p><strong>Dung tích lò 23 lít</strong></p>
</div>', 20000, 800000, 800000, 2000000, 3, '2021-12-05 21:44:57', '2022-03-05 21:44:59', 1, 0, 1, 0),
        (15, 'Máy Làm Bánh BIYI BM1513F', 'Sản phẩm không tiết ra các chất độc hại trong quá trình sử dụng, ngoài ra khuôn nướng.', '<table><tbody><tr><td>Thương hiệu</td><td>BIYI</td></tr><tr><td>Xuất xứ thương hiệu</td><td>Hong Kong</td></tr><tr><td>Chất liệu</td><td><p>Khay bằng nhôm đúc</p></td></tr><tr><td>Công suất</td><td>600 W</td></tr><tr><td>Kích thước</td><td><p>130 x 149 x 110 mm</p></td></tr><tr><td>Model</td><td>BM1513F </td></tr><tr><td>Xuất xứ</td><td>Trung Quốc</td></tr><tr><td>Trọng lượng</td><td>1,35 kg</td></tr></tbody></table>', 10000, 200000, 200000, 1000000, 4, '2021-12-05 21:47:39', '2022-02-08 21:47:43', 1, 0, 1, 0),
        (16, 'Máy làm bánh nướng hình thú ngộ nghĩnh.', 'Máy có kiểu dáng nhỏ gọn, trọng lượng chỉ 1.6kg để bạn có thể dễ dàng chi chuyển.', '<ul>
   <li>Chất liệu: chống dính</li>
   <li>Màu sắc: Vàng</li>
   <li>Điện áp: 220V- 50Hz</li>
   <li>Kích thước: 26 x 22 x 13 cm</li>
   <li>Bạn có thể tự tay làm những chiếc bánh xinh xinh cho bé yêu và một bữa sáng ngon lành, bổ dưỡng cho cả nhà.</li>
   <li>Khuôn bánh với 7 hình thú ngộ nghỉnh, dễ thương: chó, mèo, thỏ, hươu, …</li>
   <li>Máy nướng tự động, hệ thống chốt an toàn. Có chế độ điều khiển nhiệt độ tự động.</li>
   <li>Vỏ máy bằng nhựa chịu nhiệt bền, chân đế cao su chống trơn trượt.</li>
   <li>Có đèn cảnh báo giúp bạn dễ dàng làm những việc khác trong quá trình nướng.</li>
  </ul>', 10000, 200000, 200000, 400000, 4, '2021-12-05 21:48:37', '2022-01-20 11:48:38', 1, 0, 1, 0),
        (17, '3 Trong 1 Tiross TS513', 'Máy làm bánh Tiross TS513 với 3 loại vỉ nướng đi kèm, bạn có thể làm các loại bánh.', '<table><tbody><tr><td>Thương hiệu</td><td>DSP</td></tr><tr><td>Xuất xứ thương hiệu</td><td>Trung Quốc</td></tr><tr><td>Chất liệu</td><td><p>Chất liệu: Inox,&nbsp;Nhựa</p></td></tr><tr><td>Công suất</td><td>750W</td></tr><tr><td>Điện áp</td><td>20-240V 50/60Hz</td></tr><tr><td>Xuất xứ</td><td>Trung Quốc</td></tr><tr><td>Trọng lượng</td><td>2.75kg</td></tr></tbody></table>', 15000, 400000, 400000, 700000, 4, '2021-12-05 21:49:39', '2022-01-19 21:49:40', 1, 0, 1, 0),
        (18, 'Máy Bào Đá Kahchan EP5178_Đ', 'nhỏ gọn dễ sử dụng. Công suất máy hoạt động chỉ với 300W không lo điện năng.', '<table><tbody><tr><td>Thương hiệu</td><td>KAHCHAN</td></tr><tr><td>Xuất xứ thương hiệu</td><td>Trung Quốc</td></tr><tr><td>Chất liệu</td><td>Inox</td></tr><tr><td>Công suất</td><td>300W</td></tr><tr><td>Kích thước</td><td>42 x 21 x 44 cm</td></tr><tr><td>Model</td><td>EP5178_Đ</td></tr><tr><td>Xuất xứ</td><td>Trung Quốc</td></tr><tr><td>Trọng lượng</td><td>6kg</td></tr></tbody></table>', 200000, 1400000, 1400000, 1700000, 5, '2021-12-05 21:51:18', '2022-01-14 21:51:19', 1, 0, 1, 0),
        (19, 'Tự Động Tiross TS9090 (Xanh) - Hàng Chính Hãng', 'màu sắc đẹp mắt và sở hữu tính năng hiện đại, giúp bạn tự làm món kem thơm ngon. ', '<table><tbody><tr><td>Thương hiệu</td><td>Tiross</td></tr><tr><td>Xuất xứ thương hiệu</td><td>Ba Lan</td></tr><tr><td>Dung tích</td><td>700 ml</td></tr><tr><td>Công suất</td><td>90W</td></tr><tr><td>Điện áp</td><td>220V/50Hz</td></tr><tr><td>Kích thước</td><td>28 x 31 x 29.5 cm</td></tr><tr><td>Model</td><td>TS9090 (Xanh)</td></tr><tr><td>Xuất xứ</td><td>Trung Quốc</td></tr><tr><td>Trọng lượng</td><td>3.63 kg</td></tr></tbody></table>', 250000, 2000000, 2000000, 2500000, 5, '2021-12-05 21:52:34', '2022-01-19 06:52:35', 1, 0, 1, 0),
        (20, 'UNOLD 48895 Dung Tích 1.5 Lít', 'Công nghệ được đóng gói trong một vỏ thép không gỉ thanh lịch, bền.', '<h3>THÔNG SỐ SẢN PHẨM</h3><ul>
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
<li>Thiết kế thông minh giúp tay cầm không bị mỏi, đường viền tròn, tinh tế và sang trọng</li>
<li>Có thể điều chỉnh năm tốc độ đánh nhanh - chậm</li>
<li>Công suất 125W, đánh nhanh hơn mà tiết kiệm thời gian</li>
<li>Thân máy làm bằng nhựa ABS, an toàn và dẻo dai, khó nứt, vỡ, không mùi</li>
<li>Hệ thống tản nhiệt đa hướng, cách nhiệt và phân tán không khí, tản nhiệt nhanh giúp máy không bị nóng trong quá trình sử dụng</li>
<li>Hộp sản phẩm gồm:&nbsp;Máy đánh trứng x 1, tay đánh trứng x 2, dụng cụ tách lòng trắng trứng x 1, hướng dẫn sử dụng x 1</li>
</ul>', 50000, 800000, 800000, 1500000, 6, '2021-12-05 21:56:59', '2022-01-18 15:17:00', 1, 0, 1, 0),
        (22, 'L-Beans 900A công suất 360W', 'Máy xay cafe chuyên nghiệp của L-Beans luôn được đánh giá cao vì sự bền bỉ.', '<table><tbody><tr><td>Thương hiệu</td><td>L-Beans</td></tr><tr><td>Chất liệu</td><td><p>Hợp kim nhôm</p></td></tr><tr><td>Công suất</td><td>350W</td></tr><tr><td>Điện áp</td><td>AC 220V-50Hz</td></tr><tr><td>Kích thước</td><td><p>300*190*500MM</p></td></tr><tr><td>Trọng lượng</td><td>11.8kg</td></tr></tbody></table>', 200000, 9000000, 9000000, 12000000, 6, '2021-12-05 21:57:58', '2022-02-13 13:57:59', 1, 0, 1, 0),
        (23, 'Espresso Tiross TS-621', 'Chế độ đánh bọt giúp pha chế cà phê Cappuccino theo phong cách Ý.', '<ul>
<li>Máy có công tắc tắt mở riêng, núm điều khiển hiện thị dễ dàng với đèn LED xanh</li>
<li>Công suất: 220-240V /800W</li>
<li>Dung tích bình đun (boiler) 240ml/ Áp suất 3.5bar (50psi)</li>
<li>Filter bằng inox (chứa khoảng 20gram cafe), tay phin bằng nhôm.</li>
<li>Vòi đánh sữa inox, có thể tháo rời</li>
<li>Ly thủy tinh hứng cafe 50-200ml</li>
<li>Khay hứng nhỏ giọt bằng inox dễ dàng tháo rời vệ sinh</li>
</ul>', 30000, 700000, 700000, 1200000, 6, '2021-12-05 21:59:04', '2022-02-05 21:59:05', 1, 0, 1, 0),
        (24, 'Máy xay tích điện mini', 'Hình thức và địa chỉ giao hàng mà có thể phát sinh thêm chi phí khác như phí vận chuyển', '<div><p>MÁY XAY ĐA NĂNG MINI CẦM TAY ĐA NĂNG</p>
<p>️NHỎ GỌN</p>
<p>️TIỆN LỢI</p>
<p>️AN TOÀN -------------------------------------</p>
<p>️ Công dụng: Xay các loại thực phẩm: Thịt, tôm, cua, cá nhuyễn như giò; xay rau, củ, quả, sinh tố, gia vị tỏi ớt và đá viên chỉ trong 30s.</p>
<p>Dung tích cối: 250ml</p>
<p>Công suất: 30w-45w, điện áp 220v</p>
<p>Tốc độ 9500 vòng/phút</p>
<p>Lưỡi dao bằng inox không gỉ.</p>
<p>Dễ dàng vệ sinh</p>
</div>', 10000, 70000, 70000, 200000, 7, '2021-12-05 22:05:24', '2022-01-14 10:05:25', 1, 0, 1, 0),
        (25, 'Máy Xay Thịt 2 Lưỡi Kép Nonostyle', 'Máy xay thịt Nonostyle với nhiều công dụng và tính năng ưu việt, là trợ thủ đắc lực.', '<ul>
<li><span style="font-weight: 400;">Thân máy với chất liệu thép cao cấp an toàn sử dụng.<br><br></span></li>
<li><span style="font-weight: 400;">Lõi bọc thép chắc chắn, lớp thép chịu lực tốt, lớp thép bọc ngoài chống trơn trượt.</span></li>
<li><span style="font-weight: 400;">Khớp nối chắc chắn và chống mài mòn.<br><br></span></li>
<li><span style="font-weight: 400;">Vận hành êm ái, tuổi thọ bền.<br><br></span></li>
<li><span style="font-weight: 400;">Các khớp cố định trục xoay chắc chắn.</span></li>
<li><span style="font-weight: 400;">Lưỡi dao kép cấu trúc chữ S bằng thép không gỉ.<br><br></span></li>
<li><span style="font-weight: 400;">Thân máy xay thiết kế thông minh, bề mặt vệ sinh dễ dàng.<br><br></span></li>
</ul>
', 10000, 200000, 200000, 400000, 7, '2021-12-05 22:13:40', '2022-01-16 05:13:41', 1, 0, 1, 0),
        (26, 'Some By Mi Super Matcha Pore Clean Clay Mask 100g', 'Mặt Nạ Đất Sét Some By Mi Super Matcha Pore Clean Clay Mask với thành phần đất sét và trà xanh', '<ul>
<li>Nước tẩy trang innisfree Green Tea Cleansing Water 300ml</li>
<li>Sữa rửa mặt trà xanh innisfree Green Tea Foam Cleanser 15ml</li>
<li>Tinh chất dưỡng ẩm trà xanh innisfree Green Tea Seed Serum 8ml</li>
<li>Nước cân bằng dưỡng ẩm trà xanh innisfree Green Tea Seed Skin 15ml</li>
<li>Kem dưỡng ẩm vùng da quanh mắt trà xanh innisfree Green Tea Seed Eye Cream 5ml</li>
</ul>', 10000, 200000, 200000, 400000, 8, '2021-12-05 22:32:26', '2022-02-05 22:32:27', 1, 0, 1, 0),
        (27, 'Vitamin C SAP Neogen Dermalogy Real Vita Serum 32g', 'Tinh chất sở hữu bộ đôi vàng Vitamin C dạng SAP + niacinamide hàm lượng cao giúp giảm thâm.', '<p><strong><span style="margin: 0px; padding: 0px;">Cách sử dụng:</span></strong></p>
<ul>
<li><span style="margin: 0px; padding: 0px;" data-spm-anchor-id="a2o4n.pdp.product_">Do sản phẩm chứa chủ yếu là thành phần tự nhiên nên thời hạn sử dụng cũng bị rút ngắn, vì vậy nên bảo quản trong ngăn mát tủ lạnh sẽ tốt hơn nhé. Và mỗi khi sử dụng thì lôi ra, cảm giác sau khi giọt serum rơi trên da rất mát dịu, thư giãn. Hai giọt cho mỗi lần sử dụng, và nhớ là cho dù bao nhiêu bước dưỡng thì serum dùng sau bước toner, và trước dưỡng ẩm nhé!</span></li>
<li><span style="margin: 0px; padding: 0px;">Dùng em nó vào buổi sáng cũng rất thích, giúp da hạn chế đổ dầu, nhưng nhớ phải dùng kem chống nắng nha vì Vitamin C rất bắt nắng!</span></li>
<li>
<p style="margin: 0px; padding: 8px 0px; font-family: Roboto, -apple-system, system-ui, ''Helvetica Neue'', Helvetica, sans-serif; white-space: pre-wrap;"><span style="margin: 0px; padding: 0px;" data-spm-anchor-id="a2o4n.pdp.product_">Sau khi rửa mặt và toner , chỉ cần dùng vài giọt Serum Vitamin C lên khắp mặt, có thể thoa nhiều hơn chỗ vùng bị thâm , nám , sạm nâu hay sẹo. Sau khi dùng serum Vitamin C nên dùng thêm một loại kem dưỡng ẩm ban đêm sẽ tăng hiệu quả sử dụng.</span></p>
</li>
<li>
<p style="margin: 0px; padding: 8px 0px; font-family: Roboto, -apple-system, system-ui, ''Helvetica Neue'', Helvetica, sans-serif; white-space: pre-wrap;"><span style="margin: 0px; padding: 0px;">Ban đầu sau khi thoa sẽ có một chút châm chích, đây là hiện tượng bình thường khi C bắt đầu tác động lên da. Những lần sau khi dùng da không còn thấy hiện tượng này. ( tránh bôi lan vùng mắt nha ) tất cả các loại Vitamin C đều như thế và hiện tượng này sẽ nhanh chóng qua.</span></p>
</li>
<li>
<p style="margin: 0px; padding: 8px 0px; font-family: Roboto, -apple-system, system-ui, ''Helvetica Neue'', Helvetica, sans-serif; white-space: pre-wrap;"><span style="margin: 0px; padding: 0px;"><strong>Chú ý</strong> : Vì là Pure Vitamin (hoàn toàn tinh khiết) nên các Nàng cần phải bảo quản thật kỹ ! Luôn giữ Serum ở nhiệt độ mát.</span></p>
</li>
</ul>', 50000, 460000, 460000, 860000, 8, '2021-12-05 22:33:22', '2022-02-01 17:33:22', 1, 0, 1, 0),
        (28, 'Kem Dưỡng Ẩm Hỗ Trợ Trị Nám', 'Được đặc chế hòa nhịp với quá trình thay đổi sinh học của làn da.', '<p><strong>Công Dụng</strong></p>
<ul>
<li>Làm mờ các đốm nâu, vết thâm sạm.</li>
<li>Hỗ trợ kiểm soát chất nhờn, giảm dầu thừa trên da.</li>
<li>Ngăn ngừa bụi bẩn và vi khuẩn từ môi trường bên ngoài nhất là trong mùa hè, mùa của bụi bẩn và nắng nóng.</li>
<li>Cải thiện và làm mờ các vết<em class="Highlight">&nbsp;sẹo&nbsp;</em>thâm do<em class="Highlight">&nbsp;mụn&nbsp;</em>để lại nhờ chiết xuất cam thảo.</li>
<li>Thu nhỏ lỗ chân lông và giúp da sáng khoẻ nhờ chiết xuất dâu tằm.</li>
<li>Cung cấp vitamin A, B, và C giúp nhăn ngừa lão hoá và nếp nhăn trên da.</li>
</ul>', 60000, 700000, 700000, 900000, 8, '2021-12-05 22:34:33', '2022-02-02 22:34:33', 1, 0, 1, 0),
        (29, 'Nước hoa nam Dynik hương biển sành điệu 50ml', 'Bên cạnh đó, tuỳ vào loại sản phẩm, hình thức và địa chỉ giao hàng mà có thể phát sinh', '<p style="box-sizing: border-box; margin: 0px 0px 10px; padding: 0px; color: #333333; font-family: ''Open Sans''; font-size: 13px;"><span style="box-sizing: border-box; margin: 0px; padding: 0px; font-size: 14px;"><span style="box-sizing: border-box; margin: 0px; padding: 0px;">Thương hiệu:&nbsp;Nước hoa Charme</span><br style="box-sizing: border-box; margin: 0px; padding: 0px;"><span style="box-sizing: border-box; margin: 0px; padding: 0px;">Loại:&nbsp;</span>Nước hoa nam<br style="box-sizing: border-box; margin: 0px; padding: 0px;"><span style="box-sizing: border-box; margin: 0px; padding: 0px;">Dung tích:</span>&nbsp;10ml<br style="box-sizing: border-box; margin: 0px; padding: 0px;"><span style="box-sizing: border-box; margin: 0px; padding: 0px;">Độ tuổi khuyên dùng:</span>&nbsp;Trên 25<br style="box-sizing: border-box; margin: 0px; padding: 0px;"><span style="box-sizing: border-box; margin: 0px; padding: 0px;">Nồng độ:</span>&nbsp;EDP<br style="box-sizing: border-box; margin: 0px; padding: 0px;"><span style="box-sizing: border-box; margin: 0px; padding: 0px;">Độ lưu hương:</span>&nbsp;Lâu - 10 giờ đến 12 giờ<br style="box-sizing: border-box; margin: 0px; padding: 0px;"><span style="box-sizing: border-box; margin: 0px; padding: 0px;">Thời điểm khuyên dùng:</span>&nbsp;Ngày, Đêm, Thu, Đông<br style="box-sizing: border-box; margin: 0px; padding: 0px;"><span style="box-sizing: border-box; margin: 0px; padding: 0px;">Mùi hương đặc trưng:</span><br style="box-sizing: border-box; margin: 0px; padding: 0px;">&nbsp; &nbsp;+ Hương đầu: Hương vị cam bergamot, hương bưởi<br style="box-sizing: border-box; margin: 0px; padding: 0px;">&nbsp; &nbsp;+ Hương giữa: Hương bạc hà<br style="box-sizing: border-box; margin: 0px; padding: 0px;">&nbsp; &nbsp;+ Hương cuối: Hạt bạch đậu khấu, gừng, hồ tiêu, cỏ hương bài, hoa nhài<br style="box-sizing: border-box; margin: 0px; padding: 0px;"><span style="box-sizing: border-box; margin: 0px; padding: 0px;">Nhóm nước hoa:&nbsp;</span>Woody Aromatic<br style="box-sizing: border-box; margin: 0px; padding: 0px;"><span style="box-sizing: border-box; margin: 0px; padding: 0px;">Phong cách:</span>&nbsp;Nam tính, lịch lãm, bí ẩn</span></p>', 55000, 300000, 300000, 700000, 9, '2021-12-05 22:35:35', '2022-01-18 22:35:36', 1, 0, 1, 0),
        (30, 'Áo Thun Nam Cổ Tròn', 'Áo Thun Trơn Nam Tsimple được may bằng chất liệu cotton, thấm hút mồ hôi tốt, ít nhăn', '<ul>
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
        (31, 'Đồ Bơi Nam Và Nữ Couple', 'Thiết kế mạnh mẽ, kiểu dáng thể thao tôn dáng. Chất liệu thun co giãn, bền chắc', '<p>- Màu chủ đạo: trắng và đen</p>
<p>- Thiết kế 2 mảnh khỏe khoắn, đồ bơi nữ có sẵn mút ngực. Tay dài che nắng, bảo vệ tia UV (chuẩn UPF 50+) cho làn da tay của bạn.</p>
<p>- Là bộ đồ bơi cho các cặp đôi khi đi cùng nhau, hoặc cá nhân có thể mua riêng mẫu ưng ý.</p>
<p>- Chất liệu thun lạnh co giãn tốt, bền chắc, đường may đẹp.</p>
<p>- Là một trong các sản phẩm đồ bơi áo tắm bikiki đồ bơi một mảnh đồ bơi hai mảnh đồ bơi cặp đồ bơi nam nữ được yêu thích năm nay.</p>', 50000, 369000, 369000, 500000, 12, '2022-01-07 22:30:35', '2022-01-31 22:33:36', 1, 0, 1, 0),
        (32, 'Quần jogger nam RFE', 'Quần jogger nam túi hộp chất kaki mềm mịn, phong cách đường phố RFE', '<p>✧ Kiểu dáng trẻ trung, năng động màu sắc đẹp dễ mix đồ với giày, áo ba lỗ, áo thun, mũ lưỡi trai,</p>
<p>✧ Chất kaki đẹp, mềm mịn, thấm hút mồ hôi tốt tạo cảm giác thoải mái dễ chịu khi mặc</p>
<p>✧ Đường chỉ may tỉ mỉ, khóa túi chắc chắn, không bai, không xù, không bám dính</p>
<p>✧ Bền màu vĩnh viễn, an toàn tuyệt đối với người mặc</p>
<p>✧ Phù hợp mặc đi chơi, đi dạo, chơi thể thao, tập thể dục,</p>', 20000, 180000, 180000, 325000, 13, '2022-01-05 22:30:35', '2022-01-31 22:40:36', 1, 0, 1, 0),
        (33, 'Samsung Galaxy M12 (4GB/64GB)', 'Điện Thoại Samsung Galaxy M12 (4GB/64GB) thoải mái trải nghiệm nhiều nội dung hơn.', '<table><tbody><tr><td>Dung lượng pin</td><td>5000mAh</td></tr><tr><td>Bluetooth</td><td>Bluetooth v5.0</td></tr><tr><td>Thương hiệu</td><td>Samsung</td></tr><tr><td>Xuất xứ thương hiệu</td><td>Hàn Quốc</td></tr><tr><td>Camera sau</td><td>48.0 MP + 5.0 MP + 2.0 MP + 2.0 MP</td></tr><tr><td>Camera trước</td><td>8.0 MP</td></tr><tr><td>Hỗ trợ thẻ nhớ ngoài</td><td>MicroSD</td></tr><tr><td>Chip set</td><td>Exynos 850 (8 nhân)</td></tr><tr><td>Đèn Flash</td><td>Có</td></tr><tr><td>Loại/ Công nghệ màn hình</td><td>PLS TFT LCD</td></tr><tr><td>GPS</td><td>GPS', 100000, 1500000, 1500000, 3500000, 1, '2022-01-13 18:52:59', '2022-01-24 18:53:03', 1, 1, 1, 0),
        (34, 'Xiaomi POCO X3 PRO - Hàng Chính Hãng', 'ra mắt nổi bật với thiết kế khá độc đáo với cụm camera, màn hình mượt mà như lụa, pin khủng', '<table><tbody><tr><td>Dung lượng pin</td><td>5160 mAh</td></tr><tr><td>Bluetooth</td><td>A2DP/ v5.0/ LE</td></tr><tr><td>Thương hiệu</td><td>Xiaomi</td></tr><tr><td>Camera sau</td><td>Chính 48 MP &amp; Phụ 8 MP, 2 MP, 2 MP</td></tr><tr><td>Camera trước</td><td>20 MP</td></tr><tr><td>Hỗ trợ thẻ nhớ ngoài</td><td>MicroSD</td></tr><tr><td>Chip đồ họa (GPU)</td><td>Adreno 640</td></tr><tr><td>Chip set</td><td>Snapdragon 860 8 nhân</td></tr><tr><td>Tốc độ CPU</td><td>1 nhân 2.96 GHz, 3 nhân 2.42 GHz &amp; 4 nhân 1.8 GHz</td></tr><tr><td>Loại/ Công nghệ màn hình</td><td>IPS LCD</td></tr><tr><td>FM radio</td><td>Có</td></tr><tr><td>GPS</td><td>GLONASS/ GALILEO/ BDS/ A-GPS</td></tr><tr><td>Model</td><td>POCO X3 Pro</td></tr><tr><td>Jack tai nghe</td><td>3.5 mm</td></tr><tr><td>Loại pin</td><td>Li-Po</td></tr><tr><td>Loại Sim</td><td>2 Nano SIM</td></tr><tr><td>Nghe nhạc</td><td>Có</td></tr><tr><td>Xuất xứ</td><td>Trung Quốc</td></tr><tr><td>Cổng sạc</td><td>Type-C</td></tr><tr><td>Trọng lượng</td><td>215 g</td></tr><tr><td>Quay phim</td><td>FullHD 1080p@60fps /FullHD 1080p@30fps /4K 2160p@30fps</td></tr><tr><td>Độ phân giải</td><td>Full HD+ (1080 x 2400 Pixels)</td></tr><tr><td>Kích thước màn hình</td><td>6.67 inch</td></tr><tr><td>Wifi</td><td>Wi-Fi hotspot /Dual-band (2.4 GHz/5 GHz) /Wi-Fi Direct/ Wi-Fi 802.11 a/b/g/n/ac</td></tr><tr><td>Xem phim</td><td>Có</td></tr></tbody></table>', 200000, 3000000, 3000000, 5000000, 1, '2022-01-10 18:55:15', '2022-01-18 18:55:17', 1, 1, 1, 0),
        (35, 'iPhone 13 Pro Max 128GB - Hàng Chính Hãng', 'iPhone 13 Pro Max gói gọn nhiều tính năng cực đỉnh trong một thiết kế 6.7 inch.2 Mạng 5G', '<table><tbody><tr><td>Dung lượng pin</td><td> 4352 mAh</td></tr><tr><td>Bluetooth</td><td>Có</td></tr><tr><td>Thương hiệu</td><td>Apple</td></tr><tr><td>Xuất xứ thương hiệu</td><td>Mỹ</td></tr><tr><td>Camera sau</td><td>3 camera 12 MP</td></tr><tr><td>Camera trước</td><td>12MP</td></tr><tr><td>Chip đồ họa (GPU)</td><td> Apple GPU 5 nhân</td></tr><tr><td>Chip set</td><td>Chip A15 Bionic (5nm)</td></tr><tr><td>Kết nối khác</td><td>NFC</td></tr><tr><td>Tốc độ CPU</td><td>3.22 GHz</td></tr><tr><td>Kích thước</td><td>160.8 x 78.1 x 7.4 mm</td></tr><tr><td>Loại/ Công nghệ màn hình</td><td>OLED', 500000, 25000000, 25000000, 30000000, 1, '2022-01-09 18:57:16', '2022-01-16 18:57:18', 1, 1, 1, 0),
        (36, 'Tecno Pova 2 6GB l 128GB', 'Tecno POVA 2 là sự kế thừa trực tiếp của POVA năm ngoái . CPU hiện đã tốt hơn một chút', '<table><tbody><tr><td>Thời gian pin</td><td>7000 mAh</td></tr><tr><td>Bluetooth</td><td>Bluetooth 5.0', 200000, 2000000, 2000000, 4500000, 1, '2022-01-08 18:58:30', '2022-02-13 18:58:38', 1, 1, 1, 0),
        (37, 'Điện Thoại Samsung Galaxy A72 (8GB/256GB)', 'Điện Thoại Samsung Galaxy A72 (8GB/256GB) mang lại hình ảnh mãn nhãn', '<table><tbody><tr><td>Dung lượng pin</td><td>5000mAh</td></tr><tr><td>Bluetooth</td><td>Có</td></tr><tr><td>Thương hiệu</td><td>Samsung</td></tr><tr><td>Xuất xứ thương hiệu</td><td>Hàn Quốc</td></tr><tr><td>Camera sau</td><td>64MP + 12MP + 8MP + 5MP</td></tr><tr><td>Camera trước</td><td>32 MP</td></tr><tr><td>Hỗ trợ thẻ nhớ ngoài</td><td>microSD</td></tr><tr><td>Chip đồ họa (GPU)</td><td>Adreno 618</td></tr><tr><td>Chip set</td><td>Snapdragon 720G</td></tr><tr><td>Tốc độ CPU</td><td>2 nhân 2.3 Ghz &amp; 6 nhân 1.8 Ghz</td></tr><tr><td>Đèn Flash</td><td>Có</td></tr><tr><td>Loại/ Công nghệ màn hình</td><td>Super AMOLED</td></tr><tr><td>GPS</td><td>BDS, A-GPS, GLONASS</td></tr><tr><td>Hỗ trợ 4G</td><td>Có</td></tr><tr><td>Phụ kiện đi kèm</td><td>Sách hướng dẫn, cây lấy sim, cáp</td></tr><tr><td>Model</td><td>Galaxy A72 (8GB/256GB)</td></tr><tr><td>Jack tai nghe</td><td>3.5mm</td></tr><tr><td>Số sim</td><td>2</td></tr><tr><td>Loại pin</td><td>Li-Ion 5000 mAh</td></tr><tr><td>Loại Sim</td><td>Nano-SIM</td></tr><tr><td>Nghe nhạc</td><td>Có</td></tr><tr><td>Xuất xứ</td><td>Việt Nam/Ấn Độ/Trung Quốc (Tùy từng đợt nhập hàng)</td></tr><tr><td>Pin có thể tháo rời</td><td>Pin liền</td></tr><tr><td>Cổng sạc</td><td>USB Type-C</td></tr><tr><td>Quay phim</td><td>4K 2160p@30fps, FullHD 1080p@120fps, FullHD 1080p@240fps, FullHD 1080p@30fps</td></tr><tr><td>RAM</td><td>8GB</td></tr><tr><td>Độ phân giải</td><td>Full HD+ (1080 x 2400 Pixels)</td></tr><tr><td>ROM</td><td>256GB</td></tr><tr><td>Kích thước màn hình</td><td>6.7 inch</td></tr><tr><td>Hỗ trợ thẻ tối đa</td><td>1TB</td></tr><tr><td>Tính năng camera</td><td>Chống rung quang học (OIS), Toàn cảnh (Panorama), HDR</td></tr><tr><td>Video call</td><td>Có - Qua ứng dụng OTT</td></tr><tr><td>Wifi</td><td>Có</td></tr><tr><td>Xem phim</td><td>Có</td></tr></tbody></table>', 300000, 5000000, 5000000, 9000000, 1, '2022-01-07 19:00:02', '2022-01-25 19:00:04', 1, 1, 1, 0),
        (38, 'Điện Thoại OnePlus Nord CE 5G (12GB/256G)', 'Điện thoại OnePlus Nord CE 5G sử dụng CPU Snapdragon 750G đây là con chip lý tưởng', '<table><tbody><tr><td>Dung lượng pin</td><td>4500 mAh</td></tr><tr><td>Bluetooth</td><td>A2DP', 250000, 4000000, 4000000, 8000000, 1, '2022-01-06 19:01:23', '2022-02-13 19:01:50', 1, 1, 1, 0),
        (39, 'Điện Thoại Samsung Galaxy A12 (4GB/128GB)', 'Samsung Galaxy A12 mang diện mạo thân thuộc của những chiếc Samsung tiền nhiệm, thiết kế nguyên khối', '<table><tbody><tr><td>Dung lượng pin</td><td>5000 mAh</td></tr><tr><td>Bluetooth</td><td>v5.0</td></tr><tr><td>Thương hiệu</td><td>Samsung</td></tr><tr><td>Xuất xứ thương hiệu</td><td>Hàn Quốc</td></tr><tr><td>Camera sau</td><td>Chính 48 MP &amp; Phụ 5 MP', 150000, 1000000, 1000000, 4000000, 1, '2022-01-13 19:03:14', '2022-01-15 19:03:17', 1, 1, 1, 0),
        (40, 'Điện Thoại Vivo Y21 (4GB/64GB) - Hàng Chính Hãng', 'Điện thoại Vivo Y21 sở hữu thiết kế mặt lưng với họa tiết vân kim cương độc đáo', '<table><tbody><tr><td>Dung lượng pin</td><td>5000 mAh</td></tr><tr><td>Bluetooth</td><td>A2DP', 100000, 2000000, 2000000, 3500000, 1, '2022-01-13 19:04:17', '2022-01-17 19:04:20', 1, 1, 1, 0),
        (41, 'Laptop Apple MacBook Pro 2018 13.3inch MR9R2', 'MacBook Pro nâng tầm khái niệm notebook lên một tầm cao mới với hiệu năng và tính di động chuẩn mực', '<div class="css-17aam1">- CPU: Core i5 ( 2.3 GHz <br>- Màn hình: 13.3" ( 2560 x 1600 ) , không cảm ứng <br>- RAM: 8GB LPDDR3 2133MHz <br>- Đồ họa: Intel Iris Plus Graphics 650 <br>- Lưu trữ: 512GB SSD <br>- Hệ điều hành: macOS <br>- Pin: Pin liền</div>', 1000000, 40000000, 40000000, 45000000, 2, '2022-01-12 20:51:22', '2022-03-13 20:51:33', 1, 1, 1, 0),
        (42, 'Laptop Acer Nitro 5 AN515-52-51LW', 'Nitro 5 với thiết kế lớp vỏ vân Carbon mạnh mẽ kết hợp với bản lề màu đỏ nổi bật đậm chất gaming.', '<div class="css-17aam1">- CPU: Intel Core i5-8300H ( 2.3 GHz - 4.0 GHz / 8MB / 4 nhân', 500000, 18000000, 18000000, 21000000, 2, '2022-01-02 20:53:06', '2022-02-13 20:53:11', 1, 1, 1, 0),
        (43, 'Laptop ASUS Zenbook UX363EA- HP130T', 'aptop Asus Zenbook UX363EA-HP130T là một trong những cái tên mang đến hiệu năng cực kỳ vượt trội', '<div class="css-17aam1">- CPU: Intel Core i5-1135G7 <br>- Màn hình: 13.3" OLED (1920 x 1080)<br>- RAM: 1 x 8GB LPDDR4X 4266MHz <br>- Đồ họa: Intel Iris Xe Graphics<br>- Lưu trữ: 512GB SSD M.2 NVMe / <br>- Hệ điều hành: Windows 10 Home 64-bit<br>- Pin: 4 cell 67 Wh Pin liền<br>- Khối lượng: 1.3 kg<br>- ChuẩnIntel EVO</div>', 800000, 23000000, 23000000, 28000000, 2, '2022-01-03 20:54:18', '2022-01-18 20:54:25', 1, 1, 1, 0),
        (44, 'Laptop Dell Vostro 14 3405 V4R53500U001W', 'thế hệ máy tính được cải tiến về hiệu năng nhằm tối ưu khả năng xử lý thông tin một cách nhanh chóng', '<div class="css-17aam1">- CPU: AMD Ryzen 5 3500U <br>- Màn hình: 14" WVA (1920 x 1080)<br>- RAM: 1 x 4GB DDR4 2400MHz <br>- Đồ họa: AMD Radeon Vega 8 Graphics<br>- Lưu trữ: 256GB SSD M.2 NVMe / <br>- Hệ điều hành: Windows 10 Home SL 64-bit<br>- Pin: 3 cell 42 Wh Pin liền<br>- Khối lượng: 1.7 kg</div>', 400000, 10000000, 10000000, 16000000, 2, '2022-01-13 20:55:34', '2022-01-16 20:55:37', 1, 1, 1, 0),
        (45, 'Laptop HP ProBook 450 G8 2H0U4PA', 'chiếc laptop sở hữu vẻ ngoài trang nhã và sang trọng nhờ thiết kế màu bạc đẹp mắt.', '<div class="css-17aam1">- CPU: Intel Core i3-1115G4 <br>- Màn hình: 15.6" (1366 x 768)<br>- RAM: 1 x 4GB DDR4 3200MHz <br>- Đồ họa: Intel UHD Graphics<br>- Lưu trữ: 256GB SSD M.2 NVMe / <br>- Hệ điều hành: Windows 10 Home SL 64-bit<br>- Pin: 3 cell 45 Wh Pin liền<br>- Khối lượng: 1.7 kg</div>', 300000, 10000000, 10000000, 14000000, 2, '2022-01-11 20:56:32', '2022-01-15 20:56:43', 1, 1, 1, 0),
        (46, 'Laptop Lenovo Yoga Slim 7 14ITL05- 82A3004FVN', 'thiết kế cứng cáp trọng lượng nhẹ 1.36kg nhưng vẫn tích hợp nhiều tính năng cùng chip Core i7', '<div class="css-17aam1">- CPU: Intel Core i7-1165G7 <br>- Màn hình: 14" IPS (1920 x 1080)<br>- RAM: 8GB Onboard DDR4 3200MHz <br>- Đồ họa: Intel Iris Xe Graphics<br>- Lưu trữ: 512GB SSD M.2 NVMe / <br>- Hệ điều hành: Windows 10 Home SL 64-bit<br>-  60 Wh Pin liền<br>- Khối lượng: 1.4 kg<br>- ChuẩnIntel EVO</div>', 700000, 20000000, 20000000, 26000000, 2, '2022-01-13 20:58:10', '2022-01-20 20:58:16', 1, 1, 1, 0);