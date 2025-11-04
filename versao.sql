CREATE TABLE versao(
    ean_13 NUMBER(13) CONSTRAINT pk_versao PRIMARY KEY(ean_13),
    designacao VARCHAR(36) CONSTRAINT nn_versao_designacao NOT NULL,
--
    CONSTRAINT ck_versao_ean_13
        CHECK(LENGTH(ean_13) = 13 AND ean_13 > 0),
--
);