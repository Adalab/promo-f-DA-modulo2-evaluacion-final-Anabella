USE sakila;

--1.Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT (title)  
  FROM film; 

--2.Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT title, rating
 FROM film 
  WHERE rating = 'PG-13';

 --3.Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
 
 SELECT f.title , f.description 
  FROM film  AS f
   WHERE description LIKE '%amazing%'; 
  
  --4.Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
  
  SELECT f.`title`, f.`length` 
   FROM film AS f
    WHERE  f.`length`> 120;  --Mirar si el lenght es la duracion
    
  
 --5.Recupera los nombres de todos los actores.
 
 SELECT first_name  
   FROM actor;
  
  --6.Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
  
  SELECT first_name, last_name 
   FROM actor
    WHERE last_name LIKE '%Gibson%';  
   
   
 --7.Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
 
 SELECT first_name
  FROM actor 
   WHERE actor_id BETWEEN 10 AND 20; 
  
 
--8.Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.

SELECT title, rating 
 FROM film
  WHERE rating NOT IN ('R','PG-13');
  

--9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.

SELECT rating, COUNT(*) AS recuento_clasificacion
  FROM film
GROUP BY rating;

--10.Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, 
su nombre y apellido junto con la cantidad de películas alquiladas.

customer c       --customer_id,
rental           --customer_id, rental_id, inventory_id
inventory i      --inventory_id

SELECT c.customer_id,c.first_name, c.last_name, COUNT(i.inventory_id) AS cant_peliculas    
 FROM customer AS c
 INNER JOIN rental AS r ON c.customer_id = r.customer_id 
 INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id 

GROUP BY c.customer_id,c.first_name, c.last_name;


--11.Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

category c          --category_id, nombre de la categoria
film_category fc    --film_id, category_id
inventory i         --film_id

SELECT c.name, COUNT(i.inventory_id) AS cant_categoria
  FROM category AS c 
  INNER JOIN film_category AS fc ON c.category_id = fc.category_id  
  INNER JOIN inventory AS i ON fc.film_id = i.film_id  

 GROUP BY c.name; 

--12.Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

SELECT rating, AVG(`length`) AS promedio_duracion
 FROM film 
GROUP BY rating;

--13.Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

actor --actor_id
film  --film_id 
film_actor fa  --actor_id y film_id

SELECT a.first_name, a.last_name, f.title
 FROM actor AS a 
 INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id  
 INNER JOIN film AS f ON fa.film_id = f.film_id 
 
WHERE title = 'Indian Love';


--14.Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

SELECT title
 FROM film 

 WHERE description LIKE '%dog%' OR description LIKE '%cat%';

--15.Hay algún actor/actriz que no aparecen en ninguna película en la tabla film_actor.

SELECT a.first_name, a.last_name
 FROM actor AS a
 LEFT JOIN film_actor AS fa ON a.actor_id = fa.actor_id 
 LEFT JOIN film AS f ON fa.film_id = f.film_id 

  WHERE fa.actor_id IS NULL;



--16.Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.

SELECT title
 FROM film 
  WHERE release_year BETWEEN 2005 AND 2010;
 
--17.Encuentra el título de todas las películas que son de la misma categoría que "Family".

film f             --film_id, title
category c         --category_id, nombre de la categoria
film_category fc   --category_id, film_id

SELECT f.title 
 FROM film AS f
 INNER JOIN film_category AS fc ON f.film_id = fc.film_id 
 INNER JOIN category AS c ON fc.category_id = c.category_id 

WHERE c.name = 'Family'; 


--18.Muestra el nombre y apellido de los actores que aparecen en más de 10 películas. --CHEQUEAR RESULTADO

actor  --actor_id
film_actor fa   --actor_id, film_id

SELECT a.first_name, a.last_name
 FROM actor AS a
 INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id 

GROUP BY a.first_name, a.last_name
HAVING COUNT(film_id) > 10;


--19.Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.

SELECT title
 FROM film

WHERE `length` > 120 AND rating = 'R';

 
--20.Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y 
--muestra el nombre de la categoría junto con el promedio de duración.

--category categoty_id, name 
--film   length, film_id
--film_category fc  category_id, film_id

SELECT c.name, AVG(`length`) AS duracion_superior_120
 FROM category AS c
 INNER JOIN film_category AS fc ON c.category_id = fc.category_id 
 INNER JOIN film AS f ON fc.film_id = f.film_id 

GROUP BY c.name 
HAVING  AVG(`length`) > 120;
 
--21.Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.


SELECT a.first_name, COUNT(fa.film_id) AS cant_peliculas_actuadas
 FROM actor a 
 INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
  
GROUP BY fa.actor_id
HAVING COUNT(fa.film_id)  >5;


--22.Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. 
--Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y 
luego selecciona las películas correspondientes.

rental  ---rental_id, fechas
film    --film_id, title, rental_duration 
inventory i 

SELECT f.title
FROM film  AS f
INNER JOIN inventory AS i ON f.film_id  = i.film_id  
INNER JOIN rental AS r ON i.inventory_id  = r.inventory_id  
WHERE r.rental_id  IN 

              (SELECT rental_id 
               FROM rental 
               WHERE DATEDIFF(return_date ,rental_date)> 5)

GROUP BY f.title; 

--23.Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". 
--Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.


--actor, actor_id
--film_actor fa --actor_id, film_id
--category --category_id, name 
--film_category fc  film_id, category_id 


SELECT a.first_name, a.last_name
FROM actor AS a 
WHERE a.actor_id NOT IN 

         (SELECT a.actor_id FROM actor AS a 
          INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id  
          INNER JOIN film_category AS fc ON fa.film_id = fc.film_id
          INNER JOIN category AS c ON fc.category_id = c.category_id 
          WHERE c.name = 'Horror');

         
 --BONUS Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.
 
film   --film_id, duracion
film_category fc    --film_id, category_id
category c     categrory_id, name 
 
 
SELECT title FROM film AS f
WHERE f.film_id  IN 

          (SELECT f.film_id
           FROM film  AS f 
           INNER JOIN film_category AS fc ON f.film_id = fc.film_id 
           INNER JOIN category AS c ON fc.category_id = c.category_id  
           WHERE c.name = 'Comedy'  AND f.`length` > 180); 
 
 
 
 
 