use sakila;

-- 1. How many copies of the film _Hunchback Impossible_ exist in the inventory system?

select COUNT(inventory_id) AS copies
	from inventory
    join film
		on inventory.film_id = film.film_id
	where title = "Hunchback Impossible";



-- 2. List all films whose length is longer than the average of all the films.

SELECT TITLE AS longer_than_average_films, length
	from film where length > (SELECT AVG(LENGTH) AS AVERAGE_LENGTH
	FROM FILM)
    order by length desc;


-- 3. Use subqueries to display all actors who appear in the film _Alone Trip_.

SELECT concat (first_name, " ", last_name) actors, title
	from actor
    join film_actor
		on actor.actor_id = film_actor.actor_id
	join film
		on film_actor.film_id = film.film_id
	where title = "Alone Trip";
    


-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

select title AS TITLE, name as CATEGORY
from film
join film_category
	on film.film_id = film_category.film_id
join category
	on film_category.category_id = category.category_id
where name = "family";


-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

SELECT CONCAT(FIRST_NAME, " ", LAST_NAME) AS NAME, EMAIL
	FROM CUSTOMER
    JOIN ADDRESS 
		ON customer.address_id = address.address_id
	JOIN CITY
		ON address.city_id = city.city_id
	JOIN COUNTRY
		ON city.country_id = country.country_id
	WHERE country = "CANADA" ;


-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films.
--  First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

SELECT concat(first_name, " ", last_name) as ACTOR, count(film_actor.actor_id) AS MOVIES_MADE, film_actor.actor_id 
	from actor
    join film_actor
		on actor.actor_id = film_actor.actor_id
	join film
		on film_actor.film_id = film.film_id
	group by film_actor.actor_id
    order by MOVIES_MADE desc
    limit 1;
   

SELECT title
FROM film
WHERE film_id IN (SELECT film_id
					FROM film_actor
					WHERE actor_id IN (SELECT actor_id
										FROM (SELECT actor_id, COUNT(film_id) AS count
												FROM film_actor
                                                GROUP BY actor_id
                                                ORDER BY count DESC
                                                LIMIT 1) AS actor_id));






-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments


SELECT film.title
FROM film
INNER JOIN inventory ON film.film_id = inventory.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE rental.customer_id = (
    SELECT customer_id
    FROM payment
    GROUP BY customer_id
    ORDER BY SUM(amount) DESC
    LIMIT 1);





-- 8. Get the `client_id` and the `total_amount_spent` of those clients who spent more than the average of the `total_amount` spent by each client.

SELECT customer_id, SUM(amount) AS total_spent
FROM payment
GROUP BY customer_id
HAVING total_spent > (SELECT AVG(amount) FROM payment);


