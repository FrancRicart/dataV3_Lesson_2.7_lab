/*
Instructions
1. How many films are there for each of the categories in the category table. Use appropriate join to write this query.
2. Display the total amount rung up by each staff member in August of 2005.
3. Which actor has appeared in the most films?
4. Most active customer (the customer that has rented the most number of films)
5. Display the first and last names, as well as the address, of each staff member.
6. List each film and the number of actors who are listed for that film.
7. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name.
8. List number of films per category -> THIS IS THE FIRST QUESTION AS THE FIRST!
*/

USE sakila;

-- 1. How many films are there for each of the categories in the category table. Use appropriate join to write this query.

-- the common column here is category_id

SELECT * FROM category as c
JOIN sakila.film_category as f
ON c.category_id = fc.category_id;

SELECT c.name as category, COUNT(DISTINCT f.film_id) AS films FROM sakila.category as c
INNER JOIN sakila.film_category as f
ON c.category_id = f.category_id
GROUP BY category
ORDER BY films DESC;


-- 2. Display the total amount rung up by each staff member in August of 2005.

SELECT * FROM payment as p;
SELECT * FROM staff as s;

SELECT * FROM sakila.staff as s
JOIN sakila.payment as p
ON s.staff_id = p.staff_id;

SELECT s.first_name as "name", s.last_name as "surname", SUM(p.amount) as "amount" FROM sakila.staff as s
JOIN sakila.payment as p
ON s.staff_id = p.staff_id
WHERE p.payment_date BETWEEN "2005-08-01 00:00:00" AND "2005-08-31 23:59:59"
GROUP BY s.staff_id
ORDER BY amount DESC;

-- 3. Which actor has appeared in the most films?
SELECT * FROM sakila.actor as a;
SELECT * FROM sakila.film_actor as f;

SELECT * FROM sakila.film_actor as f
INNER JOIN sakila.actor as a
ON a.actor_id = f.actor_id;

SELECT a.first_name as "name", a.last_name as "surname", SUM(f.film_id) as "amount_of_movies" FROM sakila.actor as a
INNER JOIN sakila.film_actor as f
ON a.actor_id = f.actor_id 
GROUP BY a.actor_id
ORDER BY amount_of_movies DESC
LIMIT 1;

-- 4. Most active customer (the customer that has rented the most number of films)
SELECT c.first_name as name, c.last_name as surname, sum(r.rental_id) as rentals
FROM sakila.customer as c
INNER JOIN sakila.rental as r
ON c.customer_id = r.customer_id
GROUP BY c.customer_id
ORDER BY rentals DESC
LIMIT 1; 

-- 5. Display the first and last names, as well as the address, of each staff member.
SELECT s.first_name, s.last_name, a.address
FROM sakila.staff as s
INNER JOIN sakila.address as a
ON s.address_id = a.address_id;

-- 6. List each film and the number of actors who are listed for that film.
-- Bear in mind that a movie could have no actors! This means that might want a LEFT JOIN in order not to miss those!

SELECT * FROM film;
SELECT * FROM film_actor;

SELECT fi.title AS films, COUNT(DISTINCT fa.actor_id) as number_of_actors
FROM sakila.film AS fi
LEFT JOIN sakila.film_actor AS fa
ON fi.film_id = fa.film_id
GROUP BY fi.film_id
ORDER BY number_of_actors DESC, films;

-- 7. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name.
-- I am using a LEFT JOIN in case there were customers with no payments done, but I think the result is just the same as with the INNER JOIN.
-- coincident: customer_id

SELECT c.last_name AS surname, c.first_name AS name, SUM(p.amount) AS total_amount
FROM payment as p
LEFT JOIN customer as c
ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY total_amount, name;

