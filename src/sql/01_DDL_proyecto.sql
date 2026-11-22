/* =====================================================================
   PROYECTO SID - Plataforma para compartir conocimiento de estudio
   Entrega 3 - Script DDL (creación de la base de datos)
   Motor: Oracle (SQL Developer / Data Modeler)

   Qué hace este script:
   Crea las 15 tablas del modelo relacional (3FN), con sus llaves
   primarias, llaves foráneas y reglas de validación (CHECK, UNIQUE,
   NOT NULL, DEFAULT). Al final agrega comentarios (COMMENT ON) a cada
   tabla y a sus columnas para que quede documentada dentro de la base.

   Convención de nombres (según correcciones recibidas):
   - Tablas en inglés y en plural, columnas en inglés.
   - Todo en minúscula con guion bajo (snake_case).
   - La llave primaria se llama <entidad_singular>_id y las llaves
     foráneas usan el mismo nombre de la llave que referencian.
     Ej.: students.student_id  <-  material.student_id

   Equivalencia con el modelo relacional anterior (nombres en español):
   INSTITUCION_EDUCATIVA -> institutions
   CURSO                 -> courses
   TIPO_MATERIAL         -> material_types
   PROFESOR              -> professors
   PROGRAMA              -> programs
   ESTUDIANTE            -> students
   TITULO                -> degrees
   GRUPO                 -> course_groups
   GRUPO_DETALLE         -> group_details
   PENSUM                -> program_courses
   INSCRIPCION_PROGRAMA  -> program_enrollments
   MATRICULA             -> course_enrollments
   MATERIAL              -> materials
   COMENTARIO            -> material_comments
   MATERIAL_GUARDADO     -> saved_materials

   Orden de creación (primero las tablas que no dependen de otras):
   1. institutions, courses, material_types
   2. professors, programs
   3. students, degrees, course_groups
   4. group_details, program_courses, program_enrollments, course_enrollments
   5. materials, material_comments, saved_materials
   ===================================================================== */


/* ---------------------------------------------------------------------
   0. LIMPIEZA (opcional)
   Borra las tablas si ya existen, de la más dependiente a la menos.
   Quitar los comentarios solo si se quiere volver a crear todo.
   --------------------------------------------------------------------- */
-- DROP TABLE saved_materials       CASCADE CONSTRAINTS;
-- DROP TABLE material_comments     CASCADE CONSTRAINTS;
-- DROP TABLE materials             CASCADE CONSTRAINTS;
-- DROP TABLE course_enrollments    CASCADE CONSTRAINTS;
-- DROP TABLE program_enrollments   CASCADE CONSTRAINTS;
-- DROP TABLE program_courses       CASCADE CONSTRAINTS;
-- DROP TABLE group_details         CASCADE CONSTRAINTS;
-- DROP TABLE course_groups         CASCADE CONSTRAINTS;
-- DROP TABLE degrees               CASCADE CONSTRAINTS;
-- DROP TABLE students              CASCADE CONSTRAINTS;
-- DROP TABLE programs              CASCADE CONSTRAINTS;
-- DROP TABLE professors            CASCADE CONSTRAINTS;
-- DROP TABLE material_types        CASCADE CONSTRAINTS;
-- DROP TABLE courses               CASCADE CONSTRAINTS;
-- DROP TABLE institutions          CASCADE CONSTRAINTS;


/* =====================================================================
   1. TABLAS INDEPENDIENTES
   ===================================================================== */

-- ---------------------------------------------------------------------
-- institutions (antes INSTITUCION_EDUCATIVA)
-- Universidades o colegios a los que pertenecen estudiantes, profesores
-- y programas.
-- ---------------------------------------------------------------------
CREATE TABLE institutions (
    institution_id  NUMBER(3)      NOT NULL,
    name            VARCHAR2(200)  NOT NULL,
    city            VARCHAR2(100)  NOT NULL,
    CONSTRAINT institutions_pk PRIMARY KEY (institution_id)
);

-- ---------------------------------------------------------------------
-- courses (antes CURSO)
-- Materias académicas (ej. Sistemas Intensivos en Datos).
-- ---------------------------------------------------------------------
CREATE TABLE courses (
    course_id    NUMBER(4)      NOT NULL,
    course_name  VARCHAR2(200)  NOT NULL,
    credits      NUMBER(3)      NOT NULL,
    CONSTRAINT courses_pk         PRIMARY KEY (course_id),
    CONSTRAINT courses_credits_ck CHECK (credits > 0)
);

