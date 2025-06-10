PRAGMA foreign_keys = OFF;

-- FATO: fato_aluno_trajetoria
-- Esta tabela representa a trajetória individual de cada aluno, consolidando seus dados pessoais,
-- a última matrícula e o último vínculo empregatício.
-- Ela é a tabela de fatos central do nosso modelo estrela. O join com a dimensão de escolas
-- deve ser feito em tempo de consulta usando co_escola_educacenso e ano_entrada_ifb.
CREATE TABLE fato_aluno_trajetoria (
    -- Aluno (da tabela aluno_ifb)
    id_aluno INTEGER PRIMARY KEY,
    data_nascimento DATE,
    idade INTEGER,
    sexo VARCHAR,
    nacionalidade VARCHAR,
    raca VARCHAR,
    portador_deficiencia BOOLEAN,

    -- Matrícula (da tabela matricula_ifb - representando a última matrícula)
    ano_entrada_ifb INTEGER, -- Chave para join com a dim_escola
    co_ciclo_matricula VARCHAR,
    periodo VARCHAR,
    situacao_matricula VARCHAR,
    tipo_cota VARCHAR,
    atestado_baixarenda VARCHAR,
    unidade_ensino VARCHAR,

    -- Curso (da tabela curso_ifb - relacionado à última matrícula)
    co_curso VARCHAR,
    no_curso VARCHAR,
    co_tipo_curso VARCHAR,
    tipo_curso VARCHAR,
    co_tipo_nivel VARCHAR,
    ds_tipo_nivel VARCHAR,
    ds_eixo_tecnologico VARCHAR,
    modalidade_ensino VARCHAR,
    carga_horaria INTEGER,

    -- Chave da Escola (para o join com a dimensão de escolas)
    co_escola_educacenso VARCHAR,
    
    -- Vínculo Empregatício (da tabela vinculo_empregaticio - representando o último vínculo)
    ano_rais INTEGER,
    razao_social VARCHAR,
    tipo_vinculo_empregaticio VARCHAR,
    data_admissao_declarada DATE,
    tempo_emprego DOUBLE, -- em meses
    motivo_desligamento VARCHAR,
    mes_desligamento VARCHAR,
    indicador_vinculo_ativo BOOLEAN,
    
    -- Remuneração (da tabela remuneracao - relacionada ao último vínculo)
    vl_remun_media_nom DOUBLE,
    vl_remun_media_sm DOUBLE,
    vl_remun_dezembro_nom DOUBLE,
    vl_remun_dezembro_sm DOUBLE,
    qtd_hora_contr INTEGER,
    vl_ultima_remuneracao_ano DOUBLE,
    vl_salario_contratual DOUBLE,

    -- Localização do Vínculo Empregatício (da tabela localizacao)
    uf_vinculo VARCHAR,
    municipio_vinculo VARCHAR
);

-- DIMENSÃO: dim_escola_indicadores_anuais
-- Esta tabela consolida todos os indicadores anuais (desempenho, participação, taxas) para todas as escolas.
-- Ela serve como uma dimensão para ser unida (JOIN) com a tabela de fatos dos alunos.
-- A granularidade é de um registro por escola por ano.
CREATE TABLE dim_escola_indicadores_anuais (
    -- Chave composta
    co_escola_educacenso VARCHAR,
    nu_ano INTEGER,

    -- Info da Escola (da tabela escola)
    no_escola_educacenso VARCHAR,
    tp_dependencia_adm_escola SMALLINT,
    tp_localizacao_escola SMALLINT,
    inse_escola DOUBLE,

    -- Localização da Escola (da tabela localizacao)
    uf_escola VARCHAR,
    municipio_escola VARCHAR,

    -- Indicadores Escolares (da tabela indicadores_escolares)
    nu_taxa_permanencia DOUBLE,
    nu_taxa_aprovacao DOUBLE,
    nu_taxa_reprovacao DOUBLE,
    nu_taxa_abandono DOUBLE,
    pc_formacao_docente DOUBLE,
    porte_escola VARCHAR,

    -- Participação ENEM (da tabela participacao_enem)
    nu_matriculas_enem INTEGER,
    nu_participantes_nec_esp_enem INTEGER,
    nu_participantes_enem INTEGER,
    nu_taxa_participacao_enem DOUBLE,

    -- Desempenho ENEM (da tabela desempenho_enem)
    nu_media_cn_enem DOUBLE,
    nu_media_ch_enem DOUBLE,
    nu_media_lp_enem DOUBLE,
    nu_media_mt_enem DOUBLE,
    nu_media_red_enem DOUBLE,

    PRIMARY KEY (co_escola_educacenso, nu_ano)
);
