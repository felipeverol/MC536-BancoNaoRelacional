import duckdb
import os

# --- Configurações ---
DB_PATH = "BancoNaoRelacional.db"
TRATADOS_DIR = "dados/tratados"
ENEM_CSV_PATH = os.path.join(TRATADOS_DIR, "MICRODADOS_ENEM_ESCOLA.csv")
TRABALHO_CSV_PATH = os.path.join(TRATADOS_DIR, "mundo_trabalho.csv")

# --- Conexão com o DuckDB ---
con = duckdb.connect(database=DB_PATH, read_only=False)

# --- Carga para dim_escola_indicadores_anuais ---
print("Iniciando a carga para a tabela 'dim_escola_indicadores_anuais'...")
try:
    query = f"""
    -- Inicia a inserção na tabela de destino
    INSERT INTO dim_escola_indicadores_anuais
    
    -- Seleciona os dados do CSV, especificando o separador decimal
    SELECT
        co_escola_educacenso,
        nu_ano,
        no_escola_educacenso,
        tp_dependencia_adm_escola,
        tp_localizacao_escola,
        inse_escola,
        uf_escola,
        municipio_escola,
        nu_taxa_permanencia,
        nu_taxa_aprovacao,
        nu_taxa_reprovacao,
        nu_taxa_abandono,
        pc_formacao_docente,
        porte_escola,
        nu_matriculas_enem,
        nu_participantes_nec_esp_enem,
        nu_participantes_enem,
        nu_taxa_participacao_enem,
        nu_media_cn_enem,
        nu_media_ch_enem,
        nu_media_lp_enem,
        nu_media_mt_enem,
        nu_media_red_enem
    FROM read_csv('{ENEM_CSV_PATH}', header=True, sep=';')
    
    """

    con.execute(query)
    print("Carga para 'dim_escola_indicadores_anuais' concluída.")
except Exception as e:
    print(f"Erro ao carregar dados do ENEM: {e}")

# --- Carga para fato_aluno_trajetoria ---
print("\nIniciando a carga para a tabela 'fato_aluno_trajetoria'...")
try:
    query = f"""
    -- Inicia a inserção na tabela de destino
    INSERT INTO fato_aluno_trajetoria
    
    -- Seleciona os dados do CSV, especificando o separador decimal
    SELECT
        id_aluno,
        data_nascimento,
        idade,
        sexo,
        nacionalidade,
        raca,
        portador_deficiencia,
        ano_entrada_ifb,
        co_ciclo_matricula,
        periodo,
        situacao_matricula,
        tipo_cota,
        atestado_baixarenda,
        unidade_ensino,
        co_curso,
        no_curso,
        co_tipo_curso,
        tipo_curso,
        co_tipo_nivel,
        ds_tipo_nivel,
        ds_eixo_tecnologico,
        modalidade_ensino,
        carga_horaria,
        co_escola_educacenso,
        ano_rais,
        razao_social,
        tipo_vinculo_empregaticio,
        data_admissao_declarada,
        tempo_emprego,
        motivo_desligamento,
        mes_desligamento,
        indicador_vinculo_ativo,
        vl_remun_media_nom,
        vl_remun_media_sm,
        vl_remun_dezembro_nom,
        vl_remun_dezembro_sm,
        qtd_hora_contr,
        vl_ultima_remuneracao_ano,
        vl_salario_contratual,
        uf_vinculo,
        municipio_vinculo
    FROM read_csv('{TRABALHO_CSV_PATH}', header=True, sep=';')
    
    """

    con.execute(query)

    print("Carga para 'fato_aluno_trajetoria' concluída.")

except Exception as e:
    print(f"Erro ao carregar dados de trabalho: {e}")

# Fecha a conexão ao final do script
con.close()
print("\nProcesso de carga finalizado.")
