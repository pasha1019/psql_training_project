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
---В таблице city для каждого города указано количество дней, за которые заказ может быть доставлен в этот город
--- (рассматривается только этап "Транспортировка"). Для тех заказов, которые прошли этап транспортировки, 
--- вывести количество дней за которое заказ реально доставлен в город. А также, если заказ доставлен с опозданием,
--- указать количество дней задержки, в противном случае вывести 0. В результат включить номер заказа (buy_id),
--- а также вычисляемые столбцы Количество_дней и Опоздание. Информацию вывести в отсортированном по номеру заказа виде.
select  bs.buy_id, extract (day from age(bs.date_step_end, bs.date_step_beg)) as Количество_дней, -- в MySQL следует использовать datediff 
case when extract (day from age(bs.date_step_end, bs.date_step_beg)) - (c2.days_delivery) > 0 
then extract (day from age(bs.date_step_end, bs.date_step_beg)) - (c2.days_delivery)
else 0
end as Опоздание 
from buy_step bs
join step s on s.step_id = bs.step_id
join buy b on b.buy_id = bs.buy_id 
join client c on b.client_id = c.client_id 
join city c2 on c2.city_id = c.city_id 
where s.name_step = 'Транспортировка'
and bs.date_step_end is not null
order by bs.buy_id
;
--- Выбрать всех клиентов, которые заказывали книги Достоевского, информацию вывести в отсортированном по алфавиту виде. 
--- В решении используйте фамилию автора, а не его id.
select distinct name_client from client c
join buy b on b.client_id = c.client_id
join buy_book bb on b.buy_id = bb.buy_id
join book b2 on b2.book_id = bb.book_id
join author a on a.author_id = b2.author_id
where a.name_author = 'Достоевский Ф.М.'
order by c.name_client 
;
--- Вывести жанр (или жанры), в котором было заказано больше всего экземпляров книг, указать это количество .
--- Последний столбец назвать Количество.
select g.name_genre
, sum(bb.amount) as Количество 
from genre g 
join book b on g.genre_id = b.genre_id 
join buy_book bb on bb.book_id = b.book_id
group by g.name_genre
having sum(bb.amount) = (
select max(sum_amount) 
from
    (select sum(bb2.amount) as sum_amount from buy_book bb2
    join book b2 on bb2.book_id = b2.book_id
    group by b2.genre_id) -- для MySQL нужно добавить алиас подзапроса
)
;
--- MySQL - архивная таблица
--- Сравнить ежемесячную выручку от продажи книг за текущий и предыдущий годы. 
--- Для этого вывести год, месяц, сумму выручки в отсортированном сначала по возрастанию месяцев,
--- затем по возрастанию лет виде. Название столбцов: Год, Месяц, Сумма.
SELECT YEAR(ba.date_payment) AS Год,
MONTHNAME(ba.date_payment) AS Месяц,
SUM(ba.amount*ba.price) as Сумма
FROM 
    buy_archive ba
group by Год, Месяц
UNION ALL
SELECT YEAR(date_step_end) AS Год,
MONTHNAME(date_step_end) AS Месяц,
SUM(buy_book.amount*b.price) as Сумма
FROM 
    book b
    INNER JOIN buy_book USING(book_id)
    INNER JOIN buy USING(buy_id) 
    INNER JOIN buy_step USING(buy_id)
    INNER JOIN step USING(step_id)                  
WHERE  date_step_end IS NOT Null and name_step = "Оплата"
group by Год, Месяц
order by Месяц ASC, Год ASC
;
--- MySQL - архивная таблица
--- Для каждой отдельной книги необходимо вывести информацию о количестве проданных экземпляров и их стоимости за 2020 и 2019 год .
--- За 2020 год проданными считать те экземпляры, которые уже оплачены. Вычисляемые столбцы назвать Количество и Сумма. 
--- Информацию отсортировать по убыванию стоимости.
SELECT Название, sum(Количество) as Количество, sum(Сумма) as Сумма
FROM (
SELECT b.title as Название, sum(ba.amount) as Количество, sum(ba.price * ba.amount) as Сумма
FROM 
    buy_archive ba
JOIN book b on b.book_id = ba.book_id
group by b.title
UNION ALL
SELECT b.title, sum(buy_book.amount) as Количество, sum(b.price * buy_book.amount) as Сумма
FROM 
    book b
    INNER JOIN buy_book USING(book_id)
    INNER JOIN buy USING(buy_id) 
    INNER JOIN buy_step USING(buy_id)
    INNER JOIN step USING(step_id)                  
WHERE  date_step_end IS NOT Null and name_step = "Оплата"
group by b.title
) as sub
group by Название
order by Сумма DESC
;