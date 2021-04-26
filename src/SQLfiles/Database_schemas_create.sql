

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
