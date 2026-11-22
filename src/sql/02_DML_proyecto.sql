/* =====================================================================
   PROYECTO SID - Plataforma para compartir conocimiento de estudio
   Entrega 3 - Script DML (datos de prueba)
   Rol: Persona 2
   Motor: Oracle (SQL Developer)

   Qué hace este script:
   Inserta los datos de prueba en las 15 tablas creadas por el DDL, de
   modo que cada uno de los 3 reportes (DQL) devuelva al menos 10
   registros:
   - Reporte 1 (material por profesor): 12 profesores (10 con grupos,
     9 con material y 3 sin material, para que se vea el LEFT JOIN).
   - Reporte 2 (Top 10 de materiales): 20 materiales, de modo que el TOP
     recorta la lista; hay un empate (puestos 9 y 10) que se desempata
     por descargas, y dos materiales del Top sin comentarios.
   - Reporte 3 (material por curso): 12 cursos (2 sin grupos y 1 con
     grupo pero sin material, para que se vea el LEFT JOIN).

   Cantidad de registros por tabla:
   institutions 5, courses 12, material_types 5, professors 12,
   programs 6, students 15, degrees 16, course_groups 14,
   group_details 14, program_courses 12, program_enrollments 15,
   course_enrollments 30, materials 20, material_comments 18,
   saved_materials 21.

   Requiere: haber ejecutado antes el script DDL (crea las tablas).
   Los datos son inventados y no corresponden a personas reales.
   Orden de inserción: primero las tablas de las que otras dependen
   (el mismo orden del DDL).
   ===================================================================== */


/* ---------------------------------------------------------------------
   0. LIMPIEZA (opcional)
   Si ya se cargaron datos y se quiere repetir la carga, quitar los
   comentarios y borrar los datos de la más dependiente a la menos.
   --------------------------------------------------------------------- */
-- DELETE FROM saved_materials;
-- DELETE FROM material_comments;
-- DELETE FROM materials;
-- DELETE FROM course_enrollments;
-- DELETE FROM program_enrollments;
-- DELETE FROM program_courses;
-- DELETE FROM group_details;
-- DELETE FROM course_groups;
-- DELETE FROM degrees;
-- DELETE FROM students;
-- DELETE FROM programs;
-- DELETE FROM professors;
-- DELETE FROM material_types;
-- DELETE FROM courses;
-- DELETE FROM institutions;
-- COMMIT;

/* ---------------------------------------------------------------------
   1. institutions: instituciones educativas
   --------------------------------------------------------------------- */
INSERT INTO institutions (institution_id, name, city) VALUES (1, 'Universidad Icesi', 'Cali');
INSERT INTO institutions (institution_id, name, city) VALUES (2, 'Universidad del Valle', 'Cali');
INSERT INTO institutions (institution_id, name, city) VALUES (3, 'Pontificia Universidad Javeriana Cali', 'Cali');
INSERT INTO institutions (institution_id, name, city) VALUES (4, 'Universidad Nacional de Colombia', 'Bogotá');
INSERT INTO institutions (institution_id, name, city) VALUES (5, 'Universidad de los Andes', 'Bogotá');

/* ---------------------------------------------------------------------
   2. courses: materias
   --------------------------------------------------------------------- */
INSERT INTO courses (course_id, course_name, credits) VALUES (101, 'Sistemas Intensivos en Datos', 3);
INSERT INTO courses (course_id, course_name, credits) VALUES (102, 'Cálculo Diferencial', 4);
INSERT INTO courses (course_id, course_name, credits) VALUES (103, 'Programación Orientada a Objetos', 3);
INSERT INTO courses (course_id, course_name, credits) VALUES (104, 'Álgebra Lineal', 3);
INSERT INTO courses (course_id, course_name, credits) VALUES (105, 'Estructuras de Datos', 3);
INSERT INTO courses (course_id, course_name, credits) VALUES (106, 'Estadística y Probabilidad', 3);
INSERT INTO courses (course_id, course_name, credits) VALUES (107, 'Física Mecánica', 4);
INSERT INTO courses (course_id, course_name, credits) VALUES (108, 'Bases de Datos Avanzadas', 3);
INSERT INTO courses (course_id, course_name, credits) VALUES (109, 'Ingeniería de Software', 3);
INSERT INTO courses (course_id, course_name, credits) VALUES (110, 'Redes de Computadores', 3);
INSERT INTO courses (course_id, course_name, credits) VALUES (111, 'Inteligencia Artificial', 3);
INSERT INTO courses (course_id, course_name, credits) VALUES (112, 'Ecuaciones Diferenciales', 3);

/* ---------------------------------------------------------------------
   3. material_types: catálogo de tipos de material
   --------------------------------------------------------------------- */
INSERT INTO material_types (material_type_id, name) VALUES (1, 'Libro');
INSERT INTO material_types (material_type_id, name) VALUES (2, 'Examen');
INSERT INTO material_types (material_type_id, name) VALUES (3, 'Taller');
INSERT INTO material_types (material_type_id, name) VALUES (4, 'Nota de clase');
INSERT INTO material_types (material_type_id, name) VALUES (5, 'Tip de estudio');