-- ---------------------------------------------------------------------
-- material_types (antes TIPO_MATERIAL)
-- Catálogo de clases de material (libro, examen, taller, nota, tip...).
-- ---------------------------------------------------------------------
CREATE TABLE material_types (
    material_type_id  NUMBER         NOT NULL,
    name              VARCHAR2(100)  NOT NULL,
    CONSTRAINT material_types_pk      PRIMARY KEY (material_type_id),
    CONSTRAINT material_types_name_uq UNIQUE (name)
);


/* =====================================================================
   2. TABLAS QUE DEPENDEN DE institutions
   ===================================================================== */

-- ---------------------------------------------------------------------
-- professors (antes PROFESOR)
-- Docentes que dictan los grupos. Cada uno pertenece a una institución.
-- ---------------------------------------------------------------------
CREATE TABLE professors (
    professor_id    NUMBER(4)      NOT NULL,
    first_name      VARCHAR2(100)  NOT NULL,
    last_name       VARCHAR2(100)  NOT NULL,
    email           VARCHAR2(150)  NOT NULL,
    institution_id  NUMBER(3)      NOT NULL,
    CONSTRAINT professors_pk          PRIMARY KEY (professor_id),
    CONSTRAINT professors_email_uq    UNIQUE (email),
    CONSTRAINT professors_institution_fk FOREIGN KEY (institution_id)
        REFERENCES institutions (institution_id)
);

-- ---------------------------------------------------------------------
-- programs (antes PROGRAMA)
-- Carreras o programas académicos de una institución.
-- ---------------------------------------------------------------------
CREATE TABLE programs (
    program_id      NUMBER(3)      NOT NULL,
    name            VARCHAR2(200)  NOT NULL,
    institution_id  NUMBER(3)      NOT NULL,
    CONSTRAINT programs_pk PRIMARY KEY (program_id),
    CONSTRAINT programs_institution_fk FOREIGN KEY (institution_id)
        REFERENCES institutions (institution_id)
);


/* =====================================================================
   3. students, degrees Y course_groups
   ===================================================================== */

-- ---------------------------------------------------------------------
-- students (antes ESTUDIANTE)
-- Usuarios de la plataforma (el perfil es solo para estudiantes).
-- El correo no se puede repetir (UNIQUE).
-- ---------------------------------------------------------------------
CREATE TABLE students (
    student_id      NUMBER(6)      NOT NULL,
    name            VARCHAR2(150)  NOT NULL,
    email           VARCHAR2(150)  NOT NULL,
    institution_id  NUMBER(3)      NOT NULL,
    CONSTRAINT students_pk       PRIMARY KEY (student_id),
    CONSTRAINT students_email_uq UNIQUE (email),
    CONSTRAINT students_institution_fk FOREIGN KEY (institution_id)
        REFERENCES institutions (institution_id)
);

-- ---------------------------------------------------------------------
-- degrees (antes TITULO)
-- Títulos académicos de un profesor (un profesor puede tener varios).
-- ---------------------------------------------------------------------
CREATE TABLE degrees (
    degree_id     NUMBER(6)      NOT NULL,
    title         VARCHAR2(200)  NOT NULL,
    professor_id  NUMBER(4)      NOT NULL,
    CONSTRAINT degrees_pk PRIMARY KEY (degree_id),
    CONSTRAINT degrees_professor_fk FOREIGN KEY (professor_id)
        REFERENCES professors (professor_id)
);

-- ---------------------------------------------------------------------
-- course_groups (antes GRUPO)
-- Un curso dictado por un profesor en un periodo (ej. '2026-2').
-- Es el punto de unión entre profesor, curso y material.
-- ---------------------------------------------------------------------
CREATE TABLE course_groups (
    course_group_id  NUMBER(3)    NOT NULL,
    professor_id     NUMBER(4)    NOT NULL,
    course_id        NUMBER(4)    NOT NULL,
    term             VARCHAR2(6)  NOT NULL,
    CONSTRAINT course_groups_pk PRIMARY KEY (course_group_id),
    CONSTRAINT course_groups_professor_fk FOREIGN KEY (professor_id)
        REFERENCES professors (professor_id),
    CONSTRAINT course_groups_course_fk FOREIGN KEY (course_id)
        REFERENCES courses (course_id)
);


