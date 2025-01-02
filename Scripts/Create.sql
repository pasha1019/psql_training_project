create table seats
(
	aircraft_code char( 3 ) not null,
	seat_no varchar( 4 ) not null, -- varchar хранит любые символы
	fare_conditions varchar( 10 ) not null,
	check
	(fare_conditions in ('Economy', 'Comfort', 'Business')), -- проверка
	primary key (aircraft_code, seat_no), -- первичный ключ
	foreign key (aircraft_code) -- внешний ключ
	references aircrafts (aircraft_code) -- зависимость
	on delete cascade -- каскадное удаление записей
)
;