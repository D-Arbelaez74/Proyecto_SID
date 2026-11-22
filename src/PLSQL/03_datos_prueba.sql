/* =====================================================================
   Datos de prueba y demostración
   Requiere el DDL y los scripts 00, 01 y 02.

   Carga un mini escenario, prueba el procedimiento y la función (con
   casos de éxito y de error)
   ===================================================================== */

SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF

ROLLBACK;


-- Datos base
INSERT INTO institutions (institution_id, name, city) VALUES (901, 'Universidad de Prueba SID', 'Cali');

INSERT INTO professors (professor_id, first_name, last_name, email, institution_id)
VALUES (9001, 'Ana', 'Gomez', 'ana.gomez@sid.test', 901);
INSERT INTO professors (professor_id, first_name, last_name, email, institution_id)
VALUES (9002, 'Luis', 'Mora', 'luis.mora@sid.test', 901);

INSERT INTO courses (course_id, course_name, credits) VALUES (9101, 'Sistemas Intensivos en Datos', 3);
INSERT INTO courses (course_id, course_name, credits) VALUES (9102, 'Bases de Datos Avanzadas', 3);

INSERT INTO material_types (material_type_id, name) VALUES (901, 'Examen');
INSERT INTO material_types (material_type_id, name) VALUES (902, 'Taller');
INSERT INTO material_types (material_type_id, name) VALUES (903, 'Nota');
INSERT INTO material_types (material_type_id, name) VALUES (904, 'Tip');

INSERT INTO students (student_id, name, email, institution_id) VALUES (900001, 'Laura Perez', 'laura.perez@sid.test', 901);
INSERT INTO students (student_id, name, email, institution_id) VALUES (900002, 'Carlos Ruiz', 'carlos.ruiz@sid.test', 901);
INSERT INTO students (student_id, name, email, institution_id) VALUES (900003, 'Marta Diaz', 'marta.diaz@sid.test', 901);

-- Grupos 901 y 902: curso 9101 (profesores distintos). Grupo 903: curso 9102.
INSERT INTO course_groups (course_group_id, professor_id, course_id, term) VALUES (901, 9001, 9101, '2026-2');
INSERT INTO course_groups (course_group_id, professor_id, course_id, term) VALUES (902, 9002, 9101, '2026-2');
INSERT INTO course_groups (course_group_id, professor_id, course_id, term) VALUES (903, 9001, 9102, '2026-2');

-- Marta (900003) no está matriculada en ningún grupo
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (900001, 901);
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (900002, 901);
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (900001, 902);
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (900002, 903);


-- Materiales creados con el procedimiento; luego se ajustan contadores y
-- fechas para tener un ranking con diferencias, y se agregan comentarios y guardados.
DECLARE
    v_m1 materials.material_id%TYPE;
    v_m2 materials.material_id%TYPE;
    v_m3 materials.material_id%TYPE;
    v_m4 materials.material_id%TYPE;
    v_m5 materials.material_id%TYPE;
BEGIN
    pkg_material_publishing.sp_publish_material(900001, 901, 903,
        'Resumen de normalización 3FN', 'Resumen de 1FN a 3FN con ejemplos.', 'https://sid.test/3fn.pdf', v_m1);
    pkg_material_publishing.sp_publish_material(900002, 901, 901,
        'Parcial 1 resuelto', 'Solución paso a paso del primer parcial.', 'https://sid.test/parcial1.pdf', v_m2);
    pkg_material_publishing.sp_publish_material(900001, 902, 902,
        'Taller de SQL con soluciones', 'Ejercicios de joins y subconsultas.', 'https://sid.test/taller_sql.pdf', v_m3);
    pkg_material_publishing.sp_publish_material(900001, 901, 904,
        'Tip: índices en llaves foráneas', 'Por qué indexar las FK en Oracle.', 'https://sid.test/tip.pdf', v_m4);
    pkg_material_publishing.sp_publish_material(900002, 903, 903,
        'Notas de Bases de Datos Avanzadas', 'Apuntes de las primeras clases.', 'https://sid.test/bda.pdf', v_m5);

    UPDATE materials SET views_count = 120, downloads_count = 30, publication_date = SYSDATE - 60 WHERE material_id = v_m1;
    UPDATE materials SET views_count =  80, downloads_count = 45, publication_date = SYSDATE -  5 WHERE material_id = v_m2;
    UPDATE materials SET views_count = 200, downloads_count = 60, publication_date = SYSDATE - 90 WHERE material_id = v_m3;
    UPDATE materials SET views_count =  10, downloads_count =  2, publication_date = SYSDATE -  1 WHERE material_id = v_m4;
    UPDATE materials SET views_count =  50, downloads_count = 10, publication_date = SYSDATE - 10 WHERE material_id = v_m5;

    INSERT INTO material_comments (comment_id, student_id, material_id, content, comment_date) VALUES (900001, 900002, v_m1, 'Muy claro, gracias.', SYSDATE - 50);
    INSERT INTO material_comments (comment_id, student_id, material_id, content, comment_date) VALUES (900002, 900003, v_m1, 'Faltó un ejemplo de 2FN.', SYSDATE - 40);
    INSERT INTO material_comments (comment_id, student_id, material_id, content, comment_date) VALUES (900003, 900001, v_m2, 'Corrección en el punto 3.', SYSDATE - 3);
    INSERT INTO material_comments (comment_id, student_id, material_id, content, comment_date) VALUES (900004, 900003, v_m2, 'Me salvó para el examen.', SYSDATE - 2);
    INSERT INTO material_comments (comment_id, student_id, material_id, content, comment_date) VALUES (900005, 900002, v_m3, 'Buenos ejercicios.', SYSDATE - 70);
    INSERT INTO material_comments (comment_id, student_id, material_id, content, comment_date) VALUES (900006, 900001, v_m5, 'Buen resumen de la clase 1.', SYSDATE - 8);

    INSERT INTO saved_materials (student_id, material_id, saved_date) VALUES (900002, v_m1, SYSDATE - 49);
    INSERT INTO saved_materials (student_id, material_id, saved_date) VALUES (900001, v_m2, SYSDATE - 4);
    INSERT INTO saved_materials (student_id, material_id, saved_date) VALUES (900003, v_m2, SYSDATE - 3);
    INSERT INTO saved_materials (student_id, material_id, saved_date) VALUES (900002, v_m3, SYSDATE - 60);
    INSERT INTO saved_materials (student_id, material_id, saved_date) VALUES (900003, v_m4, SYSDATE - 1);
