/* =====================================================================
   PROYECTO SID - Entrega 3
   Casos de prueba del trigger TRG_VALIDA_PUBLICACION_MATERIAL

   Requiere: DDL, DML y el trigger ya creados.
   Usa datos reales del DML:
   - Estudiante 1 (Laura Camila Pérez)  -> Universidad Icesi (inst. 1)
   - Estudiante 4 (Daniel Esteban López) -> Universidad del Valle (inst. 2)
   - Grupo 1 -> profesor 1 (Carlos Ramírez) -> Universidad Icesi (inst. 1)
   Los ids 9001 a 9005 no existen en el DML, así que no chocan.
   ===================================================================== */
SET SERVEROUTPUT ON;

-- 1. CASO EXITOSO: estudiante y profesor del grupo son de la misma institución
--    y la fecha es válida. Inserta sin error.
INSERT INTO materials (
    material_id, material_type_id, course_group_id, student_id,
    title, publication_date, downloads_count, description, views_count, file_url
) VALUES (
    9001, 1, 1, 1,
    'Resumen Examen Parcial 1', SYSDATE, 0,
    'Guía completa de preparación con ejercicios resueltos.', 0, 'https://sid.example.com/materiales/m9001.pdf'
);
-- Resultado esperado: 1 fila creada.

-- 2. CASO FALLIDO 1: estudiante de otra institución (dispara ORA-20001)
--    El estudiante 4 es de Univalle y el grupo 1 lo dicta un profesor de Icesi.
INSERT INTO materials (
    material_id, material_type_id, course_group_id, student_id,
    title, publication_date, downloads_count, description, views_count, file_url
) VALUES (
    9002, 1, 1, 4,
    'Taller no permitido', SYSDATE, 0,
    'Prueba de validación institucional', 0, 'https://sid.example.com/materiales/m9002.pdf'
);
-- Resultado esperado: ORA-20001: ... no puede subir material al grupo 1 porque
-- pertenece a una institución distinta a la del docente ...

-- 3. CASO FALLIDO 2: fecha de publicación futura (dispara ORA-20002)
INSERT INTO materials (
    material_id, material_type_id, course_group_id, student_id,
    title, publication_date, downloads_count, description, views_count, file_url
) VALUES (
    9003, 1, 1, 1,
    'Notas Semana Futura', SYSDATE + 10, 0,
    'Prueba de validación de fecha', 0, 'https://sid.example.com/materiales/m9003.pdf'
);
-- Resultado esperado: ORA-20002: La fecha de publicación (...) no puede ser futura ...

-- 4. CASO FALLIDO 3: grupo que no existe (dispara ORA-20003)
INSERT INTO materials (
    material_id, material_type_id, course_group_id, student_id,
    title, publication_date, downloads_count, description, views_count, file_url
) VALUES (
    9004, 1, 999, 1,
    'Material en grupo inexistente', SYSDATE, 0,
    'Prueba de integridad', 0, 'https://sid.example.com/materiales/m9004.pdf'
);
-- Resultado esperado: ORA-20003: El estudiante o el grupo especificado no existen.

-- 5. CASO EXITOSO EN UPDATE: el trigger también corre al actualizar.
--    El material 1 es del estudiante 1 en el grupo 1 (misma institución), así que
--    subirle las visitas funciona.
UPDATE materials SET views_count = views_count + 1 WHERE material_id = 1;
-- Resultado esperado: 1 fila actualizada.

-- Se deshace todo lo de la prueba para dejar la base como estaba
ROLLBACK;
