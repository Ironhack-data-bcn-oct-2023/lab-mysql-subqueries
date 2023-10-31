use sakila;

-- 1. How many copies of the film _Hunchback Impossible_ exist in the inventory system?
select count(inventory_id) from inventory
where film_id in (select film_id from film where title = "Hunchback Impossible");
-- 6 copies 

-- 2. List all films whose length is longer than the average of all the films.
select title, length from film
	where length > (select avg(length) from film);

-- 3. Use subqueries to display all actors who appear in the film _Alone Trip_.
select film_actor.actor_id, actor.first_name, actor.last_name from film_actor
join actor
	on film_actor.actor_id = actor.actor_id
where film_id in (select film_id from film where title = "Alone Trip");

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select title, category.name from film
	join film_category
		on film.film_id = film_category.film_id
			join category
				on film_category.category_id = category.category_id
where category.name = "Family";

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, 
-- you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

-- using JOINS (uff long one!)
select CONCAT(first_name," " ,last_name) AS full_name, customer.email from customer
	join address
		on customer.address_id = address.address_id
			join city
				on address.city_id = city.city_id
					join country
						on city.country_id = country.country_id
where country.country = 'Canada';

-- using subqueries

-- this was not working. I didn't understand why, see the next one
-- select CONCAT(first_name," " ,last_name) AS full_name, customer.email from customer
-- where address_id in (select address_id from address 
-- join city
-- on address.city_id = city.city_id
-- join country
-- on city.country_id = country.country_id
-- where country.country = 'Canada') as country_is_canada;

select CONCAT(first_name," " ,last_name) AS full_name, customer.email from customer
	join (select address_id from address 
			join city
				on address.city_id = city.city_id
					join country
						on city.country_id = country.country_id
where country.country = 'Canada') as country_is_canada on customer.address_id = country_is_canada.address_id;

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

-- getting the frequency list
select actor_id, count(actor_id) as counting from film_actor
	group by actor_id
	order by count(actor_id) DESC;

-- then the top 1
select actor_id, counting from
	(select actor_id, count(actor_id) as counting from film_actor
	group by actor_id
	order by count(actor_id) DESC) as count_prolific limit 1;

-- selecting the movie codes that top1 took part in:
select film_id from film_actor
	where actor_id in (select actor_id from 
	(select actor_id, count(actor_id) as counting from film_actor
	group by actor_id
	order by count(actor_id) DESC limit 1) as top1_actor);
    
-- now converting these film_ids into film titles
select title, film_id from film
	where film_id in (
		select film_id from film_actor
		where actor_id in (select actor_id from 
		(select actor_id, count(actor_id) as counting from film_actor
		group by actor_id
		order by count(actor_id) DESC limit 1) as top1_actor));

-- 7. Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

-- first let's get that customer:
select customer_id, sum(amount) from payment
	group by customer_id
    order by sum(amount) DESC;

-- just the top1
select customer_id, sum(amount) from payment
	group by customer_id
    order by sum(amount) DESC
    limit 1;
    
-- who was that person?
select customer_id, first_name, last_name from customer
	where customer_id in (select customer_id from
	(select customer_id, sum(amount) as total_amount from payment
	group by customer_id
    order by sum(amount) DESC
    limit 1) as top1_customer);

-- what titles did he rent?
SELECT film.title FROM film 
	JOIN inventory ON film.film_id = inventory.film_id
	JOIN rental ON inventory.inventory_id = rental.inventory_id
	JOIN customer ON rental.customer_id = customer.customer_id
WHERE customer.customer_id = (SELECT customer_id FROM 
	(SELECT customer_id, SUM(amount) as total_amount FROM payment
	GROUP BY customer_id
	ORDER BY total_amount DESC
	LIMIT 1) AS best_customer);


-- 8. Get the `client_id` and the `total_amount_spent` of those clients who spent more than the average of the `total_amount` spent by each client.
-- what was the total amount spent by each client?
select customer_id, sum(amount) as total_amount_spent from payment
	group by customer_id;
    
-- the average of that
select avg(total_amount_spent) from
	(select customer_id, sum(amount) as total_amount_spent from payment
	group by customer_id) as client_summary;

-- total amount spent per client having that sum being bigger thant the avg I've just calculated above:
select customer.customer_id, sum(amount) as total_amount_spent from customer
	join payment on customer.customer_id = payment.customer_id
	group by customer.customer_id
having sum(amount) >
	(select avg(total_amount_spent) from
	(select customer_id, sum(amount) as total_amount_spent from payment
	group by customer_id) as client_summary); 