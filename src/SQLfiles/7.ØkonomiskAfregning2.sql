SELECT Vaccine_Type, Pris, (SELECT sum(Vaccination_Foretaget)
 WHERE Vaccination_Foretaget = TRUE AND MONTH(Tidspunkt) = MONTH(current_date()))
 AS Antal,
 (SELECT ((SELECT sum(Vaccination_Foretaget) 
 WHERE Vaccination_Foretaget = TRUE AND MONTH(Tidspunkt) = MONTH (current_date())) * Pris))
 AS Samlet_Pris
 FROM Aftale NATURAL JOIN Vaccine NATURAL JOIN Borger GROUP BY Vaccine_Type;