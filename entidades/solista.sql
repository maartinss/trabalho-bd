CREATE TABLE solista (
    isni,
--
    CONSTRAINT pk_solista
        PRIMARY KEY(isni),
--
    CONSTRAINT fk_solista
        FOREIGN KEY(isni) REFERENCES artista ON DELETE CASCADE,
--
);
