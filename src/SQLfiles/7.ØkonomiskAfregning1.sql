 SELECT Vaccine_Type, Pris, (SELECT sum(Vaccination_Foretaget)
 WHERE Vaccination_Foretaget = TRUE ) AS Antal,
 (SELECT ((SELECT sum(Vaccination_Foretaget)
 WHERE Vaccination_Foretaget = TRUE) * pris))
 AS Samlet_Pris
 FROM Aftale NATURAL JOIN Vaccine NATURAL JOIN Borger GROUP BY Vaccine_Type;