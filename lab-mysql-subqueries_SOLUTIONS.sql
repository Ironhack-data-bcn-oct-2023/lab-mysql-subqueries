USE sakila;
-- 1. How many copies of the film _Hunchback Impossible_ exist in the inventory system?

SELECT title, count(inventory_id) as Inventory FROM film
	JOIN inventory on film.film_id = inventory.film_id
    WHERE film.title = "Hunchback Impossible";

-- 2. List all films whose length is longer than the average of all the films.

SELECT title, length FROM film
	WHERE length > (SELECT avg(length) FROM film)
    ORDER BY length desc;


-- 3. Use subqueries to display all actors who appear in the film _Alone Trip_.
    
SELECT * FROM actor
WHERE actor_id in (SELECT actor_id FROM film_actor Where film_id in (SELECT film_id FROM film Where title = "Alone Trip"));
	


-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
-- film --> film_category --> category
-- title --> film_id --> film_id --> category_id --> name
SELECT title as Movie_Names FROM film
WHERE film_id in (SELECT film_id FROM film_category Where category_id in (SELECT category_id FROM category Where name = "family"));

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
-- customers from CANADA
-- customers--> Address --> City --> Country
-- firstname & Email --> Address_id --> city_id --> country_id --> country
SELECT first_name as Name, email FROM customer
	WHERE Address_id in (SELECT Address_id FROM Address 
		WHERE city_id in (SELECT city_id FROM City 
			WHERE country_id in (SELECT country_id FROM Country 
				WHERE country = "Canada")));
                
SELECT first_name as Name, email FROM customer
		join Address on customer.Address_id = Address.Address_id
			join City on Address.city_id = City.city_id
				join Country on City.country_id = Country.country_id
					WHERE country = "Canada";


-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
-- (SELECTactor sum(name) is the heighest) --> Which movies has this person starred?

SELECT actor_id from film_actor GROUP BY actor_id ORDER BY (SELECT count(film_id)) DESC LIMIT 1;

SELECT title FROM film
	WHERE film_id in (SELECT film_id FROM film_actor WHERE actor_id = 107);

-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
-- customer_id with most sum of payments GROUP BY customer_id ORDER BY (SELECT sum(profit)) DESC LIMIT 1;
-- customer --> payment
-- customer name --> customer_id --> amount
-- film - inventory - rental - customer
-- title - film_id - inventory_id - rental_id - customer_id
SELECT customer_id, amount FROM Customer
	WHERE customer_id in (SELECT customer_id FROM payment GROUP BY customer_id ORDER BY sum(amount));
    
SELECT customer_id, sum(amount) as Total FROM payment
	GROUP BY customer_id ORDER BY Total DESC LIMIT 1;

SELECT title as Movie_title FROM film
	WHERE film_id in (SELECT film_id FROM inventory 
		WHERE inventory_id in (SELECT inventory_id FROM rental 
			WHERE customer_id in (SELECT customer_id FROM Customer
				WHERE customer_id = 526)));

-- 8. Get the `client_id` and the `total_amount_spent` of those clients who spent more than the average of the `total_amount` spent by each client.
-- cusotmer --> payment
-- customer_id --> amount

-- avg amount of total clients payment
SELECT avg(total_amount_spent) FROM (SELECT customer_id, SUM(amount) as total_amount_spent FROM payment GROUP BY customer_id) AS amount;

SELECT customer_id, SUM(amount) as total_amount_spent FROM payment
	GROUP BY customer_id
    HAVING total_amount_spent > (SELECT AVG(total_amount_spent) FROM
		(SELECT customer_id, SUM(amount) as total_amount_spent FROM payment GROUP BY customer_id) AS amount)
	ORDER BY total_amount_spent DESC;
    
    
    
    
SELECT customer_id, sum(amount) AS total_amount_spent FROM payment
	GROUP BY customer_id
    HAVING amount > WHERE sum(amount) > avg(amount)
	SELECT customer_id, sum(amount) FROM payment (SELECT customer_id FROM payment 
			ORDER BY amount desc);