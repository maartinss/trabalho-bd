CREATE TABLE lista_personalizada(
    username,
    nome VARCHAR(36),
--
    CONSTRAINT fk_lista_personalizada_username
        FOREIGN KEY(username) REFERENCES utilizador ON DELETE CASCADE,
--
    CONSTRAINT pk_lista_personalizada
        PRIMARY KEY(username, nome),
--
);