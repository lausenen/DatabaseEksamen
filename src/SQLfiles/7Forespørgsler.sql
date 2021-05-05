/* Daglig rapport */
-- 7.1
SELECT Vaccine_Type, (SELECT sum(Vaccination_Foretaget)
WHERE Vaccination_Foretaget = TRUE AND DAY(Tidspunkt) = DAY(current_date())) AS sumVaccines 
FROM Aftale NATURAL JOIN Vaccine NATURAL JOIN Borger GROUP BY Vaccine_Type;

/*Økonomisk afregning*/
-- 7.2.1 nr. 1
 SELECT Vaccine_Type, Pris, (SELECT sum(Vaccination_Foretaget)
 WHERE Vaccination_Foretaget = TRUE ) AS Antal,
 (SELECT ((SELECT sum(Vaccination_Foretaget)
 WHERE Vaccination_Foretaget = TRUE) * pris))
 AS Samlet_Pris
 FROM Aftale NATURAL JOIN Vaccine NATURAL JOIN Borger GROUP BY Vaccine_Type;
 
 -- 7.2.1 nr. 2
select Vaccine_Type, Pris, (select sum(Vaccination_Foretaget) from  Aftale 
where Vaccination_Foretaget = true and month(Tidspunkt) = month(current_date())) 
as Antal, 
(select ((select sum(Vaccination_Foretaget) from  Aftale 
where Vaccination_Foretaget = true and month(Tidspunkt) = month(current_date())) * Pris))
as Samlet_Pris
from  Aftale natural join Vaccine natural join Borger group by Vaccine_Type;

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



