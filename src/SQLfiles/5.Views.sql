CREATE VIEW Fuldtidsmedarbejdere AS 
SELECT Medarbejder_ID, Fornavn,Efternavn,Løn 
FROM Medarbejder
WHERE Titel = 'Fuldtid'
GROUP BY Løn DESC;

CREATE VIEW Samlede_Vaccinationer AS
SELECT DISTINCT Vaccine_Type, Count(Borger_ID) AS TOTAL
FROM Aftale NATURAL JOIN Borger 
GROUP BY Vaccine_Type;

