/* =====================================================================
    Paquete pkg_material_publishing
   Publicación de material de estudio. Requiere seq_materials (00).
   ===================================================================== */

CREATE OR REPLACE PACKAGE pkg_material_publishing AS

    -- Excepciones públicas (se pueden capturar por nombre)
    e_student_not_found       EXCEPTION;  -- -20001: el estudiante no existe
    PRAGMA EXCEPTION_INIT (e_student_not_found, -20001);

    e_group_not_found         EXCEPTION;  -- -20002: el grupo no existe
    PRAGMA EXCEPTION_INIT (e_group_not_found, -20002);

    e_student_not_enrolled    EXCEPTION;  -- -20003: el estudiante no está matriculado en el grupo
    PRAGMA EXCEPTION_INIT (e_student_not_enrolled, -20003);

    e_material_type_not_found EXCEPTION;  -- -20004: el tipo de material no existe
    PRAGMA EXCEPTION_INIT (e_material_type_not_found, -20004);

    e_invalid_data            EXCEPTION;  -- -20005: título, descripción o URL vacíos o demasiado largos
    PRAGMA EXCEPTION_INIT (e_invalid_data, -20005);

    /* ---------------------------------------------------------------
       PROCEDIMIENTO: sp_publish_material

       FUNCIONALIDAD:
         Publica un material de estudio en un grupo. Valida que el
         título, la descripción y el enlace no estén vacíos, que existan
         el estudiante, el grupo y el tipo de material, y que el
         estudiante esté matriculado en ese grupo (course_enrollments).
         Si todo es válido, inserta el material con fecha de publicación
         SYSDATE y con vistas y descargas en 0, y devuelve su id.

       PARÁMETROS:
         p_student_id       (IN)  Estudiante que publica.
         p_course_group_id  (IN)  Grupo al que se sube el material.
         p_material_type_id (IN)  Tipo de material (libro, examen, ...).
         p_title            (IN)  Título.
         p_description      (IN)  Descripción del contenido.
         p_file_url         (IN)  Enlace donde está el archivo.
         p_material_id      (OUT) Id del material creado.

       EXCEPCIONES: las cinco definidas arriba.
       --------------------------------------------------------------- */
    PROCEDURE sp_publish_material (
        p_student_id        IN  students.student_id%TYPE,
        p_course_group_id   IN  course_groups.course_group_id%TYPE,
        p_material_type_id  IN  material_types.material_type_id%TYPE,
        p_title             IN  materials.title%TYPE,
        p_description       IN  materials.description%TYPE,
        p_file_url          IN  materials.file_url%TYPE,
        p_material_id       OUT materials.material_id%TYPE
    );

END pkg_material_publishing;
/
SHOW ERRORS


CREATE OR REPLACE PACKAGE BODY pkg_material_publishing AS

    -- ORA-12899: valor más largo que la columna (se convierte en e_invalid_data)
    e_value_too_large  EXCEPTION;
    PRAGMA EXCEPTION_INIT (e_value_too_large, -12899);

    -- Validaciones privadas
    FUNCTION student_exists (p_student_id IN students.student_id%TYPE)
        RETURN BOOLEAN
    IS
        v_count PLS_INTEGER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM students WHERE student_id = p_student_id;
        RETURN v_count > 0;
    END student_exists;

    FUNCTION group_exists (p_course_group_id IN course_groups.course_group_id%TYPE)
        RETURN BOOLEAN
    IS
        v_count PLS_INTEGER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM course_groups WHERE course_group_id = p_course_group_id;
        RETURN v_count > 0;
    END group_exists;

    FUNCTION material_type_exists (p_material_type_id IN material_types.material_type_id%TYPE)
        RETURN BOOLEAN
    IS
        v_count PLS_INTEGER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM material_types WHERE material_type_id = p_material_type_id;
        RETURN v_count > 0;
    END material_type_exists;

    FUNCTION is_enrolled (
        p_student_id      IN students.student_id%TYPE,
        p_course_group_id IN course_groups.course_group_id%TYPE
    ) RETURN BOOLEAN
    IS
        v_count PLS_INTEGER;
    BEGIN
        SELECT COUNT(*)
          INTO v_count
          FROM course_enrollments
         WHERE student_id      = p_student_id
           AND course_group_id = p_course_group_id;
        RETURN v_count > 0;
    END is_enrolled;


    PROCEDURE sp_publish_material (
        p_student_id        IN  students.student_id%TYPE,
        p_course_group_id   IN  course_groups.course_group_id%TYPE,
        p_material_type_id  IN  material_types.material_type_id%TYPE,
        p_title             IN  materials.title%TYPE,
        p_description       IN  materials.description%TYPE,
        p_file_url          IN  materials.file_url%TYPE,
        p_material_id       OUT materials.material_id%TYPE
    )
    IS
        v_new_id materials.material_id%TYPE;
    BEGIN
        p_material_id := NULL;

        -- En Oracle una cadena vacía es NULL
        IF TRIM(p_title) IS NULL THEN
            RAISE_APPLICATION_ERROR(-20005, 'El título del material es obligatorio.');
        END IF;
        IF TRIM(p_description) IS NULL THEN
            RAISE_APPLICATION_ERROR(-20005, 'La descripción del material es obligatoria.');
        END IF;
        IF TRIM(p_file_url) IS NULL THEN
            RAISE_APPLICATION_ERROR(-20005, 'El enlace del archivo es obligatorio.');
        END IF;

        IF NOT student_exists(p_student_id) THEN
            RAISE_APPLICATION_ERROR(-20001, 'El estudiante ' || p_student_id || ' no existe.');
        END IF;
        IF NOT group_exists(p_course_group_id) THEN
            RAISE_APPLICATION_ERROR(-20002, 'El grupo ' || p_course_group_id || ' no existe.');
        END IF;
        IF NOT material_type_exists(p_material_type_id) THEN
            RAISE_APPLICATION_ERROR(-20004, 'El tipo de material ' || p_material_type_id || ' no existe.');
        END IF;

        -- Solo publica quien cursa el grupo
        IF NOT is_enrolled(p_student_id, p_course_group_id) THEN
            RAISE_APPLICATION_ERROR(-20003,
                'El estudiante ' || p_student_id || ' no está matriculado en el grupo '
                || p_course_group_id || '.');
        END IF;

        v_new_id := seq_materials.NEXTVAL;

        INSERT INTO materials (
            material_id, material_type_id, course_group_id, student_id,
            title, publication_date, downloads_count, description,
            views_count, file_url
        ) VALUES (
            v_new_id, p_material_type_id, p_course_group_id, p_student_id,
            TRIM(p_title), SYSDATE, 0, TRIM(p_description),
            0, TRIM(p_file_url)
        );

        p_material_id := v_new_id;

    EXCEPTION
        WHEN e_value_too_large THEN
            RAISE_APPLICATION_ERROR(-20005,
                'El título (máx. 200), la descripción (máx. 1000) o el enlace (máx. 500) es demasiado largo.');
    END sp_publish_material;

END pkg_material_publishing;
/
SHOW ERRORS
