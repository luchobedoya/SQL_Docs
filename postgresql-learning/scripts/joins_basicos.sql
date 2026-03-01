/* ============================================================================
   Autor: Luis Bedoya
   Fecha: 2026-03-01
   Tema: Cruce de Tablas (INNER JOIN y FULL JOIN) y uso de Alias
   Base de Datos: dvdrental
============================================================================ */

-- ----------------------------------------------------------------------------
-- 1. INNER JOIN (La intersección estricta)
-- ----------------------------------------------------------------------------
/* PRO-TIP: Usamos "Alias" (c y r) para que el código sea más limpio.
   Siempre escribe INNER JOIN en lugar de solo JOIN por claridad.
*/

-- Mostrar solo los clientes que tienen rentas registradas
SELECT 
    c.first_name, 
    c.last_name, 
    r.rental_date 
FROM public.customer c
INNER JOIN public.rental r 
    ON c.customer_id = r.customer_id
ORDER BY r.rental_date DESC;


-- ----------------------------------------------------------------------------
-- 2. FULL OUTER JOIN (La unión total)
-- ----------------------------------------------------------------------------
/* NOTA: FULL JOIN trae todo. Si un cliente no tiene rentas, 
   su 'rental_date' será NULL. Si una renta no tiene cliente, 
   el 'first_name' será NULL. ¡Cuidado, es pesado para el servidor!
*/

-- Mostrar TODOS los clientes y TODAS las rentas, coincidan o no.
SELECT 
    c.first_name, 
    c.last_name,
    r.rental_date 
FROM public.customer c
FULL OUTER JOIN public.rental r 
    ON c.customer_id = r.customer_id;

