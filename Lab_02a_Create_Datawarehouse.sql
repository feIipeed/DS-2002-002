#DROP database `northwind_dw`;
CREATE DATABASE `Northwind_DW` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE northwind_dw;
#USE Northwind_DW3;

# DROP TABLE `dim_customers`;
CREATE TABLE `dim_customers` (
  `customer_key` int NOT NULL AUTO_INCREMENT,
  `company` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `job_title` varchar(50) DEFAULT NULL,
  `business_phone` varchar(25) DEFAULT NULL,
  `fax_number` varchar(25) DEFAULT NULL,
  `address` longtext,
  `city` varchar(50) DEFAULT NULL,
  `state_province` varchar(50) DEFAULT NULL,
  `zip_postal_code` varchar(15) DEFAULT NULL,
  `country_region` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`customer_key`),
  KEY `city` (`city`),
  KEY `company` (`company`),
  KEY `first_name` (`first_name`),
  KEY `last_name` (`last_name`),
  KEY `zip_postal_code` (`zip_postal_code`),
  KEY `state_province` (`state_province`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4;


# DROP TABLE `dim_employees`;
CREATE TABLE `dim_employees` (
  `employee_key` int NOT NULL AUTO_INCREMENT,
  `company` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `email_address` varchar(50) DEFAULT NULL,
  `job_title` varchar(50) DEFAULT NULL,
  `business_phone` varchar(25) DEFAULT NULL,
  `home_phone` varchar(25) DEFAULT NULL,
  `fax_number` varchar(25) DEFAULT NULL,
  `address` longtext,
  `city` varchar(50) DEFAULT NULL,
  `state_province` varchar(50) DEFAULT NULL,
  `zip_postal_code` varchar(15) DEFAULT NULL,
  `country_region` varchar(50) DEFAULT NULL,
  `web_page` longtext,
  PRIMARY KEY (`employee_key`),
  KEY `city` (`city`),
  KEY `company` (`company`),
  KEY `first_name` (`first_name`),
  KEY `last_name` (`last_name`),
  KEY `zip_postal_code` (`zip_postal_code`),
  KEY `state_province` (`state_province`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;


# DROP TABLE `dim_products`;
CREATE TABLE `dim_products` (
  `product_key` int NOT NULL AUTO_INCREMENT,
  `product_code` varchar(25) DEFAULT NULL,
  `product_name` varchar(50) DEFAULT NULL,
  `standard_cost` decimal(19,4) DEFAULT '0.0000',
  `list_price` decimal(19,4) NOT NULL DEFAULT '0.0000',
  `reorder_level` int DEFAULT NULL,
  `target_level` int DEFAULT NULL,
  `quantity_per_unit` varchar(50) DEFAULT NULL,
  `discontinued` tinyint(1) NOT NULL DEFAULT '0',
  `minimum_reorder_quantity` int DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`product_key`),
  KEY `product_code` (`product_code`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4;


# DROP TABLE `dim_shippers`;
CREATE TABLE `dim_shippers` (
  `shipper_key` int NOT NULL AUTO_INCREMENT,
  `company` varchar(50) DEFAULT NULL,
  `address` longtext,
  `city` varchar(50) DEFAULT NULL,
  `state_province` varchar(50) DEFAULT NULL,
  `zip_postal_code` varchar(15) DEFAULT NULL,
  `country_region` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`shipper_key`),
  KEY `city` (`city`),
  KEY `company` (`company`),
  KEY `zip_postal_code` (`zip_postal_code`),
  KEY `state_province` (`state_province`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;


# DROP TABLE `dim_suppliers`;
CREATE TABLE `dim_suppliers` (
  `supplier_key` int NOT NULL AUTO_INCREMENT,
  `company` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `job_title` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`supplier_key`),
  KEY `company` (`company`),
  KEY `first_name` (`first_name`),
  KEY `last_name` (`last_name`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4;


-- ----------------------------------------------------------------------
-- TODO: JOIN the orders, order_details, order_details_status and 
--       orders_status tables to create a new Fact Table in Northwind_DW.
-- To keep things simple, don't include purchase order or inventory info
-- ----------------------------------------------------------------------
#DROP TABLE `fact_orders`;
# CREATE TABLE `fact_orders`;

CREATE TABLE fact_orders
AS
SELECT o.id AS `order_key`
	, e.id AS `employee_key`
    , c.id AS `customer_key`
    , p.id AS `product_key`
    , sh.id AS `shipper_key`
    , sh.company AS `ship_name`
    , sh.address AS `ship_address`
    , sh.city AS `ship_city`
    , sh.state_province AS `ship_state_province`
    , sh.zip_postal_code AS `ship_zip_postal_code`
    , sh.country_region AS `ship_country_region`
    , od.quantity AS `quantity`
    , o.order_date AS `order_date`
    , o.shipped_date AS `shipped_date`
    , od.unit_price AS `unit_price`
    , od.discount AS `discount`
    , o.shipping_fee AS `shipping_fee`
    , o.taxes AS `taxes`
    , o.payment_type AS `payment_type`
    , o.paid_date AS `paid_date`
    , o.tax_rate AS `tax_rate`
	, os.status_name AS `order_status`
	, ods.status_name AS `order_details_status`
FROM northwind.products AS p
	, northwind.employees AS e
    , northwind.customers AS c
    , northwind.shippers AS sh
    , northwind.orders AS o
INNER JOIN northwind.orders_status AS os
ON o.status_id = os.id
INNER JOIN northwind.order_details AS od
ON o.id = od.order_id
INNER JOIN northwind.order_details_status AS ods
ON od.status_id = ods.id;

/*
CREATE TABLE fact_orders AS
SELECT o.id,
    o.employee_id,
    o.customer_id,
    od.product_id,
    o.shipper_id,
    o.ship_name,
    o.ship_address,
    o.ship_city,
    o.ship_state_province,
    o.ship_zip_postal_code,
    o.ship_country_region,
    od.quantity,
    o.order_date,
    o.shipped_date,
    od.unit_price,
    od.discount,
    o.shipping_fee,
    o.taxes,
    o.payment_type,
    o.paid_date,
    o.tax_rate,
    os.status_name AS order_status,
    ods.status_name AS order_details_status
FROM northwind.orders AS o
INNER JOIN northwind.orders_status AS os
ON o.status_id = os.id
RIGHT OUTER JOIN northwind.order_details AS od
ON o.id = od.order_id
INNER JOIN northwind.order_details_status AS ods
ON od.status_id = ods.id;
*/