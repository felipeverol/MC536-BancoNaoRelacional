import duckdb

# Nome do banco persistente
db_path = "BancoNaoRelacional.db"

# Conecta (ou cria) o banco
con = duckdb.connect(db_path)

# Cria a tabela fato_aluno_trajetoria
con.execute("""
CREATE TABLE IF NOT EXISTS fato_aluno_trajetoria (
    id_aluno INTEGER,
    data_nascimento DATE,
    idade INTEGER,
    sexo VARCHAR,
    nacionalidade VARCHAR,
    raca VARCHAR,
    portador_deficiencia BOOLEAN,
    ano_entrada_ifb INTEGER,
    co_ciclo_matricula VARCHAR,
    periodo VARCHAR,
    situacao_matricula VARCHAR,
    tipo_cota VARCHAR,
    atestado_baixarenda VARCHAR,
    unidade_ensino VARCHAR,
    co_curso VARCHAR,
    no_curso VARCHAR,
    co_tipo_curso VARCHAR,
    tipo_curso VARCHAR,
    co_tipo_nivel VARCHAR,
    ds_tipo_nivel VARCHAR,
    ds_eixo_tecnologico VARCHAR,
    modalidade_ensino VARCHAR,
    carga_horaria INTEGER,
    co_escola_educacenso VARCHAR,
    ano_rais INTEGER,
    razao_social VARCHAR,
    tipo_vinculo_empregaticio VARCHAR,
    data_admissao_declarada DATE,
    tempo_emprego DOUBLE,
    motivo_desligamento VARCHAR,
    mes_desligamento VARCHAR,
    indicador_vinculo_ativo BOOLEAN,
    vl_remun_media_nom DOUBLE,
    vl_remun_media_sm DOUBLE,
    vl_remun_dezembro_nom DOUBLE,
    vl_remun_dezembro_sm DOUBLE,
    qtd_hora_contr INTEGER,
    vl_ultima_remuneracao_ano DOUBLE,
    vl_salario_contratual DOUBLE,
    uf_vinculo VARCHAR,
    municipio_vinculo VARCHAR
);
""")

# Cria a tabela dim_escola_indicadores_anuais
con.execute("""
CREATE TABLE IF NOT EXISTS dim_escola_indicadores_anuais (
    co_escola_educacenso VARCHAR,
    nu_ano INTEGER,
    no_escola_educacenso VARCHAR,
    tp_dependencia_adm_escola SMALLINT,
    tp_localizacao_escola SMALLINT,
    inse_escola DOUBLE,
    uf_escola VARCHAR,
    municipio_escola VARCHAR,
    nu_taxa_permanencia DOUBLE,
    nu_taxa_aprovacao DOUBLE,
    nu_taxa_reprovacao DOUBLE,
    nu_taxa_abandono DOUBLE,
    pc_formacao_docente DOUBLE,
    porte_escola VARCHAR,
    nu_matriculas_enem INTEGER,
    nu_participantes_nec_esp_enem INTEGER,
    nu_participantes_enem INTEGER,
    nu_taxa_participacao_enem DOUBLE,
    nu_media_cn_enem DOUBLE,
    nu_media_ch_enem DOUBLE,
    nu_media_lp_enem DOUBLE,
    nu_media_mt_enem DOUBLE,
    nu_media_red_enem DOUBLE,
    PRIMARY KEY (co_escola_educacenso, nu_ano)
);
""")

# Fecha a conexão
con.close()

print("Banco BancoNaoRelacional.db criado com sucesso com as tabelas definidas.")