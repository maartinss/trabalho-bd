-- SIBD 2025/2026
-- 2ª Etapa
-- Grupo 12
-- Rodrigo Martins 63745 TP14 Proporção de esforço: 25% Esteve responsável maioritariamente pela criação das tabelas, mas também contribuiu para as outras áreas do trabalho e contribuiu para uma melhor interpertação do diagrama e conheecimentos teóricos
-- Denis Dryagin 63749 TP14 Proporção de esforço: 25% Contribuiu para a criação das tabelas, assim como para uma boa organização do trabalho e restrições de integridade
-- Rodrigo Lourenço 64727 TP14 Proporção de esforço: 25% Contribuiu para a a criação e inserção nas tabelas e criação das mesmas, assim como ajudou nas restrições de integridade
-- Pedro Dias 63736 TP14 Proporção de esforço: 25% Também esteve responsável pela criação e inserção nas tabelas, também pela verificação da integridade dos dados nelas colocados.
--
-- 1. Username e e-mail dos utilizadores nascidos em 1990, que têm como artista
-- favorito Day6, e que, durante o ano de 2025, registaram a posse de um ou mais
-- álbuns interpretados por esse artista. O EAN-13, título, e ano de lançamento
-- dos álbuns também devem ser mostrados, bem como o número de dias que
-- passaram desde a data dos registos de posse. A ordenação do resultado deve
-- ser ascendente pelo username dos utilizadores e descendente pelo número de
-- dias que passaram desde os registos de posse e pelo EAN-13 dos álbuns.
-- Variante com menor cotação: sem o cálculo do número de dias que passaram
-- desde a data dos registos de posse de álbuns.
CREATE VIEW exercicio1 AS 
    SELECT DISTINCT UT.username, UT.email, AL.ean, AL.titulo, AL.ano, (CURRENT_DATE - PO.desde) AS dias_desde_registo
    FROM utilizador UT, artista AR, album AL, possui PO
    WHERE (UT.nascimento = 1990) 
        AND (UT.artista = AR.isni) 
        AND (AR.nome = 'Day6')
        AND (UT.username = PO.utilizador)
        AND (PO.album = AL.ean)
        AND (AL.artista = AR.isni)
        AND (PO.desde > '01-01-2025')
    ORDER BY UT.username ASC, dias_desde_registo DESC, AL.ean DESC;
--
-- 2. Username dos utilizadores com endereço de e-mail no gmail.com que, considerando apenas os registos de posse efetuados entre 2000 e 2020, ou não possuem álbuns interpretados pelo artista Dire Straits, ou possuem no máximo
-- três álbuns desse artista. Adicionalmente, os utilizadores não podem possuir
-- álbuns do tipo single, seja qual for o artista e o ano do registo. O resultado deve
-- vir ordenado pelo username de forma ascendente.
-- Variantes com menor cotação: a) sem a verificação dos utilizadores não possuírem álbuns do tipo single; b) sem a verificação do número de álbuns dos Dire
-- Straits; e c) sem a verificação do e-mail dos utilizadores ser no gmail.com.
CREATE VIEW exercicio2 AS
    SELECT DISTINCT UT.username
    FROM utilizador UT
    JOIN possui PO ON UT.username = PO.utilizador
    WHERE (REGEXP_LIKE(UT.email, '@gmail\.com'))
        AND (PO.desde BETWEEN TO_DATE('01-01-2000', 'DD-MM-YYYY') AND TO_DATE('31-12-2020', 'DD-MM-YYYY'))
        AND(UT.username NOT IN (
            SELECT PO2.utilizador
            FROM possui PO2
            JOIN album AL2 ON AL2.ean = PO2.album
            WHERE ((AL2.tipo = 'single'))
        ))
        AND ((SELECT COUNT(*)
            FROM possui PO3
            JOIN album AL ON AL.ean = PO3.album
            JOIN artista AR ON AR.isni = AL.artista
            WHERE (AR.nome = 'Dire Straits')
                    AND PO3.utilizador = UT.username) <= 3)
    ORDER BY UT.username ASC;
--
-- 3. Nome e ano de início de atividade de artistas tais que todos os utilizadores nascidos de 2000 em diante tenham registado a posse de pelo menos um álbum
-- interpretado por esses artistas, com as seguintes restrições adicionais: só artistas que tenham lançado um ou mais álbuns nos dois últimos anos, e os registos de posse dos utilizadores têm de ter sido feitos entre as 12h e as 19h59.
-- O resultado deve vir ordenado por nome de artista de forma ascendente e pelo
-- seu ano de início de atividade de forma descendente. Nota: a data de um registo
-- de posse de álbum também guarda as horas e minutos.
-- Variantes com menor cotação: a) sem a verificação do número de álbuns lançados pelos artistas nos dois últimos anos; e b) sem a verificação da hora dos registos de posse de álbuns.
CREATE VIEW exercicio3 AS
    SELECT DISTINCT AR.nome, AR.inicio
    FROM artista AR
    JOIN album AL ON AR.isni = AL.artista
    JOIN possui PO on AL.ean = PO.album 
    JOIN utilizador UT ON PO.utilizador = UT.username
    WHERE (UT.nascimento >= 2000)
        AND ((SELECT COUNT(*)
            FROM possui PO2
            JOIN 
            WHERE (PO2.utilizador = UT.username)
                AND (PO2.album =)) >= 1)
    ORDER BY ;