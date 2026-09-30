-- 1. Determina el número de copias de la película "El jorobado imposible" que existen en el sistema de inventario
SELECT
    COUNT(*) AS number_of_copies
FROM inventory
WHERE film_id = (
    SELECT film_id
    FROM film
    WHERE title = 'HUNCHBACK IMPOSSIBLE'
);
-- 2. Muéstrame las películas cuya duración sea mayor que la duración media de todas las películas
SELECT
    title,
    length
FROM film
WHERE length > (
    SELECT AVG(length)
    FROM film
);
-- 3. Utilice una subconsulta para mostrar todos los actores que aparecen en la película "Alone Trip"
SELECT
    first_name,
    last_name
FROM actor
WHERE actor_id IN (
    SELECT actor_id
    FROM film_actor
    WHERE film_id = (
        SELECT film_id
        FROM film
        WHERE title = 'ALONE TRIP'
    )
);

-- BONUS 4. Identifica todas las películas clasificadas como películas familiares

SELECT
    title
FROM film
WHERE film_id IN (
    SELECT film_id
    FROM film_category
    WHERE category_id = (
        SELECT category_id
        FROM category
        WHERE name = 'Family'
    )
);

-- BONUS 5. Recuperar el nombre y el correo electrónico de los clientes de Canadá utilizando tanto subconsultas como uniones.
SELECT
    first_name,
    last_name,
    email
FROM customer
WHERE address_id IN (
    SELECT address_id
    FROM address
    WHERE city_id IN (
        SELECT city_id
        FROM city
        WHERE country_id = (
            SELECT country_id
            FROM country
            WHERE country = 'Canada'
        )
    )
);

-- 5B.

SELECT
    c.first_name,
    c.last_name,
    c.email
FROM customer AS c

INNER JOIN address AS a
    ON c.address_id = a.address_id

INNER JOIN city AS ci
    ON a.city_id = ci.city_id

INNER JOIN country AS co
    ON ci.country_id = co.country_id

WHERE co.country = 'Canada';

-- BONUS 6. Determina en qué películas participó el actor más prolífico

SELECT
    title
FROM film
WHERE film_id IN (
    SELECT film_id
    FROM film_actor
    WHERE actor_id = (
        SELECT actor_id
        FROM film_actor
        GROUP BY actor_id
        ORDER BY COUNT(film_id) DESC
        LIMIT 1
    )
);

-- BONUS 7. Encuentra las películas alquiladas por el cliente más rentable en la base de datos de Sakila
SELECT DISTINCT
    title
FROM film
WHERE film_id IN (

    SELECT film_id
    FROM inventory
    WHERE inventory_id IN (

        SELECT inventory_id
        FROM rental
        WHERE customer_id = (

            SELECT customer_id
            FROM payment
            GROUP BY customer_id
            ORDER BY SUM(amount) DESC
            LIMIT 1
        )
    )
);
-- BONUS 8. Mostrar los clientes cuyo gasto total es superior al gasto total medio de los clientes
SELECT
    customer_id,
    SUM(amount) AS total_amount_spent
FROM payment

GROUP BY customer_id

HAVING SUM(amount) > (
    SELECT AVG(total_spent)
    FROM (
        SELECT
            customer_id,
            SUM(amount) AS total_spent
        FROM payment
        GROUP BY customer_id
    ) AS customer_totals
);