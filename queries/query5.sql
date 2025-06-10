-- Esta query identifica alunos de cursos presenciais que conseguiram um emprego em um município
-- diferente daquele onde estudaram, com uma remuneração anual superior a R$1000.
-- O resultado mostra o aluno, seu curso, a remuneração, e os municípios da escola e do emprego.

SELECT
    fat.id_aluno,
    fat.vl_ultima_remuneracao_ano AS ultima_remuneracao_anual,
    fat.no_curso,
    fat.modalidade_ensino,
    deia.municipio_escola,
    fat.municipio_vinculo AS municipio_empregado
FROM
    fato_aluno_trajetoria fat
JOIN
    dim_escola_indicadores_anuais deia ON fat.co_escola_educacenso = deia.co_escola_educacenso
                                       AND fat.ano_entrada_ifb = deia.nu_ano
WHERE
    -- O script original tinha um nome de CTE 'matriculados_a_distancia' mas filtrava por 'Educação Presencial'.
    -- Mantivemos a lógica de filtrar por 'Educação Presencial'.
    fat.modalidade_ensino = 'Educação Presencial'
    AND fat.vl_ultima_remuneracao_ano >= 1000
    AND deia.municipio_escola != fat.municipio_vinculo
    -- Garante que as localidades são válidas para comparação
    AND deia.municipio_escola IS NOT NULL
    AND fat.municipio_vinculo IS NOT NULL
ORDER BY
    ultima_remuneracao_anual DESC;