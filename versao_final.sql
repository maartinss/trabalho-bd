-- SIBD 2025/2026
-- 2ª Etapa
-- Grupo 12
-- Rodrigo Martins 63745 TP14
-- Denis Dryagin 63749 TP14
-- Rodrigo Lourenço 64727 TP14
-- Pedro Dias 63736 TP14
--
-- RIA Suportada:
-- RIA Não suportada:
--
--
-- Comandos DROP TABLE
--
--
DROP TABLE album CASCADE CONSTRAINTS;
DROP TABLE artista CASCADE CONSTRAINTS;
DROP TABLE solista CASCADE CONSTRAINTS;
DROP TABLE grupo CASCADE CONSTRAINTS;
DROP TABLE utilizador CASCADE CONSTRAINTS;
DROP TABLE versao CASCADE CONSTRAINTS;
DROP TABLE suporte_fisico CASCADE CONSTRAINTS;
DROP TABLE lista_personalizada CASCADE CONSTRAINTS;
DROP TABLE refere CASCADE CONSTRAINTS;
DROP TABLE possui CASCADE CONSTRAINTS;
DROP TABLE membro CASCADE CONSTRAINTS;
DROP TABLE em CASCADE CONSTRAINTS;
--
--
-- Comandos CREATE TABLE
--
--
-- Não é possível verificar se o ano de lançamento é maior que o ano de inicio de atividade (RIA-8)
--
CREATE TABLE album(
    mbid    VARCHAR(36),
    titulo  VARCHAR(36) CONSTRAINT nn_album_titulo NOT NULL,
    tipo    VARCHAR(5) CONSTRAINT nn_album_tipo NOT NULL,
    ano_lancamento  NUMBER(4) CONSTRAINT nn_album_ano_lancamento NOT NULL,
--
    CONSTRAINT pk_album
        PRIMARY KEY (mbid),
--  RIA-2 O tipo de álbum só pode ser single, EP ou LP 
--
    CONSTRAINT ck_album_tipo
        CHECK(tipo IN('EP','LP','single')),
--
    CONSTRAINT ck_album_ano_lancamento
        CHECK(ano_lancamento BETWEEN 0 AND 2025),
--  RIA-1 O código MBID de um álbum tem de ter 36 caracteres
--
    CONSTRAINT ck_album_mbid
        CHECK(REGEXP_LIKE(mbid, '^[0-9a-z-]+$') AND LENGTH(mbid) = 36)
--
);
--
-- Não é possível representar a RIA 10 solista AND grupo COVER artista
--
CREATE TABLE artista(
    isni CHAR(16),
    nome VARCHAR(36) CONSTRAINT nn_artista_nome NOT NULL,
    ano_inicio NUMBER(4) CONSTRAINT nn_artista_ano_inicio NOT NULL,
--
    CONSTRAINT pk_artista 
        PRIMARY KEY(isni),
--  RIA-7 O código ISNI de um artista tem de ter 16 dígitos
--
    CONSTRAINT ck_artista_isni
        CHECK(REGEXP_LIKE(isni, '^[0-9]+$') AND (LENGTH(isni) = 16)),
--
    CONSTRAINT ck_artista_ano_inicio
        CHECK(ano_inicio BETWEEN 0 AND 2025)
--
);
--
--
CREATE TABLE solista (
    isni,
--
    CONSTRAINT pk_solista
        PRIMARY KEY(isni),
--
    CONSTRAINT fk_solista
        FOREIGN KEY(isni) REFERENCES artista ON DELETE CASCADE
--
);
--
--
CREATE TABLE grupo(
    isni,
--
    CONSTRAINT pk_grupo
        PRIMARY KEY(isni),
--
    CONSTRAINT fk_grupo_isni
        FOREIGN KEY(isni) REFERENCES artista ON DELETE CASCADE
--        
);
--
--
-- Não foi possível verificar se a data de nascimento do utilizador é 13 ou mais anos anterior à data atual (RIA-15)
--
CREATE TABLE utilizador(
    username    VARCHAR(24),
    email       VARCHAR(50) CONSTRAINT nn_utilizador_email NOT NULL, -- RIA-13 O endereço de email identifica univocamente o utilizador
    palavra_passe   VARCHAR(36),
    data_de_nascimento DATE,
--
    CONSTRAINT pk_utilizador
        PRIMARY KEY (username),
--
    CONSTRAINT ck_utilizador_username
        CHECK(REGEXP_LIKE(username, '^[0-9a-zA-Z]+$'))
--
);
--
--
CREATE TABLE lista_personalizada(
    username,
    nome VARCHAR(36),
--
    CONSTRAINT fk_lista_username
        FOREIGN KEY(username) REFERENCES utilizador ON DELETE CASCADE,
--
    CONSTRAINT pk_lista_personalizada
        PRIMARY KEY(username, nome)
--
);
--
--
CREATE TABLE versao(
    ean_13 CHAR(13) ,
    designacao VARCHAR(36) CONSTRAINT nn_versao_designacao NOT NULL,
--
    CONSTRAINT pk_versao 
        PRIMARY KEY(ean_13),
--  RIA-12 O código EAN-13 da versão de um álbum tem de ter 13 dígitos e ser positivo
--
    CONSTRAINT ck_versao_ean_13
        CHECK(REGEXP_LIKE(ean_13,'^[0-9]+$') AND LENGTH(ean_13) = 13)
--
);
--
--
CREATE TABLE suporte_fisico(
    tipo CHAR(7),
--
    CONSTRAINT pk_suporte_fisico
        PRIMARY KEY(tipo),
-- RIA 11 O tipo de um suporte físico tem de ser CD, vinil ou cassete
--
    CONSTRAINT ck_suporte_fisico
        CHECK(tipo IN ('cassete', 'cd', 'vinil'))
--
);
--
--
CREATE TABLE em(
    mbid,
    suporte_fisico,
--
    CONSTRAINT pk_em
        PRIMARY KEY(mbid, suporte_fisico),
--
    CONSTRAINT fk_em_mbid
        FOREIGN KEY(mbid) REFERENCES album ON DELETE CASCADE,
--
    CONSTRAINT fk_em_suporte_fisico
        FOREIGN KEY(suporte_fisico) REFERENCES suporte_fisico
--
);
--
--
-- Não é possível verificar se a data de adição é posterior à data de lançamento do álbum (RIA-16)
-- Não é possível verificar se a data de adição é posterior à data que o utilizador perfaz 13 anos (RIA-17)
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
        FOREIGN KEY(ean_13) REFERENCES versao ON DELETE CASCADE
