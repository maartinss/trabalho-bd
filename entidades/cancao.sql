CREATE TABLE cancao(
    isrc CHAR(12),
    titulo VARCHAR(36) CONSTRAINT nn_cancao_titulo NOT NULL,
    duracao NUMBER(4) CONSTRAINT nn_cancao_duracao NOT NULL,
--
    CONSTRAINT pk_cancao
        PRIMARY KEY (isrc),
--
    CONSTRAINT ck_cancao_duracao
        CHECK(duracao > 0),
--
    CONSTRAINT ck_cancao_isrc
        CHECK(REGEPX_LIKE(isrc, '^[A-Za-z]+$')),
--
);