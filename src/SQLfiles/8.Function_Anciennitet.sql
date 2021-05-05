
DELIMITER $$
CREATE FUNCTION Anciennitet (current_Medarbejder_ID varchar(10))
returns int
DETERMINISTIC
BEGIN 
  DECLARE år int;
  SET år = floor(DATEDIFF(current_date(),(select Ansættelsesdato from medarbejder where Medarbejder_ID = current_Medarbejder_ID))/365);
  RETURN år;
END$$
DELIMITER ;

select Medarbejder_ID, Anciennitet( Medarbejder_ID) as Anciennitet from medarbejder;







