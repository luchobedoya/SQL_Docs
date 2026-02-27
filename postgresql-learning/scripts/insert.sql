
/* ============================================================================
   Autor: Luis Bedoya
   Fecha: 2026-02-26
   Tema: Inserción de Datos (INSERT INTO, RETURNING y Batch Inserts)
   Base de Datos: dvdrental (Tabla: customer)
============================================================================ */

-- ----------------------------------------------------------------------------
-- 1. INSERCIÓN BÁSICA CON BUENAS PRÁCTICAS
-- ----------------------------------------------------------------------------
/* NOTA: Siempre nombramos las columnas explícitamente. 
   Omitimos 'active', 'activebool' y 'create_date' porque la tabla 
   ya tiene configurados valores por defecto (DEFAULT) para ellas.
*/

INSERT INTO public.customer (
    store_id, 
    first_name, 
    last_name, 
    email, 
    address_id
) 
VALUES (
    1, 
    'Amin', 
    'Espinoza', 
    'amin.espinoza@mail.com', 
    5
);

-- ----------------------------------------------------------------------------
-- 2. EL SUPERPODER DE POSTGRESQL: RETURNING
-- ----------------------------------------------------------------------------
/* PRO-TIP: RETURNING evita tener que hacer un SELECT inmediatamente 
   después de un INSERT para averiguar qué ID (Primary Key) generó la base de datos.
*/

INSERT INTO public.customer (store_id, first_name, last_name, email, address_id) 
VALUES (2, 'Sofia', 'Vergara', 'sofia.v@mail.com', 6)
RETURNING customer_id, create_date;


-- ----------------------------------------------------------------------------
-- 3. INSERCIÓN MÚLTIPLE (BATCH INSERT)
-- ----------------------------------------------------------------------------
/* NOTA: Insertar múltiples registros en una sola consulta es 
   extremadamente más rápido que hacer múltiples sentencias INSERT individuales.
*/

INSERT INTO public.customer (store_id, first_name, last_name, email, address_id) 
VALUES 
    (1, 'Carlos', 'Santana', 'carlos.s@mail.com', 7),
    (2, 'Pedro', 'Pascal', 'pedro.p@mail.com', 8),
    (1, 'Salma', 'Hayek', 'salma.h@mail.com', 9)
RETURNING customer_id, first_name;