/* =====================================================================
   4. DETALLE DE GRUPO, PENSUM, INSCRIPCIÓN Y MATRÍCULA
   ===================================================================== */

-- ---------------------------------------------------------------------
-- group_details (antes GRUPO_DETALLE)
-- Información adicional de cada grupo (relación 1 a 1 con course_groups:
-- la llave primaria es también la llave foránea).
-- ---------------------------------------------------------------------
CREATE TABLE group_details (
    course_group_id  NUMBER(3)     NOT NULL,
    group_number     NUMBER        NOT NULL,
    schedule         DATE          NOT NULL,
    modality         VARCHAR2(50)  NOT NULL,
    classroom        VARCHAR2(50),
    CONSTRAINT group_details_pk PRIMARY KEY (course_group_id),
    CONSTRAINT group_details_group_fk FOREIGN KEY (course_group_id)
        REFERENCES course_groups (course_group_id),
    CONSTRAINT group_details_number_ck CHECK (group_number > 0)
);

-- ---------------------------------------------------------------------
-- program_courses (antes PENSUM)
-- Qué cursos tiene cada programa y en qué semestre se ven.
-- (relación muchos a muchos entre courses y programs)
-- ---------------------------------------------------------------------
CREATE TABLE program_courses (
    course_id   NUMBER(4)  NOT NULL,
    program_id  NUMBER(3)  NOT NULL,
    semester    NUMBER(2)  NOT NULL,
    CONSTRAINT program_courses_pk PRIMARY KEY (course_id, program_id),
    CONSTRAINT program_courses_course_fk FOREIGN KEY (course_id)
        REFERENCES courses (course_id),
    CONSTRAINT program_courses_program_fk FOREIGN KEY (program_id)
        REFERENCES programs (program_id),
    CONSTRAINT program_courses_semester_ck CHECK (semester BETWEEN 1 AND 12)
);

-- ---------------------------------------------------------------------
-- program_enrollments (antes INSCRIPCION_PROGRAMA)
-- En qué programa está inscrito un estudiante, desde cuándo y en qué
-- estado. end_date queda vacía mientras el estudiante siga activo.
-- Estados: A = Active (activo), F = Finished (finalizado),
--          W = Withdrawn (retirado).
-- ---------------------------------------------------------------------
CREATE TABLE program_enrollments (
    student_id   NUMBER(6)  NOT NULL,
    program_id   NUMBER(3)  NOT NULL,
    start_date   DATE       NOT NULL,
    end_date     DATE,
    status       CHAR(1)    NOT NULL,
    CONSTRAINT program_enrollments_pk PRIMARY KEY (student_id, program_id),
    CONSTRAINT program_enroll_student_fk FOREIGN KEY (student_id)
        REFERENCES students (student_id),
    CONSTRAINT program_enroll_program_fk FOREIGN KEY (program_id)
        REFERENCES programs (program_id),
    CONSTRAINT program_enroll_status_ck CHECK (status IN ('A', 'F', 'W')),
    CONSTRAINT program_enroll_dates_ck CHECK (end_date IS NULL OR end_date >= start_date)
);

-- ---------------------------------------------------------------------
-- course_enrollments (antes MATRICULA)
-- Estudiantes matriculados en cada grupo
-- (relación muchos a muchos entre students y course_groups).
-- ---------------------------------------------------------------------
CREATE TABLE course_enrollments (
    student_id       NUMBER(6)  NOT NULL,
    course_group_id  NUMBER(3)  NOT NULL,
    CONSTRAINT course_enrollments_pk PRIMARY KEY (student_id, course_group_id),
    CONSTRAINT course_enroll_student_fk FOREIGN KEY (student_id)
        REFERENCES students (student_id),
    CONSTRAINT course_enroll_group_fk FOREIGN KEY (course_group_id)
        REFERENCES course_groups (course_group_id)
);


/* =====================================================================
   5. materials, material_comments Y saved_materials
   ===================================================================== */

