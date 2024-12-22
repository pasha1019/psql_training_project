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
select count(*)  from buy_book bb
join book b on bb.book_id = b.book_id 
join author a on a.author_id =b.author_id 
group by bb.book_id 

;