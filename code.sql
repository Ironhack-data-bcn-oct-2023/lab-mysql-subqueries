use sakila;

#1. How many copies of the film Hunchback Impossible exist in the inventory system?
select * from film where title = "Hunchback Impossible";
select title, count(film.film_id) as count from film
	join inventory on film.film_id = inventory.film_id
    group by title
		having title = "Hunchback Impossible";
        
#2. List all films whose length is longer than the average of all the films.
select * from film where lenght > avg(length);
select avg(length) from film;
select title, length from film where length > (select avg(length) from film);
select * from film where title = "Alone Trip";
select actor_id from film_actor where (select film_id from film where title = "Alone Trip");
select * from film_actor where film_id = 17;

select * from category where name = "Family";
select distinct name from category;

select title from film 
	join film_category on film.film_id = film_category.film_id
    where category_id in (select category_id from category where name = "family");

select concat(first_name,' ',last_name) as name from customer 
where ;

select distinct country from country;

select concat(first_name,' ',last_name) as name from customer
	join address on customer.address_id = address.address_id
    join city on address.city_id = city.city_id
    join country on city.country_id = country.country_id
    where country in (select country from country where country = "Canada");
    
    
select actor_id from film_actor where count(distinct film_id) in (select max(count(distinct film_id)) from film);

select actor_id from film_actor 
		group by actor_id
        order by count(distinct film_id) DESC
        limit 1;

select actor_id from film_actor where count(distinct film_id) in (select max(count(distinct film_id)));
        
select title from film
	join film_actor on film.film_id = film_actor.film_id
	where actor_id in (select actor_id from film_actor
		group by actor_id
        order by count(distinct film_id) DESC
        limit 1);
        
SELECT actor_id, COUNT(DISTINCT film_id) AS film_count
FROM film_actor
GROUP BY actor_id
HAVING COUNT(DISTINCT film_id) = (
    SELECT MAX(actor_count)
    FROM (
        SELECT COUNT(DISTINCT film_id) AS actor_count
        FROM film_actor
        GROUP BY actor_id
    ) subquery
);

select title from film;

select title from film
	join film_actor on film.film_id = film_actor.film_id
	where actor_id in (SELECT actor_id
		FROM film_actor
		GROUP BY actor_id
		HAVING COUNT(DISTINCT film_id) = (
		SELECT MAX(actor_count)
		FROM (
        SELECT COUNT(DISTINCT film_id) AS actor_count
        FROM film_actor
        GROUP BY actor_id
    ) subquery
));

select title from film
	join film_actor on film.film_id = film_actor.film_id
    where film.film_id in ( select film_actor.film_id where 
		(select actor_id from film_actor 
		group by actor_id
        order by count(distinct film_id) DESC
        limit 1));
        
SELECT film.title
FROM film 
WHERE film_id
    IN (SELECT film_id
        FROM
            (SELECT actor_id from film_actor 
            GROUP BY actor_id
            ORDER by COUNT(*) DESC
            LIMIT 1) AS actors
            JOIN film_actor ON actors.actor_id = film_actor.actor_id);
            
select customer_id, sum(amount) as amount from payment group by customer_id order by amount desc limit 1;

select title from film
	join inventory on title.film_id = inventory.film_id
    join rental on inventory.inventory_id = rental.inventory_id
    join payment on rental.rental_id = payment.rental_id
    join customer on payment.customer_id = customer.customer_id
	where film_id in 
		(select film_id where inventory in 
			(select inventry where rental_id in 
				(select rental_id where customer_id in 
					(select customer_id, sum(amount) as amount 
                    from payment group by customer_id order by amount desc limit 1))));
                    
select title from film
	where film_id in 
		(select film_id from film where inventory in 
			(select inventry where rental_id in 
				(select rental_id where customer_id in 
					(select customer_id, sum(amount) as amount 
                    from payment group by customer_id order by amount desc limit 1))));