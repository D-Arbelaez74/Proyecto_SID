/* =====================================================================
   PROYECTO SID - Plataforma para compartir conocimiento de estudio
   Entrega 3 - Script DQL (consultas de los reportes)
   Rol: Persona 3
   Motor: Oracle (SQL Developer)

   Qué hace este script:
   Tiene una consulta por cada reporte definido en el caso de estudio.
   Entre las tres se usan agrupamiento (GROUP BY), INNER JOIN,
   LEFT OUTER JOIN, ordenamiento (ORDER BY) y un TOP.

   Nota sobre el profesor y el curso:
   La tabla materials no guarda el profesor ni el curso directamente.
   Los dos se sacan del grupo:
   materials.course_group_id -> course_groups.professor_id / course_id

   Requiere: el DDL y el script de datos (DML).
   ===================================================================== */


/* ---------------------------------------------------------------------
   REPORTE 1: Material publicado por profesor

   En palabras normales:
   Muestra cada profesor con su institución, cuántos materiales se han
   publicado en los grupos que dicta y cuántas visitas y descargas
   suman esos materiales. Se usa LEFT JOIN para que también salgan los
   profesores que todavía no tienen material (aparecen con 0). La lista
   va de quien tiene más material a quien tiene menos.

   Usa: INNER JOIN, LEFT OUTER JOIN, GROUP BY y ORDER BY.
   --------------------------------------------------------------------- */
SELECT p.professor_id,
       p.first_name || ' ' || p.last_name  AS professor,
       i.name                              AS institution,
       COUNT(m.material_id)                AS total_materials,
       NVL(SUM(m.views_count), 0)          AS total_views,
       NVL(SUM(m.downloads_count), 0)      AS total_downloads
  FROM professors p
 INNER JOIN institutions i
         ON i.institution_id = p.institution_id
  LEFT OUTER JOIN course_groups cg
         ON cg.professor_id = p.professor_id
  LEFT OUTER JOIN materials m
         ON m.course_group_id = cg.course_group_id
 GROUP BY p.professor_id, p.first_name, p.last_name, i.name
 ORDER BY total_materials DESC, total_downloads DESC, professor;


/* ---------------------------------------------------------------------
   REPORTE 2: Material más consultado o descargado (Top 10)

   En palabras normales:
   Muestra los 10 materiales más usados de la plataforma, sumando las
   veces que se consultaron (visitas) y las que se descargaron. De cada
   uno se ve el título, el tipo, quién lo subió, el curso, las visitas,
   las descargas, el total de las dos, y cuántos comentarios y
   guardados tiene. Se usa LEFT JOIN con comentarios y guardados para
   que no se pierdan los materiales que no tienen ninguno. Si dos
   materiales empatan, va primero el que tiene más descargas.

   El TOP se hace con ROW_NUMBER() (igual que en el paquete
   pkg_material_ranking) para que funcione en cualquier versión de
   Oracle. En Oracle 12c o superior se puede cambiar por
   FETCH FIRST 10 ROWS ONLY.

   Usa: INNER JOIN, LEFT OUTER JOIN, GROUP BY, ORDER BY y TOP.
   --------------------------------------------------------------------- */
SELECT ranking, material_id, title, material_type, uploaded_by, course,
       views_count, downloads_count, total_uses, total_comments, total_saves
  FROM (SELECT ROW_NUMBER() OVER (ORDER BY m.views_count + m.downloads_count DESC,
                                           m.downloads_count DESC,
                                           m.material_id) AS ranking,
               m.material_id,
               m.title,
               mt.name                              AS material_type,
               s.name                               AS uploaded_by,
               c.course_name                        AS course,
               m.views_count,
               m.downloads_count,
               m.views_count + m.downloads_count    AS total_uses,
               COUNT(DISTINCT mc.comment_id)        AS total_comments,
               COUNT(DISTINCT sm.student_id)        AS total_saves
          FROM materials m
         INNER JOIN material_types mt
                 ON mt.material_type_id = m.material_type_id
         INNER JOIN students s
                 ON s.student_id = m.student_id
         INNER JOIN course_groups cg
                 ON cg.course_group_id = m.course_group_id
         INNER JOIN courses c
                 ON c.course_id = cg.course_id
          LEFT OUTER JOIN material_comments mc
                 ON mc.material_id = m.material_id
          LEFT OUTER JOIN saved_materials sm
                 ON sm.material_id = m.material_id
         GROUP BY m.material_id, m.title, mt.name, s.name, c.course_name,
                  m.views_count, m.downloads_count)
 WHERE ranking <= 10
 ORDER BY ranking;


/* ---------------------------------------------------------------------
   REPORTE 3: Curso con mayor material disponible

   En palabras normales:
   Muestra cada curso con cuántos grupos tiene y cuántos materiales hay
   publicados en él, junto con las visitas y descargas que suman. Los
   cursos van ordenados del que más material tiene al que menos, así
   que el primero de la lista es el curso con mayor material
   disponible. Se usa LEFT JOIN para que también aparezcan los cursos
   sin grupos o sin material (con 0).

   Usa: LEFT OUTER JOIN, GROUP BY y ORDER BY.
   --------------------------------------------------------------------- */
SELECT c.course_id,
       c.course_name,
       COUNT(DISTINCT cg.course_group_id)        AS total_groups,
       COUNT(m.material_id)                      AS total_materials,
       NVL(SUM(m.views_count), 0)                AS total_views,
       NVL(SUM(m.downloads_count), 0)            AS total_downloads
  FROM courses c
  LEFT OUTER JOIN course_groups cg
         ON cg.course_id = c.course_id
  LEFT OUTER JOIN materials m
         ON m.course_group_id = cg.course_group_id
 GROUP BY c.course_id, c.course_name
 ORDER BY total_materials DESC, total_downloads DESC, c.course_name;

