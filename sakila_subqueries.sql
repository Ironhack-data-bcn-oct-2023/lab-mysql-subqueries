USE sakila;

-- 1. How many copies of the film _Hunchback Impossible_ exist in the inventory system?
SELECT title, COUNT(inventory.film_id)
	FROM film
		JOIN inventory 
			ON film.film_id = inventory.film_id
        WHERE title = "Hunchback Impossible";
        --  Answer: There are 6 Hunchback Impossible movies in the inventory

-- 2. List all films whose length is longer than the average of all the films.

SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film);
		
-- 3. Use subqueries to display all actors who appear in the film _Alone Trip_.

SELECT first_name, last_name, title
	FROM actor
	JOIN film_actor ON actor.actor_id = film_actor.actor_id
	JOIN film ON film_actor.film_id = film.film_id
	WHERE title  = "Alone Trip";
    
## Another way to do it including subqueries:
 SELECT CONCAT(first_name," " ,last_name )
	FROM actor
		WHERE actor_id IN ( SELECT actor_id FROM film_actor JOIN film ON film.film_id = film_actor.film_id WHERE title = 'Alone Trip');

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

 SELECT title
	FROM film
		WHERE film_id IN (SELECT film_id 
        FROM film_category
        JOIN category ON category.category_id = film_category.category_id
        WHERE name = 'Family');

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

SELECT first_name, email
	FROM customer
		JOIN address
			ON address.address_id = customer.address_id
		JOIN city 
			ON city.city_id = address.city_id
		JOIN country
			ON country.country_id = city.country_id
    WHERE country.country = "Canada";
    
SELECT first_name, email 
	FROM customer 
    WHERE address_id IN
		(SELECT address_id FROM address WHERE city_id IN (SELECT city_id FROM city WHERE country_id = (SELECT country_id FROM country WHERE country = "Canada")));

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

SELECT title
	FROM film
			WHERE film_id IN (SELECT film_id FROM film_actor 
				WHERE actor_id = (SELECT actor_id FROM (SELECT actor_id, COUNT(*) AS film_count FROM film_actor GROUP BY actor_id ORDER BY film_count DESC LIMIT 1) 
	AS prolific_actor));

-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

SELECT customer_id, first_name, last_name, (SELECT SUM(amount) FROM payment WHERE customer.customer_id = payment.customer_id) AS total_payments
FROM customer 
WHERE customer_id = (
    SELECT customer_id
    FROM payment
    GROUP BY customer_id
    ORDER BY SUM(amount) DESC
    LIMIT 1);
	#Answer: KARL SEAL 
    
    SELECT film.title
FROM film
INNER JOIN inventory ON film.film_id = inventory.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE rental.customer_id = (
    SELECT customer_id
    FROM payment
    GROUP BY customer_id
    ORDER BY SUM(amount) DESC
    LIMIT 1
);

-- 8. Get the `client_id` and the `total_amount_spent` of those clients who spent more than the average of the `total_amount` spent by each client.
SELECT customer_id AS client_id, total_amount_spent
	FROM (SELECT customer_id, SUM(amount) AS total_amount_spent
		FROM payment
		GROUP BY customer_id) AS payments
	WHERE total_amount_spent > (SELECT AVG(total_amount_spent)
		FROM (SELECT customer_id, SUM(amount) AS total_amount_spent
			FROM payment
		GROUP BY customer_id) 
			AS avg_amount_spent);



