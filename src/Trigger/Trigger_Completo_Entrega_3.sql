/* =====================================================================
   PROYECTO SID - Plataforma para compartir conocimiento de estudio
   Entrega 3 - Script PL/SQL: Trigger de Validación de Publicaciones
   Rol: Persona 5
   Motor: Oracle Database (SQL Developer)
   
   Objeto: TRG_VALIDA_PUBLICACION_MATERIAL
   Tabla objetivo: materials
   Momento: BEFORE INSERT OR UPDATE FOR EACH ROW
   
   Funcionalidad:
   Asegura la coherencia de negocio antes de persistir cualquier material:
   1. Valida que el estudiante pertenezca a la misma institución del docente
      que dicta el grupo al que se asocia el material.
   2. Impide el registro de materiales con fecha de publicación futura.
   3. Inicializa y normaliza contadores (views_count, downloads_count).
   ===================================================================== */

CREATE OR REPLACE TRIGGER trg_valida_publicacion_material
BEFORE INSERT OR UPDATE ON materials
FOR EACH ROW
DECLARE
    -- Variables para almacenar la institución y datos del estudiante y docente
    v_student_inst_id    students.institution_id%TYPE;
    v_student_name       students.name%TYPE;
    v_professor_inst_id  professors.institution_id%TYPE;
    v_professor_name     VARCHAR2(250);
BEGIN
    /* -----------------------------------------------------------------
       1. OBTENCIÓN DE DATOS DEL ESTUDIANTE QUE PUBLICA
       ----------------------------------------------------------------- */
    SELECT s.institution_id, s.name
      INTO v_student_inst_id, v_student_name
      FROM students s
     WHERE s.student_id = :NEW.student_id;

    /* -----------------------------------------------------------------
       2. OBTENCIÓN DE LA INSTITUCIÓN DEL PROFESOR DEL GRUPO
       El material se asocia a course_groups. A través de este identificamos
       al profesor y la institución a la que pertenece dicho grupo.
       ----------------------------------------------------------------- */
    SELECT p.institution_id, p.first_name || ' ' || p.last_name
      INTO v_professor_inst_id, v_professor_name
      FROM course_groups cg
      JOIN professors p ON cg.professor_id = p.professor_id
     WHERE cg.course_group_id = :NEW.course_group_id;

    /* -----------------------------------------------------------------
       3. VALIDACIÓN 1: PERTENENCIA A LA MISMA INSTITUCIÓN
       Un estudiante no puede publicar material en cursos/grupos de otra
       universidad o institución ajena.
       ----------------------------------------------------------------- */
    IF v_student_inst_id <> v_professor_inst_id THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Error de Negocio [ORA-20001]: El estudiante "' || v_student_name ||
            '" (Inst: ' || v_student_inst_id || ') no puede subir material al grupo ' ||
            :NEW.course_group_id || ' porque pertenece a una institución distinta a la del docente ' ||
            v_professor_name || ' (Inst: ' || v_professor_inst_id || ').'
        );
    END IF;

    /* -----------------------------------------------------------------
       4. VALIDACIÓN 2: FECHA DE PUBLICACIÓN COHERENTE
       La fecha de publicación no puede ser superior a la fecha actual del sistema.
       ----------------------------------------------------------------- */
    IF :NEW.publication_date > SYSDATE THEN
        RAISE_APPLICATION_ERROR(
            -20002,
            'Error de Negocio [ORA-20002]: La fecha de publicación (' ||
            TO_CHAR(:NEW.publication_date, 'YYYY-MM-DD HH24:MI:SS') ||
            ') no puede ser futura respecto a la fecha del sistema.'
        );
    END IF;

    /* -----------------------------------------------------------------
       5. SANEAMIENTO Y VALORES POR DEFECTO AL INSERTAR
       ----------------------------------------------------------------- */
    IF INSERTING THEN
        -- Si la fecha viene nula, toma la fecha del sistema
        IF :NEW.publication_date IS NULL THEN
            :NEW.publication_date := SYSDATE;
        END IF;

        -- Evitar valores nulos o negativos en los contadores iniciales
        IF :NEW.views_count IS NULL OR :NEW.views_count < 0 THEN
            :NEW.views_count := 0;
        END IF;

        IF :NEW.downloads_count IS NULL OR :NEW.downloads_count < 0 THEN
            :NEW.downloads_count := 0;
        END IF;
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(
            -20003,
            'Error de Integridad [ORA-20003]: El estudiante o el grupo especificado no existen.'
        );
END trg_valida_publicacion_material;
/