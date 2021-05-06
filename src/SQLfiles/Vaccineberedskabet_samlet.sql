/* Denne fil indeholder alle vores create database, create table-statements, views
 * samt procedure, triggers, funktioner og events
 * - gruppe 12
 */

/* CREATE DATABASE og CREATE TABLE-statements*/
CREATE DATABASE IF NOT EXISTS Vaccineberedskabet;
USE vaccineberedskabet;

DROP TABLE IF EXISTS Aftale_Pris_View;
DROP TABLE IF EXISTS Aftale;
DROP TABLE IF EXISTS Ansat;
DROP TABLE IF EXISTS Borger;
DROP TABLE IF EXISTS Certificering;
DROP TABLE IF EXISTS Vaccine_beholdning;
DROP TABLE IF EXISTS Medarbejder;
DROP TABLE IF EXISTS Lokation;
DROP TABLE IF EXISTS Vaccine;

-- View
DROP VIEW IF EXISTS Aftale_Pris_View;
DROP VIEW IF EXISTS Vaccine_Budget;
DROP VIEW IF EXISTS Fuldtidsmedarbejdere;
DROP VIEW IF EXISTS Samlede_Vaccinationer;

-- Triggers
DROP TRIGGER IF EXISTS Foer_Aftale;
DROP TRIGGER IF EXISTS Vaccinebeholdning_Efter_Insert;
DROP TRIGGER IF EXISTS Foer_Ansaettelse;

-- Procedures
DROP procedure IF EXISTS Tilfoej_Ansvarlig_Medarbejder;
DROP procedure IF EXISTS Afregning_daglig;
DROP procedure IF EXISTS Afregning_maaneder;

-- Function
DROP FUNCTION IF EXISTS Anciennitet;
DROP FUNCTION IF EXISTS Vaccineantal;

CREATE TABLE Medarbejder(
  Medarbejder_ID VARCHAR(10) NOT NULL,
  Titel VARCHAR(20) NOT NULL,
  Løn INT NOT NULL,
  Fornavn VARCHAR(20) NOT NULL,
  Mellemnavn VARCHAR(20),
  Efternavn VARCHAR(20) NOT NULL,
  Ansættelsesdato DATETIME NOT NULL,
  PRIMARY KEY (Medarbejder_ID));

CREATE TABLE Lokation (
  Bynavn VARCHAR(20) NOT NULL,
  Vej VARCHAR(20) NOT NULL,
  nr INT NOT NULL,
  PRIMARY KEY (Bynavn));
  
CREATE TABLE Vaccine (
  Vaccine_Type VARCHAR(10) NOT NULL,
  Pris INT NOT NULL,
  PRIMARY KEY (Vaccine_Type));

CREATE TABLE Borger (
  Borger_ID VARCHAR(10) NOT NULL,
  Fornavn VARCHAR(45) NOT NULL,
  Mellemnavn VARCHAR(45),
  Efternavn VARCHAR(45) NOT NULL,
  Vaccine_Type VARCHAR(10) NOT NULL,
  PRIMARY KEY (Borger_ID),
  FOREIGN KEY (Vaccine_Type) REFERENCES Vaccine (Vaccine_Type)
  ON DELETE NO ACTION ON UPDATE CASCADE);

CREATE TABLE Aftale (
  Borger_ID VARCHAR(10) NOT NULL,
  Tidspunkt DATETIME NOT NULL,
  Bynavn VARCHAR(10) NOT NULL,
  Medarbejder_ID VARCHAR(10),
  Vaccination_Foretaget BOOLEAN NOT NULL DEFAULT 0,

  PRIMARY KEY (Borger_ID, Tidspunkt),
  FOREIGN KEY (Borger_ID) REFERENCES Borger(Borger_ID) 
  ON DELETE CASCADE 
  ON UPDATE CASCADE,
  FOREIGN KEY (Bynavn) REFERENCES Lokation (Bynavn)
  ON DELETE NO ACTION 
  ON UPDATE CASCADE,
  FOREIGN KEY (Medarbejder_ID) REFERENCES Medarbejder(Medarbejder_ID)
  ON DELETE NO ACTION
  ON UPDATE CASCADE);
  
  ALTER TABLE Aftale ADD UNIQUE Mødetid(Medarbejder_ID, Tidspunkt);
	
