
/* ============================================================================
   Repositorio: Master en PostgreSQL y Análisis de Datos
   Autor: Luis Bedoya
   Fecha: 2026-03-05
   Descripción: Script de referencia integral que abarca desde consultas 
                básicas (DQL) hasta manipulación de datos (DML), definición 
                de tablas (DDL) y conceptos de arquitectura.
============================================================================ */


/* ============================================================================
   1. DQL (Data Query Language) - EXTRACCIÓN Y FILTRADO AVANZADO
============================================================================ */

-- A. Rangos Inclusivos y Ordenamiento
/* Explicación: BETWEEN incluye los extremos (5 y 8). ORDER BY ASC ordena de 
   menor a mayor. Es la forma más limpia y optimizada de filtrar rangos matemáticos. */
SELECT * FROM public.payment 
WHERE amount BETWEEN 5 AND 8 
ORDER BY amount ASC;

-- B. Filtros Complejos (AND, LIKE, IN)
/* Explicación: El operador AND actúa como un embudo estricto; ambas condiciones 
   deben ser verdaderas. LIKE 'A%' busca patrones (empieza con A) e IN busca 
   coincidencias exactas en una lista, reduciendo filas rápidamente. */
SELECT * FROM public.film 
WHERE title LIKE 'A%' 
  AND last_name IN ('Smith', 'Jones');

-- C. Operaciones de Conjuntos (UNION)
/* Explicación: UNION combina los resultados de dos consultas distintas en una sola 
   columna. El ORDER BY siempre debe ir al final de la consulta global para 
   ordenar el resultado final (en este caso, 'empleado' antes que 'cliente' por orden DESC). */
SELECT nombre, 'empleado' AS tipo 
FROM empleados
UNION
SELECT nombre, 'cliente' AS tipo 
FROM clientes
ORDER BY tipo DESC;


/* ============================================================================
   2. MANEJO DEL TIEMPO (FECHAS Y TIMESTAMP)
============================================================================ */

-- A. Extracción Básica (Regla de Oro)
/* Explicación: EXTRACT saca partes específicas de una fecha. 
   Regla de Oro: Nunca usar 'año' con la 'ñ' en los alias para evitar que el 
   código se rompa al conectarlo con Python o herramientas de BI. */
SELECT 
    EXTRACT(YEAR FROM rental_date) AS anio, 
    EXTRACT(MONTH FROM rental_date) AS mes
FROM public.rental;

--
