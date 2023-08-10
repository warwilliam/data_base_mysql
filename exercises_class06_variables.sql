use musimundos;

-- Tabela: músicas e faturas
-- 1. Liste todas as canções com seus dados, mas o campo compositor deve ser mostrado em caixa alta, e aqueles com mais de 1, 
-- troque o ',' por ';'(virgula por ponto e vírgula). Além disso, vocês devem adicionar uma nova coluna que mostre o nome alternativo
-- da música (o nome que está entre parênteses dentro do campo nome). Para casos em que não há nome alternativo, mostre NULL .


select id, nome, replace(UPPER(compositor), ',', ';')
FROM cancoes c;
