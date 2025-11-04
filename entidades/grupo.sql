CREATE TABLE grupo(
    isni,
--
    CONSTRAINT pk_grupo
        PRIMARY KEY(isni),
--
    CONSTRAINT fk_grupo_isni
        FOREIGN KEY(isni) REFERENCES artista ON DELETE CASCADE,
--        
);