CREATE TABLE faixa (
    mbid,
    numero NUMBER(2),
--
    CONSTRAINT pk_faixa
        PRIMARY KEY(mbid, numero),
--
    CONSTRAINT fk_faixa
        FOREIGN KEY(mbid) REFERENCES album ON DELETE CASCADE,
--
    CONSTRAINT ck_faixa_numero
        CHECK(numero > 0),        
);