-----TOP 5 Cutomers----
SELECT  * FROM  
    (
    select o.customerid, sum(d.quantity)
    from sales_orders o
    join sales_order_details d
    on o.orderid=d.order_id
    group by  o.customerid
    order by sum(d.quantity) desc
    )
WHERE rownum <= 5;























----Top 5 sales people-----

SELECT  * FROM  
    (
    select  o.employeeid, sum(d.quantity)
    from sales_orders o
    join sales_order_details d
    on o.orderid=d.order_id
    join sales_employees e
    on e.employeeid=o.employeeid
    group by o.employeeid
    order by sum(d.quantity) desc
    )
WHERE rownum <= 5;


-----2nd best selling product---

select * from (select   product_id, sum(quantity)
from sales_order_details 
group by product_id
order by sum(quantity) desc)
where rownum <= 2;

------Display product name, category of that product that are shipped by Speedy Express.----

select p.product_name, p.category_id, o.ship_via, s.company_name
from sales_products p
join sales_order_details d
on p.product_id=d.product_id
join sales_orders o 
on o.orderid=d.order_id
join sales_shippers s
on s.shipper_id=o.ship_via
where s.company_name= 'Speedy Express';


---Display list of cities where Dairy Products is not being sold?----


select s.city, c.category_name
from sales_products p
join sales_suppliers s 
on p.supplier_id=s.supplier_id
join sales_categories c
on c.category_id=p.category_id
where c.category_name not like 'Dairy%';


-----Which is the best performing year (sales wise)------

select sum(d.quantity) as total_sales, to_char(o.shipped_date,'YY') as years
from sales_order_details d
join sales_orders o
on o.orderid=d.order_id
group by to_char(o.shipped_date,'YY')
order by sum(quantity) desc;


-----What is the average delay (in days) for shipping orders in the month of January---

select orderid,to_char(shipped_date,'Mon') as month,order_date, shipped_date,
        avg((shipped_date-order_date)) as delay_days
from sales_orders 
where to_char(shipped_date,'Mon')='Jan'
group by orderid,to_char(shipped_date,'Mon'),order_date, shipped_date;

-----Display region and the total sales for that region for Q1 and Q2----
SELECT  * FROM  
    (
    select  o.orderid, o.customerid,o.ship_region, sum(d.quantity)
    from sales_orders o
    join sales_order_details d
    on o.orderid=d.order_id
    group by o.orderid, o.customerid,o.ship_region
    order by sum(d.quantity) desc
    )
WHERE rownum <= 5;

SELECT  * FROM  
    (
    select  o.employeeid,e.lastname,e.firstname, sum(d.quantity),o.ship_region
    from sales_orders o
    join sales_order_details d
    on o.orderid=d.order_id
    join sales_employees e
    on e.employeeid=o.employeeid
    group by o.employeeid,e.lastname,e.firstname,o.ship_region
    order by sum(d.quantity) desc
    )
WHERE rownum <= 5;

-----List of customers whose average yearly sale is more that Rs. 10000?----
       select unit_price*quantity,to_char(o.shipped_date,'YY') as years, customerid, employeeid
from sales_customers c 
join sales_orders o
on o.customerid=c.customer_id
join sales_order_details d
on d.order_id=o.orderid
where unit_price*quantity > 10000
order by unit_price*quantity desc;

-----Top 5 products which have largest inventory - Rs wise?-----

select * from
(
    select product_id,product_name,(units_in_stock*unit_price)
    from sales_products
    order by (units_in_stock*unit_price) desc)
where rownum<=5;

-----Top 5 products which have largest inventory - Quantity wise?------
select * from
(
    select product_id,product_name,(units_in_stock+units_on_order) as total_quantity
    from sales_products
    order by (units_in_stock+units_on_order) desc)
where rownum<=5;
