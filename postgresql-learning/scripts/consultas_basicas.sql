/* ============================================================================
   Autor: Luis Bedoya
   Fecha: 2026-02-25
   Tema: Consultas Básicas, Filtros de Fecha, Búsquedas de Texto (LIKE) y Listas (IN)
   Base de Datos: dvdrental
============================================================================ */

-- ----------------------------------------------------------------------------
-- 1. ORDENAMIENTO DE DATOS (ORDER BY)
-- ----------------------------------------------------------------------------

-- Orden ascendente (Por defecto, de la A a la Z)
SELECT actor_id, first_name, last_name 
FROM public.actor 
ORDER BY first_name ASC;

-- Orden descendente (De la Z a la A)
SELECT actor_id, first_name, last_name 
FROM public.actor 
ORDER BY first_name DESC;

-- Orden descendente controlando los valores Nulos (Buena práctica)
SELECT actor_id, first_name, last_name 
FROM public.actor 
ORDER BY first_name DESC NULLS LAST;


-- ----------------------------------------------------------------------------
-- 2. FILTRADO DE RANGOS NUMÉRICOS (BETWEEN)
-- ----------------------------------------------------------------------------

-- Filtrar pagos que estén entre 5 y 8 (Inclusivo)
SELECT payment_id, amount, payment_date
FROM public.payment 
WHERE amount BETWEEN 5 AND 8;


-- ----------------------------------------------------------------------------
-- 3. ALIAS Y BUENAS PRÁCTICAS DE NOMENCLATURA (AS)
-- ----------------------------------------------------------------------------

-- Renombrar columnas para la aplicación final (CamelCase o snake_case)
SELECT 
    payment_id AS id_pago, 
    amount AS monto_total
FROM public.payment;


-- ----------------------------------------------------------------------------
-- 4. MANEJO EXPERTO DE FECHAS
-- ----------------------------------------------------------------------------

/* NOTA: Para rangos de fechas con hora (timestamps), evitamos BETWEEN.
  Usamos >= para el inicio y < (menor estricto) para el día siguiente al final.
  Esto garantiza que no perdamos registros por fracciones de hora/segundo.
*/
SELECT actor_id, first_name, last_update 
FROM public.actor 
WHERE last_update >= '1998-05-26' 
  AND last_update < '2013-05-26';


-- ----------------------------------------------------------------------------
-- 5. BÚSQUEDAS DE TEXTO SENSIBLES A MAYÚSCULAS (LIKE)
-- ----------------------------------------------------------------------------

/* NOTA: El comodín '%' al final permite usar índices (búsqueda rápida).
   El comodín al inicio (ej. '%Af%') fuerza un escaneo completo de la tabla,
   lo cual degrada el rendimiento en tablas gigantes. 
*/

-- Buscar películas que empiecen exactamente con "Af" (Mayúscula obligatoria)
SELECT film_id, title, release_year
FROM public.film
WHERE title LIKE 'Af%';


-- ----------------------------------------------------------------------------
-- 6. BÚSQUEDAS IGNORANDO MAYÚSCULAS/MINÚSCULAS (ILIKE)
-- ----------------------------------------------------------------------------

/* PRO-TIP PostgreSQL: ILIKE es exclusivo de Postgres y hace búsquedas 
   'Case-Insensitive'. Ideal para buscadores web donde el usuario
   escribe todo en minúsculas.
*/

-- Encontrará 'chase', 'CHASE', 'Chase', etc.
SELECT actor_id, first_name, last_name
FROM public.actor
WHERE last_name ILIKE 'chase%';


-- ----------------------------------------------------------------------------
-- 7. FILTRADO POR LISTAS DE VALORES (IN)
-- ----------------------------------------------------------------------------

/* NOTA: Usar IN es mucho más eficiente y legible que encadenar múltiples 
   condiciones OR. Postgres lo optimiza excelente con índices B-Tree.
*/

-- Buscar actores de apellidos específicos
SELECT 
    actor_id AS id_actor, 
    first_name AS nombre, 
    last_name AS apellido
FROM public.actor
WHERE last_name IN ('Chase', 'Nicholson', 'Mostel')
ORDER BY last_name ASC, first_name ASC;


-- ----------------------------------------------------------------------------
-- 8. EL INVERSO: EXCLUIR DE UNA LISTA (NOT IN)
-- ----------------------------------------------------------------------------

/* PRO-TIP: ¡Cuidado con los nulos! Si la lista dentro del NOT IN 
   llega a contener un NULL, la consulta entera devolverá cero registros.
*/

-- Traer todos los actores EXCEPTO los de esta lista
SELECT 
    actor_id, first_name, last_name
FROM public.actor
WHERE last_name NOT IN ('Chase', 'Nicholson', 'Mostel')
ORDER BY last_name ASC;


----------------------