/* ---------------------------------------------------------------------
   4. professors: profesores (los profesores 11 y 12 no dictan grupos)
   --------------------------------------------------------------------- */
INSERT INTO professors (professor_id, first_name, last_name, email, institution_id) VALUES (1, 'Carlos', 'Ramírez', 'carlos.ramirez@icesi.edu.co', 1);
INSERT INTO professors (professor_id, first_name, last_name, email, institution_id) VALUES (2, 'María Fernanda', 'Gómez', 'maria.gomez@icesi.edu.co', 1);
INSERT INTO professors (professor_id, first_name, last_name, email, institution_id) VALUES (3, 'Andrés Felipe', 'Ruiz', 'andres.ruiz@icesi.edu.co', 1);
INSERT INTO professors (professor_id, first_name, last_name, email, institution_id) VALUES (4, 'Luisa Fernanda', 'Torres', 'luisa.torres@correounivalle.edu.co', 2);
INSERT INTO professors (professor_id, first_name, last_name, email, institution_id) VALUES (5, 'Jorge Iván', 'Castillo', 'jorge.castillo@correounivalle.edu.co', 2);
INSERT INTO professors (professor_id, first_name, last_name, email, institution_id) VALUES (6, 'Diana Patricia', 'Herrera', 'diana.herrera@javerianacali.edu.co', 3);
INSERT INTO professors (professor_id, first_name, last_name, email, institution_id) VALUES (7, 'Julián David', 'Mejía', 'julian.mejia@javerianacali.edu.co', 3);
INSERT INTO professors (professor_id, first_name, last_name, email, institution_id) VALUES (8, 'Sandra Milena', 'Ortiz', 'sandra.ortiz@unal.edu.co', 4);
INSERT INTO professors (professor_id, first_name, last_name, email, institution_id) VALUES (9, 'Ricardo Alonso', 'Vargas', 'ricardo.vargas@unal.edu.co', 4);
INSERT INTO professors (professor_id, first_name, last_name, email, institution_id) VALUES (10, 'Natalia Andrea', 'Salazar', 'natalia.salazar@uniandes.edu.co', 5);
INSERT INTO professors (professor_id, first_name, last_name, email, institution_id) VALUES (11, 'Felipe Augusto', 'Cárdenas', 'felipe.cardenas@uniandes.edu.co', 5);
INSERT INTO professors (professor_id, first_name, last_name, email, institution_id) VALUES (12, 'Paola Andrea', 'Quintero', 'paola.quintero@icesi.edu.co', 1);

/* ---------------------------------------------------------------------
   5. programs: programas académicos
   --------------------------------------------------------------------- */
INSERT INTO programs (program_id, name, institution_id) VALUES (1, 'Ingeniería de Sistemas', 1);
INSERT INTO programs (program_id, name, institution_id) VALUES (2, 'Ingeniería Telemática', 1);
INSERT INTO programs (program_id, name, institution_id) VALUES (3, 'Ingeniería de Sistemas', 2);
INSERT INTO programs (program_id, name, institution_id) VALUES (4, 'Ciencias de la Computación', 4);
INSERT INTO programs (program_id, name, institution_id) VALUES (5, 'Ingeniería Industrial', 3);
INSERT INTO programs (program_id, name, institution_id) VALUES (6, 'Administración de Empresas', 5);

/* ---------------------------------------------------------------------
   6. students: estudiantes
   --------------------------------------------------------------------- */
INSERT INTO students (student_id, name, email, institution_id) VALUES (1, 'Laura Camila Pérez', 'laura.perez@u.icesi.edu.co', 1);
INSERT INTO students (student_id, name, email, institution_id) VALUES (2, 'Santiago Rojas Díaz', 'santiago.rojas@u.icesi.edu.co', 1);
INSERT INTO students (student_id, name, email, institution_id) VALUES (3, 'Valentina Moreno Cruz', 'valentina.moreno@u.icesi.edu.co', 1);
INSERT INTO students (student_id, name, email, institution_id) VALUES (4, 'Daniel Esteban López', 'daniel.lopez@correounivalle.edu.co', 2);
INSERT INTO students (student_id, name, email, institution_id) VALUES (5, 'Camila Andrea Suárez', 'camila.suarez@correounivalle.edu.co', 2);
INSERT INTO students (student_id, name, email, institution_id) VALUES (6, 'Juan Sebastián Parra', 'juan.parra@javerianacali.edu.co', 3);
INSERT INTO students (student_id, name, email, institution_id) VALUES (7, 'Mariana Lozano Gil', 'mariana.lozano@javerianacali.edu.co', 3);
INSERT INTO students (student_id, name, email, institution_id) VALUES (8, 'Mateo Alejandro Cortés', 'mateo.cortes@unal.edu.co', 4);
INSERT INTO students (student_id, name, email, institution_id) VALUES (9, 'Isabella Ramírez Vélez', 'isabella.ramirez@unal.edu.co', 4);
INSERT INTO students (student_id, name, email, institution_id) VALUES (10, 'Nicolás Ospina Reyes', 'nicolas.ospina@uniandes.edu.co', 5);
INSERT INTO students (student_id, name, email, institution_id) VALUES (11, 'Sofía Alejandra Medina', 'sofia.medina@uniandes.edu.co', 5);
INSERT INTO students (student_id, name, email, institution_id) VALUES (12, 'Samuel David Giraldo', 'samuel.giraldo@u.icesi.edu.co', 1);
INSERT INTO students (student_id, name, email, institution_id) VALUES (13, 'Gabriela Ríos Martínez', 'gabriela.rios@correounivalle.edu.co', 2);
INSERT INTO students (student_id, name, email, institution_id) VALUES (14, 'Tomás Eduardo Acosta', 'tomas.acosta@javerianacali.edu.co', 3);
INSERT INTO students (student_id, name, email, institution_id) VALUES (15, 'Juliana Paola Duque', 'juliana.duque@unal.edu.co', 4);

