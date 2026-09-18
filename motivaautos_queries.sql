--Provide the full name, email adress, total orders for customers who have made an order.

select 
	c.first_name ||' '||c.last_name as full_name, 
	c.email , 
	count (o.order_id) as total_orders
from orders o
join customers c
on c.customer_id = o.customer_id
group by c.first_name, c.last_name, c.email;

--Retrieve cars that have been ordered with their corresponding revenue and unit sold
--Rerturn ordered cars, their revenue and units sold
--cars table and orders table
--car_id
--inner join

select 
	cr.car_id, 
	cr.car_brand, 
	cr.car_model, 
	sum (o.quantity_sold) as total_quantity, 
	sum (o.sales_amount) as total_revenue
from cars cr
join orders o
on cr.car_id = o.car_id
group by cr.car_id, cr.car_brand, cr.car_model;


select 
	cr.car_id, 
	cr.car_brand, 
	cr.car_model, 
	sum (o.quantity_sold) as total_quantity, 
	sum (o.sales_amount) as total_revenue
from cars cr
join orders o
on cr.car_id = o.car_id
group by 1,2,3;


--Find Customers who have spent above avg revenue

select 
	 c.customer_id, c.first_name || ' ' || c.last_name as full_name,
    sum (o.sales_amount) as revenue
from customers c
join orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.first_name || ' ' || c.last_name
having sum(o.sales_amount) > (select avg (o.sales_amount))

--Retrieve most expensive car
select *
from cars 
where unit_price = (select max(unit_price) from cars)


--TIMESTAMPS AND EXTRACTION

select 
	order_date,
	extract (year from order_date) as order_year,
	extract (month from order_date) as order_month
from orders;

--Total revenue generated for each year
select 
	extract (year from order_date) as "Year", 
	sum (sales_amount) as "Total Revenue"
from orders
group by "Year";


--Total revenue and total quantity sold
select 
	'$' || to_char (sum (sales_amount), 'fm999,999,999') as "Total Revenue",
	sum (quantity_sold) as "Total Qty Sold" 
from orders;

--Segment customers into loyalty tiers (Gold, Silver and Bronze)
select 
	c.customer_id, 
	c.first_name ||' '|| c.last_name as "Full Name", 
	'$' || to_char (sum (o.sales_amount), 'fm999,999,999') as "Revenue",
	case
		when sum(o.sales_amount) >= 1000000 then 'Gold'
		when sum(o.sales_amount) < 1000000 and sum(o.sales_amount) >= 500000 then 'Silver'
		else 'Bronze' 
		end as "Customer Tier"
from customers c
join orders o
on c.customer_id = o.customer_id
group by 1,2;

--Monthly sales trend across years
select 
	extract (year from order_date) as "Year",
	extract (month from order_date) as "Month No",
	to_char (order_date, 'Month') as "Month",
	'$' || to_char (sum (sales_amount), 'fm999,999,999') as "Total Sales"
from orders
group by 1,2,3
order by 1,2;

--Most frequently purchased car color
select c.car_color, 
	coalesce (sum(o.quantity_sold), 0) as "Total Qty"
from cars c
left join orders o
on c.car_id = o.car_id
group by 1
order by "Total Qty" desc;

--Explain Analyze
EXPLAIN ANALYSE
select c.car_color, 
	coalesce (sum(o.quantity_sold), 0) as "Total Qty"
from cars c
left join orders o
on c.car_id = o.car_id
group by 1
order by "Total Qty" desc;