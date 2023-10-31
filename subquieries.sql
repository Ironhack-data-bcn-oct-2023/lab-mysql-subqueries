import pymysql
import sqlalchemy as alch # python -m pip install --upgrade 'sqlalchemy<2.0'
from getpass import getpass
import pandas as pd

def password():
    password = getpass("Enter your password: ")


password = getpass()

dbName = "Sakila"

connectionData=f"mysql+pymysql://root:{password}@localhost/{dbName}"

connectionData=f"mysql+pymysql://root:{password}@localhost/{dbName}"
engine = alch.create_engine(connectionData)

# 1. How many copies of the film _Hunchback Impossible_ exist in the inventory system?

query= """SELECT COUNT(*) AS num_copies
FROM inventory
WHERE film_id = (SELECT film_id FROM film WHERE title = 'Hunchback Impossible');"""
pd.read_sql_query(query, engine)


# 2. List all films whose length is longer than the average of all the films.

query ="""
select title from film
where length > (select avg(length) from film)"""

pd.read_sql_query(query, engine)

# 3. Use subqueries to display all actors who appear in the film _Alone Trip_.

query = """ 
select first_name, last_name 
from actor

where actor_id IN (select actor_id from film_actor

join film on film_actor.film_id = film.film_id

where film.title = "Alone Trip");
"""

pd.read_sql_query(query, engine)

# 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

query = """ 
select title
from film
where film.film_id IN (select film_id from film_category
join category c on film_category.category_id = c.category_id
where c.name = "Family");"""


pd.read_sql_query(query, engine)

# 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, 
# you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

query = """ 
    select concat(first_name," ", last_name) as "full name", email 
    from customer
    join address on customer.address_id = address.address_id
    join city on address.city_id = city.city_id
    join country on city.country_id = country.country_id
    where country.country = "Canada"
"""
pd.read_sql_query(query, engine)

query = """ 
    select first_name, last_name, email
    from customer
    where address_id in (select address_id from address where city_id in (select city_id from city
    join country on city.country_id = country.country_id
    where country.country = "Canada"))
"""
pd.read_sql_query(query, engine)

#6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
# First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
query = """
SELECT 
    title
FROM
    film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            (SELECT 
                actor_id, COUNT(*) film_count
            FROM
                film_actor
            GROUP BY actor_id
            ORDER BY film_count DESC
            LIMIT 1) AS actors
                JOIN
            film_actor ON actors.actor_id = film_actor.actor_id);
"""
pd.read_sql_query(query, engine)

# 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer
# ie the customer that has made the largest sum of payments

query="""SELECT 
    title
FROM
    film
WHERE
    film_id IN (SELECT 
            film_id
        FROM inventory where inventory_id in (SELECT inventory_id from rental
        where rental_id in (select rental_id from payment where customer_id = (select customer_id from payment
        group by customer_id
        order by count(*)desc 
        limit 1
        ))));
        """
pd.read_sql_query(query, engine)

# 8. Get the `client_id` and the `total_amount_spent` of those clients who spent more than the average of the `total_amount` spent by each client.

query ="""
SELECT customer_id, SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING total_amount_spent > (
  SELECT AVG(amount)
  FROM payment
);"""

pd.read_sql_query(query, engine)