/* ---------------------------------------------------------------------
   7. degrees: títulos de los profesores
   --------------------------------------------------------------------- */
INSERT INTO degrees (degree_id, title, professor_id) VALUES (1, 'Ingeniero de Sistemas', 1);
INSERT INTO degrees (degree_id, title, professor_id) VALUES (2, 'Magíster en Ingeniería de Software', 1);
INSERT INTO degrees (degree_id, title, professor_id) VALUES (3, 'Matemático', 3);
INSERT INTO degrees (degree_id, title, professor_id) VALUES (4, 'Magíster en Matemáticas Aplicadas', 3);
INSERT INTO degrees (degree_id, title, professor_id) VALUES (5, 'Ingeniera Telemática', 2);
INSERT INTO degrees (degree_id, title, professor_id) VALUES (6, 'Doctora en Ciencias de la Computación', 2);
INSERT INTO degrees (degree_id, title, professor_id) VALUES (7, 'Ingeniera de Sistemas', 4);
INSERT INTO degrees (degree_id, title, professor_id) VALUES (8, 'Magíster en Ciencia de Datos', 5);
INSERT INTO degrees (degree_id, title, professor_id) VALUES (9, 'Estadístico', 7);
INSERT INTO degrees (degree_id, title, professor_id) VALUES (10, 'Magíster en Estadística', 7);
INSERT INTO degrees (degree_id, title, professor_id) VALUES (11, 'Física', 8);
INSERT INTO degrees (degree_id, title, professor_id) VALUES (12, 'Doctora en Física', 8);
INSERT INTO degrees (degree_id, title, professor_id) VALUES (13, 'Ingeniero de Sistemas', 9);
INSERT INTO degrees (degree_id, title, professor_id) VALUES (14, 'Magíster en Bases de Datos', 9);
INSERT INTO degrees (degree_id, title, professor_id) VALUES (15, 'Ingeniera Industrial', 10);
INSERT INTO degrees (degree_id, title, professor_id) VALUES (16, 'Ingeniera de Sistemas', 6);

/* ---------------------------------------------------------------------
   8. course_groups: grupos (el grupo 10 y los cursos 111 y 112 quedan sin material)
   --------------------------------------------------------------------- */
INSERT INTO course_groups (course_group_id, professor_id, course_id, term) VALUES (1, 1, 101, '2026-2');
INSERT INTO course_groups (course_group_id, professor_id, course_id, term) VALUES (2, 2, 101, '2026-2');
INSERT INTO course_groups (course_group_id, professor_id, course_id, term) VALUES (3, 3, 102, '2026-2');
INSERT INTO course_groups (course_group_id, professor_id, course_id, term) VALUES (4, 4, 103, '2026-2');
INSERT INTO course_groups (course_group_id, professor_id, course_id, term) VALUES (5, 5, 104, '2026-2');
INSERT INTO course_groups (course_group_id, professor_id, course_id, term) VALUES (6, 6, 105, '2026-2');
INSERT INTO course_groups (course_group_id, professor_id, course_id, term) VALUES (7, 7, 106, '2026-2');
INSERT INTO course_groups (course_group_id, professor_id, course_id, term) VALUES (8, 8, 107, '2026-2');
INSERT INTO course_groups (course_group_id, professor_id, course_id, term) VALUES (9, 9, 108, '2026-2');
INSERT INTO course_groups (course_group_id, professor_id, course_id, term) VALUES (10, 10, 109, '2026-2');
INSERT INTO course_groups (course_group_id, professor_id, course_id, term) VALUES (11, 1, 108, '2026-1');
INSERT INTO course_groups (course_group_id, professor_id, course_id, term) VALUES (12, 4, 110, '2026-1');
INSERT INTO course_groups (course_group_id, professor_id, course_id, term) VALUES (13, 6, 102, '2026-1');
INSERT INTO course_groups (course_group_id, professor_id, course_id, term) VALUES (14, 2, 110, '2026-2');

