
-- "Muéstrame los IDs de los clientes VIP (aquellos que han rentado más de 20 películas)" 

SELECT customer_id, COUNT(rental_id) AS total_rentas 
FROM public.rental
 GROUP BY customer_id 
HAVING COUNT(rental_id) > 20 
ORDER BY total_rentas DESC; -- Pro-Tip: Siempre ordena de mayor a menor para ver a los mejores primero