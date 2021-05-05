/* Daglig rapport */
-- 7.1
SELECT Vaccine_Type, COUNT(Vaccination_Foretaget) AS Antal
FROM Aftale_Pris_View WHERE Vaccination_Foretaget = true
AND DAY(Tidspunkt) = DAY(current_date())
GROUP BY Vaccine_Type
HAVING Antal > 0;

/*Økonomisk afregning*/
-- 7.2.1 nr. 1
SELECT Vaccine_Type,COUNT(Vaccination_Foretaget) AS Antal, (COUNT(Vaccination_Foretaget)) * Pris AS Total_Pris
FROM Aftale_Pris_View WHERE Vaccination_Foretaget = true
GROUP BY Vaccine_Type
HAVING Total_Pris > 0;
 
 -- 7.2.1 nr. 2
SELECT Vaccine_Type, (COUNT(Vaccination_Foretaget) AS Antal) * Pris AS Total_Pris
FROM Aftale_Pris_View WHERE Vaccination_Foretaget = true and MONTH(Tidspunkt) = MONTH(current_date())
GROUP BY Vaccine_Type
HAVING Total_Pris > 0;

/* Total afregning */
-- 7.2.2

SELECT SUM(Antal) AS TOTAL_ANTAL, SUM(Samlet_Pris) AS TOTAL_PRIS FROM Vaccine_Budget;

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