/* ---------------------------------------------------------------------
   9. group_details: detalle de cada grupo (relación 1 a 1)
   --------------------------------------------------------------------- */
INSERT INTO group_details (course_group_id, group_number, schedule, modality, classroom) VALUES (1, 1, TO_DATE('2026-08-03 07:00', 'YYYY-MM-DD HH24:MI'), 'Presencial', 'Aula 301');
INSERT INTO group_details (course_group_id, group_number, schedule, modality, classroom) VALUES (2, 2, TO_DATE('2026-08-03 09:00', 'YYYY-MM-DD HH24:MI'), 'Presencial', 'Aula 302');
INSERT INTO group_details (course_group_id, group_number, schedule, modality, classroom) VALUES (3, 1, TO_DATE('2026-08-04 07:00', 'YYYY-MM-DD HH24:MI'), 'Presencial', 'Aula 210');
INSERT INTO group_details (course_group_id, group_number, schedule, modality, classroom) VALUES (4, 1, TO_DATE('2026-08-04 10:00', 'YYYY-MM-DD HH24:MI'), 'Híbrida', 'Laboratorio 2');
INSERT INTO group_details (course_group_id, group_number, schedule, modality, classroom) VALUES (5, 1, TO_DATE('2026-08-05 08:00', 'YYYY-MM-DD HH24:MI'), 'Presencial', 'Aula 115');
INSERT INTO group_details (course_group_id, group_number, schedule, modality, classroom) VALUES (6, 1, TO_DATE('2026-08-05 10:00', 'YYYY-MM-DD HH24:MI'), 'Presencial', 'Laboratorio 1');
INSERT INTO group_details (course_group_id, group_number, schedule, modality, classroom) VALUES (7, 1, TO_DATE('2026-08-06 07:00', 'YYYY-MM-DD HH24:MI'), 'Virtual', NULL);
INSERT INTO group_details (course_group_id, group_number, schedule, modality, classroom) VALUES (8, 1, TO_DATE('2026-08-06 09:00', 'YYYY-MM-DD HH24:MI'), 'Presencial', 'Aula 120');
INSERT INTO group_details (course_group_id, group_number, schedule, modality, classroom) VALUES (9, 1, TO_DATE('2026-08-07 14:00', 'YYYY-MM-DD HH24:MI'), 'Híbrida', 'Aula 405');
INSERT INTO group_details (course_group_id, group_number, schedule, modality, classroom) VALUES (10, 1, TO_DATE('2026-08-07 16:00', 'YYYY-MM-DD HH24:MI'), 'Virtual', NULL);
INSERT INTO group_details (course_group_id, group_number, schedule, modality, classroom) VALUES (11, 1, TO_DATE('2026-02-02 14:00', 'YYYY-MM-DD HH24:MI'), 'Presencial', 'Aula 405');
INSERT INTO group_details (course_group_id, group_number, schedule, modality, classroom) VALUES (12, 1, TO_DATE('2026-02-03 08:00', 'YYYY-MM-DD HH24:MI'), 'Presencial', 'Laboratorio 3');
INSERT INTO group_details (course_group_id, group_number, schedule, modality, classroom) VALUES (13, 2, TO_DATE('2026-02-04 07:00', 'YYYY-MM-DD HH24:MI'), 'Presencial', 'Aula 210');
INSERT INTO group_details (course_group_id, group_number, schedule, modality, classroom) VALUES (14, 2, TO_DATE('2026-08-03 14:00', 'YYYY-MM-DD HH24:MI'), 'Virtual', NULL);

/* ---------------------------------------------------------------------
   10. program_courses: pensum de los programas
   --------------------------------------------------------------------- */
INSERT INTO program_courses (course_id, program_id, semester) VALUES (101, 1, 5);
INSERT INTO program_courses (course_id, program_id, semester) VALUES (102, 1, 1);
INSERT INTO program_courses (course_id, program_id, semester) VALUES (103, 1, 2);
INSERT INTO program_courses (course_id, program_id, semester) VALUES (104, 1, 2);
INSERT INTO program_courses (course_id, program_id, semester) VALUES (105, 1, 3);
INSERT INTO program_courses (course_id, program_id, semester) VALUES (106, 1, 4);
INSERT INTO program_courses (course_id, program_id, semester) VALUES (108, 1, 6);
INSERT INTO program_courses (course_id, program_id, semester) VALUES (109, 1, 7);
INSERT INTO program_courses (course_id, program_id, semester) VALUES (111, 1, 8);
INSERT INTO program_courses (course_id, program_id, semester) VALUES (110, 2, 5);
INSERT INTO program_courses (course_id, program_id, semester) VALUES (112, 3, 4);
INSERT INTO program_courses (course_id, program_id, semester) VALUES (107, 3, 1);

