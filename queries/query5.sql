-- Esta query identifica alunos de cursos presenciais que conseguiram um emprego em um município
-- diferente daquele onde estudaram, com uma remuneração anual superior a R$1000.
-- O resultado mostra o aluno, seu curso, a remuneração, e os municípios da escola e do emprego.

WITH dados_analise_completo AS (
    SELECT
        fat.id_aluno,
        fat.vl_ultima_remuneracao_ano AS ultima_remuneracao_anual,
        fat.no_curso,
        fat.modalidade_ensino,
        deia.municipio_escola,
        fat.municipio_vinculo AS municipio_empregado,
        ROW_NUMBER() OVER (
            PARTITION BY fat.id_aluno 
            ORDER BY fat.vl_ultima_remuneracao_ano DESC
        ) AS maior_remuneracao,
        ROW_NUMBER() OVER (
            PARTITION BY fat.id_aluno
            ORDER BY fat.data_admissao_declarada DESC  
        ) AS ordem_emprego   -- Para obter o municipio ao qual o aluno está empregado atualmente
    FROM
        fato_aluno_trajetoria fat
    JOIN
        dim_escola_indicadores_anuais deia ON fat.co_escola_educacenso = deia.co_escola_educacenso
    WHERE
        -- Mantivemos a lógica de filtrar por 'Educação Presencial'.
        fat.modalidade_ensino = 'Educação Presencial'
        AND fat.vl_ultima_remuneracao_ano >= 1000
        AND deia.municipio_escola != fat.municipio_vinculo
        -- Garante que as localidades são válidas para comparação
        AND deia.municipio_escola IS NOT NULL
        AND fat.municipio_vinculo IS NOT NULL
),

ultimo_emprego AS (
    SELECT * 
    FROM dados_analise_completo
    WHERE maior_remuneracao = 1 AND ordem_emprego = 1
)

SELECT id_aluno, ultima_remuneracao_anual, no_curso, modalidade_ensino, municipio_escola, municipio_empregado FROM ultimo_emprego
    ORDER BY        
        ultima_remuneracao_anual DESC;