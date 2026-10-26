People Analytics — IBM HR Dataset

Projeto de análise de dados de RH com pipeline completo: modelagem dimensional em SQL Server, análise exploratória e modelo preditivo de turnover em Python e dashboard executivo no Power BI.

Sobre o projeto

O dataset utilizado é o IBM HR Analytics Employee Attrition & Performance, com 1470 registros de funcionários. O objetivo foi entender os fatores que levam ao turnover e construir um modelo capaz de identificar funcionários em risco de saída.

Stack utilizada

- SQL Server — modelagem dimensional e queries analíticas
- Python — análise exploratória, estatística e Machine Learning
- Power BI — dashboard executivo interativo

Estrutura do projeto

├── sql/
│ ├── 01_criar_banco_and_tables.sql
│ ├── 02_importar_dados.sql
│ ├── 03_populando_dimensoes.sql
│ ├── 04_queries_analiticas.sql
│ └── 05_criar_view.sql
├── python/
│ └── people_analytics.ipynb
└── README.md

Modelagem de dados

Arquitetura dimensional com tabela fato e quatro dimensões:

- fato_rh — métricas principais de cada funcionário
- dim_funcionario — perfil demográfico
- dim_departamento — estrutura organizacional
- dim_satisfacao — indicadores de satisfação
- dim_tempo — dados de carreira e tempo de empresa

Principais descobertas

- Taxa de turnover de 16.1% — acima da média saudável de 10 a 15%
- Funcionários que saem ganham em média 30% menos que os que ficam
- Horas extra triplicam a chance de saída — 31% contra 10%
- Viagens frequentes triplicam o risco — 25% contra 8%
- Funcionários entre 18 e 25 anos têm a maior taxa de saída — 36%
- 303 funcionários classificados como alto risco de turnover

Modelo preditivo

- Algoritmo: Random Forest com 100 árvores
- Acurácia: 81.3%
- Principal fator de risco: salário mensal — 12.2% de importância
- Outros fatores relevantes: idade — 11.5%, anos na empresa — 8.8%

Dashboard

Acesse o dashboard interativo:
https://app.powerbi.com/view?r=eyJrIjoiMGI4NzExYTctMWQ5OC00NzczLTljZDMtZmJkMTI1ZTA4OTYwIiwidCI6IjY1OWNlMmI4LTA3MTQtNDE5OC04YzM4LWRjOWI2MGFhYmI1NyJ9

Como executar

1. Rode os scripts SQL na ordem numerada para criar e popular o banco
2. Abra o notebook Python e execute as células em ordem
3. Acesse o dashboard pelo link acima
