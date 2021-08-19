-- Lab SQL Join (Part 2)
USE sakila;
-- 1.Write a query to display for each store its store ID, city, and country.  
SELECT store_id, city, country
FROM sakila.store s
JOIN sakila.address a USING(address_id)
JOIN sakila.city c USING(city_id)
JOIN sakila.country USING(country_id);

-- 2.Write a query to display how much business, in dollars, each store brought in.
SELECT store_id, SUM(amount) as 'sales in dollars'
FROM sakila.payment p
JOIN sakila.staff s USING(staff_id)
GROUP BY store_id;

-- 3.Which film categories are longest?
SELECT c.name as 'category', AVG(length) AS 'average length'
FROM sakila.category c
JOIN sakila.film_category fc USING(category_id)
JOIN sakila.film f USING(film_id)
GROUP BY category
ORDER BY AVG(length) desc;


-- 4.Display the most frequently rented movies in descending order.
SELECT f.title, COUNT(rental_id) as 'total_rentals'
FROM sakila.film f
JOIN sakila.inventory i USING(film_id)
JOIN sakila.rental r USING(inventory_id)
GROUP BY f.title
ORDER BY total_rentals desc;

-- 5.List the top five genres in gross revenue in descending order.
SELECT c.name as 'genre', SUM(amount) AS 'gross_revenue'
FROM sakila.category c
JOIN sakila.film_category fc USING(category_id)
JOIN sakila.film f USING(film_id)
JOIN sakila.inventory i USING(film_id)
JOIN sakila.rental r USING(inventory_id)
JOIN sakila.payment p USING(rental_id)
GROUP BY genre
ORDER BY gross_revenue DESC;

-- 6.Is "Academy Dinosaur" available for rent from Store 1?
SELECT title, store_id, COUNT(inventory_id) as 'inventory'
FROM sakila.film f
JOIN sakila.inventory i USING(film_id)
GROUP BY store_id, title
HAVING store_id = 1 and title = 'Academy Dinosaur';
-- yes, store 1 has 4 copies of 'Academy Dinosaur"

-- 7.Get all pairs of actors that worked together.
SELECT *
FROM
(SELECT first_name, last_name, actor_id, film_id
FROM sakila.actor a
JOIN sakila.film_actor f USING(actor_id)
GROUP BY last_name, first_name, actor_id, film_id) t1
JOIN
(SELECT first_name, last_name, actor_id, film_id
FROM sakila.actor a
JOIN sakila.film_actor f USING(actor_id)
GROUP BY last_name, first_name, actor_id, film_id) t2
ON (t1.actor_id <>t2.actor_id) and (t1.film_id = t2.film_id);

-- 8. Get all pairs of customers that have rented the same film more than 3 times.
-- count(distinct film_id)>3, (link customers to rental and film id) and then to self???
SELECT t1.first_name, t1.last_name, t2.first_name, t2.last_name, t1.film_id
FROM
(SELECT first_name, last_name, r.customer_id, film_id
FROM sakila.customer c
JOIN sakila.rental r USING(customer_id)
JOIN sakila.inventory i USING(inventory_id)
GROUP BY film_id, last_name, first_name, r.customer_id) t1
JOIN
(SELECT first_name, last_name, r.customer_id, film_id
FROM sakila.customer c
JOIN sakila.rental r USING(customer_id)
JOIN sakila.inventory i USING(inventory_id)
GROUP BY film_id, last_name, first_name, r.customer_id) t2
ON (t1.film_id = t2.film_id) and (t1.r.customer_id, != t2.r.customer_id)
GROUP BY t1.first_name, t1.last_name, t2.first_name, t2.last_name, t1.film_id
HAVING count(distinct t1.film_id)>3;
-- I can't figure this one out...

-- 9. For each film, list actor that has acted in more films.
SELECT title, first_name, last_name, count(film_id) as 'films_acted_in'
FROM sakila.film f
JOIN sakila.film_actor fa USING(film_id)
JOIN sakila.actor a USING(actor_id)
GROUP BY title, last_name, first_name
ORDER BY films_acted_in desc;

-- still working on this one too...


                 