CREATE TABLE Ansat (
  Medarbejder_ID VARCHAR(10) NOT NULL,
  Bynavn VARCHAR(20) NOT NULL,
  PRIMARY KEY (Medarbejder_ID, Bynavn),
  FOREIGN KEY (Medarbejder_ID) REFERENCES Medarbejder (Medarbejder_ID)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (Bynavn) REFERENCES Lokation (Bynavn)
  ON DELETE CASCADE
  ON UPDATE CASCADE);

CREATE TABLE Certificering (
  Medarbejder_ID VARCHAR(10) NOT NULL,
  Vaccine_Type VARCHAR(10) NOT NULL,
  Certificerings_Dato DATETIME NOT NULL,
  PRIMARY KEY (Medarbejder_ID, Vaccine_Type),
  FOREIGN KEY (Medarbejder_ID) REFERENCES Medarbejder (Medarbejder_ID)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
  FOREIGN KEY (Vaccine_Type) REFERENCES Vaccine (Vaccine_Type)
  ON DELETE CASCADE
  ON UPDATE CASCADE);
	
CREATE TABLE Vaccine_beholdning (
  Vaccine_Type VARCHAR(10) NOT NULL,
  Bynavn VARCHAR(20) NOT NULL,
  Antal_Vacciner INT NULL,
  PRIMARY KEY (Vaccine_Type, Bynavn),
  FOREIGN KEY (Vaccine_Type) REFERENCES Vaccine(Vaccine_Type)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
  FOREIGN KEY (Bynavn) REFERENCES Lokation(Bynavn)
  ON DELETE CASCADE
  ON UPDATE CASCADE);

CREATE VIEW Fuldtidsmedarbejdere AS
SELECT Medarbejder_ID, Fornavn,Efternavn,Løn
FROM Medarbejder
WHERE Titel = 'Fuldtid'
GROUP BY Løn DESC;

CREATE VIEW Samlede_Vaccinationer AS
SELECT DISTINCT Vaccine_Type, Count(Borger_ID) AS TOTAL
FROM Aftale NATURAL JOIN Borger
GROUP BY Vaccine_Type;

CREATE VIEW Aftale_Pris_View AS
SELECT Aftale.Borger_ID, Aftale.Tidspunkt, Aftale.Bynavn, Aftale.Medarbejder_ID,
Aftale.Vaccination_Foretaget, Borger.Vaccine_Type, Vaccine.Pris
FROM Aftale NATURAL JOIN Borger NATURAL JOIN Vaccine
WHERE Aftale.Borger_ID = Borger.Borger_ID and Vaccine.Vaccine_Type =  Borger.Vaccine_Type;

CREATE VIEW Vaccine_Budget AS
SELECT Vaccine_Type,COUNT(Vaccination_Foretaget) AS Antal, (COUNT(Vaccination_Foretaget)) * Pris AS Total_Pris
FROM Aftale_Pris_View WHERE Vaccination_Foretaget = true
GROUP BY Vaccine_Type
HAVING Total_Pris > 0;


/* SQL programmering*/

/* Før ansættelse - er medarbejderen allerede ansat 3 steder?*/
-- 8.1 
DELIMITER $$
CREATE TRIGGER Foer_Ansaettelse
BEFORE INSERT ON Ansat FOR EACH  ROW
BEGIN
IF (SELECT COUNT(Medarbejder_ID) FROM Ansat 
WHERE Medarbejder_ID = NEW.Medarbejder_ID)  = 3
THEN SIGNAL SQLSTATE 'HY000'
SET MYSQL_ERRNO = 2021, 
MESSAGE_TEXT = 'Medarbejdere kan max være ansat 3 lokationer!';
END IF;
END$$

/* Opdaterer vaccinebeholdningen efter Borgers vaccineaftale er overstået 
/ vaccination er foretaget */
-- 8.2
DELIMITER $$
CREATE TRIGGER Vaccinebeholdning_Efter_Insert
AFTER UPDATE ON Aftale FOR EACH ROW
BEGIN
IF NEW.Bynavn IS NOT NULL 
AND NEW.Vaccination_Foretaget = true
THEN UPDATE Vaccine_Beholdning
SET Antal_Vacciner = (Antal_Vacciner - 1)
WHERE Vaccine_Type =
(SELECT DISTINCT Vaccine_Type FROM Borger 
WHERE Borger.Borger_ID = NEW.Borger_ID)
AND Vaccine_Beholdning.Bynavn = NEW.Bynavn;
END IF;
END$$

