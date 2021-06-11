
-- -----------------------------------------------------
-- Schema prd_demo
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `prd_demo`;
USE `prd_demo` ;
-- -----------------------------------------------------
-- Table `prd_demo`.`ffa_user_type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prd_demo`.`ffa_user_type` (
  `ut_id` BIGINT(20),
  `user_type` VARCHAR(20),
  `label` VARCHAR(30));
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
-- -----------------------------------------------------
-- Table `prd_demo`.`ffa_employment_type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prd_demo`.`ffa_employment_type` (
  `employment_type` TINYINT(20),
  `name` VARCHAR(200));
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
-- -----------------------------------------------------
-- Table `prd_demo`.`ffa_order_status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prd_demo`.`ffa_order_status` (
  `status_id` TINYINT(2),
  `status_name` VARCHAR(20));
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
  `address_geo` POINT,
  `suburb` VARCHAR(100),
  `state` VARCHAR(50),
  `postcode` VARCHAR(10),
  `external_id` VARCHAR(50),
  `active` TINYINT(1),
  `parent_id` BIGINT(20));
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
