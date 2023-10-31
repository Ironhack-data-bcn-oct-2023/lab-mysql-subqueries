-- SUBQUERIES LAB
-- 1. How many copies of the film _Hunchback Impossible_ exist in the inventory system?
-- JOIN
use sakila;
select count(inventory.film_id), inventory_id
from inventory
join film
on inventory.film_id = film.film_id
where film.title = "Hunchback Impossible"
group by inventory.film_id, inventory_id;

-- SUBQUERY
select subquery.film_count, subquery.inventory_id
from (
    select count(inventory.film_id) as film_count, inventory_id
    from inventory
    join film on inventory.film_id = film.film_id
    where film.title = "Hunchback Impossible"
    group by inventory.film_id, inventory_id
) as subquery;
 
 -- 2. List all films whose length is longer than the average of all the films.
 select avg_length.avg_uni, avg_length.length, avg_length.title
 from 
 (select
 AVG(film.length) as avg_uni, film.length, film.title
 from film group by film.title, film.length) as avg_length
 where avg_length.length > avg_uni;
 
 -- 3. Use subqueries to display all actors who appear in the film _Alone Trip_.
 select concat(first_name, " ", last_name) "full name"
 from actor
 where actor_id in (select actor_id from film_actor join film on film_actor.film_id = film.film_id
 where film.title = "Alone Trip");
 
 -- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select title from 
film where film.film_id in (select film_id from film_category where category_id in(select category_id from category where name ="family"));

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
select concat(first_name, " ", last_name) as "full name", email
from customer where address_id in 
(select address_id from address where city_id in 
(select city_id from city where country_id in
(select country_id from country 
where country = "canada")));

select concat(first_name, " ", last_name) as "full name", email
from customer
join address
on customer.address_id = address.address_id
join city
on address.city_id = city.city_id
join country
on city.country_id = country.country_id
where country = "canada";

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
select title
from film where film_id in
(select film_id from film_actor where actor_id =
(select actor_id from film_actor
group by actor_id
order by count(*) desc
limit 1
)
)
limit 10;

-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
select title
from film
where film.film_id in (select film_id
from inventory
where inventory_id in (select inventory_id
from rental
where rental_id in (select rental_id
from payment
where customer_id = (select customer_id
from payment
group by customer_id
order by sum(amount) desc
limit 1
))));

-- 8. Get the `client_id` and the `total_amount_spent` of those clients who spent more than the average of the `total_amount` spent by each client.
select customer_id, sum(amount) as total_amount_spent
from payment
group by customer_id
having total_amount_spent > ( SELECT AVG(amount)
payment);
