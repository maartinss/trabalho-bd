CREATE TABLE membro(
    grupo,
    solista,
    --
    CONSTRAINT pk_membro
        PRIMARY KEY (grupo,solista),
    --
    CONSTRAINT fk_membro_grupo
        FOREIGN KEY(grupo) REFERENCES grupo ON DELETE CASCADE,
--
    CONSTRAINT fk_membro_solista
        FOREIGN KEY(solista) REFERENCES solista ON DELETE SET NULL,
);