--
);
--
--
CREATE TABLE refere(
    nome,
    username,
    mbid,
--
    CONSTRAINT pk_refere
        PRIMARY KEY(nome, mbid),
--
    CONSTRAINT fk_refere_lista_personalizada
        FOREIGN KEY(nome, username) REFERENCES lista_personalizada(nome, username) ON DELETE CASCADE,
--
    CONSTRAINT fk_refere_mbid
        FOREIGN KEY(mbid) REFERENCES album ON DELETE CASCADE
--
);
--
--
CREATE TABLE membro(
    solista,
    grupo,
--
    CONSTRAINT fk_membro_solista
        FOREIGN KEY(solista) REFERENCES solista,
--
    CONSTRAINT fk_membro_grupo
        FOREIGN KEY(grupo) REFERENCES grupo
);
--
--
-- ALTER TABLE
--
--
ALTER TABLE album ADD(
    artista_isni,
--
    CONSTRAINT fk_album_artista
        FOREIGN KEY(artista_isni) REFERENCES artista ON DELETE SET NULL
);
--
--
ALTER TABLE utilizador ADD(
    favorito,
--
    CONSTRAINT fk_utilizador_favorito
        FOREIGN KEY(favorito) REFERENCES artista ON DELETE SET NULL
);
--
--
ALTER TABLE versao ADD(
    mbid_album,
    suporte_fisico,
--
    CONSTRAINT fk_versao_em
        FOREIGN KEY(mbid_album,suporte_fisico) REFERENCES em(mbid,suporte_fisico)
);
--
--
-- INSERT INTO
--
--
-- SUPORTE FÍSICO
--
INSERT INTO suporte_fisico(tipo)
    VALUES('cassete');
--
INSERT INTO suporte_fisico(tipo)
    VALUES('cd');
--
INSERT INTO suporte_fisico(tipo)
    VALUES('vinil');
--
-- Artista
--
INSERT INTO artista(isni, nome, ano_inicio)
    VALUES('0000000469889776', 'Drake', 2006);
--
INSERT INTO artista(isni, nome, ano_inicio)
    VALUES('0000000098003605', 'The Cranberries', 1989);
--
INSERT INTO artista(isni, nome, ano_inicio)
    VALUES('0000000116814390', 'Dolores O Riordan', 1990);
--
INSERT INTO artista(isni, nome, ano_inicio)
    VALUES('0000000059280052', 'Noel Hogan', 1989);
--
INSERT INTO artista(isni, nome, ano_inicio)
    VALUES('0000000129563286', 'Mike Hogan', 1989);