/* ---------------------------------------------------------------------
   11. program_enrollments: inscripción de estudiantes a programas (A = activo, F = finalizado, W = retirado)
   --------------------------------------------------------------------- */
INSERT INTO program_enrollments (student_id, program_id, start_date, end_date, status) VALUES (1, 1, DATE '2023-08-01', NULL, 'A');
INSERT INTO program_enrollments (student_id, program_id, start_date, end_date, status) VALUES (2, 1, DATE '2023-08-01', NULL, 'A');
INSERT INTO program_enrollments (student_id, program_id, start_date, end_date, status) VALUES (3, 1, DATE '2024-02-01', NULL, 'A');
INSERT INTO program_enrollments (student_id, program_id, start_date, end_date, status) VALUES (4, 3, DATE '2022-08-01', NULL, 'A');
INSERT INTO program_enrollments (student_id, program_id, start_date, end_date, status) VALUES (5, 3, DATE '2021-02-01', DATE '2025-12-15', 'F');
INSERT INTO program_enrollments (student_id, program_id, start_date, end_date, status) VALUES (6, 5, DATE '2024-02-01', NULL, 'A');
INSERT INTO program_enrollments (student_id, program_id, start_date, end_date, status) VALUES (7, 5, DATE '2023-08-01', DATE '2024-06-30', 'W');
INSERT INTO program_enrollments (student_id, program_id, start_date, end_date, status) VALUES (8, 4, DATE '2022-02-01', NULL, 'A');
INSERT INTO program_enrollments (student_id, program_id, start_date, end_date, status) VALUES (9, 4, DATE '2023-08-01', NULL, 'A');
INSERT INTO program_enrollments (student_id, program_id, start_date, end_date, status) VALUES (10, 6, DATE '2024-08-01', NULL, 'A');
INSERT INTO program_enrollments (student_id, program_id, start_date, end_date, status) VALUES (11, 6, DATE '2024-02-01', NULL, 'A');
INSERT INTO program_enrollments (student_id, program_id, start_date, end_date, status) VALUES (12, 1, DATE '2022-02-01', NULL, 'A');
INSERT INTO program_enrollments (student_id, program_id, start_date, end_date, status) VALUES (13, 3, DATE '2023-02-01', NULL, 'A');
INSERT INTO program_enrollments (student_id, program_id, start_date, end_date, status) VALUES (14, 5, DATE '2025-02-01', NULL, 'A');
INSERT INTO program_enrollments (student_id, program_id, start_date, end_date, status) VALUES (15, 4, DATE '2024-08-01', NULL, 'A');

/* ---------------------------------------------------------------------
   12. course_enrollments: matrícula de estudiantes en grupos
   --------------------------------------------------------------------- */
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (1, 1);
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (1, 11);
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (2, 1);
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (2, 2);
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (3, 1);
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (3, 2);
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (4, 3);
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (4, 5);
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (5, 3);
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (5, 6);
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (6, 4);
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (6, 6);
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (7, 5);
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (7, 7);
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (8, 6);
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (8, 8);
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (9, 7);
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (9, 9);
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (10, 8);
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (10, 9);
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (11, 9);
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (11, 10);
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (12, 1);
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (12, 11);
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (13, 12);
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (13, 14);
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (14, 13);
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (14, 3);
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (15, 14);
INSERT INTO course_enrollments (student_id, course_group_id) VALUES (15, 12);

/* ---------------------------------------------------------------------
   13. materials: material publicado (las visitas y descargas alimentan los reportes)
   Cada material lo sube un estudiante de la MISMA institución del profesor
   que dicta el grupo (regla que valida el trigger trg_valida_publicacion_material).
   --------------------------------------------------------------------- */
