/* Daglig rapport */
-- 7.1
SELECT Vaccine_Type, COUNT(Vaccination_Foretaget) AS Antal
FROM Aftale_Pris_View WHERE Vaccination_Foretaget = true
AND DAY(Tidspunkt) = DAY(current_date())
GROUP BY Vaccine_Type
HAVING Antal > 0;

/*
-- NB! så matcher nedenstående insert-Tidspunkt på >>sekundet<< nedenstående update-Tidspunkt.
-- For at UPDATE-statementet kan opdatere den rigtige aftale, skal alle statements altså eksekverens samtidig
INSERT INTO Borger VALUES (0000000001, 'Vilmer', 'Borg', 'Villadsen', 'Covaxx');
INSERT INTO Aftale (Borger_ID, Tidspunkt, Bynavn) VALUES (0000000001, current_timestamp() ,'Kbh');
SELECT* FROM Aftale;

SET SQL_SAFE_UPDATES = 0;
-- NB så matcher nedenstående update på sekundet ovenstående insert-Tidspunkt.
UPDATE Aftale SET Vaccination_Foretaget = true WHERE Borger_ID = 0000000001 AND Tidspunkt = current_timestamp();

*/

/*Økonomisk afregning*/
-- 7.2.1 nr. 1
SELECT Vaccine_Type,COUNT(Vaccination_Foretaget) AS Antal, (COUNT(Vaccination_Foretaget)) * Pris AS Total_Pris
FROM Aftale_Pris_View WHERE Vaccination_Foretaget = true
GROUP BY Vaccine_Type
HAVING Total_Pris > 0;

 -- 7.2.1 nr. 2
SELECT Vaccine_Type, COUNT(Vaccination_Foretaget) * Pris AS Total_Pris
FROM Aftale_Pris_View WHERE Vaccination_Foretaget = true and MONTH(Tidspunkt) = MONTH(current_date())
GROUP BY Vaccine_Type
HAVING Total_Pris > 0;

/* Total afregning */
-- 7.2.2

SELECT SUM(Antal) AS TOTAL_ANTAL, SUM(Total_Pris) AS TOTAL_PRIS FROM Vaccine_Budget;

/* Undersøge certificeret personale på given lokation */
-- 7.3
SELECT DISTINCT Bynavn, Vaccine_Type, (SELECT DISTINCT COUNT(Medarbejder_ID) 
WHERE Certificering.Medarbejder_ID = Ansat.Medarbejder_ID) 
AS Antal_Medarbejdere
FROM Ansat NATURAL JOIN Certificering 
GROUP BY Bynavn, Vaccine_Type;

/* Vaccinebehov pr. lokation */
 -- 7.4
SELECT Bynavn, Vaccine_Type, COUNT(Vaccination_Foretaget) AS Antal_Vacciner
FROM Aftale NATURAL RIGHT JOIN Borger WHERE Vaccination_Foretaget = FALSE
GROUP BY Bynavn, Vaccine_Type;

/* Sorter medarbejdere i løn */
-- 7.5

Select Medarbejder_ID, TItel, Løn from Medarbejder order by Løn desc;
 
/*Sortering af aftaler ift. tidspunkt*/
-- 7.6

Select Borger_ID, Medarbejder_ID, Bynavn, Tidspunkt from Aftale order by Tidspunkt asc;






