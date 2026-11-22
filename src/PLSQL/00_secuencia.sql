/* Secuencia que genera materials.material_id. Empieza en 100 porque el DML
   ya usa los ids 1 a 20 (así no hay llaves duplicadas).
   La usa pkg_material_publishing.sp_publish_material. */

CREATE SEQUENCE seq_materials
    START WITH 100
    INCREMENT BY 1
    MAXVALUE 999999
    NOCYCLE;
