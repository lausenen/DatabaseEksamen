INSERT Medarbejder VALUES
(2102983231,'Deltid',18000, 'Jesper', 'Hjalmer', 'Yonassen',20210101),
(1702832222,'Deltid',18000, 'Sybille','Bispebjerg', 'Pleyer',20210101),
(2611672111,'Deltid',19000, 'Gunnar', null, 'Frederiksen',20210101),
(0101986748,'Fuldtid',28500, 'Søs', null, 'Tjerne',20210101),
(1212996743,'Fuldtid',30000, 'Pontus',null, 'Andersson',20210101),
(2101883231,'Fuldtid',32500, 'Helle', 'Helle', 'Helle',20210101),
(1212694544,'Fuldtid',30000, 'Janne',null, 'Johansen',20210101),
(2611672102,'Fuldtid',27000, 'Vera', null, 'Frederiksen',20210101),
(0101986741,'Fuldtid', 27000, 'Jakub', null, 'Björnsson',20210101),
(1207996743,'Timelønnet',210, 'Celin',null, 'Peroit',20210101),
(1207996741,'Timelønnet',180, 'Peter',null, 'Piratos',20210101);

INSERT Vaccine VALUES 
('Covaxx',50),
('Divoc', 25),
('Blast3000',3000),
('Aspera',100);

INSERT Borger VALUES
(1234567891,'Lars', null, 'Larsen','Covaxx'),
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

INSERT Vaccine_Beholdning VALUES 
('Covaxx','Kbh',10000),
('Covaxx','Hill',5000),
('Covaxx','Aarhus',10000),
('Covaxx','Kolding',5000),
('Covaxx','Odense',10000),
('Covaxx','Nakskov',200),
('Divoc','Kbh',2000),
('Divoc','Hill',1000),
('Divoc','Aarhus',3000),
('Divoc','Kolding',1000),
('Divoc','Odense',3000),
('Divoc','Nakskov',400),
('Blast3000','Kbh',200),
('Blast3000','Hill',100),
('Blast3000','Aarhus',200),
('Blast3000','Kolding',50),
('Blast3000','Odense',100),
('Blast3000','Nakskov',20),
('Aspera','Kbh',5),
('Aspera','Hill',500),
('Aspera','Aarhus',1000),
('Aspera','Kolding',500),
('Aspera','Odense',1000),
('Aspera','Nakskov',200);

INSERT Ansat VALUES
(0101986748,'Kbh'),
(1212996743, 'Hill'),
(1212996743, 'Odense'),
(1702832222, 'Kbh'),
(2102983231, 'Hill'),
(2102983231, 'Odense'),
(2611672111,'Aarhus'),
(0101986748,'Aarhus'),
(2102983231, 'Nakskov');

INSERT Aftale (Borger_ID, Tidspunkt, Bynavn, Medarbejder_ID) VALUES 
(110987444,20210427103000,'Kbh',1212996743),
(110987444,20210427104500,'Kbh',1212996743),
(110987444,20210427114500,'Kbh',1212996743),
(110987444,20210427101504,'Kbh',1212996743),
(110987444,20210427111500,'Aarhus',1212996743),
(110987444,20210427123004,'Kolding',1212996743);

INSERT Aftale (Borger_ID, Tidspunkt, Bynavn, Medarbejder_ID, Vaccination_Foretaget) VALUES
(0110987444,20210527101500,'Kbh',1212996743, 0),
(2611672101,20210527110000,'Kbh',1212996743, 0),
(1234567891,20210427120000,'kbh',1212996743, 0),
(3001025555,20210427113000,'Kbh',1212996743, 0),
(1212996733,20210527103000,'kbh',1212996743, 0);

INSERT Certificering VALUES 
('101986748','Aspera', 20210501),
('1212996743','Blast3000', 20210110),
('1702832222','Covaxx', 20210903),
('2102983231','Divoc', 20211204),
('2611672111','Divoc', 20210321),
('101986748','Blast3000', 20210327),
('2611672111','Blast3000', 20210321),
('2611672111','Aspera', 20210321);