-- ---------------------------------------------------------------------
-- materials (antes MATERIAL)
-- Contenido que publican los estudiantes (libros, exámenes, notas,
-- tips). Guarda sus visitas y descargas (base de los reportes 2 y 3).
--
-- Aclaración para los reportes: la publicación está asociada a un
-- ESTUDIANTE (student_id, quien lo sube), pero el PROFESOR se obtiene a
-- través del grupo: materials.course_group_id -> course_groups.professor_id.
-- Así, "material publicado por profesor" (reporte 1) significa el
-- material subido a los grupos que dicta ese profesor. Del mismo modo,
-- el curso (reporte 3) sale de course_groups.course_id.
-- ---------------------------------------------------------------------
CREATE TABLE materials (
    material_id        NUMBER(6)       NOT NULL,
    material_type_id   NUMBER          NOT NULL,
    course_group_id    NUMBER(3)       NOT NULL,
    student_id         NUMBER(6)       NOT NULL,
    title              VARCHAR2(200)   NOT NULL,
    publication_date   DATE            NOT NULL,
    downloads_count    INTEGER         DEFAULT 0 NOT NULL,
    description        VARCHAR2(1000)  NOT NULL,
    views_count        NUMBER(6)       DEFAULT 0 NOT NULL,
    file_url           VARCHAR2(500)   NOT NULL,
    CONSTRAINT materials_pk PRIMARY KEY (material_id),
    CONSTRAINT materials_type_fk FOREIGN KEY (material_type_id)
        REFERENCES material_types (material_type_id),
    CONSTRAINT materials_group_fk FOREIGN KEY (course_group_id)
        REFERENCES course_groups (course_group_id),
    CONSTRAINT materials_student_fk FOREIGN KEY (student_id)
        REFERENCES students (student_id),
    CONSTRAINT materials_downloads_ck CHECK (downloads_count >= 0),
    CONSTRAINT materials_views_ck     CHECK (views_count >= 0)
);

-- ---------------------------------------------------------------------
-- material_comments (antes COMENTARIO)
-- Comentarios que hacen los estudiantes sobre un material (para añadir
-- ideas o corregir). Se llama material_comments porque COMMENT es una
-- palabra reservada de Oracle.
-- ---------------------------------------------------------------------
CREATE TABLE material_comments (
    comment_id    NUMBER(6)       NOT NULL,
    student_id    NUMBER(6)       NOT NULL,
    material_id   NUMBER(6)       NOT NULL,
    content       VARCHAR2(2000)  NOT NULL,
    comment_date  DATE            NOT NULL,
    CONSTRAINT material_comments_pk PRIMARY KEY (comment_id),
    CONSTRAINT mat_comments_student_fk FOREIGN KEY (student_id)
        REFERENCES students (student_id),
    CONSTRAINT mat_comments_material_fk FOREIGN KEY (material_id)
        REFERENCES materials (material_id)
);

-- ---------------------------------------------------------------------
-- saved_materials (antes MATERIAL_GUARDADO)
-- Material que un estudiante separa para revisar después
-- (relación muchos a muchos entre students y materials).
-- ---------------------------------------------------------------------
CREATE TABLE saved_materials (
    student_id   NUMBER(6)  NOT NULL,
    material_id  NUMBER(6)  NOT NULL,
    saved_date   DATE       NOT NULL,
    CONSTRAINT saved_materials_pk PRIMARY KEY (student_id, material_id),
    CONSTRAINT saved_mat_student_fk FOREIGN KEY (student_id)
        REFERENCES students (student_id),
    CONSTRAINT saved_mat_material_fk FOREIGN KEY (material_id)
        REFERENCES materials (material_id)
);


/* =====================================================================
   6. ÍNDICES SOBRE LLAVES FORÁNEAS
   Oracle no crea índices automáticamente en las llaves foráneas. Estos
   aceleran los joins de los reportes (material por profesor, por curso,
   por estudiante, etc.).
   ===================================================================== */
CREATE INDEX idx_professors_institution ON professors (institution_id);
CREATE INDEX idx_students_institution   ON students (institution_id);
CREATE INDEX idx_degrees_professor      ON degrees (professor_id);
CREATE INDEX idx_course_groups_prof     ON course_groups (professor_id);
CREATE INDEX idx_course_groups_course   ON course_groups (course_id);
CREATE INDEX idx_materials_type         ON materials (material_type_id);
CREATE INDEX idx_materials_group        ON materials (course_group_id);
CREATE INDEX idx_materials_student      ON materials (student_id);
CREATE INDEX idx_mat_comments_material  ON material_comments (material_id);


