CREATE TABLE utilizador(
    username    VARCHAR(24),
    email       VARCHAR(36) CONSTRAINT nn_utilizador_email NOT NULL,
    palavra_passe   VARCHAR(12),
    data_de_nascimento DATE,
--
    CONSTRAINT pk_utilizador,
      PRIMARY KEY (username),
--
    CONSTRAINT ck_utilizador_idade_minima
    CHECK (data_de_nascimento <= ADD_MONTHS(CURRENT_DATE, -156)),
);