/* Checker om der er vacciner nok på lager til at oprette en ny aftale */
-- 8.3
DELIMITER $$
CREATE TRIGGER Foer_Aftale
BEFORE INSERT ON Aftale FOR EACH  ROW
BEGIN
IF (
SELECT Antal_Vacciner FROM Vaccine_Beholdning 
WHERE Vaccine_Type = (SELECT DISTINCT Vaccine_Type FROM Borger WHERE Borger.Borger_ID = NEW.Borger_ID)
AND Bynavn = NEW.Bynavn)  
- (SELECT COUNT(Vaccination_Foretaget) FROM Aftale WHERE Vaccination_Foretaget = false 
AND Bynavn = NEW.Bynavn)  - 1 < 0
THEN SIGNAL SQLSTATE 'HY000'
SET MYSQL_ERRNO = 2022, 
MESSAGE_TEXT = 'Ikke nok vacciner!';
END IF;
END$$

/* Procedure - er den tildelte ansvarlige medarbejder certificeret? */
-- 8.4

DELIMITER $$
USE Vaccineberedskabet $$
CREATE PROCEDURE Tilfoej_Ansvarlig_Medarbejder (IN vMedarbejder_ID VARCHAR(10),
IN vTidspunkt DATETIME, 
IN vBorger_ID VARCHAR(10))
BEGIN
IF (SELECT EXISTS (select * FROM Certificering
WHERE Medarbejder_ID = vMedarbejder_ID AND Vaccine_Type = (SELECT Vaccine_Type FROM Borger WHERE Borger.Borger_ID = vBorger_ID))) THEN
UPDATE Aftale SET Medarbejder_ID = vMedarbejder_ID
where Tidspunkt = vTidspunkt AND Borger_ID = vBorger_ID;
ELSE
SIGNAL SQLSTATE 'HY000'
SET MYSQL_ERRNO = 2021, 
MESSAGE_TEXT = 'Medarbejderen er ikke certificeret i denne vaccine!';
END IF;
END$$
DELIMITER ;

/* Anciennitet */
-- 8.5
DELIMITER $$
CREATE FUNCTION Anciennitet (current_Medarbejder_ID varchar(10))
returns int
DETERMINISTIC
BEGIN 
  DECLARE år int;
  SET år = floor(DATEDIFF(current_date(),(select Ansættelsesdato from medarbejder where Medarbejder_ID = current_Medarbejder_ID))/365);
  RETURN år;
END$$
DELIMITER ;


/* Vaccine antal funktion */
-- 8.6
DROP FUNCTION IF EXISTS VaccineAntal;
DELIMITER //
Create function
VaccineAntal (VType varchar(10))
returns int
begin
declare VTotalAntal int;
Select sum(Antal_Vacciner) into VTotalAntal
from vaccine_beholdning where Vaccine_Type = VType;
return VTotalAntal;
end //
DELIMITER ;

/* Daglig rapport til sundhedsmyndighederne - antal daglige vaccinationer */
-- 8.7
set global event_scheduler=on;

delimiter //
create procedure afregning_daglig()
begin
SELECT Vaccine_Type, COUNT(Vaccination_Foretaget) AS Antal
FROM Aftale_Pris_View WHERE Vaccination_Foretaget = true
AND DAY(Tidspunkt) = DAY(current_date())
GROUP BY Vaccine_Type
HAVING Antal > 0;
end //
delimiter ;

create event if not exists daglig_vaccinations_rapport
on schedule every 1 day
on completion preserve
do call afregning_daglig;

/* Månedlig økonomisk rapport */
-- 8.8
set global event_scheduler = on;

delimiter //
create procedure afregning_maaneder()
begin
SELECT Vaccine_Type, (COUNT(Vaccination_Foretaget)) * Pris AS Total_Pris FROM Aftale_Pris_View
WHERE Vaccination_Foretaget = true and MONTH(Tidspunkt) = MONTH(current_date())
GROUP BY Vaccine_Type HAVING Total_Pris > 0;
end //
delimiter ;

create event if not exists maenedlig_oekonomisk_rapport
on schedule every 1 month
on completion preserve
do call afregning_maeneder;

