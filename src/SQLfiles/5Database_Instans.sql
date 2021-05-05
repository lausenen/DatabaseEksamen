CREATE DATABASE IF NOT EXISTS Vaccineberedskabet;
USE vaccineberedskabet;

DROP TABLE IF EXISTS Aftale;
DROP TABLE IF EXISTS Ansat;
DROP TABLE IF EXISTS Borger;
DROP TABLE IF EXISTS Certificering;
DROP TABLE IF EXISTS Vaccine_beholdning;
DROP TABLE IF EXISTS Medarbejder;
DROP TABLE IF EXISTS Lokation;
DROP TABLE IF EXISTS Vaccine;

CREATE TABLE Medarbejder(
  Medarbejder_ID VARCHAR(10) NOT NULL,
  Titel VARCHAR(20) NOT NULL,
  Løn INT NOT NULL,
  Fornavn VARCHAR(20) NOT NULL,
  Mellemnavn VARCHAR(20),
  Efternavn VARCHAR(20) NOT NULL,
  Ansættelsesdato DATETIME NOT NULL,
  PRIMARY KEY (Medarbejder_ID));

CREATE TABLE Lokation (
  Bynavn VARCHAR(20) NOT NULL,
  Vej VARCHAR(20) NOT NULL,
  nr INT NOT NULL,
  PRIMARY KEY (Bynavn));
  
CREATE TABLE Vaccine (
  Vaccine_Type VARCHAR(10) NOT NULL,
  Pris INT NOT NULL,
  PRIMARY KEY (Vaccine_Type));

CREATE TABLE Borger (
  Borger_ID VARCHAR(10) NOT NULL,
  Fornavn VARCHAR(45) NOT NULL,
  Mellemnavn VARCHAR(45),
  Efternavn VARCHAR(45) NOT NULL,
  Vaccine_Type VARCHAR(10) NOT NULL,
  PRIMARY KEY (Borger_ID),
  FOREIGN KEY (Vaccine_Type) REFERENCES Vaccine (Vaccine_Type)
  ON DELETE NO ACTION ON UPDATE CASCADE);

CREATE TABLE Aftale (
  Borger_ID VARCHAR(10) NOT NULL,
  Tidspunkt DATETIME NOT NULL,
  Bynavn VARCHAR(10) NOT NULL,
  Medarbejder_ID VARCHAR(10),
  Vaccination_Foretaget BOOLEAN NOT NULL DEFAULT 0,

  PRIMARY KEY (Borger_ID, Tidspunkt),
  FOREIGN KEY (Borger_ID) REFERENCES Borger(Borger_ID) 
  ON DELETE CASCADE 
  ON UPDATE CASCADE,
  FOREIGN KEY (Bynavn) REFERENCES Lokation (Bynavn)
  ON DELETE NO ACTION 
  ON UPDATE CASCADE,
  FOREIGN KEY (Medarbejder_ID) REFERENCES Medarbejder(Medarbejder_ID)
  ON DELETE NO ACTION
  ON UPDATE CASCADE);
  
  ALTER TABLE Aftale ADD UNIQUE Mødetid(Medarbejder_ID, Tidspunkt);
	
CREATE TABLE Ansat (
  Medarbejder_ID VARCHAR(10) NOT NULL,
  Bynavn VARCHAR(20) NOT NULL,
  PRIMARY KEY (Medarbejder_ID, Bynavn),
  FOREIGN KEY (Medarbejder_ID) REFERENCES Medarbejder (Medarbejder_ID)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (Bynavn) REFERENCES Lokation (Bynavn)
  ON DELETE CASCADE
  ON UPDATE CASCADE);

CREATE TABLE Certificering (
  Medarbejder_ID VARCHAR(10) NOT NULL,
  Vaccine_Type VARCHAR(10) NOT NULL,
  Certificerings_Dato DATETIME NOT NULL,
  PRIMARY KEY (Medarbejder_ID, Vaccine_Type),
  FOREIGN KEY (Medarbejder_ID) REFERENCES Medarbejder (Medarbejder_ID)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
  FOREIGN KEY (Vaccine_Type) REFERENCES Vaccine (Vaccine_Type)
  ON DELETE CASCADE
  ON UPDATE CASCADE);
	
CREATE TABLE Vaccine_beholdning (
  Vaccine_Type VARCHAR(10) NOT NULL,
  Bynavn VARCHAR(20) NOT NULL,
  Antal_Vacciner INT NULL,
  PRIMARY KEY (Vaccine_Type, Bynavn),
  FOREIGN KEY (Vaccine_Type) REFERENCES Vaccine(Vaccine_Type)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
  FOREIGN KEY (Bynavn) REFERENCES Lokation(Bynavn)
  ON DELETE CASCADE
  ON UPDATE CASCADE);

CREATE VIEW Fuldtidsmedarbejdere AS
SELECT Medarbejder_ID, Fornavn,Efternavn,Løn
FROM Medarbejder
WHERE Titel = 'Fuldtid'
GROUP BY Løn DESC;

CREATE VIEW Samlede_Vaccinationer AS
SELECT DISTINCT Vaccine_Type, Count(Borger_ID) AS TOTAL
FROM Aftale NATURAL JOIN Borger
GROUP BY Vaccine_Type;

CREATE VIEW Aftale_Pris_View AS
SELECT Aftale.Borger_ID, Aftale.Tidspunkt, Aftale.Bynavn, Aftale.Medarbejder_ID,
Aftale.Vaccination_Foretaget, Borger.Vaccine_Type, Vaccine.Pris
FROM Aftale NATURAL JOIN Borger NATURAL JOIN Vaccine
WHERE Aftale.Borger_ID = Borger.Borger_ID and Vaccine.Vaccine_Type =  Borger.Vaccine_Type;

  show tables;