/* =====================================================================
   7. COMENTARIOS DE DOCUMENTACIÓN (quedan guardados en la base de datos)
   Se pueden consultar en USER_TAB_COMMENTS y USER_COL_COMMENTS.
   ===================================================================== */

-- institutions
COMMENT ON TABLE  institutions IS 'Instituciones educativas (universidades o colegios) de estudiantes, profesores y programas.';
COMMENT ON COLUMN institutions.institution_id IS 'Identificador único de la institución.';
COMMENT ON COLUMN institutions.name           IS 'Nombre de la institución.';
COMMENT ON COLUMN institutions.city           IS 'Ciudad donde queda la institución.';

-- courses
COMMENT ON TABLE  courses IS 'Materias académicas que se dictan.';
COMMENT ON COLUMN courses.course_id   IS 'Identificador único del curso.';
COMMENT ON COLUMN courses.course_name IS 'Nombre del curso.';
COMMENT ON COLUMN courses.credits     IS 'Número de créditos del curso (mayor a 0).';

-- material_types
COMMENT ON TABLE  material_types IS 'Catálogo de tipos de material (libro, examen, taller, nota, tip).';
COMMENT ON COLUMN material_types.material_type_id IS 'Identificador único del tipo de material.';
COMMENT ON COLUMN material_types.name             IS 'Nombre del tipo de material (no se repite).';

-- professors
COMMENT ON TABLE  professors IS 'Profesores que dictan los grupos de los cursos.';
COMMENT ON COLUMN professors.professor_id   IS 'Identificador único del profesor.';
COMMENT ON COLUMN professors.first_name     IS 'Nombre del profesor.';
COMMENT ON COLUMN professors.last_name      IS 'Apellido del profesor.';
COMMENT ON COLUMN professors.email          IS 'Correo del profesor (no se repite).';
COMMENT ON COLUMN professors.institution_id IS 'Institución a la que pertenece el profesor.';

-- programs
COMMENT ON TABLE  programs IS 'Programas académicos (carreras) de una institución.';
COMMENT ON COLUMN programs.program_id     IS 'Identificador único del programa.';
COMMENT ON COLUMN programs.name           IS 'Nombre del programa.';
COMMENT ON COLUMN programs.institution_id IS 'Institución que ofrece el programa.';

-- students
COMMENT ON TABLE  students IS 'Estudiantes con perfil en la plataforma; son quienes publican, comentan y guardan material.';
COMMENT ON COLUMN students.student_id     IS 'Identificador único del estudiante.';
COMMENT ON COLUMN students.name           IS 'Nombre completo del estudiante.';
COMMENT ON COLUMN students.email          IS 'Correo del estudiante (no se repite).';
COMMENT ON COLUMN students.institution_id IS 'Institución a la que pertenece el estudiante.';

-- degrees
COMMENT ON TABLE  degrees IS 'Títulos académicos de los profesores.';
COMMENT ON COLUMN degrees.degree_id   IS 'Identificador único del título.';
COMMENT ON COLUMN degrees.title       IS 'Nombre del título (ej. Magíster en Ingeniería).';
COMMENT ON COLUMN degrees.professor_id IS 'Profesor que tiene el título.';

-- course_groups
COMMENT ON TABLE  course_groups IS 'Un curso dictado por un profesor en un periodo académico. Une profesor, curso y material.';
COMMENT ON COLUMN course_groups.course_group_id IS 'Identificador único del grupo.';
COMMENT ON COLUMN course_groups.professor_id    IS 'Profesor que dicta el grupo.';
COMMENT ON COLUMN course_groups.course_id       IS 'Curso que se dicta en el grupo.';
COMMENT ON COLUMN course_groups.term            IS 'Periodo académico, por ejemplo 2026-2.';

