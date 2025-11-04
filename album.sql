-- Não é possível verificar se o ano de lançamento é maior que o ano de inicio de atividade
--
CREATE TABLE album(
    mbid    VARCHAR(36),
    titulo  VARCHAR(36) CONSTRAINT nn_album_titulo NOT NULL,
    tipo    VARCHAR(5) CONSTRAINT nn_album_tipo NOT NULL,
    ano_lancamento  NUMBER(4) CONSTRAINT nn_album_ano_lancamento NOT NULL,
--
    CONSTRAINT pk_album
        PRIMARY KEY (mbid),
--
    CONSTRAINT ck_album_tipo
        CHECK((tipo = 'EP') OR (tipo ='LP') OR (tipo = 'single')),
--
    CONSTRAINT ck_album_ano_lancamento
        CHECK(ano_lancamento BETWEEN 0 AND 2025),
);