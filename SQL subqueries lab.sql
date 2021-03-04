-- Subqueries Lab

-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT count(inventory_id)
FROM sakila.inventory
WHERE film_id in (SELECT film_id FROM sakila.film WHERE title = "Hunchback Impossible");

-- 2. List all films whose length is longer than the average of all the films.

SELECT title
FROM sakila.film
WHERE length > (
SELECT avg(length)
FROM sakila.film);

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT first_name,last_name
FROM sakila.actor
WHERE actor_id in (SELECT distinct actor_id
FROM sakila.film_actor
WHERE film_id in (SELECT film_id FROM sakila.film WHERE title = 'Alone Trip'));

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT title
FROM sakila.film
WHERE film_id in (SELECT film_id FROM sakila.film_category WHERE category_id in (SELECT category_id FROM sakila.category WHERE name = 'Family'));

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

-- Using subqueries

SELECT email
FROM sakila.customer
WHERE address_id in (SELECT address_id FROM sakila.address WHERE city_id in (SELECT city_id FROM sakila.city WHERE country_id in ( SELECT country_id FROM sakila.country WHERE country = 'Canada')));


-- Joins tables

SELECT email 
FROM sakila.customer as customer_table
JOIN sakila.address as address_tabe on customer_table.address_id = address_tabe.address_id
JOIN sakila.city as city_table on address_tabe.city_id = city_table.city_id
JOIN sakila.country as country_table on city_table.country_id = country_table.country_id
WHERE country = 'Canada';

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

SELECT title
FROM sakila.film
WHERE film_id in (SELECT film_id FROM sakila.film_actor WHERE actor_id in (SELECT actor_id
FROM (SELECT actor_id, count(film_id), dense_rank() over (order by count(film_id) desc) as ranking
FROM sakila.film_actor
GROUP BY actor_id) as sub1
WHERE ranking = 1));

-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

SELECT title
FROM sakila.film
WHERE film_id in (SELECT film_id FROM sakila.inventory WHERE inventory_id in (SELECT rental_id
FROM sakila.rental WHERE customer_id  in (SELECT customer_id
FROM (SELECT customer_id, sum(amount), dense_rank() over(order by sum(amount) desc) as ranking
FROM sakila.payment
GROUP BY customer_id) as sub1
WHERE ranking=1)));

-- 8. Customers who spent more than the average payments -- not too sure about this one tbh


SELECT distinct customer_id, avg(amount)
FROM sakila.payment
WHERE amount > (SELECT avg(abc) FROM (SELECT customer_id, avg(amount) as abc
FROM sakila.payment
GROUP BY customer_id) as sub1)
GROUP BY customer_id;



