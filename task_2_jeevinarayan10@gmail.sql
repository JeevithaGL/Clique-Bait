--Q1.How many users are there
 select count(DISTINCT user_id) from users

--Q2.How many cookies does each user have on average?


select avg(cookie_count) as average
from(
SELECT user_id,count(DISTINCT cookie_id) AS cookie_count
FROM users 
GROUP BY user_id
)as  UserCookies

 
select * from users
--Q3 What is the unique number of visits by all users per month? 

select user_id,count(distinct visit_id)as counts,month(start_date_of_user)as month
from Final_Raw_Data
group by month(start_date_of_user), user_id 
order by month,user_id

--Q4. What is the number of events for each event type? 

select event_type,count(event_name) as num_of_events
from Final_Raw_Data
group by event_type

--Q5. What is the percentage of visits which have a purchase event?
SELECT 
    (COUNT(CASE WHEN purchase = 1 THEN 1 END) * 100.0 / COUNT(*)) AS percentage_visits_with_purchase
FROM visit_summary

--Q6. What is the percentage of visits which view the checkout page but do not have a purchase event? 
SELECT 
    (COUNT(CASE WHEN page_views > 0 AND purchase = 0 THEN 1 END) * 100.0 / COUNT(*)) AS percentage_visits_with_checkout_no_purchase
FROM visit_summary;

--Q7. What are the top 3 pages by number of views?
SELECT top 3 page_id, COUNT(*) AS views
FROM events
WHERE event_type =1
GROUP BY page_id
ORDER BY views DESC

--Q8. What is the number of views and cart adds for each product category?
SELECT p.product_category,
       SUM(CASE WHEN e.event_type = 'view' THEN 1 ELSE 0 END) AS views,
       SUM(CASE WHEN e.event_type = 'add_to_cart' THEN 1 ELSE 0 END) AS cart_adds
FROM events e
JOIN products p ON e.product_id = p.product_id
GROUP BY p.product_category;

--Q9. What are the top 3 products by purchases?
SELECT top 3 product_id, COUNT(*) AS purchases
FROM Final_Raw_Data
WHERE event_type = 3
GROUP BY product_id
ORDER BY purchases DESC

--Q10.Using prodct_level_summary and product_category_level_summary tables, 
--Find which product had the most views, cart adds and purchases?
--Q11.  Using prodct_level_summary and product_category_level_summary tables, 
--Find Which product was most likely to be abandoned?
--Q12.  Using prodct_level_summary and product_category_level_summary tables,
--Find which product had the highest view to purchase percentage?
select * from visit_summary

--Q10.Using prodct_level_summary and product_category_level_summary tables, 
--Find which product had the most views, cart adds and purchases?
SELECT 
    p.product_id,
    MAX(p.views) AS max_views,
    MAX(p.add_to_cart) AS max_cart_adds,
    MAX(p.purchased) AS max_purchases
FROM product_level_summary p
GROUP BY p.product_id

select * from  prodct_level_summary 
select * from  product_category_level_summary

--Q11.  Using prodct_level_summary and product_category_level_summary tables, 
--Find Which product was most likely to be abandoned?

select product_id,
       max(abandoned_cart) as abandoned
from product_level_summary
group by
product_id
order by
abandoned desc

select product_category, 
       max(abandoned_cart) as abandoned 
       from product_category_level_summary
	   group by
       product_category
	   order by
	   abandoned desc

--Q12.  Using prodct_level_summary and product_category_level_summary tables,
--Find which product had the highest view to purchase percentage?

SELECT top 1 
    pls.product_id,
    pc.product_category,
    MAX((pc.views * 100.0) / pls.views) AS view_to_purchase_percentage
FROM 
    product_level_summary pls
JOIN 
    product_category_level_summary pc ON pls.purchased= pc.purchased
GROUP BY 
    pls.product_id, pc.product_category
ORDER BY 
    view_to_purchase_percentage DESC


--Q13.  Using prodct_level_summary and product_category_level_summary tables,
--Find what is the average conversion rate from view to cart add? (5 marks each for excel & sql)


   SELECT 
    AVG(view_to_cart_add) AS average_conversion_rate
FROM (
    SELECT 
        pls.product_id,
        (SUM(pc.add_to_cart) * 100.0 / SUM(pls.views)) AS view_to_cart_add
    FROM 
        product_level_summary pls
    JOIN 
        product_category_level_summary pc ON pls.purchased = pc.purchased
    GROUP BY 
        pls.product_id
) AS conversion_rates;

--Q14.  Using prodct_level_summary and product_category_level_summary tables,
--Find What is the average conversion rate from cart add to purchase? (5 marks each for excel & sql)

SELECT 
   product_category,
   AVG(cart_add_to_purchase_percentage) AS average_conversion_rate
FROM (
    SELECT 
       pc.product_category,
        (pc.add_to_cart * 100.0 / NULLIF(pc.add_to_cart, 0)) AS cart_add_to_purchase_percentage
    FROM 
        product_category_level_summary pc
    WHERE 
        pc.add_to_cart > 0 -- Exclude cases where there are no cart adds
) AS conversion_rates
group by
product_category;

--Q15.  Using visit_summary table, Identifying users who have received impressions 
--during each campaign period and comparing each metric with other users who did not have an impression event

SELECT *
FROM 
    visit_summary
WHERE 
    impression = 1
	and
	campaign_name is not null

	--Q16.  Using visit_summary table, can we conclude that clicking on an impression lead to higher purchase rates?
	
SELECT sum(purchase)
FROM 
    visit_summary
WHERE 
    impression = 1
	and
	click = 1

SELECT sum(purchase)
FROM 
    visit_summary
WHERE 
    impression = 1
	and
	click = 0
	
	--Q17.  Using visit_summary table,
	--What is the uplift in purchase rate when comparing users who click on a campaign impression 
	--versus users who do not receive an impression? What if we compare them with users who just an impression but do not click? 

	
	
	--Q18.Using visit_summary table, What metrics can you use to quantify the success or failure 
	-- of each campaign compared to each other?
	
