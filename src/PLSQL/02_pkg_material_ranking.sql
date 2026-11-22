/* =====================================================================
   Paquete pkg_material_ranking
   Puntaje de popularidad de los materiales y ranking por curso.
   Solo lee datos
   ===================================================================== */

CREATE OR REPLACE PACKAGE pkg_material_ranking AS

    -- Pesos del puntaje
    c_weight_views      CONSTANT NUMBER := 1;
    c_weight_downloads  CONSTANT NUMBER := 3;
    c_weight_comments   CONSTANT NUMBER := 2;
    c_weight_saves      CONSTANT NUMBER := 5;
    c_decay_days        CONSTANT NUMBER := 30;  -- cada 30 días de antigüedad el puntaje se divide entre un punto más

    -- Excepciones públicas
    e_material_not_found  EXCEPTION;  -- -20006: el material no existe
    PRAGMA EXCEPTION_INIT (e_material_not_found, -20006);

    e_course_not_found    EXCEPTION;  -- -20007: el curso no existe
    PRAGMA EXCEPTION_INIT (e_course_not_found, -20007);

    e_invalid_limit       EXCEPTION;  -- -20008: el límite del top debe ser >= 1
    PRAGMA EXCEPTION_INIT (e_invalid_limit, -20008);

    /* ---------------------------------------------------------------
       FUNCIÓN: fn_popularity_score

       FUNCIONALIDAD:
         Calcula el puntaje de popularidad de un material según la
         interacción que ha recibido:
           crudo   = vistas*1 + descargas*3 + comentarios*2 + guardados*5
           puntaje = crudo / (1 + días_desde_publicación / 30)
         El ajuste por antigüedad permite que un material nuevo con buena
         acogida compita con uno viejo que ya acumuló mucho.

       PARÁMETROS:
         p_material_id (IN) Material a evaluar.

       RETORNA:
         NUMBER con el puntaje, redondeado a 2 decimales.

       EXCEPCIONES:
         e_material_not_found si el material no existe.

       NOTA: solo lee datos, por lo que se puede usar dentro de un SELECT.
       --------------------------------------------------------------- */
    FUNCTION fn_popularity_score (
        p_material_id IN materials.material_id%TYPE
    ) RETURN NUMBER;

    /* ---------------------------------------------------------------
       PROCEDIMIENTO: sp_top_materials_by_course

       FUNCIONALIDAD:
         Devuelve en un cursor los N materiales más populares de un curso
         (de todos sus grupos y profesores), ordenados por
         fn_popularity_score de mayor a menor. El curso y el profesor de
         cada material salen de course_groups.

         Columnas: RANKING, MATERIAL_ID, TITLE, MATERIAL_TYPE,
         UPLOADED_BY, PROFESSOR, TERM, VIEWS_COUNT, DOWNLOADS_COUNT,
         POPULARITY_SCORE.

       PARÁMETROS:
         p_course_id (IN)  Curso a consultar.
         p_limit     (IN)  Cuántos materiales devolver (por defecto 10).
         p_result    (OUT) Cursor con el resultado; quien llama debe
                           cerrarlo (CLOSE).

       EXCEPCIONES:
         e_invalid_limit si p_limit es nulo o menor a 1;
         e_course_not_found si el curso no existe.
       --------------------------------------------------------------- */
    PROCEDURE sp_top_materials_by_course (
        p_course_id  IN  courses.course_id%TYPE,
        p_limit      IN  PLS_INTEGER DEFAULT 10,
        p_result     OUT SYS_REFCURSOR
    );

END pkg_material_ranking;
/
SHOW ERRORS


CREATE OR REPLACE PACKAGE BODY pkg_material_ranking AS

    FUNCTION fn_popularity_score (
        p_material_id IN materials.material_id%TYPE
    ) RETURN NUMBER
    IS
        v_views      materials.views_count%TYPE;
        v_downloads  materials.downloads_count%TYPE;
        v_pub_date   materials.publication_date%TYPE;
        v_comments   PLS_INTEGER;
        v_saves      PLS_INTEGER;
        v_raw        NUMBER;
        v_age_days   NUMBER;
    BEGIN
        SELECT m.views_count,
               m.downloads_count,
               m.publication_date,
               (SELECT COUNT(*) FROM material_comments c WHERE c.material_id = m.material_id),
               (SELECT COUNT(*) FROM saved_materials s   WHERE s.material_id = m.material_id)
          INTO v_views, v_downloads, v_pub_date, v_comments, v_saves
          FROM materials m
         WHERE m.material_id = p_material_id;

        v_raw := v_views     * c_weight_views
               + v_downloads * c_weight_downloads
               + v_comments  * c_weight_comments
               + v_saves     * c_weight_saves;

        v_age_days := GREATEST(0, TRUNC(SYSDATE) - TRUNC(v_pub_date));

        RETURN ROUND(v_raw / (1 + v_age_days / c_decay_days), 2);

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20006, 'El material ' || p_material_id || ' no existe.');
    END fn_popularity_score;


    PROCEDURE sp_top_materials_by_course (
        p_course_id  IN  courses.course_id%TYPE,
        p_limit      IN  PLS_INTEGER DEFAULT 10,
        p_result     OUT SYS_REFCURSOR
    )
    IS
        v_count PLS_INTEGER;
    BEGIN
        IF p_limit IS NULL OR p_limit < 1 THEN
            RAISE_APPLICATION_ERROR(-20008, 'El límite debe ser mayor o igual a 1.');
        END IF;

        SELECT COUNT(*) INTO v_count FROM courses WHERE course_id = p_course_id;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20007, 'El curso ' || p_course_id || ' no existe.');
        END IF;

        -- Se numera el ranking y se recorta al top sin FETCH FIRST (compatible con Oracle 11g)
        OPEN p_result FOR
            SELECT r.ranking, r.material_id, r.title, r.material_type, r.uploaded_by,
                   r.professor, r.term, r.views_count, r.downloads_count, r.popularity_score
              FROM (SELECT ROW_NUMBER() OVER (ORDER BY t.popularity_score DESC, t.material_id) AS ranking,
                           t.material_id, t.title, t.material_type, t.uploaded_by,
                           t.professor, t.term, t.views_count, t.downloads_count, t.popularity_score
                      FROM (SELECT m.material_id,
                                   m.title,
                                   mt.name                            AS material_type,
                                   s.name                             AS uploaded_by,
                                   p.first_name || ' ' || p.last_name AS professor,
                                   cg.term,
                                   m.views_count,
                                   m.downloads_count,
                                   pkg_material_ranking.fn_popularity_score(m.material_id) AS popularity_score
                              FROM materials m
                              JOIN course_groups  cg ON cg.course_group_id  = m.course_group_id
                              JOIN professors     p  ON p.professor_id      = cg.professor_id
                              JOIN material_types mt ON mt.material_type_id = m.material_type_id
                              JOIN students       s  ON s.student_id        = m.student_id
                             WHERE cg.course_id = p_course_id) t) r
             WHERE r.ranking <= p_limit
             ORDER BY r.ranking;
    END sp_top_materials_by_course;

END pkg_material_ranking;
/
SHOW ERRORS
