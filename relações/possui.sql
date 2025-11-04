-- Não é possível verificar se a data de adição é posterior à data de lançamento do álbum
-- Não é possível verificar se a data de adição é posterior à data que o utilizador perfaz 13 anos
CREATE TABLE possui(
    username,
    ean_13,
    data_adicao DATE CONSTRAINT nn_possui_data_adicao NOT NULL,
--
    CONSTRAINT pk_possui
        PRIMARY KEY(username,ean_13),
--
    CONSTRAINT fk_possui_username
        FOREIGN KEY(username) REFERENCES utilizador ON DELETE CASCADE,
--
    CONSTRAINT fk_possui_ean_13
        FOREIGN KEY(ean_13) REFERENCES versao ON DELETE CASCADE,
--
);