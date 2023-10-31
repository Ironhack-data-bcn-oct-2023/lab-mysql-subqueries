use sakila;

-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
	select
		(select count(*)
		 from inventory
		 where film_id = (select film_id
						 from film
						 where title = 'Hunchback Impossible')
		) as "Number of Copies of Hunchback Impossible";

-- 2. List all films whose length is longer than the average of all the films.
	select title as "Longest films" from film
		where length > (select avg(length) from film);

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
	select concat(first_name," " ,last_name) as full_name from actor 
		where actor_id IN (select actor_id 
							from film_actor
							where film_id = (select film_id 
												from film where title = 'Alone Trip')
	);

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
	select title from film
		where film_id IN (select film_id
							from film_category
                            where category_id = (select category_id
													from category where name = 'family')
	);

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, 
-- that will help you get the relevant information.
	select first_name, email from customer
		where address_id IN (select address_id 
							from address
                            where city_id IN (select city_id
												from city
                                                where country_id IN (select country_id
																	from country where country = 'Canada')
	));
    
	select first_name, email 
    from customer as c
		join address as ad on c.address_id = ad.address_id
        join city as ct on ad.city_id = ct.city_id
        join country as ctr on ct.country_id = ctr.country_id
			where ctr.country = 'Canada';
    
-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most
-- number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films
-- that he/she starred.
	select title from film
		where film_id in (select film_id from film_actor
							where actor_id = (select actor_id from film_actor
												group by actor_id
												order by COUNT(*) desc limit 1)
	);

-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable
-- customer ie the customer that has made the largest sum of payments.
	select title from film
		where film_id in (select film_id from inventory
			where inventory_id in (select inventory_id from rental
				where customer_id = (select customer_id from customer
					where customer_id = (select customer_id from payment
						group by customer_id
						order by sum(amount) desc limit 1)
	)));

-- 8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent
-- by each client.
	select customer_id, total
    from (
		select customer_id, sum(amount) as total
        from payment
		group by customer_id
    ) as subquery where total > (
		select avg(total)
		from (
			select customer_id, SUM(amount) as total
            from payment
			group by customer_id) as avg_subquery
	);