insert into aircrafts (aircraft_code, model, "range")
values ('SU9','Sukhoi SuperJet-100', 3000)
;
select * from aircrafts a 
;
insert into aircrafts (aircraft_code, model, "range")
values ('773','Boeing 777-300', 11100),
	('763','Boeing 767-300', 7900),
	('733','Boeing 737-300', 4200),	
	('320','Airbus A320-200', 5700),	
	('321','Airbus A321-200', 5600),
	('319','Airbus A319-100', 6700),
	('CN1','Cessna 208 Caravan', 1200),
	('CR2','Bombardier CRJ-200', 2700)
;
insert into seats
values ('SU9','1A','Business'),
	('SU9','1B','Business'),
	('SU9','10A','Economy'),
	('SU9','10B','Economy'),
	('SU9','10F','Economy'),
	('SU9','20F','Economy')
;
insert into seats
values ('CR2','1A','Business'),
	('CR2','1B','Business'),
	('CR2','10A','Economy'),
	('CR2','10B','Economy'),
	('CR2','14F','Economy'),
	('CR2','21F','Economy')
;