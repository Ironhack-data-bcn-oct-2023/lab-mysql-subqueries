USE sakila;

-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT count(film_id)
FROM inventory
WHERE inventory.film_id IN (
	SELECT film_id
FROM film
WHERE title = 'Hunchback Impossible');


-- 2. List all films whose length is longer than the average of all the films.
SELECT *
FROM film
WHERE LENGTH > (
	SELECT avg(LENGTH)
FROM film );


-- 3. 'Use subqueries to display all actors who appear in the film Alone Trip.
SELECT *
FROM actor a
WHERE a.actor_id IN (
	SELECT actor_id
FROM film_actor
WHERE film_id IN (
		SELECT f.film_id
FROM film f
WHERE f.title = 'Alone Trip'));


/*4.Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
Identify all movies categorized as family films.*/

SELECT *
FROM film c
WHERE c.film_id IN (
	SELECT fc.film_id
FROM film_category fc
WHERE fc.category_id IN (
		SELECT c2.category_id
FROM category c2
WHERE c2.name = 'Family')) ;


/* 5. Get name and email from customers from Canada using subqueries. 
Do the same with joins. Note that to create a join, 
you will have to identify the correct tables with their primary keys and foreign keys, 
that will help you get the relevant information.*/

-- Join version

SELECT c.first_name , c.email
FROM customer c
JOIN store s ON
s.store_id = c.store_id
JOIN address a ON
a.address_id = s.address_id
JOIN city c2 ON
c2.city_id = a.city_id
JOIN country c3 ON
c3.country_id = c2.country_id
WHERE c3.country = 'Canada';
		
-- Subqueries version

SELECT c.first_name , c.email
FROM customer c
WHERE c.store_id IN (
	SELECT s.store_id
FROM store s
WHERE s.address_id IN (
		SELECT a.address_id
FROM address a
WHERE a.city_id IN (
			SELECT c2.city_id
FROM city c2
WHERE c2.country_id IN (
				SELECT c3.country_id
FROM country c3
WHERE c3.country = 'Canada'))));


/* 6. Which are films starred by the most prolific actor? 
Most prolific actor is defined as the actor that has acted in the most number of films. 
First you will have to find the most prolific actor and then use that actor_id 
 to find the different films that he/she starred.*/
				

SELECT *
FROM film f
WHERE f.film_id IN (
	SELECT film_id
FROM film_actor fa
WHERE fa.actor_id IN(
		SELECT actor_id
FROM(
			SELECT fa.actor_id , count(film_id)
FROM film_actor fa
GROUP BY fa.actor_id
ORDER BY COUNT(film_id) DESC
LIMIT 1) AS top_actor));
				


/* 7. Films rented by most profitable customer. 
You can use the customer table and payment table to find the most profitable customer 
ie the customer that has made the largest sum of payments */
		
		
SELECT * FROM film f WHERE f.film_id IN(
SELECT i.film_id  FROM inventory i WHERE i.inventory_id IN (	
	SELECT r.inventory_id  FROM rental r WHERE r.customer_id IN (		
		SELECT customer_id from( -- Top customer id
		SELECT p.customer_id ,SUM(p.amount) AS total_spent  
		FROM payment p GROUP BY p.customer_id
		ORDER BY total_spent DESC LIMIT 1) AS top_customer
)));




/* 8. Get the client_id and the total_amount_spent of those clients who spent 
more than the average of the total_amount spent by each client.*/

SELECT p2.customer_id ,sum(p2.amount) AS total_customer FROM payment p2
GROUP BY p2.customer_id 
HAVING total_customer > (SELECT ROUND(sum(p.amount) / count(*),2) AS avg_spent FROM payment p);