INSERT INTO materials (material_id, material_type_id, course_group_id, student_id, title, publication_date, downloads_count, description, views_count, file_url) VALUES (1, 1, 1, 1, 'Resumen del libro Sistemas Intensivos en Datos', DATE '2026-08-20', 210, 'Material de estudio compartido sobre: resumen del libro Sistemas Intensivos en Datos.', 480, 'https://sid.example.com/materiales/m001.pdf');
INSERT INTO materials (material_id, material_type_id, course_group_id, student_id, title, publication_date, downloads_count, description, views_count, file_url) VALUES (2, 2, 1, 2, 'Parcial resuelto de modelado conceptual 2025-2', DATE '2026-09-02', 340, 'Material de estudio compartido sobre: parcial resuelto de modelado conceptual 2025-2.', 620, 'https://sid.example.com/materiales/m002.pdf');
INSERT INTO materials (material_id, material_type_id, course_group_id, student_id, title, publication_date, downloads_count, description, views_count, file_url) VALUES (3, 3, 2, 3, 'Taller de normalización resuelto', DATE '2026-09-10', 150, 'Material de estudio compartido sobre: taller de normalización resuelto.', 390, 'https://sid.example.com/materiales/m003.pdf');
INSERT INTO materials (material_id, material_type_id, course_group_id, student_id, title, publication_date, downloads_count, description, views_count, file_url) VALUES (4, 4, 3, 2, 'Notas de clase: reglas de derivación', DATE '2026-08-25', 90, 'Material de estudio compartido sobre: notas de clase: reglas de derivación.', 300, 'https://sid.example.com/materiales/m004.pdf');
INSERT INTO materials (material_id, material_type_id, course_group_id, student_id, title, publication_date, downloads_count, description, views_count, file_url) VALUES (5, 2, 3, 3, 'Parcial de Cálculo Diferencial con soluciones', DATE '2026-09-05', 405, 'Material de estudio compartido sobre: parcial de Cálculo Diferencial con soluciones.', 710, 'https://sid.example.com/materiales/m005.pdf');
INSERT INTO materials (material_id, material_type_id, course_group_id, student_id, title, publication_date, downloads_count, description, views_count, file_url) VALUES (6, 5, 4, 4, 'Tips para la sustentación de Programación Orientada a Objetos', DATE '2026-09-15', 40, 'Material de estudio compartido sobre: tips para la sustentación de Programación Orientada a Objetos.', 150, 'https://sid.example.com/materiales/m006.pdf');
INSERT INTO materials (material_id, material_type_id, course_group_id, student_id, title, publication_date, downloads_count, description, views_count, file_url) VALUES (7, 1, 5, 5, 'Guía de Álgebra Lineal paso a paso', DATE '2026-08-28', 260, 'Material de estudio compartido sobre: guía de Álgebra Lineal paso a paso.', 520, 'https://sid.example.com/materiales/m007.pdf');
INSERT INTO materials (material_id, material_type_id, course_group_id, student_id, title, publication_date, downloads_count, description, views_count, file_url) VALUES (8, 3, 6, 6, 'Taller de listas y árboles', DATE '2026-09-12', 130, 'Material de estudio compartido sobre: taller de listas y árboles.', 260, 'https://sid.example.com/materiales/m008.pdf');
INSERT INTO materials (material_id, material_type_id, course_group_id, student_id, title, publication_date, downloads_count, description, views_count, file_url) VALUES (9, 2, 7, 7, 'Parcial de Estadística y Probabilidad', DATE '2026-09-18', 200, 'Material de estudio compartido sobre: parcial de Estadística y Probabilidad.', 430, 'https://sid.example.com/materiales/m009.pdf');
INSERT INTO materials (material_id, material_type_id, course_group_id, student_id, title, publication_date, downloads_count, description, views_count, file_url) VALUES (10, 4, 8, 8, 'Notas de Física Mecánica: leyes de Newton', DATE '2026-09-20', 60, 'Material de estudio compartido sobre: notas de Física Mecánica: leyes de Newton.', 180, 'https://sid.example.com/materiales/m010.pdf');
INSERT INTO materials (material_id, material_type_id, course_group_id, student_id, title, publication_date, downloads_count, description, views_count, file_url) VALUES (11, 1, 9, 9, 'Apuntes de Bases de Datos Avanzadas', DATE '2026-09-08', 175, 'Material de estudio compartido sobre: apuntes de Bases de Datos Avanzadas.', 350, 'https://sid.example.com/materiales/m011.pdf');
INSERT INTO materials (material_id, material_type_id, course_group_id, student_id, title, publication_date, downloads_count, description, views_count, file_url) VALUES (12, 3, 9, 15, 'Taller de índices y optimización de consultas', DATE '2026-10-01', 110, 'Material de estudio compartido sobre: taller de índices y optimización de consultas.', 275, 'https://sid.example.com/materiales/m012.pdf');
INSERT INTO materials (material_id, material_type_id, course_group_id, student_id, title, publication_date, downloads_count, description, views_count, file_url) VALUES (13, 2, 11, 1, 'Parcial de SQL del periodo 2026-1', DATE '2026-03-15', 300, 'Material de estudio compartido sobre: parcial de SQL del periodo 2026-1.', 560, 'https://sid.example.com/materiales/m013.pdf');
INSERT INTO materials (material_id, material_type_id, course_group_id, student_id, title, publication_date, downloads_count, description, views_count, file_url) VALUES (14, 5, 12, 13, 'Cómo preparar el examen de Redes de Computadores', DATE '2026-03-20', 35, 'Material de estudio compartido sobre: cómo preparar el examen de Redes de Computadores.', 120, 'https://sid.example.com/materiales/m014.pdf');
INSERT INTO materials (material_id, material_type_id, course_group_id, student_id, title, publication_date, downloads_count, description, views_count, file_url) VALUES (15, 4, 13, 14, 'Resumen de límites y derivadas', DATE '2026-03-10', 170, 'Material de estudio compartido sobre: resumen de límites y derivadas.', 340, 'https://sid.example.com/materiales/m015.pdf');
INSERT INTO materials (material_id, material_type_id, course_group_id, student_id, title, publication_date, downloads_count, description, views_count, file_url) VALUES (16, 3, 14, 1, 'Taller de subredes IP', DATE '2026-10-05', 25, 'Material de estudio compartido sobre: taller de subredes IP.', 95, 'https://sid.example.com/materiales/m016.pdf');
INSERT INTO materials (material_id, material_type_id, course_group_id, student_id, title, publication_date, downloads_count, description, views_count, file_url) VALUES (17, 1, 1, 3, 'Mapa conceptual de la unidad 1', DATE '2026-08-30', 190, 'Material de estudio compartido sobre: mapa conceptual de la unidad 1.', 410, 'https://sid.example.com/materiales/m017.pdf');
INSERT INTO materials (material_id, material_type_id, course_group_id, student_id, title, publication_date, downloads_count, description, views_count, file_url) VALUES (18, 5, 2, 2, 'Errores comunes en el modelo relacional', DATE '2026-09-22', 80, 'Material de estudio compartido sobre: errores comunes en el modelo relacional.', 230, 'https://sid.example.com/materiales/m018.pdf');
INSERT INTO materials (material_id, material_type_id, course_group_id, student_id, title, publication_date, downloads_count, description, views_count, file_url) VALUES (19, 2, 5, 4, 'Parcial de Álgebra Lineal del periodo 2026-1', DATE '2026-09-25', 145, 'Material de estudio compartido sobre: parcial de Álgebra Lineal del periodo 2026-1.', 380, 'https://sid.example.com/materiales/m019.pdf');
INSERT INTO materials (material_id, material_type_id, course_group_id, student_id, title, publication_date, downloads_count, description, views_count, file_url) VALUES (20, 4, 6, 14, 'Notas sobre complejidad algorítmica', DATE '2026-10-08', 20, 'Material de estudio compartido sobre: notas sobre complejidad algorítmica.', 85, 'https://sid.example.com/materiales/m020.pdf');

