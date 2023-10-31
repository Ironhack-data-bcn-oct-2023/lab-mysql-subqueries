#!/usr/bin/env python
# coding: utf-8




# Import necessary Python modules
import pymysql
import sqlalchemy as alch
from getpass import getpass
import pandas as pd
import os



password = getpass()




dbName = "sakila"





connectionData = f"mysql+pymysql://root:{password}@localhost/{dbName}"





engine = alch.create_engine(connectionData)


# ### 1. How many copies of the film _Hunchback Impossible_ exist in the inventory system?




# Wrong option

query = '''
SELECT title, inventory.film_id
FROM film 
JOIN inventory ON film.film_id = inventory.film_id
WHERE film.title = "Hunchback Impossible";
'''
pd.read_sql_query(query, engine)




# Subquery option

query= '''SELECT COUNT(*) AS num_copies
FROM inventory
WHERE film_id = (SELECT film_id FROM film WHERE title = 'Hunchback Impossible');'''

pd.read_sql_query(query, engine)


# ### 2. List all films whose length is longer than the average of all the films.




query = "SELECT title FROM film WHERE length > (SELECT AVG(length) FROM film);"
pd.read_sql_query(query, engine)


# ### 3. Use subqueries to display all actors who appear in the film _Alone Trip_.




query = ''' SELECT first_name, last_name
FROM actor
WHERE actor.actor_id IN (SELECT actor_id FROM film_actor
    JOIN film ON film_actor.film_id = film.film_id
    WHERE film.title = "Alone Trip");
'''
pd.read_sql_query(query, engine)


# ### 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.




query = ''' SELECT title
FROM film
WHERE film.film_id IN (
    SELECT film_id
    FROM film_category
    JOIN category ON film_category.category_id = category.category_id
    WHERE category.name = "Family"
);
'''

pd.read_sql_query(query, engine)


# ### 5.  Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.




# Subquery

query = ''' SELECT concat(first_name, " ", last_name) as full_name, email
FROM customer
WHERE customer.address_id IN (select address_id 
from address
where city_id in (select city_id from city
join country on city.country_id = country.country_id
where country.country = "Canada"
));
'''

pd.read_sql_query(query, engine)





# Joins

query = ''' select concat(first_name, " ", last_name) as full_name, email
from customer
join address on customer.address_id = address.address_id
join city on address.city_id = city.city_id
join country on city.country_id = country.country_id
where country.country = "Canada";
'''

pd.read_sql_query(query, engine)


# ### 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.




query = ''' SELECT title
FROM film
WHERE film.film_id IN (SELECT film_id
    FROM film_actor
    WHERE actor_id = (SELECT actor_id
        FROM film_actor
        GROUP BY actor_id
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ));

'''


pd.read_sql_query(query, engine)


# ### 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments.




# First part (find the most profitable customer).

query = ''' select customer_id, sum(amount) as sum_amount
from payment
group by customer_id
order by sum_amount desc
limit 1;

'''

pd.read_sql_query(query, engine)





# Second part (find the films rented by the most profitable customer).

query = ''' select title
from film
where film.film_id in (select film_id 
from inventory
where inventory_id in (select inventory_id
from rental
where rental_id in (select rental_id
from payment
where customer_id = (select customer_id
from payment
group by customer_id
order by sum(amount) desc
limit 1

))));

'''

pd.read_sql_query(query, engine)


# ### 8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.



query = ''' select customer_id, sum(amount) as total_amount_spent
from payment
group by customer_id
having total_amount_spent > ( SELECT AVG(amount) 
payment);

'''
pd.read_sql_query(query, engine)

