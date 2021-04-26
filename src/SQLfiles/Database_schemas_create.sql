
DROP TABLE IF EXISTS Aftale;
DROP TABLE IF EXISTS Ansat;
DROP TABLE IF EXISTS Borger;
DROP TABLE IF EXISTS Certificering;
DROP TABLE IF EXISTS Vaccine_beholdning;
DROP TABLE IF EXISTS Vagtplan;
DROP TABLE IF EXISTS Vagt;
DROP TABLE IF EXISTS Medarbejder;
DROP TABLE IF EXISTS Lokation;
DROP TABLE IF EXISTS Tidspunkt;
DROP TABLE IF EXISTS Vaccine;

CREATE TABLE Medarbejder (
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
  År YEAR NOT NULL,
  Måned INT2 NOT NULL,
  Dato INT2 NOT NULL,
  Klokkeslet TIME NOT NULL,
  Bynavn VARCHAR(10) NOT NULL,
  Medarbejder_ID VARCHAR(10),
  PRIMARY KEY (Borger_ID, År, Måned, Dato, Klokkeslet),
  FOREIGN KEY (Borger_ID) REFERENCES Borger(Borger_ID)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (Bynavn) REFERENCES Lokation (Bynavn)
  ON DELETE NO ACTION
  ON UPDATE CASCADE,
  FOREIGN KEY (Medarbejder_ID) REFERENCES Medarbejder(Medarbejder_ID)
  ON DELETE NO ACTION
  ON UPDATE CASCADE);


CREATE TABLE Tidspunkt (
  Dagkode CHAR NOT NULL,
  Starttidspunkt TIME NOT NULL,
  Sluttidspunkt TIME NOT NULL,
  PRIMARY KEY (Dagkode, Starttidspunkt));

CREATE TABLE Vagt (
  Vagt_ID INT NOT NULL AUTO_INCREMENT,
  Aar YEAR NOT NULL,
  Uge SMALLINT NOT NULL,
  Dagkode CHAR NOT NULL,
  Starttidspunkt TIME NOT NULL,
  Bynavn VARCHAR(10) NOT NULL,
  PRIMARY KEY (Vagt_ID),
  FOREIGN KEY (Dagkode) REFERENCES Tidspunkt (Dagkode)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (Dagkode , Starttidspunkt) REFERENCES Tidspunkt (Dagkode , Starttidspunkt)
  ON DELETE CASCADE
  ON UPDATE CASCADE);

CREATE TABLE Ansat (
  Medarbejder_ID VARCHAR(10) NOT NULL,
  Bynavn VARCHAR(10) NOT NULL,
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
  Doser_Vacciner INT NULL,
  PRIMARY KEY (Vaccine_Type, Bynavn),
  FOREIGN KEY (Vaccine_Type) REFERENCES Vaccine(Vaccine_Type)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
  FOREIGN KEY (Bynavn) REFERENCES Lokation(Bynavn)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION);

CREATE TABLE Vagtplan (
  Vagt_ID INT NOT NULL,
  Medarbejder_ID VARCHAR(10) NOT NULL,
  PRIMARY KEY (Vagt_ID, Medarbejder_ID),
  FOREIGN KEY (Vagt_ID) REFERENCES Vagt(Vagt_ID)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (Medarbejder_ID) REFERENCES Medarbejder(Medarbejder_ID)
  ON DELETE NO ACTION
  ON UPDATE CASCADE);

  show tables;


/* virker af en mærkelig grund ikke
INSERT Vaccine_Beholdning VALUES
('Covaxx','Kbh',10000),
('Covaxx','Hill',5000),
('Covaxx','Aarhus',10000),
('Covaxx','Kolding',5000),
('Covaxx','Odsense',10000),
('Covaxx','Naksskov',200),
('Divoc','Kbh',2000),
('Divoc','Hill',1000),
('Divoc','Aarhus',3000),
('Divoc','Kolding',1000),
('Divoc','Odsense',3000),
('Divoc','Naksskov',400),
('Blast3000','Kbh',200),
('Blast3000','Hill',100),
('Blast3000','Aarhus',200),
('Blast3000','Kolding',50),
('Blast3000','Odsense',100),
('Blast3000','Naksskov',20),
('Aspera','Kbh',1000),
('Aspera','Hill',500),
('Aspera','Aarhus',1000),
('Aspera','Kolding',500),
('Aspera','Odsense',1000),
('Aspera','Naksskov',200);

SELECT* FROM Vaccine_Beholdning;
*/



-- SELECT* FROM Borger;
SELECT* FROM Aftale;
SELECT* FROM Ansat;
-- SELECT* FROM Borger;
SELECT* FROM Certificering;
SELECT* FROM Vaccine_beholdning;
SELECT* FROM Vagtplan;
SELECT* FROM Vagt;
-- SELECT* FROM Medarbejder;

SELECT* FROM Lokation;
SELECT* FROM Tidspunkt;
SELECT* FROM Vaccine;

