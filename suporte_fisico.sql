CREATE TABLE suporte_fisico(
    tipo CHAR(7),
--
    CONSTRAINT pk_suporte_fisico
        PRIMARY KEY(tipo),
--
    CONSTRAINT ck_suporte_fisico
        CHECK(tipo IN ('cassete', 'cd', 'vinil')),
--
);