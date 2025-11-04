CREATE TABLE refere(
    nome,
    mbid,
--
    CONSTRAINT pk_refere
        PRIMARY KEY(nome, mbid),
--
    CONSTRAINT fk_refere_nome
        FOREIGN KEY(nome) REFERENCES lista_personalizada ON DELETE CASCADE,
--
    CONSTRAINT fk_refere_mbid
        FOREIGN KEY(mbid) REFERENCES album ON DELETE CASCADE,
--
);