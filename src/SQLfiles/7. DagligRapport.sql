SELECT Vaccine_Type, (SELECT sum(Vaccination_Foretaget)
 WHERE Vaccination_Foretaget = TRUE AND DAY(Tidspunkt) = DAY(current_date())) AS sumVaccines 
 FROM Aftale NATURAL JOIN Vaccine NATURAL JOIN Borger GROUP BY Vaccine_Type;