-- group_details
COMMENT ON TABLE  group_details IS 'Detalles de cada grupo (número, horario, modalidad y salón). Relación 1 a 1 con course_groups.';
COMMENT ON COLUMN group_details.course_group_id IS 'Grupo al que pertenece el detalle (llave primaria y foránea a la vez).';
COMMENT ON COLUMN group_details.group_number    IS 'Número del grupo dentro del curso (mayor a 0).';
COMMENT ON COLUMN group_details.schedule        IS 'Fecha y hora de la clase.';
COMMENT ON COLUMN group_details.modality        IS 'Modalidad del grupo (presencial, virtual, etc.).';
COMMENT ON COLUMN group_details.classroom       IS 'Salón de clase; puede estar vacío si es virtual.';

-- program_courses
COMMENT ON TABLE  program_courses IS 'Pensum: cursos que componen cada programa y el semestre en que se ven.';
COMMENT ON COLUMN program_courses.course_id  IS 'Curso incluido en el programa.';
COMMENT ON COLUMN program_courses.program_id IS 'Programa al que pertenece el curso.';
COMMENT ON COLUMN program_courses.semester   IS 'Semestre en que se cursa (entre 1 y 12).';

-- program_enrollments
COMMENT ON TABLE  program_enrollments IS 'Programas en los que está o estuvo inscrito cada estudiante.';
COMMENT ON COLUMN program_enrollments.student_id IS 'Estudiante inscrito.';
COMMENT ON COLUMN program_enrollments.program_id IS 'Programa en el que se inscribió.';
COMMENT ON COLUMN program_enrollments.start_date IS 'Fecha en que empezó el programa.';
COMMENT ON COLUMN program_enrollments.end_date   IS 'Fecha en que terminó; vacía si sigue activo. No puede ser anterior al inicio.';
COMMENT ON COLUMN program_enrollments.status     IS 'Estado: A = Activo, F = Finalizado, W = Retirado.';

-- course_enrollments
COMMENT ON TABLE  course_enrollments IS 'Estudiantes matriculados en cada grupo.';
COMMENT ON COLUMN course_enrollments.student_id      IS 'Estudiante matriculado.';
COMMENT ON COLUMN course_enrollments.course_group_id IS 'Grupo en el que se matriculó.';

-- materials
COMMENT ON TABLE  materials IS 'Material de estudio publicado por estudiantes (libros, exámenes, notas, tips).';
COMMENT ON COLUMN materials.material_id      IS 'Identificador único del material.';
COMMENT ON COLUMN materials.material_type_id IS 'Tipo de material (libro, examen, etc.).';
COMMENT ON COLUMN materials.course_group_id  IS 'Grupo (curso, profesor y periodo) al que corresponde el material. De aquí se obtiene el profesor y el curso para los reportes.';
COMMENT ON COLUMN materials.student_id       IS 'Estudiante que publicó el material.';
COMMENT ON COLUMN materials.title            IS 'Título del material.';
COMMENT ON COLUMN materials.publication_date IS 'Fecha en que se publicó.';
COMMENT ON COLUMN materials.downloads_count  IS 'Veces que se ha descargado (empieza en 0).';
COMMENT ON COLUMN materials.description      IS 'Descripción del contenido.';
COMMENT ON COLUMN materials.views_count      IS 'Veces que se ha consultado (empieza en 0).';
COMMENT ON COLUMN materials.file_url         IS 'Enlace donde está guardado el archivo.';

-- material_comments
COMMENT ON TABLE  material_comments IS 'Comentarios de estudiantes sobre un material.';
COMMENT ON COLUMN material_comments.comment_id   IS 'Identificador único del comentario.';
COMMENT ON COLUMN material_comments.student_id   IS 'Estudiante que escribió el comentario.';
COMMENT ON COLUMN material_comments.material_id  IS 'Material comentado.';
COMMENT ON COLUMN material_comments.content      IS 'Texto del comentario.';
COMMENT ON COLUMN material_comments.comment_date IS 'Fecha en que se hizo el comentario.';

-- saved_materials
COMMENT ON TABLE  saved_materials IS 'Material que un estudiante guarda para revisarlo después.';
COMMENT ON COLUMN saved_materials.student_id  IS 'Estudiante que guardó el material.';
COMMENT ON COLUMN saved_materials.material_id IS 'Material guardado.';
COMMENT ON COLUMN saved_materials.saved_date  IS 'Fecha en que lo guardó.';

/* ===================== FIN DEL SCRIPT DDL ===================== */
