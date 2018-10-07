CREATE DATABASE IF NOT EXISTS `dbagrigator` CHARACTER SET utf8 COLLATE utf8_unicode_ci;

USE `dbagrigator`;
-- Otherwise Events won't work
SET GLOBAL event_scheduler = ON;

CREATE TABLE IF NOT EXISTS  `users` (
  `id` mediumint(8) unsigned NOT NULL auto_increment,
  `usr_id` varchar(36) NOT NULL, -- hyphens can be removed in the application
  `usr_name` varchar(255) default NULL,
  `usr_active` mediumint default NULL,
  `usr_created` varchar(255),
  PRIMARY KEY (`id`)
) AUTO_INCREMENT=1;

CREATE TABLE IF NOT EXISTS  `countries` (
	`cnt_id` SMALLINT(8) unsigned NOT NULL AUTO_INCREMENT,
	`cnt_code` CHAR(2),
	`cnt_title` VARCHAR(100),
	`cnt_created` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`cnt_id`)
) AUTO_INCREMENT=1;

CREATE TABLE IF NOT EXISTS  `numbers` (
  `id` mediumint(8) unsigned NOT NULL auto_increment,
  `num_id` mediumint,
  `cnt_id` mediumint default NULL,
  `num_number` varchar(100) default NULL,
  `num_created` varchar(255),
  PRIMARY KEY (`id`)
) AUTO_INCREMENT=1;

CREATE TABLE IF NOT EXISTS  `send_log` (
	`log_id` MEDIUMINT(8) unsigned NOT NULL auto_increment,
	`usr_id` CHAR(36),
	`num_id` MEDIUMINT(8),
	`log_message` TEXT,
	`log_success` BOOLEAN,
	`log_created` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	KEY `logCreated` (`log_created`) USING BTREE,
	PRIMARY KEY (`log_id`)
) AUTO_INCREMENT=1;

-- 
CREATE TABLE IF NOT EXISTS  `send_log_aggregated` (
	`log_id` MEDIUMINT(8) unsigned NOT NULL auto_increment,
	`usr_id` CHAR(36),
	`cnt_id` mediumint default NULL,
	`log_success` INT(8),
	`log_fail` INT(8),
	`log_created` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	KEY `logCreated` (`log_created`) USING BTREE,
	PRIMARY KEY (`log_id`)
) AUTO_INCREMENT=1;

#################################################################
### Dictionary for sentence creation
#################################################################
CREATE TABLE IF NOT EXISTS  `word_list` (
	`wrd_id` MEDIUMINT(8) unsigned NOT NULL auto_increment,
	`wrd_name` CHAR(40),
	`wrd_created` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`wrd_id`)
) AUTO_INCREMENT=1;
##################################################################
#################################################################
### The MAIN aggrigation procedure
#################################################################
 DELIMITER // -- Scheduled for every night 03:00
 CREATE PROCEDURE CreateSendLogAggregator()
  BEGIN
  -- No Duplicated values 
   INSERT INTO `send_log_aggregated` (`usr_id`, `cnt_id`,`log_success`,`log_fail`, `log_created`)
	SELECT usr_id, numbers.cnt_id as cnt_id, sum(log_success = 1) as log_success, sum(log_success = 0) as log_fail, date_format(send_log.log_created, "%Y-%m-%d") 
	FROM `send_log`, numbers WHERE send_log.num_id=numbers.num_id 
	GROUP BY usr_id, cnt_id ORDER BY log_success  DESC, log_fail DESC;

	-- Truncate send_log for new day
	SET FOREIGN_KEY_CHECKS = 0; 
	TRUNCATE table `send_log`; 
	SET FOREIGN_KEY_CHECKS = 1;

   END //
 DELIMITER ;

#####################################################################
###
#####################################################################
DELIMITER //
CREATE PROCEDURE `GetRandomWordList`(OUT str VARCHAR(255))
BEGIN
 DECLARE x  INT;
 DECLARE upto INT;
 
 SET x := 1;
 SET str :=  '';
 SET upto = FLOOR( 5 + RAND() * 15);
 
 WHILE x  <= upto DO
 SET  str := CONCAT(str,(SELECT wrd_name FROM word_list ORDER BY RAND() LIMIT 1 ),' ');
 SET  x := x + 1; 
 END WHILE;
 
 SELECT str;
 END //
 DELIMITER ;

#####################################################################
###
#####################################################################

 DELIMITER //
 CREATE PROCEDURE CreateSendLog()
  BEGIN
	DECLARE usrID CHAR(36);
    DECLARE numID MEDIUMINT(9);
    DECLARE logMessage VARCHAR(250) DEFAULT '';
    DECLARE logSuccess TINYINT;
    DECLARE logCreated TIMESTAMP;
    
    SET usrID := (select usr_id from users order by rand() limit 1);
    SET numID := (select num_id from numbers order by rand() limit 1);
    -- Generates random sentence
    CALL GetRandomWordList(logMessage);
    SET logSuccess = (select floor(rand() * 10) % 2);
    SET logCreated = (NoW());
     
    INSERT INTO `send_log` (`usr_id`, `num_id`, `log_message`, `log_success`, `log_created`) VALUES (usrID, numID, logMessage, logSuccess, logCreated);
   END //
 DELIMITER ;

#####################################################################
#####################################################################
### Run this in order to create some data 
#####################################################################

DELIMITER //
CREATE PROCEDURE `RandomRunning`(OUT str VARCHAR(255))
BEGIN
 DECLARE x  INT;
 DECLARE upto INT;
 
 SET x := 1;
 SET upto := FLOOR( 5 + RAND() * 15);
 
 WHILE x  <= upto DO
 CALL CreateSendLog();
 SET  x := x + 1; 
 END WHILE;
 
 SELECT str;
 END //
 DELIMITER ;
 
#####################################################################

#####################################################################
### Event for Send_log agrigation
#####################################################################
CREATE DEFINER=`dbsms`@`localhost` EVENT `Agrigation` 
ON SCHEDULE EVERY 1 DAY 
STARTS '2018-10-07 03:00:00'
ON COMPLETION NOT PRESERVE ENABLE 
DO CALL CreateSendLogAggregator()