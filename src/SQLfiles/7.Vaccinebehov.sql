SELECT Bynavn, Vaccine_Type, COUNT(Vaccination_Foretaget) AS Antal_Vacciner
FROM Aftale NATURAL RIGHT JOIN Borger WHERE Vaccination_Foretaget = FALSE
GROUP BY Bynavn, Vaccine_Type;