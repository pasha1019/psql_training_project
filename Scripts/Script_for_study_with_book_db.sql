select bb.buy_id, b.title, b.price, bb.amount from buy_book bb
join book b on b.book_id = bb.book_id
join buy on buy.buy_id = bb.buy_id
where buy.client_id = 1
order by bb.buy_id, b.title
;
----
---Посчитать, сколько раз была заказана каждая книга, для книги вывести ее автора (нужно посчитать, в каком количестве заказов
---фигурирует каждая книга).  Вывести фамилию и инициалы автора, название книги, последний столбец
---назвать Количество. Результат отсортировать сначала  по фамилиям авторов, а потом по названиям книг.
select a.name_author, b.title, count(bb.buy_book_id) as Количество from buy_book bb
right join book b on bb.book_id = b.book_id 
join author a on a.author_id =b.author_id 
group by a.name_author, b.title
order by a.name_author, b.title 
;
---Вывести города, в которых живут клиенты, оформлявшие заказы в интернет-магазине. Указать количество заказов в каждый город, этот столбец назвать Количество.
--- Информацию вывести по убыванию количества заказов, а затем в алфавитном порядке по названию городов.
select c2.name_city, count(c2.name_city) as Количество from buy b
join client c on b.client_id =c.client_id
join city c2 on c2.city_id = c.city_id
group by c2.name_city
order by Количество desc, c2.name_city ASC
;
---Вывести номера всех оплаченных заказов и даты, когда они были оплачены.
select bs.buy_id, bs.date_step_end from buy_step bs
join step s on s.step_id = bs.step_id
where s.name_step = 'Оплата' and date_step_end is not null
;
---Вывести информацию о каждом заказе: его номер, кто его сформировал (фамилия пользователя) и его стоимость (сумма произведений количества заказанных книг и их цены), 
---в отсортированном по номеру заказа виде. Последний столбец назвать Стоимость.
select bb.buy_id, c.name_client, sum(bb.amount * b.price) as Стоимость from buy_book bb 
join book b on b.book_id = bb.book_id
join buy b2 on b2.buy_id = bb.buy_id
join client c on c.client_id = b2.client_id
group by bb.buy_id, c.name_client
order by bb.buy_id 
;
---Вывести номера заказов (buy_id) и названия этапов, на которых они в данный момент находятся. 
---Если заказ доставлен –  информацию о нем не выводить. Информацию отсортировать по возрастанию buy_id.
select bs.buy_id, s.name_step from buy_step bs
join step s on s.step_id = bs.step_id
where bs.date_step_end is null
and bs.date_step_beg is not null
order by bs.buy_id
;

