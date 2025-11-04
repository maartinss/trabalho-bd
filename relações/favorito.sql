ALTER TABLE utilizador(
    favorito,
--
    CONSTRAINT fk_utilizador_favorito
        FOREIGN KEY(favorito) REFERENCES artista ON DELETE SET NULL,
--
);