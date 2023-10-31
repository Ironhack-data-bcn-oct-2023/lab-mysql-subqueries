USE sakila;
-- How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(*) FROM inventory
JOIN film ON inventory.film_id = film.film_id
WHERE film.title = 'Hunchback Impossible';
-- List all films whose length is longer than the average of all the films.
SELECT title, length FROM film
WHERE length > (SELECT AVG(length) FROM film);
-- Use subqueries to display all actors who appear in the film Alone Trip.
SELECT actor_id, first_name, last_name FROM actor 
WHERE actor_id IN (
	SELECT actor_id FROM film_actor
    WHERE film_id = (
    SELECT film_id FROM film
    WHERE title = 'Alone Trip'
    )
    );
-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT film.title, film.rating FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE category.name = 'family';

SELECT film_id, title, rating FROM film
WHERE film_id IN (
	SELECT film_id FROM film_category
    WHERE category_id = (
		SELECT category_id FROM category
        WHERE name = 'family'
        )
	);

-- Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
SELECT first_name, last_name, email FROM customer
WHERE address_id IN (
	SELECT address_id FROM address
    WHERE city_id IN (
		SELECT city_id FROM city
		WHERE country_id = (
				SELECT country_id FROM country
                WHERE country = 'canada'
                )
			)
		);
        
SELECT customer.first_name, customer.last_name, customer.email FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
WHERE country.country = 'canada';
-- Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films.First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT actor_id, COUNT(film_id) as num_films FROM film_actor
GROUP BY actor_id
ORDER BY num_films DESC
LIMIT 1;
SELECT film_id, title FROM film
WHERE film_id IN (
  SELECT film_id FROM film_actor
  WHERE actor_id = (
    SELECT actor_id FROM film_actor
    GROUP BY actor_id
    ORDER BY COUNT(film_id) DESC
    LIMIT 1
  )
);
-- Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
SELECT customer_id FROM payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 1;

SELECT title FROM film
WHERE film_id IN (
    SELECT inventory.film_id FROM rental
    JOIN inventory ON rental.inventory_id = inventory.inventory_id
		WHERE rental.customer_id = '526'
        );
-- Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
SELECT customer_id, SUM(amount) AS Total_Amount_Spent FROM payment
GROUP BY customer_id 
HAVING total_amount_spent > (
	SELECT AVG(total_amount) FROM (
		SELECT SUM(amount) AS total_amount FROM payment
		GROUP BY customer_id
		) AS customer_totals
        )
        ORDER BY total_amount_spent DESC;