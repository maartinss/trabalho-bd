ALTER TABLE album(
    artista,
--
    CONSTRAINT fk_album_artista
        FOREIGN KEY(artista) REFERENCES artista ON DELETE SET NULL,
--
);