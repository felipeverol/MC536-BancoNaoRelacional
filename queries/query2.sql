-- Esta query tem como objetivo analisar a correlação entre o salário médio dos egressos
-- e o desempenho médio no ENEM das escolas localizadas no mesmo município do vínculo empregatício.
-- A análise é feita ano a ano, considerando o ano de admissão do egresso.

WITH vinculos_por_localizacao AS (
    -- Agrupa os egressos por ano de admissão e localização do vínculo, calculando o salário médio.
    SELECT
        EXTRACT(YEAR FROM data_admissao_declarada) AS ano_admissao,
        id_loc_vinculo,
        uf_vinculo,
        municipio_vinculo,
        AVG(vl_salario_contratual) AS media_salarial_local
    FROM
        fato_aluno_trajetoria
    WHERE
        data_admissao_declarada IS NOT NULL AND id_loc_vinculo IS NOT NULL
    GROUP BY
        ano_admissao, id_loc_vinculo, uf_vinculo, municipio_vinculo
),

enem_por_localizacao AS (
    -- Calcula a média geral do ENEM para cada escola por ano e localização.
    SELECT
        nu_ano,
        id_loc_escola,
        -- Calcula a média das 5 notas do ENEM
        AVG((nu_media_cn_enem + nu_media_ch_enem + nu_media_lp_enem + nu_media_mt_enem + nu_media_red_enem) / 5) AS media_geral_enem_escola
    FROM
        dim_escola_indicadores_anuais
    WHERE id_loc_escola IS NOT NULL
    GROUP BY
        nu_ano, id_loc_escola
)

-- Junta os dados de salários e desempenho no ENEM pela localização e ano.
SELECT
    vpl.ano_admissao,
    vpl.uf_vinculo,
    vpl.municipio_vinculo,
    ROUND(vpl.media_salarial_local, 2) AS media_salarial,
    ROUND(epl.media_geral_enem_escola, 2) AS media_enem
FROM
    vinculos_por_localizacao vpl
JOIN
    enem_por_localizacao epl ON vpl.id_loc_vinculo = epl.id_loc_escola AND vpl.ano_admissao = epl.nu_ano
ORDER BY
    vpl.uf_vinculo ASC, vpl.municipio_vinculo ASC;
