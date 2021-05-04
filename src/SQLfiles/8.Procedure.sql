USE Vaccineberedskabet;
DROP procedure IF EXISTS Skift_Ansvarlig_Medarbejder;

DELIMITER $$
USE Vaccineberedskabet $$
CREATE PROCEDURE Skift_Ansvarlig_Medarbejder (IN vMedarbejder_ID VARCHAR(10),
IN vTidspunkt DATETIME, 
IN vBorger_ID VARCHAR(10))
BEGIN
IF (SELECT Vaccine_Type FROM Certificering 
WHERE Medarbejder_ID = vMedarbejder_ID AND Vaccine_Type = (SELECT Vaccine_Type FROM Borger WHERE Borger.Borger_ID = vBorger_ID)) != true THEN
UPDATE Aftale SET Medarbejder_ID = vMedarbejder_ID
WHERE Tidspunkt = vTidspunkt AND Borger_ID = vBorger_ID;
ELSE
SIGNAL SQLSTATE 'HY000'
SET MYSQL_ERRNO = 2021, 
MESSAGE_TEXT = 'Medarbejderen er ikke certificeret i denne vaccine!';
END IF;
END$$
DELIMITER ;

-- Eksempel brugt til at teste proceduren
INSERT INTO Medarbejder VALUES (1000000001,'Deltid',18000, 'Vitus', null, 'Vilmer',20210101);
INSERT INTO Ansat VALUES (1000000001, 'Odense');
SELECT* FROM Ansat;

Call Skift_ansvarlig_Medarbejder(1000000001, 20210427120000, 1234567891);
INSERT INTO Certificering VALUES (1000000001, 'Covaxx',20210501000000);
Call Skift_ansvarlig_Medarbejder(1000000001, 20210427120000, 1234567891);

SELECT* FROM Aftale;
