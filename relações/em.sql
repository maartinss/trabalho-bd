CREATE TABLE em(
    mbid,
    suporte_fisico,
--
    CONSTRAINT pk_em
        PRIMARY KEY(mbid, suporte_fisico),
--
    CONSTRAINT fk_em_mbid
        FOREIGN KEY(mbid) REFERENCES album ON DELETE CASCADE,
--
    CONSTRAINT fk_em_suporte_fisico
        FOREIGN KEY(suporte_fisico) REFERENCES suporte_fisico ON DELETE CASCADE,
--
);