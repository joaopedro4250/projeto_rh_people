-- 7. Criando uma VIEW completa para análise
CREATE VIEW vw_analise_completa AS
SELECT 
    func.id_funcionario,
    func.genero,
    func.estado_civil,
    func.idade,
    dep.departamento,
    dep.cargo,
    dep.area_educacao,
    sat.satisfacao_trabalho,
    sat.satisfacao_ambiente,
    sat.satisfacao_relacionamento,
    sat.equilibrio_vida,
    t.anos_empresa,
    t.anos_cargo_atual,
    t.anos_ultima_promocao,
    t.anos_gestor_atual,
    f.salario_mensal,
    f.percentual_aumento,
    f.acoes_empresa,
    f.horas_extra,
    f.viagens_negocios,
    f.attrition,
    f.distancia_casa,
    f.nivel_cargo,
    f.empresas_anteriores,
    -- Score de risco já calculado na view
    (
        CASE WHEN f.horas_extra = 'Yes' THEN 2 ELSE 0 END +
        CASE WHEN sat.satisfacao_trabalho <= 2 THEN 2 ELSE 0 END +
        CASE WHEN sat.equilibrio_vida <= 2 THEN 2 ELSE 0 END +
        CASE WHEN f.distancia_casa > 20 THEN 1 ELSE 0 END +
        CASE WHEN f.salario_mensal < 3000 THEN 1 ELSE 0 END +
        CASE WHEN t.anos_empresa < 2 THEN 1 ELSE 0 END
    ) AS score_risco,
    CASE 
        WHEN (
            CASE WHEN f.horas_extra = 'Yes' THEN 2 ELSE 0 END +
            CASE WHEN sat.satisfacao_trabalho <= 2 THEN 2 ELSE 0 END +
            CASE WHEN sat.equilibrio_vida <= 2 THEN 2 ELSE 0 END +
            CASE WHEN f.distancia_casa > 20 THEN 1 ELSE 0 END +
            CASE WHEN f.salario_mensal < 3000 THEN 1 ELSE 0 END +
            CASE WHEN t.anos_empresa < 2 THEN 1 ELSE 0 END
        ) >= 5 THEN 'Alto Risco'
        WHEN (
            CASE WHEN f.horas_extra = 'Yes' THEN 2 ELSE 0 END +
            CASE WHEN sat.satisfacao_trabalho <= 2 THEN 2 ELSE 0 END +
            CASE WHEN sat.equilibrio_vida <= 2 THEN 2 ELSE 0 END +
            CASE WHEN f.distancia_casa > 20 THEN 1 ELSE 0 END +
            CASE WHEN f.salario_mensal < 3000 THEN 1 ELSE 0 END +
            CASE WHEN t.anos_empresa < 2 THEN 1 ELSE 0 END
        ) >= 3 THEN 'Médio Risco'
        ELSE 'Baixo Risco'
    END AS classificacao_risco
FROM fato_rh f
JOIN dim_funcionario func ON f.id_funcionario = func.id_funcionario
JOIN dim_departamento dep ON f.id_departamento = dep.id_departamento
JOIN dim_satisfacao sat ON f.id_satisfacao = sat.id_satisfacao
JOIN dim_tempo t ON f.id_tempo = t.id_tempo;

-- Testar a view
SELECT TOP 10 * FROM vw_analise_completa
ORDER BY score_risco DESC;