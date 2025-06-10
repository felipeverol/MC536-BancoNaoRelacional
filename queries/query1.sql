-- Esta query tem como objetivo analisar a relação entre o desempenho médio dos alunos do IFB no ENEM 
-- e a sua remuneração média após ingressarem no mercado de trabalho.
-- Para isso, associamos o ano de admissão do aluno no mercado de trabalho (data_admissao_declarada)
-- com o ano em que ele participou do ENEM (nu_ano), assumindo que ambos representam o mesmo ciclo de formação.

WITH medias_salariais AS (
    -- Calcula a média da remuneração nominal e do salário contratual dos alunos por:
    -- 1. ano de admissão no trabalho (extraído de data_admissao_declarada)
    -- 2. escola em que o aluno estudou (via co_escola_educacenso na fato_aluno_trajetoria)
    SELECT
        EXTRACT(YEAR FROM data_admissao_declarada) AS ano_admissao,
        co_escola_educacenso,
        ROUND(AVG(vl_remun_media_nom), 2) AS media_remun_media_nom,
        ROUND(AVG(vl_salario_contratual), 2) AS media_salario_contratual
    FROM
        fato_aluno_trajetoria
    WHERE
        data_admissao_declarada IS NOT NULL
    GROUP BY
        ano_admissao,
        co_escola_educacenso
)

-- Associa as médias salariais calculadas com as médias de desempenho no ENEM 
-- para os mesmos anos e escolas, retornando os indicadores lado a lado.
SELECT
    ms.ano_admissao,
    ms.co_escola_educacenso,
    ms.media_remun_media_nom,
    ms.media_salario_contratual,
    de.nu_media_cn_enem,
    de.nu_media_ch_enem,
    de.nu_media_lp_enem,
    de.nu_media_mt_enem,
    de.nu_media_red_enem
FROM
    medias_salariais ms
JOIN dim_escola_indicadores_anuais de
    ON ms.ano_admissao = de.nu_ano
    AND ms.co_escola_educacenso = de.co_escola_educacenso
WHERE
    ms.co_escola_educacenso = '53006178'  -- IFB (Instituto Federal de Brasília)
ORDER BY
    ms.ano_admissao;

