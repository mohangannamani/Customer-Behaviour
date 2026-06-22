
--Q1 What is total revenue genrated by male vss  female customer..?
select
gender,
sum(purachase_amount_usd) as revenue
from customer_data
group by gender


-- Q2 which customer used a disount but still spent more then avg amount..??
select
customer_id,
purachase_amount_usd
from customer_data
where discount_applied='yes'
and purachase_amount_usd >=(select
avg(purachase_amount_usd) from customer_data)

--Q3 Which are the top 5 products with the highest average review rating..??
select * from(select
item_purchased,
avg(review_rating) as avg_rating,
dense_rank()over(order by avg(review_rating) desc) as rnk
from customer_data
group by item_purchased
)t
where rnk<=5

--Q4 compare the average purachase amount between standard and express shiping..??



SELECT
    shipping_type,
    AVG(purachase_amount_usd) AS avgcompare
FROM customer_data
WHERE shipping_type IN ('standard', 'express')
GROUP BY shipping_type;

--Q5 DO subscrbied customers spend more amount? compare average spent and total revenue between subscribers and non subscribers.?

select 
subscription_status,
count(customer_id) as total_customer,
round(avg(purachase_amount_usd),2) as avg_spent,
round(sum(purachase_amount_usd),2) as total_revenue
from customer_data
group by subscription_status
order by total_revenue,avg_spent desc;

-- Q6 which five products have the highest percentage of purchase with discount applied..??
select top 5
item_purchased,
round(100*sum(case when discount_applied='yes'THEN 1 ELSE 0 END)/count(*),2) as discount_rate
from customer_data
group by item_purchased
order by discount_rate desc

-- Q7 segment customers into new,returning,and loyal based on their total numbers of previous purchases ,and show the count of each segment
with customer_type as(
select 
customer_id,
previous_purchases,
case
when previous_purchases=1 then 'new'
when previous_purchases between 2 and 10 then 'returning'
else 'loyal'
end as customer_segment
from customer_data)
select customer_segment,count(*) as 'number of customers'
from customer_type
group by customer_segment
--Q8 what are the top 3 most purchased products within each category..?

with item_count as (select
category,
item_purchased,
count(customer_id)as total_orders,
row_number()over(partition by category order by count(customer_id) desc) as item_ranking
from customer_data
group by category,item_purchased)

select 
item_ranking,
category,
item_purchased,
total_orders
from item_count
where item_ranking<=3

--Q9 Are customers who are repeat buyers(more than 5 previous purchase) also likely to subscribe.?
select subscription_status,
count(customer_id) as repeat_buyers
from customer_data
where previous_purchases > 5
group by subscription_status

--Q10 What is the revenue contribution of each age group
select
age_group,
sum(purachase_amount_usd) as total_revenue
from customer_data
group by age_group
order by total_revenue desc

