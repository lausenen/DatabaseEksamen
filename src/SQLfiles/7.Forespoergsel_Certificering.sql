SELECT DISTINCT Bynavn, Vaccine_Type, (SELECT DISTINCT COUNT(Medarbejder_ID) 
WHERE Certificering.Medarbejder_ID = Ansat.Medarbejder_ID) 
AS Antal_Medarbejdere
FROM Ansat NATURAL JOIN Certificering 
GROUP BY Bynavn, Vaccine_Type;

SELECT Medarbejder_ID, Vaccine_Type FROM Medarbejder NATURAL JOIN Certificering;