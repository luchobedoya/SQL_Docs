
/* ============================================================================
   Autor: Luis Bedoya
   Fecha: 2026-03-04
   Tema: Masterclass - CRUD Completo, Vistas (Views) y Funciones (PL/pgSQL)
   Base de Datos: dvdrental
============================================================================ */

-- ============================================================================
-- 1. REPASO CRUD (Create, Read, Update, Delete) CON BUENAS PRÁCTICAS
-- ============================================================================

-- CREATE (Insertar con RETURNING para evitar doble viaje)
INSERT INTO public.customer (store_id, first_name, last_name, email, address_id) 
VALUES (1, 'Luis', 'Bedoya', 'luis.b@email.com', 5)
RETURNING customer_id;

-- READ (Leer usando JOINs y Alias explícitos)
SELECT c.first_name, c.last_name, a.address
FROM public.customer c
INNER JOIN public.address a ON c.address_id = a.address_id
WHERE c.first_name = 'Luis';

-- UPDATE (Modificar con WHERE estricto y actualizando el timestamp)
UPDATE public.customer
SET email = 'luis.profesional@email.com',
    last_update = CURRENT_TIMESTAMP
WHERE first_name = 'Luis' AND last_name = 'Bedoya'
RETURNING customer_id, email;

-- DELETE (Borrado seguro envuelto en una Transacción)
BEGIN;
DELETE FROM public.customer WHERE email = 'luis.profesional@email.com';
COMMIT; -- (O ROLLBACK si hubo un error)


-- ============================================================================
-- 2. VISTAS (VIEWS): GUARDANDO CONSULTAS COMPLEJAS
-- ============================================================================
/* PRO-TIP DBA: Una vista es como una "tabla virtual". No guarda datos, 
   guarda la consulta. Es ideal para que los analistas de BI (Tableau, PowerBI) 
   o los programadores Frontend consuman datos complejos sin tener que 
   escribir los JOINs gigantes cada vez.
*/

-- Buena práctica: Usar CREATE OR REPLACE y el prefijo 'vw_' (View)
CREATE OR REPLACE VIEW public.vw_clientes_vip_resumen AS
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    COUNT(r.rental_id) AS total_rentas,
    SUM(p.amount) AS total_gastado
FROM public.customer c
INNER JOIN public.rental r ON c.customer_id = r.customer_id
INNER JOIN public.payment p ON r.rental_id = p.rental_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(r.rental_id) > 20;

-- ¿Cómo se usa? ¡Como si fuera una tabla normal y súper simple!
-- SELECT * FROM public.vw_clientes_vip_resumen ORDER BY total_gastado DESC;


-- ============================================================================
-- 3. FUNCIONES (FUNCTIONS): LÓGICA DE NEGOCIO EN LA BASE DE DATOS
-- ============================================================================
/* PRO-TIP DBA: Las funciones encapsulan lógica. Si necesitas calcular algo 
   repetitivamente (como el total de dinero que ha gastado un cliente específico), 
   creas una función. En Postgres usamos el lenguaje PL/pgSQL.
*/

-- Buena práctica: Usar el prefijo 'fn_' (Function) y 'p_' para los parámetros
CREATE OR REPLACE FUNCTION public.fn_obtener_total_gastado(p_cliente_id INT)
RETURNS NUMERIC AS $$
DECLARE
    v_total_gastado NUMERIC; -- Variable interna para guardar el resultado
BEGIN
    -- Hacemos la consulta y guardamos el resultado (INTO) en la variable
    SELECT SUM(amount) INTO v_total_gastado
    FROM public.payment
    WHERE customer_id = p_cliente_id;

    -- Buena práctica: Si el cliente no tiene pagos (NULL), devolvemos 0
    RETURN COALESCE(v_total_gastado, 0);
END;
$$ LANGUAGE plpgsql;

-- ¿Cómo se usa? La llamas dentro de un SELECT pasándole el ID del cliente
-- SELECT public.fn_obtener_total_gastado(1) AS gasto_del_cliente_1;