CREATE TABLE artista(
    isni CHAR(16) CONSTRAINT pk_artista PRIMARY KEY(isni),
    nome VARCHAR(36) CONSTRAINT nn_artista_nome NOT NULL,
    ano_inicio INTEGER(4) CONSTRAINT nn_artista_ano_inicio NOT NULL,
--
    
);