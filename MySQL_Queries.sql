select * from walmart;

-- Business Problems:
/*
1- Find different payment method and number of transactions, number of quantity sold 
*/
select
	payment_method,
    count(*) as no_of_transactions,
    sum(quantity) as no_of_quantity_sold
from walmart
group by payment_method
;

/*
2- Identify the highest-rated category in each branch, displaying the branch, category, and average rating
*/
select *
from
(
	select
		branch,
		category,
		avg(rating) as avg_rating,
		rank() over(partition by branch order by avg(rating) desc) as highest_rank
	 from walmart
	 group by branch, category
) as ranked_data
where highest_rank = 1
;

/*
3- Identify the busiest day for each branch based on the number of transactions
*/
-- Add temporary DATE column
alter table walmart add column temp_date date;

-- Update with converted values
update walmart
set temp_date = str_to_date(`date`, '%d/%m/%y');

-- Verify conversion worked
select *
from walmart
where temp_date is null;

-- Drop old column and rename new one
ALTER TABLE walmart DROP COLUMN `date`;
ALTER TABLE walmart CHANGE COLUMN temp_date transaction_date DATE;

select 
	branch,
    day_name,
    transaction_count
from(
select
    branch,
    -- Extract full name of the day of the week
    dayname(transaction_date) as day_name,
    count(*) as transaction_count,
    -- row_number will choose exactly one day instead of rank maybe multiple days if have same transaction_count
    row_number() over(partition by branch order by count(*) desc) as rn
from walmart
group by branch, day_name
) as ranked_days
where rn = 1
order by branch;

/*
4- Calculate the total quantity of items sold per payment method. list payment_method and total_quantity.
*/
select
	payment_method,
    sum(quantity) as no_of_quantity_sold
from walmart
group by payment_method
;

/*
5- Determine the average, minimum, and maximum rating of category for each city.
List the city, average_rating, min_rating, and max_rating
*/

select
	city,
    category,
    min(rating) as min_rating,
    max(rating) as max_rating,
    avg(rating) as avg_rating
from walmart
group by city, category
order by city
;

/*
6- Calculate total profit for each category by considering total_profit as
(unit_price * quantity * profit_margin).
List category and total_profit, ordered from highest to lowest profit.
*/
select
	category,
    sum(total_revenue),
    sum(total_revenue * profit_margin) as total_profit
from walmart
group by category
order by total_profit desc
;

/*
7- Determine the most common payment method for each branch. Display branch and preferred payment method.
*/
with BranchPaymentCounts
as(
select 
	branch,
    payment_method,
    count(*) as payment_count,
    rank() over(partition by branch order by count(*) desc) as common_payment_rank
from walmart
group by branch, payment_method
order by branch
)
select * 
from BranchPaymentCounts
where common_payment_rank =1;

/*
8- Categorize sales into 3 group morning, afternoon, evening.
Find out which of the shift and number of invoices
*/

alter table walmart
add column time_formatted time;
update walmart
set time_formatted = str_to_date(`time`, '%H:%i:%s');

select
    case
		when hour(time_formatted) < 12 then 'Morning'
        when hour(time_formatted) between 12 and 17 then 'Afternoon'
        else 'Evening'
	end as shift,
    count(*) as no_invoices
from walmart
group by shift
order by no_invoices desc
;

/*
9- Identify 5 branches with highest decrease ratio in revenue
compare to last year (current year 2023 and last year 2022)
rdr = (last_rev - curr_rev)/last_rev*100
*/

with revenue_22
AS(
select 
	branch,
    SUM(total_revenue) as revenue
from walmart
where year(transaction_date) = 2022
group by branch
),
revenue_23
AS(
select 
	branch,
    SUM(total_revenue) as revenue
from walmart
where year(transaction_date) = 2023
group by branch
) 
select 
	ls.branch,
    ls.revenue as last_year_revenue,
    cs.revenue as current_year_revenue,
    round((ls.revenue - cs.revenue) / ls.revenue * 100,2) as revenue_dec_ratio
from revenue_22 as ls
join revenue_23 as cs
on ls.branch = cs.branch
where ls.revenue > cs.revenue
order by revenue_dec_ratio desc
limit 5
;
/*
Customer & Sales Behavior Analysis
*/
/*
10- Customer Segmentation by Spending: Categorize customers into 'High', 'Medium', and 'Low' 
spenders based on their total purchase amount, and show the count of customers in each segment.
*/

with spending_percentile AS(
select 
invoice_id,
branch,
category,
city,
total_revenue,
NTILE(3) OVER (ORDER BY total_revenue DESC) as spending_tier
from walmart
order by total_revenue desc
)
select
	branch,
    category,
    city,
    total_revenue,
    case
		when spending_tier = 1 then 'High'
        when spending_tier = 2 then 'Medium'
        when spending_tier = 3 then 'Low'
    end as customer_segment
from spending_percentile
order by total_revenue desc
;

/*
11- Seasonal Sales Patterns: Analyze monthly sales trends to identify peak and low sales months.
*/

-- First analyze monthly sales
-- It appears january, december and november are peak months
with monthly_sales AS(
select 
	year(transaction_date) as year_number,
	month(transaction_date) as month_number,
    monthname(transaction_date) as month_name,
	sum(total_revenue) as monthly_revenue,
    count(*) as total_transactions
from walmart
group by year(transaction_date),month(transaction_date), monthname(transaction_date)
)
select 
	year_number,
    month_name,
    monthly_revenue,
    total_transactions
from monthly_sales
order by monthly_revenue desc
limit 10
;

/*
12- Category Performance by City: Determine which product categories perform best in each city and
calculate the revenue contribution percentage.
*/

with ranking_categories as(
select 
	city,
	category,
    sum(total_revenue) as category_total_revenue,
    -- Total City revenue using a window function
    sum(sum(total_revenue)) over (partition by city) as city_total_revenue,
    row_number() over(partition by city order by sum(total_revenue) desc) as revenue_rank
from walmart
group by city, category
)
select 
	city,
    category,
    category_total_revenue,
    revenue_rank,
    -- Calculate revenue contribution percentage
    (category_total_revenue/ city_total_revenue) * 100 as revenue_contribution_percent
from ranking_categories
where revenue_rank <= 3  -- Top 3 categories
order by city, revenue_rank
;

/*
13- Rating vs Sales Correlation: Analyze the relationship between product ratings and sales volume,
do higher-rated items sell more?
*/
-- No clear correlation
-- select * from walmart;
select 
rating,
count(distinct invoice_id) as no_of_transactions, -- how many transactions has this rating
sum(quantity) as total_quantity_sold,
sum(total_revenue) as total_revenue_generated
from walmart
group by rating
order by rating
;





