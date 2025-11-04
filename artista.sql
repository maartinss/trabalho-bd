CREATE TABLE artista(
    isni CHAR(16) CONSTRAINT pk_artista PRIMARY KEY(isni),
    nome VARCHAR(36) CONSTRAINT nn_artista_nome NOT NULL,
    ano_inicio NUMBER(4) CONSTRAINT nn_artista_ano_inicio NOT NULL,
--
    CONSTRAINT ck_artista_isni
        CHECK(LENGTH(isni) AND REGEXP_LIKE(isni, '^[0-9]+$')),
--
    CONSTRAINT ck_artista_nome
        CHECK(REGEPX_LIKE(nome, '^[A-Za-z]+$'))
--
    CONSTRAINT ck_artista_ano_inicio
        CHECK(ano_inicio BETWEEN 0 AND 2025),
--
);