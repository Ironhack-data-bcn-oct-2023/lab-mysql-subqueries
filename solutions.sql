USE sakila;

-- 1
SELECT COUNT(inventory.film_id) AS count
FROM film
JOIN inventory ON film.film_id = inventory.film_id
WHERE film.title = 'Hunchback Impossible';

    
-- 2
SELECT * FROM film
	WHERE length > (SELECT AVG(length) FROM film);
  
  
-- 3
SELECT * FROM actor
WHERE actor_id IN 
	(SELECT actor_id FROM film_actor where film_id IN 
		(SELECT film_id FROM film WHERE film.title = 'Alone Trip'));
        
-- 4
SELECT title FROM film
	JOIN film_category ON film.film_id = film_category.film_id
    JOIN category ON film_category.category_id = category.category_id
		WHERE name = 'Family';
    
    
SELECT title FROM film
WHERE film_id IN 
	(SELECT film_id FROM film_category WHERE category_id IN
		(SELECT category_id FROM category WHERE name = 'Family'));
        
SELECT DISTINCT(category.name) FROM category;


-- 5
SELECT first_name, email FROM customer
WHERE address_id IN 
	(SELECT address_id FROM address WHERE city_id IN
		(SELECT city_id FROM city WHERE country_id IN
			(SELECT country_id FROM country WHERE country='Canada')));
            

SELECT first_name, email FROM customer
	JOIN address ON customer.address_id = address.address_id
    JOIN city ON address.city_id = city.city_id
    JOIN country ON city.country_id = country.country_id
		WHERE country='Canada';
  

-- 6
SELECT actor_id FROM film_actor GROUP BY actor_id ORDER BY (SELECT COUNT(film_id)) DESC LIMIT 1;

SELECT title FROM film 
WHERE film_id IN
	(SELECT film_id FROM film_actor WHERE actor_id = 107);


-- 7
SELECT customer_id, SUM(amount) AS sum FROM payment
    GROUP BY customer_id 
    ORDER BY sum DESC LIMIT 1; -- custom_id : 526
    
SELECT title FROM film WHERE film_id IN 
	(SELECT film_id FROM inventory WHERE inventory_id IN 
		(SELECT inventory_id FROM rental WHERE customer_id=526));


-- 8
SELECT AVG(total_amount_spent) FROM
		(SELECT customer_id, SUM(amount) as total_amount_spent FROM payment GROUP BY customer_id) AS amount; -- 112.548431
        
        
SELECT customer_id, SUM(amount) as total_amount_spent FROM payment 
	GROUP BY customer_id
    HAVING total_amount_spent > (SELECT AVG(total_amount_spent) FROM
		(SELECT customer_id, SUM(amount) as total_amount_spent FROM payment GROUP BY customer_id) AS amount)
	ORDER BY total_amount_spent;
	




SELECT AVG(total_amount_spent)








    

