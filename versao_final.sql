-- SIBD 2025/2026
-- 2ª Etapa
-- Grupo 12
-- Rodrigo Martins 63745 TP14
-- Denis Dryagin 63749 TP14
-- Rodrigo Lourenço 64727 TP14
-- Pedro Dias 63736 TP14
--
--
-- Comandos DROP TABLE
--
--
DROP TABLE album IF EXISTS;
DROP TABLE artista IF EXISTS;
DROP TABLE solista IF EXISTS;
DROP TABLE grupo IF EXISTS;
DROP TABLE utilizador IF EXISTS;
DROP TABLE versao IF EXISTS;
DROP TABLE suporte_fisico IF EXISTS;
DROP TABLE lista_personalizada IF EXISTS;
DROP TABLE refere IF EXISTS;
DROP TABLE possui IF EXISTS;
DROP TABLE membro IF EXISTS;
DROP TABLE em IF EXISTS;
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
    artista,
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
        CHECK(REGEXP_LIKE(mbid, '^[0-9a-z]+$') AND LENGTH(mbid) = 36),
--
    CONSTRAINT fk_album_artista
        FOREIGN KEY(artista) REFERENCES artista ON DELETE SET NULL,
--
);
--
-- Não é possível representar a RIA 10 solista AND grupo COVER artista
--
CREATE TABLE artista(
    isni CHAR(16) CONSTRAINT pk_artista PRIMARY KEY(isni),
    nome VARCHAR(36) CONSTRAINT nn_artista_nome NOT NULL,
    ano_inicio NUMBER(4) CONSTRAINT nn_artista_ano_inicio NOT NULL,
--  RIA-7 O código ISNI de um artista tem de ter 16 dígitos
--
    CONSTRAINT ck_artista_isni
        CHECK(REGEXP_LIKE(isni, '^[0-9]+$') AND LENGTH(isni) = 16),
--
    CONSTRAINT ck_artista_nome
        CHECK(REGEXP_LIKE(nome, '^[A-Za-z]+$'))
--
    CONSTRAINT ck_artista_ano_inicio
        CHECK(ano_inicio BETWEEN 0 AND 2025),
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
        FOREIGN KEY(isni) REFERENCES artista ON DELETE CASCADE,
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
        FOREIGN KEY(isni) REFERENCES artista ON DELETE CASCADE,
--        
);
--
--
CREATE TABLE utilizador(
    username    VARCHAR(24),
    email       VARCHAR(36) CONSTRAINT nn_utilizador_email NOT NULL, -- RIA-13 O endereço de email identifica univocamente o utilizador
    palavra_passe   VARCHAR(12),
    data_de_nascimento DATE,
    favorito,
--
    CONSTRAINT pk_utilizador,
        PRIMARY KEY (username),
-- RIA 15  A data de nascimento de um utilizador tem de ser 13 ou mais anos anterior
-- à data atual, bastando fazer a verificação aquando de criação da sua conta
-- no sistema de informação.
--
    CONSTRAINT ck_utilizador_idade_minima
        CHECK (data_de_nascimento <= ADD_MONTHS(CURRENT_DATE, -156)),
-- RIA 14 O utilizador só pode ter letras e dígitos
--
    CONSTRAINT ck_utilizador_username
        CHECK(REGEXP_LIKE(isni, '^[0-9a-zA-Z]+$')),
--
    CONSTRAINT fk_utilizador_favorito
        FOREIGN KEY(favorito) REFERENCES artista ON DELETE SET NULL,
--
);
--
--
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
--
--
CREATE TABLE versao(
    ean_13 CHAR(13) ,
    designacao VARCHAR(36) CONSTRAINT nn_versao_designacao NOT NULL,
    mbid_album,
    suporte_fisico,
--
    CONSTRAINT pk_versao 
        PRIMARY KEY(ean_13),
--  RIA-12 O código EAN-13 da versão de um álbum tem de ter 13 dígitos e ser positivo
--
    CONSTRAINT ck_versao_ean_13
        CHECK(REGEXP_LIKE('^[0-9]+$') AND LENGTH(ean_13) = 13), 
--
    CONSTRAINT fk_versao_em
        FOREIGN KEY(mbid_album,suporte_fisico) REFERENCES em(mbid,suporte_fisico) ON DELETE NO ACTION,
--
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
        CHECK(tipo IN ('cassete', 'cd', 'vinil')),
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
        FOREIGN KEY(mbid) REFERENCES album ON DELETE NO ACTION,
--
    CONSTRAINT fk_em_suporte_fisico
        FOREIGN KEY(suporte_fisico) REFERENCES suporte_fisico ON DELETE NO ACTION,
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
        FOREIGN KEY(ean_13) REFERENCES versao ON DELETE CASCADE,
--
);
--
--
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
--
--
-- INSERT INTO
--
--