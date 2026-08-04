USE PeopleAnalytics;
GO

INSERT INTO dim_departamento (departamento, cargo, area_educacao)
SELECT DISTINCT
    Department,
    JobRole,
    EducationField
FROM staging_rh;

-- Verificar
SELECT * FROM dim_departamento;

INSERT INTO dim_funcionario (id_funcionario, nome_gerado, genero, estado_civil, idade)
SELECT 
    EmployeeNumber,
    CONCAT('Funcionario_', EmployeeNumber),
    Gender,
    MaritalStatus,
    Age
FROM staging_rh;

SELECT TOP 5 * FROM dim_funcionario;

INSERT INTO dim_satisfacao (satisfacao_trabalho, satisfacao_ambiente, satisfacao_relacionamento, equilibrio_vida)
SELECT DISTINCT
    JobSatisfaction,
    EnvironmentSatisfaction,
    RelationshipSatisfaction,
    WorkLifeBalance
FROM staging_rh;

SELECT * FROM dim_satisfacao;

INSERT INTO dim_tempo (anos_empresa, anos_cargo_atual, anos_ultima_promocao, anos_gestor_atual)
SELECT DISTINCT
    YearsAtCompany,
    YearsInCurrentRole,
    YearsSinceLastPromotion,
    YearsWithCurrManager
FROM staging_rh;

SELECT * FROM dim_tempo;

INSERT INTO fato_rh (
    id_funcionario,
    id_departamento,
    id_satisfacao,
    id_tempo,
    salario_mensal,
    percentual_aumento,
    acoes_empresa,
    horas_extra,
    viagens_negocios,
    attrition,
    distancia_casa,
    nivel_cargo,
    empresas_anteriores
)
SELECT 
    s.EmployeeNumber,
    d.id_departamento,
    sat.id_satisfacao,
    t.id_tempo,
    s.MonthlyIncome,
    s.PercentSalaryHike,
    s.StockOptionLevel,
    s.OverTime,
    s.BusinessTravel,
    s.Attrition,
    s.DistanceFromHome,
    s.JobLevel,
    s.NumCompaniesWorked
FROM staging_rh s
JOIN dim_departamento d 
    ON s.Department = d.departamento 
    AND s.JobRole = d.cargo 
    AND s.EducationField = d.area_educacao
JOIN dim_satisfacao sat 
    ON s.JobSatisfaction = sat.satisfacao_trabalho
    AND s.EnvironmentSatisfaction = sat.satisfacao_ambiente
    AND s.RelationshipSatisfaction = sat.satisfacao_relacionamento
    AND s.WorkLifeBalance = sat.equilibrio_vida
JOIN dim_tempo t 
    ON s.YearsAtCompany = t.anos_empresa
    AND s.YearsInCurrentRole = t.anos_cargo_atual
    AND s.YearsSinceLastPromotion = t.anos_ultima_promocao
    AND s.YearsWithCurrManager = t.anos_gestor_atual;


SELECT COUNT(*) AS total_registros FROM fato_rh;