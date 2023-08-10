-- DB emarket

SELECT ClienteID, Contato, FaturaID, DataFatura,
LEAD(DataFatura, 1) OVER (
PARTITION BY ClienteID
ORDER BY DataFatura
) ProximaCompra
FROM faturas
INNER JOIN clientes USING(ClienteID);

-- LEAD consegue pegar o proximo registro no Caso DataFatura
-- Da msm forma podemos usar o LAG para pegar o registro antecessor


WITH faturas AS(
	SELECT FaturaID,
		   ClienteID,
           Contato,
           YEAR(DataFatura) ano_venda,
           Transporte Valor_fatura
	FROM faturas
    INNER JOIN clientes USING(ClienteID)
    GROUP BY FaturaID, ano_venda
    )
    SELECT 
		FaturaID,
        ClienteID,
        Contato,
        ano_venda,
        valor_fatura,
        NTILE(4) over (
			partition by ano_venda
            ORDER BY Valor_fatura DESC
            ) grupo_venda
            FROM faturas;
-- NTILE cria grupos dividos pelo valor informado, no caso 4, sendo particionado por ano_venda, sendo assim todos registros daquele determinado ano sera divido igualmente em 4 parte

SELECT Cidade, Pais,
row_number() OVER(
partition by Pais
ORDER BY Pais
)Ocorrecias
FROM clientes;
-- conta a quantidade de registros que foi definido pelo campo informado em 'partition by'

-- FIRST VALUE busca o primeiro registro no campo informado, no caso o primeiro registro levando o titulo como parametro
SELECT Sobrenome, Nome, Titulo, DataContratacao,
FIRST_VALUE(Nome) OVER(
partition by Titulo
	order by DataContratacao
)mais_antigo
FROM empregados;

