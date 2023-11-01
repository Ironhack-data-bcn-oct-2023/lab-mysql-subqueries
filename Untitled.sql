USE sakila;

-- How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT count(film.title = 'Hunchback Impossible')
from inventory
JOIN film 
	ON inventory.film_id = film.film_id    
;

-- List all films whose length is longer than the average of all the films.
select * from film
	where film.length > (select avg(length) from film)
;

-- Use subqueries to display all actors who appear in the film Alone Trip.
select first_name, last_name from actor 
where actor_id in (select actor_id from film_actor 
where film_id = (SELECT film_id from film 
Where title = 'Alone Trip'));

-- Sales have been lagging among young families, and you wish to target all family movies 
-- for a promotion. Identify all movies categorized as family films.
select title from category
JOIN film_category ON category.category_id = film_category.category_id
JOIN film ON film_category.film_id = film.film_id
WHERE name = 'Family'
;

-- Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary 
-- keys and foreign keys, that will help you get the relevant information.

select first_name, last_name from customer where address_id in (select address_id from address
where city_id in (select city_id from city
where country_id = (select country_id from country
where country = 'Canada')));

select first_name, last_name from customer
	JOIN address ON customer.address_id = address.address_id
	JOIN city ON address.city_id = city.city_id
	JOIN country ON city.country_id = country.country_id
where country = 'Canada';

-- Which are films starred by the most prolific actor? Most prolific actor is defined as 
-- the actor that has acted in the most number of films. First you will have to find the 
-- most prolific actor and then use that actor_id to find the different films that he/she 
-- starred.
select title from film 
where film_id in (select film_id from film_actor
where actor_id = (select actor_id
from (select actor_id, count(film_id) as counter
from film_actor
group by actor_id
order by counter desc limit 1) as subquery_actor));

-- Films rented by most profitable customer. You can use the customer table and payment 
-- table to find the most profitable customer ie the customer that has made the largest 
-- sum of payments

select first_name, last_name from customer
where customer_id = (select customer_id from (select customer_id, sum(amount) as total
from payment
group by customer_id
order by total desc
limit 1) as subquery_payment)
;

-- Get the client_id and the total_amount_spent of those clients who spent more than 
-- the average of the total_amount spent by each client.
select customer_id from (select customer_id, sum(amount) as total_amount_spent
from payment
group by customer_id) as sub_2
where total_amount_spent > (select avg(total_amount_spent) 
from (select customer_id, sum(amount) as total_amount_spent
from payment
group by customer_id) as sub);

