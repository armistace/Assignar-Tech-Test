
-- -----------------------------------------------------
-- Schema prd_demo
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `prd_demo`;
USE `prd_demo` ;
-- -----------------------------------------------------
-- Table `prd_demo`.`ffa_user_type`
-- -----------------------------------------------------
SET sql_mode = '';
CREATE TABLE IF NOT EXISTS `prd_demo`.`ffa_user_type` (
  `ut_id` BIGINT(20),
  `user_type` VARCHAR(20),
  `label` VARCHAR(30));


LOAD DATA INFILE '/code/database/raw_data/ffa_user_type.csv' 
INTO TABLE ffa_user_type
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
-- -----------------------------------------------------
-- Table `prd_demo`.`ffa_user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prd_demo`.`ffa_user` (
  `user_id` BIGINT(20),
  `ut_id` BIGINT(20),
  `suburb` VARCHAR(100),
  `state` VARCHAR(50) ,
  `postcode` VARCHAR(10),
  `employment_type` TINYINT(20),
  `active` TINYINT(1),
  `modified_time` DATETIME,
  `comments` TEXT,
  `app_version` VARCHAR(10),
  `device_os` VARCHAR(100),
  `device_os_version` VARCHAR(30),
  `app_timezone` INT(3),
  `last_logged_in` DATETIME);

LOAD DATA INFILE '/code/database/raw_data/ffa_user.csv' 
INTO TABLE ffa_user
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
-- -----------------------------------------------------
-- Table `prd_demo`.`ffa_client`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prd_demo`.`ffa_client` (
  `client_id` BIGINT(20) ,
  `city` VARCHAR(100),
  `postcode` VARCHAR(10),
  `state` VARCHAR(100),
  `comments` VARCHAR(800),
  `external_id` VARCHAR(50),
  `active` INT(11));

LOAD DATA INFILE '/code/database/raw_data/ffa_client.csv' 
INTO TABLE ffa_client
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
-- -----------------------------------------------------
-- Table `prd_demo`.`ffa_employment_type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prd_demo`.`ffa_employment_type` (
  `employment_type` TINYINT(20),
  `name` VARCHAR(200));

LOAD DATA INFILE '/code/database/raw_data/ffa_employment_type.csv' 
INTO TABLE ffa_employment_type
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
-- -----------------------------------------------------
-- Table `prd_demo`.`ffa_order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prd_demo`.`ffa_order` (
  `id` INT(11) ,
  `active` TINYINT(1),
  `job_number` VARCHAR(100),
  `po_number` VARCHAR(100),
  `client_id` INT(11),
  `project_id` INT(11),
  `job_description` VARCHAR(100),
  `shift_duration` VARCHAR(100),
  `start_date` DATE,
  `end_date` DATE,
  `comments` TEXT,
  `date_created` DATETIME,
  `modified_time` DATETIME,
  `status_id` TINYINT(2),
  `supplier_id` INT(10),
  `user_id` BIGINT(20));

LOAD DATA INFILE '/code/database/raw_data/ffa_order.csv' 
INTO TABLE ffa_order
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
-- -----------------------------------------------------
-- Table `prd_demo`.`ffa_order_status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prd_demo`.`ffa_order_status` (
  `status_id` TINYINT(2),
  `status_name` VARCHAR(20));

LOAD DATA INFILE '/code/database/raw_data/ffa_order_status.csv' 
INTO TABLE ffa_order_status
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
-- -----------------------------------------------------
-- Table `prd_demo`.`ffa_project`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prd_demo`.`ffa_project` (
  `project_id` BIGINT(20) ,
  `client_id` BIGINT(20),
  `start_date` DATE,
  `end_date` DATE,
  `email` VARCHAR(100),
  `address` VARCHAR(255),
  `address_geo` VARCHAR(1000),
  `suburb` VARCHAR(100),
  `state` VARCHAR(50),
  `postcode` VARCHAR(10),
  `external_id` VARCHAR(50),
  `active` TINYINT(1),
  `parent_id` BIGINT(20));

LOAD DATA INFILE '/code/database/raw_data/ffa_project.csv' 
INTO TABLE ffa_project
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
-- (project_id, client_id, start_date, end_date, email, address, @address_geo, suburb, state, postcode, external_id, active, parent_id)
-- SET address_geo = IFNULL(@address_geo, point(0,0));
;
-- -----------------------------------------------------
-- Table `prd_demo`.`ffa_suppliers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prd_demo`.`ffa_suppliers` (
  `id` INT(10) UNSIGNED ,
  `city` VARCHAR(100),
  `postcode` VARCHAR(10),
  `state` VARCHAR(100),
  `comments` VARCHAR(800),
  `external_id` VARCHAR(50),
  `active` TINYINT(1),
  `date_added` DATETIME,
  `date_modified` DATETIME,
  `modified_time` DATETIME);

LOAD DATA INFILE '/code/database/raw_data/ffa_suppliers.csv' 
INTO TABLE ffa_suppliers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


