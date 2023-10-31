use sakila;

-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?

select film.title, count(film.title), inventory.film_id from inventory
	join film on inventory.film_id = film.film_id
	where title = "HUNCHBACK IMPOSSIBLE"
    group by film.title, inventory.film_id;
    
    -- 6 copies of Hunchback Impossible

-- 2. List all films whose length is longer than the average of all the films.

select film.title
from film
group by film.title
having avg(film.length) > (select avg(length) from film);

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT actor.first_name, actor.last_name, actor.actor_id, film_actor.film_id, film.title
FROM actor, film_actor, film
WHERE actor.actor_id = film_actor.actor_id
AND film_actor.film_id = film.film_id
AND film.title = "Alone Trip"
AND film.film_id IN (SELECT film_id FROM film WHERE title = "Alone Trip");

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
	-- Identify all movies categorized as family films.

select film.title, category.name
from film
join film_category on film.film_id = film_category.film_id
join category on film_category.category_id = category.category_id
where category.name = 'FAMILY'
group by film.title, category.name;

	-- Going to paste a subquery alternative (Uri) to 4. below for reference
    SELECT title
	FROM film
	WHERE film_id IN (SELECT film_id FROM film_category 
    WHERE category_id = (SELECT category_id 
    FROM category 
    WHERE name = 'Family'));
    

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. 
	-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, 
    -- that will help you get the relevant information.
    
    -- joins:
    
    select first_name, last_name, email, country.country
	from customer
        join store on customer.store_id = store.store_id
        join address on store.address_id = address.address_id
        join city on address.city_id = city.city_id
        join country on city.country_id = country.country_id
	where country.country = 'CANADA'
    group by first_name, last_name, email, country.country;
    
    -- subqueries:
    
    select first_name, last_name, email
    from customer
		where store_id in (select store_id from store
        where address_id in (select address_id from address
        where city_id in (select city_id from city
        where country_id in (select country_id from country
        where country = 'CANADA'))));

-- 6. Which are films starred by the most prolific actor? 
	-- Most prolific actor is defined as the actor that has acted in the most number of films. 
    -- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
	
   SELECT actor_id
FROM (
    SELECT actor_id, COUNT(actor_id) AS actor_count
    FROM film_actor
    GROUP BY actor_id
    ORDER BY actor_count DESC
    LIMIT 1
) AS subquery;

	-- most prolific actor_id = 107
    
    select title from film
    join film_actor on film.film_id = film_actor.film_id
    where film_actor.actor_id = '107';
    
-- 7. Films rented by most profitable customer. 
	-- You can use the customer table and payment table to find the most profitable customer 
    -- ie the customer that has made the largest sum of payments
    
    select customer_id, sum(amount) as total_amount from payment
    group by customer_id
    order by total_amount DESC
    limit 1;
    
    -- Highest spending customer id = 526
    
    select title from film
    join inventory on film.film_id = inventory.film_id
    join rental on inventory.inventory_id = rental.inventory_id
    where rental.customer_id = '526'
    group by title;
    
    
-- 8. Get the client_id and the total_amount_spent of those clients
	-- who spent more than the average of the total_amount spent by each client.

	-- Step 1 find average spend per client
    -- Step 2 find clients who spend above this
    -- Step 3 find client id and total amount spent of those clients
    
    
SELECT customer_id, SUM(amount) as total_amount
FROM payment
GROUP BY customer_id
HAVING total_amount > (SELECT AVG(total_amount) FROM (
    SELECT SUM(amount) as total_amount
    FROM payment
    GROUP BY customer_id
) subquery);