END;
/


-- 1. sp_publish_material: publicación exitosa
PROMPT === 1. Publicación exitosa ===
DECLARE
    v_id materials.material_id%TYPE;
BEGIN
    pkg_material_publishing.sp_publish_material(
        p_student_id       => 900002,
        p_course_group_id  => 901,
        p_material_type_id => 902,
        p_title            => 'Taller de normalización',
        p_description      => 'Ejercicios para practicar 1FN, 2FN y 3FN.',
        p_file_url         => 'https://sid.test/taller_norm.pdf',
        p_material_id      => v_id);
    DBMS_OUTPUT.PUT_LINE('Material publicado con id = ' || v_id);
END;
/

-- 2. sp_publish_material: casos de error
PROMPT === 2. Casos de error al publicar ===
DECLARE
    v_id materials.material_id%TYPE;
BEGIN
    BEGIN  -- estudiante no matriculado en el grupo
        pkg_material_publishing.sp_publish_material(900003, 901, 903, 'Intento', 'Sin matrícula.', 'https://sid.test/x.pdf', v_id);
    EXCEPTION
        WHEN pkg_material_publishing.e_student_not_enrolled THEN
            DBMS_OUTPUT.PUT_LINE('No matriculado -> ' || SQLERRM);
    END;

    BEGIN  -- grupo que no existe
        pkg_material_publishing.sp_publish_material(900001, 999, 903, 'Título', 'Descripción', 'https://sid.test/x.pdf', v_id);
    EXCEPTION
        WHEN pkg_material_publishing.e_group_not_found THEN
            DBMS_OUTPUT.PUT_LINE('Grupo inexistente -> ' || SQLERRM);
    END;

    BEGIN  -- título vacío
        pkg_material_publishing.sp_publish_material(900001, 901, 903, '   ', 'Descripción', 'https://sid.test/x.pdf', v_id);
    EXCEPTION
        WHEN pkg_material_publishing.e_invalid_data THEN
            DBMS_OUTPUT.PUT_LINE('Datos inválidos -> ' || SQLERRM);
    END;
END;
/

-- 3. fn_popularity_score dentro de un SELECT
--    Esperado: Parcial 1 = 196.29, Taller de SQL = 96.75, Resumen 3FN = 73.00,
--    Notas BD Avanzadas = 61.50, Tip = 20.32 y el material nuevo = 0.
--    El Taller de SQL tiene el mayor puntaje crudo, pero baja por sus 90 días de antigüedad.
PROMPT === 3. Puntaje por material ===
SELECT m.material_id,
       m.title,
       m.views_count,
       m.downloads_count,
       pkg_material_ranking.fn_popularity_score(m.material_id) AS popularity_score
  FROM materials m
 WHERE m.course_group_id IN (901, 902, 903)
 ORDER BY popularity_score DESC;

-- 4. sp_top_materials_by_course: top 3 del curso 9101
--    (el material del curso 9102 no debe aparecer)
PROMPT === 4. Top 3 del curso 9101 ===
DECLARE
    v_cur        SYS_REFCURSOR;
    v_ranking    NUMBER;
    v_id         materials.material_id%TYPE;
    v_title      materials.title%TYPE;
    v_type       material_types.name%TYPE;
    v_uploaded   students.name%TYPE;
    v_professor  VARCHAR2(250);
    v_term       course_groups.term%TYPE;
    v_views      materials.views_count%TYPE;
    v_downloads  materials.downloads_count%TYPE;
    v_score      NUMBER;
BEGIN
    pkg_material_ranking.sp_top_materials_by_course(
        p_course_id => 9101,
        p_limit     => 3,
        p_result    => v_cur);

    LOOP
        FETCH v_cur INTO v_ranking, v_id, v_title, v_type, v_uploaded,
                         v_professor, v_term, v_views, v_downloads, v_score;
        EXIT WHEN v_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('#' || v_ranking || ' ' || RPAD(v_title, 32) || ' | '
            || RPAD(v_type, 7) || ' | prof. ' || RPAD(v_professor, 10)
            || ' | puntaje ' || TO_CHAR(v_score, 'FM9990.00'));
    END LOOP;

    CLOSE v_cur;
END;
/

-- 5. Curso inexistente
PROMPT === 5. Curso inexistente ===
DECLARE
    v_cur SYS_REFCURSOR;
BEGIN
    pkg_material_ranking.sp_top_materials_by_course(99999, 5, v_cur);
EXCEPTION
    WHEN pkg_material_ranking.e_course_not_found THEN
        DBMS_OUTPUT.PUT_LINE('Curso inexistente -> ' || SQLERRM);
END;
/

-- Se deshace todo lo de la prueba
ROLLBACK;
