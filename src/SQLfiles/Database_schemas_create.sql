

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
  Medarbejder_ID INT NOT NULL,
  Titel VARCHAR(10) NOT NULL,
  Loen INT NOT NULL,
  Fornavn VARCHAR(45) NOT NULL,
  Mellemnavn VARCHAR(45),
  Efternavn VARCHAR(45) NOT NULL,
  Ansættelsesdato DATETIME NOT NULL,
  PRIMARY KEY (Medarbejder_ID));


CREATE TABLE Lokation (
  Bynavn VARCHAR(10) NOT NULL,
  Vej VARCHAR(10) NOT NULL,
  nr INT NOT NULL,
  PRIMARY KEY (Bynavn));
  
CREATE TABLE Vaccine (
  Vaccine_Type VARCHAR(10) NOT NULL,
  Pris INT NOT NULL,
  PRIMARY KEY (Vaccine_Type));

CREATE TABLE Borger (
  Borger_ID INT NOT NULL,
  Fornavn VARCHAR(45) NOT NULL,
  Mellemnavn VARCHAR(45),
  Efternavn VARCHAR(45) NOT NULL,
  Vaccine_Type VARCHAR(10) NULL,
  PRIMARY KEY (Borger_ID),
  FOREIGN KEY (Vaccine_Type) REFERENCES Vaccine (Vaccine_Type)
  ON DELETE NO ACTION ON UPDATE CASCADE);

CREATE TABLE Aftale (
  Borger_ID INT NOT NULL,
  Aar YEAR NOT NULL,
  Maaned INT2 NOT NULL,
  Dato INT2 NOT NULL,
  Klokkeslet TIME NOT NULL,
  Bynavn VARCHAR(10) NOT NULL,
  Medarbejder_ID INT,
  PRIMARY KEY (Borger_ID, Aar, Maaned, Dato, Klokkeslet),
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
  Medarbejder_ID INT NOT NULL,
  Bynavn VARCHAR(10) NOT NULL,
  PRIMARY KEY (Medarbejder_ID, Bynavn),
  FOREIGN KEY (Medarbejder_ID) REFERENCES Medarbejder (Medarbejder_ID)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (Bynavn) REFERENCES Lokation (Bynavn)
  ON DELETE CASCADE
  ON UPDATE CASCADE);


CREATE TABLE Certificering (
  Medarbejder_ID INT NOT NULL,
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
  Bynavn VARCHAR(10) NOT NULL,
  Doser_Vacciner INT NULL,
  PRIMARY KEY (Vaccine_Type, Bynavn),
  FOREIGN KEY (Vaccine_Type) REFERENCES Vaccine (Vaccine_Type)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (Bynavn) REFERENCES Lokation(Bynavn)
  ON DELETE CASCADE
  ON UPDATE CASCADE);
	
CREATE TABLE Vagtplan (
  Vagt_ID INT NOT NULL,
  Medarbejder_ID INT NOT NULL,
  PRIMARY KEY (Vagt_ID, Medarbejder_ID),
  FOREIGN KEY (Vagt_ID) REFERENCES Vagt (Vagt_ID)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (Medarbejder_ID) REFERENCES Medarbejder (Medarbejder_ID)
  ON DELETE NO ACTION
  ON UPDATE CASCADE);
    
  show tables;

INSERT Medarbejder VALUES
(2102983231,'Sygeplejerske',32500, 'Jesper', 'Hjalmer', 'Yonassen',20210101),
(1702832222,'Sygeplejerske',30000, 'Sybille','Bispebjerg', 'Pleyer',20210101),
(2611672111,'Rengøringsassistent',18000, 'Gunnar', null, 'Frederiksen',20210101),
(0101986748,'Lægestuderende', 15000, 'Søs', null, 'Tjerne',20210101),
(1212996743,'Lægestuderende',15000, 'Pontus',null, 'Andersson',20210101);

INSERT Vaccine VALUES
('Covaxx',50),
('Divoc', 25),
('Blast3000',3000),
('Aspera',100);

INSERT Borger VALUES
(1234567891,'Lars', null, 'Larsen','Blast3000'),
(2611672101,'Margrethe', null, 'Milliard','Blast3000'),
(0110987444,'Sys', null, 'Bjerre','Aspera'),
(1234561111,'Anders',null, 'And','Divoc'),
(3001025555,'Preben', null, 'Larsen','Blast3000'),
(2611672111,'Jonne', null, 'Hansen','Blast3000'),
(01019867470,'Ling', null, 'Ling','Aspera'),
(1212996733,'Harald',null, 'Nyborg','Divoc'),
(1706021234, 'Pedro', 'Josef', 'Santiago','Blast3000');

INSERT Lokation VALUES
('Kbh','Jagtvej', 17),
('Hill','Paradisæblevej', 101),
('Aarhus','Strøget', 10),
('Kolding','Tvedvej', 57),
('Odense','Windelsvej', 13),
('Nakskov','Æbletoften', 7);

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

