-- 1. Taxa de turnover por departamento
SELECT 
    d.departamento,
    COUNT(*) AS total_funcionarios,
    SUM(CASE WHEN f.attrition = 'Yes' THEN 1 ELSE 0 END) AS saidas,
    ROUND(
        CAST(SUM(CASE WHEN f.attrition = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) 
        / COUNT(*) * 100, 2
    ) AS taxa_turnover_pct
FROM fato_rh f
JOIN dim_departamento d ON f.id_departamento = d.id_departamento
GROUP BY d.departamento
ORDER BY taxa_turnover_pct DESC;

-- 2. Salário médio por cargo e nível
SELECT 
    d.cargo,
    f.nivel_cargo,
    COUNT(*) AS total,
    ROUND(AVG(CAST(f.salario_mensal AS FLOAT)), 2) AS salario_medio,
    MIN(f.salario_mensal) AS salario_minimo,
    MAX(f.salario_mensal) AS salario_maximo
FROM fato_rh f
JOIN dim_departamento d ON f.id_departamento = d.id_departamento
GROUP BY d.cargo, f.nivel_cargo
ORDER BY d.cargo, f.nivel_cargo;

-- 3. Ranking de risco de turnover
SELECT 
    func.nome_gerado,
    dep.cargo,
    dep.departamento,
    f.salario_mensal,
    f.horas_extra,
    f.distancia_casa,
    sat.satisfacao_trabalho,
    sat.equilibrio_vida,
    f.attrition,
    -- Score de risco calculado
    (
        CASE WHEN f.horas_extra = 'Yes' THEN 2 ELSE 0 END +
        CASE WHEN sat.satisfacao_trabalho <= 2 THEN 2 ELSE 0 END +
        CASE WHEN sat.equilibrio_vida <= 2 THEN 2 ELSE 0 END +
        CASE WHEN f.distancia_casa > 20 THEN 1 ELSE 0 END +
        CASE WHEN f.salario_mensal < 3000 THEN 1 ELSE 0 END
    ) AS score_risco
FROM fato_rh f
JOIN dim_funcionario func ON f.id_funcionario = func.id_funcionario
JOIN dim_departamento dep ON f.id_departamento = dep.id_departamento
JOIN dim_satisfacao sat ON f.id_satisfacao = sat.id_satisfacao
ORDER BY score_risco DESC;

-- 4. Ranking de salário dentro de cada departamento
-- usando Window Function (ROW_NUMBER e AVG over partition)
SELECT 
    func.nome_gerado,
    dep.departamento,
    dep.cargo,
    f.salario_mensal,
    ROUND(AVG(CAST(f.salario_mensal AS FLOAT)) 
        OVER (PARTITION BY dep.departamento), 2) AS media_depto,
    f.salario_mensal - AVG(CAST(f.salario_mensal AS FLOAT)) 
        OVER (PARTITION BY dep.departamento) AS diff_media,
    ROW_NUMBER() 
        OVER (PARTITION BY dep.departamento ORDER BY f.salario_mensal DESC) AS ranking_salario,
    f.attrition
FROM fato_rh f
JOIN dim_funcionario func ON f.id_funcionario = func.id_funcionario
JOIN dim_departamento dep ON f.id_departamento = dep.id_departamento
ORDER BY dep.departamento, ranking_salario;

-- 5. Funcionários com alto risco usando CTE
WITH risco_calculado AS (
    SELECT 
        func.nome_gerado,
        dep.departamento,
        dep.cargo,
        f.salario_mensal,
        f.attrition,
        f.horas_extra,
        sat.satisfacao_trabalho,
        sat.equilibrio_vida,
        t.anos_empresa,
        (
            CASE WHEN f.horas_extra = 'Yes' THEN 2 ELSE 0 END +
            CASE WHEN sat.satisfacao_trabalho <= 2 THEN 2 ELSE 0 END +
            CASE WHEN sat.equilibrio_vida <= 2 THEN 2 ELSE 0 END +
            CASE WHEN f.distancia_casa > 20 THEN 1 ELSE 0 END +
            CASE WHEN f.salario_mensal < 3000 THEN 1 ELSE 0 END +
            CASE WHEN t.anos_empresa < 2 THEN 1 ELSE 0 END
        ) AS score_risco
    FROM fato_rh f
    JOIN dim_funcionario func ON f.id_funcionario = func.id_funcionario
    JOIN dim_departamento dep ON f.id_departamento = dep.id_departamento
    JOIN dim_satisfacao sat ON f.id_satisfacao = sat.id_satisfacao
    JOIN dim_tempo t ON f.id_tempo = t.id_tempo
),
resumo_depto AS (
    SELECT 
        departamento,
        COUNT(*) AS total,
        SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS saidas,
        ROUND(AVG(CAST(score_risco AS FLOAT)), 2) AS score_medio_risco
    FROM risco_calculado
    GROUP BY departamento
)
SELECT 
    r.*,
    rd.score_medio_risco AS media_risco_depto,
    CASE 
        WHEN r.score_risco >= 5 THEN 'Alto Risco'
        WHEN r.score_risco >= 3 THEN 'Médio Risco'
        ELSE 'Baixo Risco'
    END AS classificacao_risco
FROM risco_calculado r
JOIN resumo_depto rd ON r.departamento = rd.departamento
ORDER BY r.score_risco DESC;

-- 6. Relação entre anos de empresa, salário e turnover
SELECT 
    t.anos_empresa,
    COUNT(*) AS total_funcionarios,
    SUM(CASE WHEN f.attrition = 'Yes' THEN 1 ELSE 0 END) AS saidas,
    ROUND(
        CAST(SUM(CASE WHEN f.attrition = 'Yes' THEN 1 ELSE 0 END) AS FLOAT)
        / COUNT(*) * 100, 2
    ) AS taxa_turnover_pct,
    ROUND(AVG(CAST(f.salario_mensal AS FLOAT)), 2) AS salario_medio,
    ROUND(AVG(CAST(sat.satisfacao_trabalho AS FLOAT)), 2) AS satisfacao_media
FROM fato_rh f
JOIN dim_tempo t ON f.id_tempo = t.id_tempo
JOIN dim_satisfacao sat ON f.id_satisfacao = sat.id_satisfacao
GROUP BY t.anos_empresa
ORDER BY t.anos_empresa;

