ALTER TABLE versao(
    mbid_album,
    suporte_fisico,
--
    CONSTRAINT fk_versao_em
        FOREIGN KEY(mbid_album,suporte_fisico) REFERENCES em(mbid,suporte_fisico) ON DELETE NO ACTION,
--
);