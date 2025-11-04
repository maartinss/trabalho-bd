CREATE TABLE cancao(
    isrc CHAR(12),
    titulo VARCHAR(36) CONSTRAINT nn_cancao_titulo NOT NULL,
    duraçao NUMBER(3) CONSTRAINT nn_canao_duraçao NOT NULL,
    --
    CONSTRAINT pk_cancao
    PRIMARY KEY (isrc),
    --
    CONSTRAINT ck_cancao_duraçao
    CHECK(duraçao BETWEEN 0 AND 999),
);