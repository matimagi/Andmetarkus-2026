-- Analyze cafe sales and compare them to budget 

-- 1.1. Cafe sales by Year-Month 
select to_char(transaction_date , 'yyyy-mm') as sales_by_month,
sum(total_spent_calc) as total_sales
from cafe_sales_cleaned csc 
group by sales_by_month 
order by sales_by_month ;

-- 1.2. Monthly sales vs monthly budget 
with monthly_sales as (
select to_char(transaction_date , 'yyyy-mm') as sales_by_month,
sum(total_spent_calc) as total_spent
from cafe_sales_cleaned csc 
group by sales_by_month 
order by sales_by_month)
select sales_by_month ,total_spent ,cb.budget_sum from monthly_sales 
left join cafe_budget cb
on sales_by_month = cb.year_month 
order by sales_by_month ;

-- 1.3. Cafe sales by item 
select csc.item_cleaned ,round(sum(csc.total_spent_calc ), 2) as sales_sum
from cafe_sales_cleaned csc 
group by csc.item_cleaned ;

-- 1.4. Compare average sale sum per item to average sale sum for all items 
select csc.item_cleaned ,
round(avg(csc.total_spent_calc ),2) as avg_by_item,
(select round(AVG(csc.total_spent_calc ), 2) as avg_total_spent 
	from cafe_sales_cleaned csc ),
round(avg(csc.total_spent_calc ) - (select AVG(csc2.total_spent_calc ) 
	as avg_total_spent from cafe_sales_cleaned csc2 ), 2) 
		as difference_from_avg_total
from cafe_sales_cleaned csc 
group by csc.item_cleaned 
order by difference_from_avg_total desc;

-- 1.5. Filter out only items where sales were more than 10 000
select csc.item_cleaned , sum(csc.total_spent_calc ) as sum_by_item
from cafe_sales_cleaned csc 
group by csc.item_cleaned 
having sum(csc.total_spent_calc ) > 10000
order by sum_by_item desc ;

-- 1.6. What were sales by payment method?
select csc.payment_method_cleaned  ,round(sum(csc.total_spent_calc ), 2) as sum_by_payment_method
from cafe_sales_cleaned csc 
group by csc.payment_method_cleaned
-- Kui tahame lisada total rida
union all 
select  'Total', round(sum(csc.total_spent_calc ), 2) as Total
from cafe_sales_cleaned csc 
;

-- 1.7. Compare average sale sum by location to average sale sum
select csc.location_cleaned,
	round(avg(csc.total_spent_calc ),2) as avg_by_location,
	(select round(AVG(csc.total_spent_calc ), 2) as avg_total_spent
		from cafe_sales_cleaned csc ),
	round(avg(csc.total_spent_calc ) - (select AVG(csc2.total_spent_calc ) 
	as avg_total_spent 
	from cafe_sales_cleaned csc2 ), 2) as difference_from_avg_total
from cafe_sales_cleaned csc 
group by csc.location_cleaned ;

-- 1.8. What were sales by location?
select csc.location_cleaned   ,sum(csc.total_spent_calc ) as sum_by_location
from cafe_sales_cleaned csc 
group by csc.location_cleaned  ;

-- 1.9. How many units per item were sold?
select csc.item_cleaned ,sum(csc.quantity  ) as sum_by_quantity
from cafe_sales_cleaned csc 
group by csc.item_cleaned ; 

-- 1.10. Filter out only items where more than 3000 units were sold
select csc.item_cleaned , sum(csc.quantity  ) as sum_by_quantity
from cafe_sales_cleaned csc 
group by csc.item_cleaned 
having sum(csc.quantity  ) > 3000
order by sum_by_quantity desc ;