--
INSERT INTO artista(isni, nome, ano_inicio)
    VALUES('0000000372875116', 'Fergal Lawler', 1989);
--
INSERT INTO artista(isni, nome, ano_inicio)
    VALUES('0000000115372770', 'OutKast', '1992');
--
INSERT INTO artista(isni, nome, ano_inicio)
    VALUES('0000000003233290', 'Andre 3000', '1991');
--
INSERT INTO artista(isni, nome, ano_inicio)
    VALUES('0000000121322154', 'Big Boi', '1992');
--
-- SOLISTA
--
INSERT INTO solista(isni)
    VALUES('0000000469889776');
--
INSERT INTO solista(isni)
    VALUES('0000000116814390');
--
INSERT INTO solista(isni)
    VALUES('0000000059280052');
--
INSERT INTO solista(isni)
    VALUES('0000000129563286');
--
INSERT INTO solista(isni)
    VALUES('0000000372875116');
--
INSERT INTO solista(isni)
    VALUES('0000000003233290');
--
INSERT INTO solista(isni)
    VALUES('0000000121322154');
--
-- GRUPO
--
INSERT INTO grupo(isni)
    VALUES('0000000098003605');
--
INSERT INTO grupo(isni)
    VALUES('0000000115372770');
--
-- ALBUM e INTERPRETADO
--
INSERT INTO album(mbid, titulo, tipo, ano_lancamento, artista_isni)
    VALUES('1e268632-6b5a-4592-bd60-64be3276d104', 'Take Care Deluxe', 'LP', 2011, '0000000469889776');
--
INSERT INTO album(mbid, titulo, tipo, ano_lancamento)
    VALUES('8052a9d4-3d20-4f66-a94b-cc9d8cbc437a', 'Donda Deluxe', 'LP', 2021);
--
--  UTILIZADOR
--
INSERT INTO utilizador(username, email, palavra_passe, data_de_nascimento)
    VALUES('denis3tenis', 'denis@fcul.pt', 'denis_estudioso', '09-10-2006');
--
INSERT INTO utilizador(username, email, palavra_passe, data_de_nascimento)
    VALUES('pepas', 'pepas@fcul.pt', 'pepas', '03-11-2005');
--
-- LISTA PERSONALIZADA 
--
INSERT INTO lista_personalizada(username, nome)
    VALUES('denis3tenis', 'Drake Glazer');
--
INSERT INTO lista_personalizada(username, nome)
    VALUES('pepas', 'Old Kanye');
--
-- EM
--
INSERT INTO em(mbid, suporte_fisico)
    VALUES('1e268632-6b5a-4592-bd60-64be3276d104', 'vinil');
--
INSERT INTO em(mbid, suporte_fisico)
    VALUES('8052a9d4-3d20-4f66-a94b-cc9d8cbc437a', 'cd');
--
-- VERSÃO e DE
--
INSERT INTO versao(ean_13, designacao, mbid_album, suporte_fisico)
    VALUES('0000000000001', 'Especial Primeiras 100 unidades', '1e268632-6b5a-4592-bd60-64be3276d104', 'vinil');
--
INSERT INTO versao(ean_13, designacao, mbid_album, suporte_fisico)
    VALUES('0000000000002', 'Original', '8052a9d4-3d20-4f66-a94b-cc9d8cbc437a', 'cd');
--
--  MEMBRO
--
INSERT INTO membro(solista, grupo)
    VALUES('0000000116814390', '0000000098003605');
--
INSERT INTO membro(solista, grupo)
    VALUES('0000000059280052', '0000000098003605');
--
INSERT INTO membro(solista, grupo)
    VALUES('0000000129563286', '0000000098003605');
--
INSERT INTO membro(solista, grupo)
    VALUES('0000000372875116', '0000000098003605');
--
INSERT INTO membro(solista, grupo)
    VALUES('0000000003233290', '0000000115372770');
--
INSERT INTO membro(solista, grupo)
    VALUES('0000000121322154', '0000000115372770');
--
-- REFERE
--
INSERT INTO refere(nome, username, mbid)
    VALUES('Drake Glazer', 'denis3tenis', '1e268632-6b5a-4592-bd60-64be3276d104');
--
INSERT INTO refere(nome, username, mbid)
    VALUES('Old Kanye', 'pepas', '8052a9d4-3d20-4f66-a94b-cc9d8cbc437a');
--
-- POSSUI
--
INSERT INTO possui(username, ean_13, data_adicao)
    VALUES('pepas', '0000000000002', '03-05-2023');
--
INSERT INTO possui(username, ean_13, data_adicao)
    VALUES('denis3tenis', '0000000000001', '23-09-2019');
--
--