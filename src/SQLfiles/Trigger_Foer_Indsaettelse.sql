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

DELIMITER $$
CREATE TRIGGER Vaccinebeholdning_Efter_Insert
AFTER UPDATE ON Aftale FOR EACH ROW
IF NEW.Bynavn IS NOT NULL 
AND NEW.Vaccination_Foretaget = true
THEN UPDATE Vaccine_Beholdning
SET Antal_Vacciner = Antal_Vacciner - 1
WHERE Vaccine_Type =
(SELECT DISTINCT Vaccine_Type FROM Borger 
WHERE Borger.Borger_ID = NEW.Borger_ID)
AND  Vaccine_Beholdning.Bynavn = NEW.Bynavn;
END IF;
END $$

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