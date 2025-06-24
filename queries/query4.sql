-- Esta query compara a "persistência no emprego" (tempo de emprego) dos egressos do IFB 
-- com a "taxa de abandono" da instituição no ano em que ingressaram.
-- O objetivo é verificar se há uma correlação entre a evasão escolar e a permanência no primeiro emprego.
-- A análise foca nos alunos que ingressaram entre 2009 e 2015.

WITH dados_analise_completo AS (
    SELECT
        fat.id_aluno,
        fat.ano_entrada_ifb,
        fat.tempo_emprego,
        fat.data_admissao_declarada,
        deia.nu_taxa_abandono,
        ROW_NUMBER() OVER (
            PARTITION BY fat.id_aluno
            ORDER BY fat.data_admissao_declarada DESC  
        ) AS ordem_emprego
    FROM
        fato_aluno_trajetoria fat
    JOIN
        dim_escola_indicadores_anuais deia ON fat.co_escola_educacenso = deia.co_escola_educacenso
                                           AND fat.ano_entrada_ifb = deia.nu_ano
    WHERE
        fat.ano_entrada_ifb BETWEEN 2009 AND 2015
        AND fat.co_escola_educacenso = '53006178'
        AND fat.motivo_desligamento IS NOT NULL AND fat.motivo_desligamento != 'NAO DESLIGADO NO ANO'
        AND fat.tempo_emprego IS NOT NULL
        AND deia.nu_taxa_abandono IS NOT NULL
),

primeiro_emprego AS (
    SELECT *
    FROM dados_analise_completo
    WHERE ordem_emprego = 1
)

SELECT
    id_aluno,
    ano_entrada_ifb,
    CASE
        WHEN tempo_emprego <= 12 THEN 'BAIXA'
        WHEN tempo_emprego > 12 AND tempo_emprego <= 36 THEN 'MEDIA'
        ELSE 'ALTA'
    END AS persistencia_emprego,
    CASE
        WHEN nu_taxa_abandono < 5 THEN 'BAIXA'
        WHEN nu_taxa_abandono >= 5 AND nu_taxa_abandono < 10 THEN 'MEDIA'
        ELSE 'ALTA'
    END AS categoria_abandono_escolar
FROM
    primeiro_emprego
ORDER BY
    id_aluno;
