use foy4;

-- CLIENT MASTER
CREATE TABLE client_master (
    client_no  VARCHAR(6),
    name       VARCHAR(20) NOT NULL,
    address1   VARCHAR(30),
    address2   VARCHAR(30),
    city       VARCHAR(15) NOT NULL,
    state      VARCHAR(15) NOT NULL,
    pincode    DECIMAL(6) NOT NULL,
    bal_due    DECIMAL(10,2) NOT NULL
);


-- PRODUCT MASTER
CREATE TABLE product_master (
    product_no      VARCHAR(6) PRIMARY KEY CHECK (product_no LIKE 'P%'),
    desciption      VARCHAR(50) NOT NULL,
    profit_percent  DECIMAL NOT NULL,
    unit_measure    VARCHAR(10) NOT NULL,
    qty_on_hand     INT NOT NULL,
    reoder_lvlnumber INT NOT NULL,
    sell_price      INT NOT NULL,
    cost_price      INT NOT NULL
);


-- SALESMAN MASTER
CREATE TABLE salesman_master (
    salesman_no  VARCHAR(6) PRIMARY KEY CHECK (salesman_no LIKE 'S%'),
    sal_name     VARCHAR(20) NOT NULL,
    address      VARCHAR(50) NOT NULL,
    city         VARCHAR(20),
    state        VARCHAR(20),
    pincode      DECIMAL(6),
    sal_amt      DECIMAL(8,2) NOT NULL,
    tgt_to_get   DECIMAL(6,2) NOT NULL,
    ytd_sales    DECIMAL(6,2) NOT NULL,
    remarks      VARCHAR(30),
    CONSTRAINT s_man CHECK (sal_amt != 0 AND tgt_to_get != 0 AND ytd_sales != 0)
);


-- SALES ORDER
CREATE TABLE sales_order (
    s_order_no    VARCHAR(6) PRIMARY KEY,
    s_order_date  DATE,
    client_no     VARCHAR(25),
    dely_add      VARCHAR(100),
    salesman_no   VARCHAR(6) FOREIGN KEY REFERENCES salesman_master(salesman_no),
    dely_type     CHAR(1) DEFAULT 'F',
    billed_yn     CHAR(1),
    dely_date     DATE,
    order_status  VARCHAR(10),
    CONSTRAINT chk_order_no      CHECK (LEFT(s_order_no, 1) = '0'),
    CONSTRAINT ck_dely_type      CHECK (dely_type IN ('P', 'F')),
    CONSTRAINT ck_dely_date      CHECK (dely_date > s_order_date),
    CONSTRAINT ck_order_status   CHECK (order_status IN ('In process', 'Fulfilled', 'Backorder', 'Cancelled'))
);


-- SALES ORDER DETAILS-------
CREATE TABLE sales_order_details (
    s_order_no     VARCHAR(6) FOREIGN KEY REFERENCES sales_order(s_order_no),
    product_no     VARCHAR(6) FOREIGN KEY REFERENCES product_master(product_no),
    qty_order      DECIMAL(8),
    qty_disp       DECIMAL(8),
    product_rate   DECIMAL(10,2)
);

---- VERİ GİRİŞİ---------- 

INSERT INTO client_master 
(client_no, name, address1, address2, city, state, pincode, bal_due)
VALUES 
('0001', 'Ivan', NULL, NULL, 'Bombay', 'Maharashtra', 400054, 15000),
('0002', 'Vandana', NULL, NULL, 'Madras', 'Tamilnadu', 780001, 0),
('0003', 'Pramada', NULL, NULL, 'Bombay', 'Maharashtra', 400057, 5000),
('0004', 'Basu', NULL, NULL, 'Bombay', 'Maharashtra', 400056, 0),
('0005', 'Ravi', NULL, NULL, 'Delhi', 'Delhi', 100001, 2000),
('0006', 'Rukmini', NULL, NULL, 'Bombay', 'Maharashtra', 400050, 0);

INSERT INTO product_master (product_no, desciption, profit_percent, unit_measure, qty_on_hand, reoder_lvlnumber, sell_price, cost_price)
VALUES
('P00001', '1.44floppies', 5, 'piece', 100, 20, 525, 500),
('P03453', 'Monitors', 6, 'piece', 10, 3, 12000, 11200),
('P06734', 'Mouse', 5, 'piece', 20, 5, 1050, 500),
('P07865', '1.22floppies', 5, 'piece', 100, 20, 525, 500),
('P07868', 'Keyboards', 2, 'piece', 10, 3, 3150, 3050),
('P07885', 'CD drives', 2.5, 'piece', 10, 3, 5250, 5100),
('P07965', '540 HDD', 4, 'piece', 10, 3, 8400, 8000),
('P07975', '1.44 Drive', 5, 'piece', 10, 3, 1050, 1000),
('P08865', '1.22 Drive', 5, 'piece', 2, 3, 1050, 1000);

