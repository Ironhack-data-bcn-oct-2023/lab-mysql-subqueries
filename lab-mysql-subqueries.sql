USE sakila;
-- 1. How many copies of the film _Hunchback Impossible_ exist in the inventory system?
SELECT title, count(inventory.film_id)
	FROM film
		JOIN inventory
			ON film.film_id = inventory.film_id
		WHERE title = 'Hunchback Impossible';
	
-- 2. List all films whose length is longer than the average of all the films.
SELECT title, length
FROM film
WHERE length > ( SELECT AVG(length) AS media FROM film);

-- 3. Use subqueries to display all actors who appear in the film _Alone Trip_.
SELECT CONCAT(first_name," " ,last_name)
	FROM actor 
		WHERE actor_id IN ( SELECT actor_id FROM film_actor JOIN film ON film.film_id = film_actor.film_id WHERE title = 'Alone Trip');

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT title
	FROM film 
		WHERE film_id IN ( SELECT film_id FROM film_category JOIN category ON film_category.category_id = category.category_id WHERE name = 'family');
	
-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
	SELECT email, first_name
		FROM customer
			JOIN address
				ON address.address_id = customer.address_id
			JOIN city
				ON city.city_id = address.city_id
			JOIN country
				ON country.country_id = city.country_id
		WHERE country ='Canada';

	SELECT email, first_name
		FROM customer 
			WHERE customer_id IN 
				(SELECT customer_id FROM address JOIN city ON city.city_id = address.city_id
						JOIN country ON country.country_id = city.country_id WHERE country ='Canada');


-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
 -- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

SELECT title FROM film 
	JOIN film_actor 
		ON film.film_id = film_actor.film_id
	WHERE actor_id =
(SELECT actor.actor_id
	FROM actor 
		JOIN film_actor
			ON actor.actor_id = film_actor.actor_id
        GROUP BY actor.actor_id 
        order by count(film_id) desc LIMIT 1);


-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable 
-- customer ie the customer that has made the largest sum of payments
SELECT title FROM film
	JOIN inventory
		ON inventory.film_id = film.film_id
	JOIN rental
		ON rental.inventory_id = inventory.inventory_id
        WHERE customer_id =
(SELECT customer.customer_id
	FROM customer 
		JOIN payment
			ON payment.customer_id = customer.customer_id
        GROUP BY customer.customer_id
        order by count(amount) desc LIMIT 1);

-- 8. Get the `client_id` and the `total_amount_spent` of those clients who spent more than the average
   --  of the `total_amount` spent by each client.
SELECT customer_id, SUM(amount) AS total_amount_spent
	FROM payment
GROUP BY customer_id
	HAVING total_amount_spent > (SELECT AVG(amount) FROM payment)
	ORDER BY total_amount_spent;