/* ---------------------------------------------------------------------
   14. material_comments: comentarios sobre los materiales (los materiales 17 y 19 no tienen comentarios)
   --------------------------------------------------------------------- */
INSERT INTO material_comments (comment_id, student_id, material_id, content, comment_date) VALUES (1, 1, 5, 'Muy útil, las soluciones están bien explicadas.', DATE '2026-09-06');
INSERT INTO material_comments (comment_id, student_id, material_id, content, comment_date) VALUES (2, 2, 5, 'Me ayudó a repasar derivadas antes del parcial.', DATE '2026-09-07');
INSERT INTO material_comments (comment_id, student_id, material_id, content, comment_date) VALUES (3, 3, 5, 'Falta explicar el ejercicio 4, pero el resto está muy claro.', DATE '2026-09-08');
INSERT INTO material_comments (comment_id, student_id, material_id, content, comment_date) VALUES (4, 4, 2, 'Buen resumen del modelo entidad-relación.', DATE '2026-09-03');
INSERT INTO material_comments (comment_id, student_id, material_id, content, comment_date) VALUES (5, 5, 2, 'Sugiero agregar un ejemplo de relación muchos a muchos.', DATE '2026-09-04');
INSERT INTO material_comments (comment_id, student_id, material_id, content, comment_date) VALUES (6, 3, 13, 'Las consultas con GROUP BY quedaron muy bien resueltas.', DATE '2026-03-16');
INSERT INTO material_comments (comment_id, student_id, material_id, content, comment_date) VALUES (7, 9, 13, 'Gracias por compartirlo, me sirvió para el taller.', DATE '2026-03-18');
INSERT INTO material_comments (comment_id, student_id, material_id, content, comment_date) VALUES (8, 6, 1, 'Resumen claro de los capítulos principales.', DATE '2026-08-22');
INSERT INTO material_comments (comment_id, student_id, material_id, content, comment_date) VALUES (9, 10, 1, 'Podrían agregar las preguntas de repaso.', DATE '2026-08-24');
INSERT INTO material_comments (comment_id, student_id, material_id, content, comment_date) VALUES (10, 8, 7, 'La explicación paso a paso de los espacios vectoriales es excelente.', DATE '2026-08-30');
INSERT INTO material_comments (comment_id, student_id, material_id, content, comment_date) VALUES (11, 11, 7, 'Corrijo un error en el ejemplo 3: el determinante da 12.', DATE '2026-09-01');
INSERT INTO material_comments (comment_id, student_id, material_id, content, comment_date) VALUES (12, 12, 9, 'Los ejercicios de probabilidad condicional están muy completos.', DATE '2026-09-19');
INSERT INTO material_comments (comment_id, student_id, material_id, content, comment_date) VALUES (13, 4, 3, 'El paso a tercera forma normal quedó claro.', DATE '2026-09-11');
INSERT INTO material_comments (comment_id, student_id, material_id, content, comment_date) VALUES (14, 13, 11, 'Buen resumen de índices y planes de ejecución.', DATE '2026-09-09');
INSERT INTO material_comments (comment_id, student_id, material_id, content, comment_date) VALUES (15, 15, 15, 'Excelente, lo usé para estudiar el parcial.', DATE '2026-03-12');
INSERT INTO material_comments (comment_id, student_id, material_id, content, comment_date) VALUES (16, 7, 6, 'Gracias por los consejos, los apliqué en la sustentación.', DATE '2026-09-16');
INSERT INTO material_comments (comment_id, student_id, material_id, content, comment_date) VALUES (17, 6, 4, 'Las reglas de derivación están bien organizadas.', DATE '2026-08-26');
INSERT INTO material_comments (comment_id, student_id, material_id, content, comment_date) VALUES (18, 9, 8, 'Faltó un ejemplo del recorrido por niveles.', DATE '2026-09-13');