INSERT INTO salesman_master (salesman_no, sal_name, address, city, state, pincode, sal_amt, tgt_to_get, ytd_sales, remarks)
VALUES 
('S00001', 'Kiran', 'A/14 Worli', 'Bombay', 'Mah', 400002, 3000, 100, 50, 'Good'),
('S00002', 'Manish', '65 Nariman', 'Bombay', 'Mah', 400001, 3000, 200, 100, 'Good'),
('S00003', 'Ravi', 'P-7 Bandra', 'Bombay', 'Mah', 400032, 3000, 200, 100, 'Good'),
('S00004', 'Ashish', 'A/5 Juhu', 'Bombay', 'Mah', 400044, 3500, 200, 150, 'Good');

INSERT INTO sales_order (s_order_no, s_order_date, client_no, dely_add, salesman_no, dely_type, billed_yn, dely_date, order_status)
VALUES 
('019001', '1996-01-12', '0001', NULL, 'S00001', 'F', 'N', '1996-01-20', 'In process'),
('019002', '1996-01-25', '0002', NULL, 'S00002', 'P', 'N', '1996-01-27', 'Cancelled'),
('016865', '1996-02-18', '0003', NULL, 'S00003', 'F', 'Y', '1996-02-20', 'Fulfilled'),
('019003', '1996-04-03', '0001', NULL, 'S00001', 'F', 'Y', '1996-04-07', 'Fulfilled'),
('046866', '1996-05-20', '0004', NULL, 'S00002', 'P', 'N', '1996-05-22', 'Cancelled'),
('010008', '1996-05-24', '0005', NULL, 'S00004', 'F', 'N', '1996-05-26', 'In process');

INSERT INTO sales_order_details (s_order_no, product_no, qty_order, qty_disp, product_rate)
VALUES 
('019001', 'P00001', 4, 4, 525),
('019001', 'P07965', 2, 1, 8400),
('019001', 'P07885', 2, 1, 5250),
('019002', 'P00001', 10, 0, 525),
('046865', 'P07868', 3, 3, 3150),
('046865', 'P07885', 10, 10, 5250),
('019003', 'P00001', 4, 4, 1050),
('019003', 'P03453', 2, 2, 1050),
('046866', 'P06734', 1, 1, 12000),
('046866', 'P07965', 1, 0, 8400),
('010008', 'P07965', 1, 0, 1050),
('010008', 'P00001', 10, 5, 525);


-------Soru - 1------
create view degeri_buyuk as select salesman_no, sal_name,address, city, state, pincode, sal_amt, tgt_to_get, 
ytd_sales, remarks from salesman_master where tgt_to_get>200

select * from degeri_buyuk

------soru 2 -----

create view product_view(pro_no, decs, profit, Unit_measure, qty, reoder_lvlnumber, sell_price, cost_price)
as
select product_no, desciption, profit_percent, unit_measure, qty_on_hand, reoder_lvlnumber, sell_price, cost_price
from product_master;

select * from product_view

------soru 3--------

select decs from product_view where qty=10;

------soru 4----------


select name, desciption from sales_order
inner join client_master on client_master.client_no = sales_order.client_no
inner join sales_order_details on sales_order_details.s_order_no = sales_order.s_order_no
inner join product_master on product_master.product_no = sales_order_details.product_no
where datediff (day, s_order_date, dely_date) > 10;

-----------Soru 5 -----------------------

create view gunluk_view               
as  
select *
from sales_order
where convert(date, s_order_date, 103) = convert(date, getdate(), 103);  ---Burada 103 stili, dd/mm/yyyy formatında tarih dönüşümü sağlar. 


select * from gunluk_view

------------soru 6 --------------------

CREATE TABLE departman (
    departman_id INT NOT NULL,
    departman_ad VARCHAR(50),
    departman_adres NVARCHAR(60),
    departman_yonetici VARCHAR(50),
    CONSTRAINT pk_departman PRIMARY KEY (departman_id, departman_yonetici),
    CONSTRAINT chk_departman_ad CHECK (LEN(departman_ad) > 0) -- departman_ad boş olamaz
);


-------------Soru 7------------------

create table musteri (
  musteri_id int primary key,
  ad varchar(50),
  soyad varchar(50),
  email varchar(100),
  telefon varchar(20),
  laptop_adet int,
  musteri_kayit date, 
);

create index [musteri_index] on [dbo].[musteri] ( [laptop_adet] ASC )


create index [musteri1_index] on [dbo].[musteri] ( [musteri_kayit] DESC )



