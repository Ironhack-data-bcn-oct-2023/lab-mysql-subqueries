USE sakila;

-- How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(film_id) FROM inventory 
WHERE film_id IN (SELECT film_id FROM film
WHERE title = "Hunchback Impossible");

-- List all films whose length is longer than the average of all the films.
SELECT title, length FROM film
WHERE length > (SELECT AVG(length) FROM film);

-- Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name  FROM actor
WHERE actor_id IN( SELECT actor_id FROM film_actor
WHERE film_id IN (SELECT film_id FROM film 
WHERE title = "Alone Trip"));

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT title FROM film
WHERE film_id IN( SELECT film_id FROM film_category
WHERE category_id IN (SELECT category_id FROM category 
WHERE name = "Family"));

-- Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

SELECT email FROM customer 
WHERE address_id IN (SELECT address_id FROM address
WHERE city_id IN( SELECT city_id FROM city
WHERE country_id IN (SELECT country_id FROM country 
WHERE country = "Canada")));

SELECT email
 FROM customer
	JOIN address
		ON  address.address_id = customer.address_id
	JOIN city
		ON city.city_id = address.city_id
	JOIN country
		ON country.country_id = city.country_id
	WHERE country = "Canada";

-- Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

SELECT title FROM film
	WHERE film_id IN (SELECT film_id FROM film_actor
		WHERE actor_id = (SELECT actor_id
FROM film_actor
GROUP BY actor_id
ORDER BY count(*) DESC
LIMIT 1 ));

-- Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
-- payment --> rental --> inventory --> film
-- SELECT title FROM film
-- WHERE film_id IN (SELECT film_id FROM film_actor
	-- WHERE actor_id = 
    SELECT title FROM film 
		WHERE film_id IN (SELECT film_id FROM inventory 
			WHERE inventory_id IN (SELECT inventory_id FROM rental
				WHERE customer_id = (SELECT customer_id FROM customer
					WHERE customer_id = (SELECT customer_id FROM payment
						GROUP BY customer_id
						ORDER BY SUM(Amount)
                        DESC LIMIT 1))));

-- Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.

SELECT customer_id, total FROM (
	SELECT customer_id, SUM(amount) AS total
    FROM payment
    GROUP BY customer_id) AS subquery 
    WHERE total > (
	SELECT AVG(total_amount_spent) FROM
		(SELECT customer_id, SUM(amount) AS total_amount_spent FROM payment
		GROUP BY customer_id) AS avg_subquery);