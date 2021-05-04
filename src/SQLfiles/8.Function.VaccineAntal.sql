DELIMITER //
Create function
VaccineAntal (VType varchar(10))
returns int
begin
declare VTotalAntal int;
Select sum(Antal_Vacciner) into VTotalAntal
from vaccine_beholdning where Vaccine_Type = VType;
return VTotalAntal;
end //
DELIMITER ;

select distinct Vaccine_Type, VaccineAntal(Vaccine_Type) from Vaccine_beholdning;

#drop function VLokation;