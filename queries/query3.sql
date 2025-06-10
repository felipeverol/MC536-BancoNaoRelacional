-- Esta query analisa a relação entre as características do mercado de trabalho local 
-- (vínculos, horas, remuneração) e o desempenho médio no ENEM das escolas na mesma localidade.
-- Apenas vínculos ativos são considerados e localidades com menos de 5 vínculos são filtradas.

WITH vinculos_por_localizacao AS (
    -- Agrega dados de vínculos empregatícios por localização (município/UF).
    -- Calcula o total de vínculos, média de horas contratuais e remuneração média.
    SELECT
        id_loc_vinculo,
        uf_vinculo,
        municipio_vinculo,
        COUNT(id_vinculo) AS total_vinculos,
        AVG(qtd_hora_contr) AS media_horas_contratuais,
        AVG(vl_remun_media_nom) AS remuneracao_media_nominal
    FROM
        fato_aluno_trajetoria
    WHERE
        indicador_vinculo_ativo = TRUE
        AND qtd_hora_contr > 0
        AND vl_remun_media_nom > 0
    GROUP BY
        id_loc_vinculo, uf_vinculo, municipio_vinculo
    HAVING
        COUNT(id_vinculo) >= 5
),

media_enem_por_localizacao AS (
    -- Calcula a média geral do ENEM e a quantidade de escolas por localização.
    SELECT
        id_loc_escola,
        AVG((nu_media_cn_enem + nu_media_ch_enem + nu_media_lp_enem + nu_media_mt_enem + nu_media_red_enem) / 5) AS media_enem,
        COUNT(DISTINCT co_escola_educacenso) AS qtd_escolas
    FROM
        dim_escola_indicadores_anuais
    GROUP BY
        id_loc_escola
)

-- Junta os dados de vínculos e de desempenho no ENEM pela localização.
SELECT
    vpl.uf_vinculo AS uf,
    vpl.municipio_vinculo AS municipio,
    vpl.total_vinculos,
    ROUND(vpl.media_horas_contratuais, 2) AS media_horas_contratuais,
    ROUND(vpl.remuneracao_media_nominal, 2) AS remuneracao_media_nominal,
    -- Calcula o valor médio por hora contratual
    ROUND(vpl.remuneracao_media_nominal / NULLIF(vpl.media_horas_contratuais, 0), 2) AS valor_hora_medio,
    ROUND(mepl.media_enem, 2) AS media_enem,
    mepl.qtd_escolas
FROM
    vinculos_por_localizacao vpl
JOIN
    media_enem_por_localizacao mepl ON vpl.id_loc_vinculo = mepl.id_loc_escola
ORDER BY
    vpl.uf_vinculo, remuneracao_media_nominal DESC;