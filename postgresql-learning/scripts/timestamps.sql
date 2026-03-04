
/* ============================================================================
   Autor: Luis Bedoya
   Fecha: 2026-03-03
   Tema: Funciones de Fecha y Tiempo (EXTRACT, TO_CHAR, DATE_TRUNC)
   Base de Datos: dvdrental
============================================================================ */

-- ----------------------------------------------------------------------------
-- 1. EXTRACCIÓN BÁSICA DE COMPONENTES
-- ----------------------------------------------------------------------------
/* NOTA: Usamos 'anio' en lugar de 'año' para evitar errores de codificación
   en sistemas externos o lenguajes de programación.
*/

SELECT 
    rental_date,
    EXTRACT(YEAR FROM rental_date) AS anio,
    EXTRACT(MONTH FROM rental_date) AS mes_num,
    EXTRACT(DAY FROM rental_date) AS dia,
    EXTRACT(DOW FROM rental_date) AS dia_semana -- 0 es Domingo, 6 es Sábado
FROM public.rental;


-- ----------------------------------------------------------------------------
-- 2. FORMATEO AVANZADO (Nombres de meses y días)
-- ----------------------------------------------------------------------------
/* PRO-TIP: TO_CHAR es mucho más flexible para reportes visuales, ya que permite
   obtener el nombre del mes en texto.
*/

SELECT 
    rental_id,
    TO_CHAR(rental_date, 'Month') AS mes_nombre,
    TO_CHAR(rental_date, 'Day') AS dia_nombre,
    TO_CHAR(rental_date, 'DD/MM/YYYY HH24:MI') AS fecha_formateada
FROM public.rental;


-- ----------------------------------------------------------------------------
-- 3. EL FAVORITO DE LOS ANALISTAS: DATE_TRUNC
-- ----------------------------------------------------------------------------
/* NOTA: Sirve para agrupar ventas por mes completo, sin separar los días.
   Ideal para gráficos de líneas de crecimiento mensual.
*/

SELECT 
    DATE_TRUNC('month', rental_date) AS mes_periodo,
    COUNT(rental_id) AS total_rentas
FROM public.rental
GROUP BY mes_periodo
ORDER BY mes_periodo DESC;