/* ---------------------------------------------------------------------
   15. saved_materials: materiales guardados por los estudiantes
   --------------------------------------------------------------------- */
INSERT INTO saved_materials (student_id, material_id, saved_date) VALUES (1, 5, DATE '2026-09-06');
INSERT INTO saved_materials (student_id, material_id, saved_date) VALUES (2, 5, DATE '2026-09-07');
INSERT INTO saved_materials (student_id, material_id, saved_date) VALUES (3, 5, DATE '2026-09-08');
INSERT INTO saved_materials (student_id, material_id, saved_date) VALUES (6, 5, DATE '2026-09-09');
INSERT INTO saved_materials (student_id, material_id, saved_date) VALUES (7, 5, DATE '2026-09-10');
INSERT INTO saved_materials (student_id, material_id, saved_date) VALUES (4, 2, DATE '2026-09-03');
INSERT INTO saved_materials (student_id, material_id, saved_date) VALUES (5, 2, DATE '2026-09-04');
INSERT INTO saved_materials (student_id, material_id, saved_date) VALUES (8, 2, DATE '2026-09-05');
INSERT INTO saved_materials (student_id, material_id, saved_date) VALUES (2, 13, DATE '2026-03-16');
INSERT INTO saved_materials (student_id, material_id, saved_date) VALUES (3, 13, DATE '2026-03-17');
INSERT INTO saved_materials (student_id, material_id, saved_date) VALUES (9, 13, DATE '2026-03-18');
INSERT INTO saved_materials (student_id, material_id, saved_date) VALUES (1, 7, DATE '2026-08-29');
INSERT INTO saved_materials (student_id, material_id, saved_date) VALUES (10, 7, DATE '2026-09-01');
INSERT INTO saved_materials (student_id, material_id, saved_date) VALUES (5, 1, DATE '2026-08-21');
INSERT INTO saved_materials (student_id, material_id, saved_date) VALUES (11, 1, DATE '2026-08-25');
INSERT INTO saved_materials (student_id, material_id, saved_date) VALUES (12, 9, DATE '2026-09-19');
INSERT INTO saved_materials (student_id, material_id, saved_date) VALUES (13, 3, DATE '2026-09-11');
INSERT INTO saved_materials (student_id, material_id, saved_date) VALUES (14, 11, DATE '2026-09-09');
INSERT INTO saved_materials (student_id, material_id, saved_date) VALUES (15, 19, DATE '2026-09-26');
INSERT INTO saved_materials (student_id, material_id, saved_date) VALUES (3, 15, DATE '2026-03-11');
INSERT INTO saved_materials (student_id, material_id, saved_date) VALUES (4, 8, DATE '2026-09-14');

/* ---------------------------------------------------------------------
   16. CONFIRMAR LOS DATOS
   --------------------------------------------------------------------- */
COMMIT;

/* ---------------------------------------------------------------------
   17. VERIFICACIÓN (opcional)
   Cuenta los registros de cada tabla. Los valores esperados están en
   el encabezado del script.
   --------------------------------------------------------------------- */
SELECT 'institutions' AS tabla, COUNT(*) AS registros FROM institutions UNION ALL
SELECT 'courses',              COUNT(*) FROM courses UNION ALL
SELECT 'material_types',       COUNT(*) FROM material_types UNION ALL
SELECT 'professors',           COUNT(*) FROM professors UNION ALL
SELECT 'programs',             COUNT(*) FROM programs UNION ALL
SELECT 'students',             COUNT(*) FROM students UNION ALL
SELECT 'degrees',              COUNT(*) FROM degrees UNION ALL
SELECT 'course_groups',        COUNT(*) FROM course_groups UNION ALL
SELECT 'group_details',        COUNT(*) FROM group_details UNION ALL
SELECT 'program_courses',      COUNT(*) FROM program_courses UNION ALL
SELECT 'program_enrollments',  COUNT(*) FROM program_enrollments UNION ALL
SELECT 'course_enrollments',   COUNT(*) FROM course_enrollments UNION ALL
SELECT 'materials',            COUNT(*) FROM materials UNION ALL
SELECT 'material_comments',    COUNT(*) FROM material_comments UNION ALL
SELECT 'saved_materials',      COUNT(*) FROM saved_materials;

/* ===================== FIN DEL SCRIPT DML ===================== */
