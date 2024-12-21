select bb.buy_id, b.title, b.price, bb.amount from buy_book bb
join book b on b.book_id = bb.book_id
join buy on buy.buy_id = bb.buy_id
where buy.client_id = 1
order by bb.buy_id, b.title
;
----

