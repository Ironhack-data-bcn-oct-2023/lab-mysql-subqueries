USE SAKILA;

-- 1

SELECT film.title , COUNT(inventory.inventory_id)
            FROM film 
            JOIN inventory 
                ON film.film_id = inventory.film_id
            WHERE film.title = "Hunchback Impossible";

-- 2

SELECT film.title,film.length
FROM film 
WHERE film.length > (select avg(film.length) from film);

-- 3

SELECT CONCAT(actor.first_name, " ", actor.last_name) AS name
FROM actor 
JOIN film_actor ON actor.actor_id = film_actor.actor_id
WHERE film_id
    IN (SELECT film_id FROM film WHERE title = 'Alone Trip');

-- 4

SELECT title
FROM film 
JOIN film_category ON film.film_id = film_category.film_id
WHERE category_id
    IN (SELECT category_id FROM category WHERE category.name = 'family');

-- 5

SELECT CONCAT(customer.first_name, " ", customer.last_name) AS name, customer.email
FROM customer 
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
WHERE country_id
    IN (SELECT country_id FROM country WHERE country.country = 'CANADA');

-- 6 

SELECT CONCAT(actor.first_name, " ", actor.last_name) AS name, COUNT(film_actor.actor_id) AS times_appear
FROM actor 
JOIN film_actor ON actor.actor_id = film_actor.actor_id
GROUP by name
ORDER BY times_appear DESC;

-- 7

SELECT film.title
FROM film
WHERE film.film_id IN 
    (SELECT film_id FROM inventory  
        WHERE inventory_id IN 
            (SELECT inventory_id FROM rental
                WHERE rental_id IN 
                    (SELECT rental_id FROM payment
                        WHERE customer_id = 
                            (SELECT customer_id from payment 
                            GROUP BY customer_id
                            ORDER by SUM(amount) DESC
                            LIMIT 1))));

-- 8

SELECT customer_id, SUM(amount) AS total_amount
FROM payment
GROUP BY customer_id
HAVING total_amount > (select avg(amount) from payment)
ORDER BY total_amount DESC;