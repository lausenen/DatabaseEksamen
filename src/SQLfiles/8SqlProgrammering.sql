
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

USE Vaccineberedskabet;
DROP procedure IF EXISTS Tilfoej_Ansvarlig_Medarbejder;

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

-- select Medarbejder_ID, Anciennitet( Medarbejder_ID) as Anciennitet from medarbejder;

/* Vaccine antal funktion */
-- 8.6
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

-- select Vaccine_Type ,VaccineAntal( Vaccine_type) as  VaccineAntal from vaccine_beholdning group by Vaccine_Type;

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

#drop procedure afregning_daglig;

create event if not exists daglig_vaccinations_rapport
on schedule every 1 day
on completion preserve
do call afregning_daglig;

-- call afregning_daglig;

/* Månedlig økonomisk rapport */
-- 8.8
set global event_scheduler=on;

delimiter //
create procedure afregning_maeneder()
begin
SELECT Vaccine_Type, (COUNT(Vaccination_Foretaget)) * Pris AS Total_Pris FROM Aftale_Pris_View
WHERE Vaccination_Foretaget = true and MONTH(Tidspunkt) = MONTH(current_date())
GROUP BY Vaccine_Type HAVING Total_Pris > 0;
end //
delimiter ;

#drop procedure afregning_maeneder;

create event if not exists maenedlig_oekonomisk_rapport
on schedule every 1 month
on completion preserve
do call afregning_maeneder;

-- call afregning_maeneder;



/*INSERT INTO Ansat VALUES (1212996743, 'kbh');
INSERT INTO Ansat VALUES (1212996743, 'Aarhus');
INSERT INTO Ansat VALUES (1212996743, 'Odense');
INSERT INTO Ansat VALUES (1212996743, 'Nakskov');*/

/*SET SQL_SAFE_UPDATES = 0;
SELECT * FROM vaccine_beholdning;
UPDATE Aftale SET Vaccination_Foretaget = true WHERE Borger_ID = 110987444 AND Tidspunkt = 20210427104500;
SELECT * FROM vaccine_beholdning;
SET SQL_SAFE_UPDATES = 1;*/

/*INSERT INTO Aftale VALUES (0110987444,20210527101510,'Kbh',1212996743, 0);*/

/*INSERT INTO Aftale (Borger_ID, Tidspunkt, Bynavn, Medarbejder_ID) VALUES
(110987444, 20210427101500,'Kbh',1212996743),
(110987444, 20210427103000,'Kbh',1212996743),
(110987444, 20210427104500,'Kbh',1212996743),
(110987444, 20210427110000,'Kbh',1212996743),
(110987444, 20210427111500,'Kbh',1212996743),
(110987444, 20210427101504,'Kbh',1212996743);*/

/*call tilfoej_ansvarlig_medarbejder (2611672111,20210427104500,110987444);

call tilfoej_ansvarlig_medarbejder (2102983231,20210427104500,110987444);*/






