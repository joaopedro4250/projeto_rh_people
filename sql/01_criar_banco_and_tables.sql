CREATE DATABASE PeopleAnalytics;
GO

USE PeopleAnalytics;
GO

USE PeopleAnalytics;
GO

-- Dimensão Funcionário
CREATE TABLE dim_funcionario (
    id_funcionario INT PRIMARY KEY,
    nome_gerado VARCHAR(100),
    genero VARCHAR(20),
    estado_civil VARCHAR(20),
    idade INT
);

-- Dimensão Departamento
CREATE TABLE dim_departamento (
    id_departamento INT PRIMARY KEY IDENTITY(1,1),
    departamento VARCHAR(50),
    cargo VARCHAR(100),
    area_educacao VARCHAR(50)
);

-- Dimensão Satisfação
CREATE TABLE dim_satisfacao (
    id_satisfacao INT PRIMARY KEY IDENTITY(1,1),
    satisfacao_trabalho INT,
    satisfacao_ambiente INT,
    satisfacao_relacionamento INT,
    equilibrio_vida INT
);

-- Dimensão Tempo
CREATE TABLE dim_tempo (
    id_tempo INT PRIMARY KEY IDENTITY(1,1),
    anos_empresa INT,
    anos_cargo_atual INT,
    anos_ultima_promocao INT,
    anos_gestor_atual INT
);

-- Tabela Fato
CREATE TABLE fato_rh (
    id_fato INT PRIMARY KEY IDENTITY(1,1),
    id_funcionario INT FOREIGN KEY REFERENCES dim_funcionario(id_funcionario),
    id_departamento INT FOREIGN KEY REFERENCES dim_departamento(id_departamento),
    id_satisfacao INT FOREIGN KEY REFERENCES dim_satisfacao(id_satisfacao),
    id_tempo INT FOREIGN KEY REFERENCES dim_tempo(id_tempo),
    salario_mensal INT,
    percentual_aumento INT,
    acoes_empresa INT,
    horas_extra VARCHAR(5),
    viagens_negocios VARCHAR(20),
    attrition VARCHAR(5),
    distancia_casa INT,
    nivel_cargo INT,
    empresas_anteriores INT
);