SELECT * FROM aircrafts
;
select * from aircrafts a 
order by a.model 
;
select * from aircrafts a 
where a."range" >= 4000 and a."range" <=6000
;
select * from seats s
;
select count(*) from seats s -- считаем записи в таблице
where s.aircraft_code = 'SU9'
;
select s.aircraft_code, count(*) as Количество from seats s
group by s.aircraft_code 
;

