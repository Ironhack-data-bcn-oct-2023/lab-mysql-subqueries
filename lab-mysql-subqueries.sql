USE sakila;
-- How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(title) FROM film
	JOIN inventory
		ON film.film_id = inventory.film_id
	WHERE title = "Hunchback Impossible"; -- 6 copies in the inventory

-- List all films whose length is longer than the average of all the films.
SELECT title FROM film
	WHERE length > (SELECT AVG(length) FROM film);

-- Use subqueries to display all actors who appear in the film Alone Trip.
SELECT CONCAT(first_name, " ", last_name) AS actor_name
FROM actor
WHERE actor.actor_id IN
	(SELECT film_actor.actor_id FROM film_actor
    WHERE film_actor.film_id IN
		(SELECT film_id FROM film WHERE title = "Alone Tripe")
	);

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion.
-- Identify all movies categorized as family films.
SELECT title FROM film
WHERE film.film_id IN
	(SELECT film_category.film_id FROM film_category
    WHERE film_category.category_id IN
		(SELECT category.category_id FROM category
        WHERE category.name = "Family")
	);

-- Get name and email from customers from Canada using subqueries. Do the same with joins.
SELECT CONCAT(first_name, " ", last_name) AS customer_name, email
FROM customer
WHERE customer.address_id IN
	(SELECT address_id FROM address
	WHERE address.city_id IN
		(SELECT city_id FROM city
        WHERE city.country_id IN
			(SELECT country_id FROM country
            WHERE country.country = "Canada")
		)
	);

SELECT CONCAT(first_name, " ", last_name) AS customer_name, email FROM customer
	JOIN address
		ON customer.address_id = address.address_id
	JOIN city
		ON address.city_id = city.city_id
	JOIN country
		ON city.country_id = country.country_id
	WHERE country.country = "Canada";

-- Which are films starred by the most prolific actor?
SELECT title FROM film
WHERE film.film_id IN
	(SELECT film_id FROM film_actor
    WHERE actor_id IN 
		(SELECT actor_id FROM
			(SELECT actor_id, COUNT(film_id) as freq FROM film_actor
            GROUP BY actor_id
            ORDER BY freq DESC LIMIT 1) AS max_actor
		)
	);

-- Films rented by most profitable customer.
SELECT title FROM film
WHERE film.film_id IN
	(SELECT film_id FROM inventory
    WHERE inventory.store_id IN
		(SELECT store_id FROM store
        WHERE store.store_id IN
			(SELECT store_id FROM customer
            WHERE customer.customer_id IN
				(SELECT customer_id FROM
					(SELECT customer_id, SUM(amount) as qty FROM payment
					GROUP BY customer_id
					ORDER BY qty DESC LIMIT 1) AS max_custo
				)
			)
		)
	);

-- Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
SELECT customer_id, SUM(amount) as total_amount FROM payment
GROUP BY customer_id
HAVING total_amount >
	(SELECT AVG(qty_client) FROM
		(SELECT SUM(amount) as qty_client FROM payment
         GROUP BY customer_id
         ) as pay_client
	);