use sakila;


-- 1a. Display the first and last names of all actors from the table `actor`. 

Select first_name,last_name From actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`. 
SELECT CONCAT(actor.first_name,  ' ', actor.last_name) AS 'ACTOR NAME'
FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
Select actor_id, first_name, last_name from actor where actor.first_name='Joe';

-- 2b. Find all actors whose last name contain the letters `GEN`:
Select * from actor where last_name like '%GEN%';

-- 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
Select last_name,first_name from actor where last_name like '%LI%';

-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country from country where country IN('Afghanistan', 'Bangladesh', 'China');

-- 3a. Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. Hint: you will need to specify the data type.
ALTER TABLE actor
ADD middle_name VARCHAR(255) after first_name;

-- 3b. You realize that some of these actors have tremendously long last names. Change the data type of the `middle_name` column to `blobs`
ALTER TABLE actor
ADD middle_name blob;

-- 3c. Now delete the `middle_name` column.
alter TABLE actor DROP middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(*) as cnt from actor 
GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name, count(*) as cnt from actor 
GROUP BY last_name having count(*) >1;

 -- 4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
-- select * from actor where last_name='williams';
Update actor set first_name='Harpo' where actor_id=172;

-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
update actor set first_name='Grucho' where (first_name='Harpo' and actor_id=172);

-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
show create table sakila.address;

-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
select first_name, last_name, address from staff join address using (address_id);


-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
SELECT staff.staff_id, sum(payment.amount) AS 'Total Payment' FROM payment
LEFT JOIN staff ON staff.staff_id = payment.staff_id
GROUP BY staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
Select film.film_id, film.title, count(film_actor.film_id) as 'Total Actors' from film_actor
Inner Join film on film_actor.film_id=film.film_id
GROUP BY film_id;

-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
select count(inventory.film_id) as 'copies of the film' from inventory where film_id IN
(select film.film_id from film where film.title = 'Hunchback Impossible');

-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
select customer.customer_id, customer.first_name, customer.last_name, sum(payment.amount) as 'Total Amount Paid'
from payment join customer on payment.customer_id=customer.customer_id
group by customer_id
ORDER BY last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English. 
SELECT title, language_id FROM film
WHERE (title LIKE 'K%' OR title LIKE 'Q%') AND language_id IN 
	(
		SELECT language_id FROM language
		WHERE name = 'English'
	);

-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT first_name, last_name FROM actor
WHERE actor_id IN
	(
		SELECT actor_id FROM film_actor
		WHERE film_id IN
			(
				SELECT film_id FROM film
				WHERE title = 'Alone Trip'
			)
	);
    
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT customer.first_name, customer.last_name, customer.email FROM customer
	JOIN address ON customer.address_id = address.address_id
	JOIN city ON city.city_id = address.city_id
	JOIN country ON city.country_id = country.country_id
WHERE country.country = 'Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
SELECT film.title FROM film
	JOIN film_category ON film.film_id = film_category.film_id
	JOIN category ON category.category_id = film_category.category_id
WHERE category.name = 'Family';

-- 7e. Display the most frequently rented movies in descending order.
SELECT film.title, COUNT(rental.rental_id) AS rental_count FROM film
	JOIN inventory ON film.film_id = inventory.film_id
	JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY rental_count DESC
LIMIT 10;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT store.store_id, COUNT(payment.payment_id) payment_count, SUM(payment.amount) AS total_amount FROM store
	JOIN inventory ON store.store_id = inventory.store_id
    JOIN rental ON inventory.inventory_id = rental.inventory_id
    JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY store.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT store.store_id, city.city, country.country FROM store
	JOIN address ON address.address_id = store.address_id
    JOIN city ON city.city_id = address.city_id
    JOIN country ON country.country_id = city.country_id;

-- 7h. List the top five genres in gross revenue in descending order. 
-- (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT category.name, SUM(payment.amount) AS gross_revenue FROM category
	JOIN film_category ON film_category.category_id = category.category_id
    JOIN inventory ON inventory.film_id = film_category.film_id
    JOIN rental ON rental.inventory_id = inventory.inventory_id
    JOIN payment ON payment.rental_id = rental.rental_id
GROUP BY category.name
ORDER BY gross_revenue DESC 
LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW Top_5_Genres AS
	SELECT category.name, SUM(payment.amount) AS gross_revenue FROM category
		JOIN film_category ON film_category.category_id = category.category_id
		JOIN inventory ON inventory.film_id = film_category.film_id
		JOIN rental ON rental.inventory_id = inventory.inventory_id
		JOIN payment ON payment.rental_id = rental.rental_id
	GROUP BY category.name
	ORDER BY gross_revenue DESC 
	LIMIT 5;

-- 8b. How would you display the view that you created in 8a?
SELECT * FROM Top_5_Genres;

-- 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW IF EXISTS Top_5_Genres;






