USE walmart_db;
SELECT * from walmart;
select count(*) from walmart;
select distinct payment_method from walmart;

select 
	payment_method,count(*)
from walmart
group by payment_method;

select count(distinct Branch) 
from walmart;

select max(quantity)
from walmart;

select min(quantity)
from walmart;

-- Business problems
-- find different payment methods and number of transactions, number of quantity sold
select
	payment_method,
    count(*) as no_payments,
    sum(quantity) as no_qty_sold
from walmart
group by payment_method;

-- Identify the highest-rated category in each branch, displaying the branch,category,avg rating
select *
from
(select
	branch,
    category,
    avg(rating) as avg_rating,
    rank() over(partition by branch order by avg(rating) desc) as `rank`
from walmart
group by 1,2
) as ranked_data
where `rank`=1;

-- identify the busiest day for each branch based on the number of transactions
describe walmart;
SELECT *
FROM
(
	select 
		branch,
		DATE_FORMAT(STR_TO_DATE(date,'%d/%m/%y'),'%W') as formated_date,
		COUNT(*) as no_transactions,
		RANK() OVER(PARTITION BY branch order by count(*) desc) as`rank`
	from walmart
	group by 1,2
) as branch_transactions
where `rank`=1;

-- calculate the total quantity of items sold per payment method.list payment_method and total_quantity.
select
	payment_method,
    sum(quantity) as no_qty_sold
from walmart
group by payment_method;

-- determine the average, minimum, and maximum rating of category for each city
-- list the city, average_rating, min_rating, and max_rating.
SELECT 
	city,
    category,
    min(rating) as min_rating,
    max(rating) as max_rating,
	avg(rating) as avg_rating
FROM walmart
group by 1,2;

-- calculate the total profit for each category by considering total_proft as
-- (unit_price * quantity * profit_margin).
-- list category and total_profit, ordered from highest to lowest profit.
select 
	category,
    sum(total) as total_revenue,
    sum(total * profit_margin) as proft
from walmart
group by 1 ;

-- determine the most common payment method for each branch,
-- display branch and the preferred_payment_method.
with cte
as
(select 
	branch,
    payment_method,
    count(*) as total_trans,
    rank() over(partition by branch order by count(*) desc) as `rank`
from walmart
group by 1,2
)
select * 
from cte
where `rank`=1;

-- categorize sales into 3 group morning, afternoon, evening)
-- find out which of the shift and number of invoices.
select 
	branch,
	case 
		when hour(cast(time as time)) < 12 then 'Morning'
		when hour(cast(time as time)) between  12 and 17 then 'Afternoon'
		else 'Evening'
	End as day_time,
    count(*)
from walmart
group by 1,2
order by 1,3 desc;

-- identify 5 branch with highest decrease ratio in 
-- revenuwe compare to last year(consider, current year 2023 and last year 2022)
-- reenue_decrease_ratio == last_year_revenue-current_year_revenue/last_year_revenue*100
select 
	* ,
	year(STR_TO_DATE(date,'%d/%m/%y')) as formated_date
from walmart;
-- 2022 sales
with revenue_2022
as
(select
	branch,
    sum(total) as revenue
from walmart
where year(STR_TO_DATE(date,'%d/%m/%y')) = 2022
group by 1
),
revenue_2023
as
(select
	branch,
    sum(total) as revenue
from walmart
where year(STR_TO_DATE(date,'%d/%m/%y')) = 2023
group by 1
)
select 
	ls.branch,
    ls.revenue as last_year_revenue,
    cs.revenue as cur_year_revenue,
    round((ls.revenue-cs.revenue)/ls.revenue*100,2) as rev_dec_ratio
from revenue_2022 as ls
join 
revenue_2023 as cs
on ls.branch=cs.branch
where ls.revenue>cs.revenue
order by 4 desc
limit 5;