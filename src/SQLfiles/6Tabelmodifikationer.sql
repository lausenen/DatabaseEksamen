INSERT INTO Medarbejder VALUES (1000000001,'Deltid',18000,'Vitus', null, 'Vilmer',20210101);
INSERT INTO Medarbejder VALUES (1000000002,'Fuldtid',3250,'Helle', null, 'Helle',20210101);
INSERT INTO Medarbejder VALUES (1000000003,'Timelønnet',210,'Helen', null, 'Peroit',20210101);


INSERT INTO Ansat VALUES (1000000001,'Kbh');
INSERT INTO Ansat VALUES (1000000002,'Kbh');
INSERT INTO Ansat VALUES (1000000003,'Kbh');


UPDATE Ansat SET Bynavn = 'Odense' WHERE Medarbejder_ID = 1000000003;


UPDATE Vaccine_beholdning SET antal_vacciner = '500' WHERE vaccine_type = 'covaxx' AND bynavn = 'kbh';

DELETE FROM Ansat WHERE Medarbejder_ID = 1000000003 AND Bynavn = 'Odense';

DELETE FROM Medarbejder WHERE Medarbejder_ID = 1000000002;

DELETE FROM Lokation WHERE Bynavn = 'Nakskov';

