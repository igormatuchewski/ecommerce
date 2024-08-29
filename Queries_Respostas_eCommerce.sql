/* 
 <><><> QUESTÃO 1 <><><>

 => 1.1 Qual é a diferença média entre data estimada de entrega e a data real de entrega dos pedidos?

Criando uma coluna para calcular quantos dias o pedido atrasou ou chegou antes do prazo */
ALTER TABLE dim_Orders
ADD DifDias INT;

UPDATE dim_Orders
SET DifDias = DATEDIFF(day, order_delivered_timestamp, order_estimated_delivery_date);

SELECT *
FROM dim_Orders;

SELECT AVG(DifDias) as Media
FROM dim_Orders

/* Verifiquei que, em média, os produtos são entregues 12 dias antes do prazo estimado */

/* 
 => 1.2 Qual é a porcentagem de pedidos entregues antes, no prazo e após a data estimada?

Para isso irei criar outra coluna que irá me retornar se o pedido foi entregue antes, no prazo ou após o prazo */
ALTER TABLE dim_Orders
ADD SituacaoEntrega VARCHAR(20)

UPDATE dim_Orders
SET SituacaoEntrega = CASE
						WHEN DifDias < 0 THEN 'Atrasado'
						WHEN DifDias = 0 THEN 'No Prazo'
						WHEN DifDias > 0 THEN 'Antes do Prazo'
					   END;

/* Criada a coluna, irei verificar a quantidade total de ordens e a quantidade em cada Situação e, logo após, a porcentagem de cada Situacao */

SELECT COUNT (*) AS qtdOrdens
FROM dim_Orders

SELECT COUNT(*) AS qtdAtraso
FROM dim_Orders
WHERE SituacaoEntrega = 'Atrasado'
/* 5605 */

SELECT COUNT(*) AS qtdNoPrazo
FROM dim_Orders
WHERE SituacaoEntrega = 'No Prazo'
/* 1133 */

SELECT COUNT(*) AS qtdAntesPrazo
FROM dim_Orders
WHERE SituacaoEntrega = 'Antes do Prazo'
/* 80689 */

SELECT
	(COUNT(CASE WHEN SituacaoEntrega = 'Atrasado' THEN 1 END) * 100.0) / COUNT(*) AS PercAtraso
FROM dim_Orders
/* 6.27*/

SELECT
	(COUNT(CASE WHEN SituacaoEntrega = 'No Prazo' THEN 1 END) * 100.0) / COUNT(*) AS PercAtraso
FROM dim_Orders
/* 1.26% */

SELECT
	(COUNT(CASE WHEN SituacaoEntrega = 'Antes do Prazo' THEN 1 END) * 100.0) / COUNT(*) AS PercAtraso
FROM dim_Orders
/* 90.34% */


/* 
 <><><> QUESTÃO 2 <><><>

 => 2.1 Quais vendedores possuem a maior taxa de pedidos cancelados ou devolvidos?

Criando uma coluna para calcular quantos dias o pedido atrasou ou chegou antes do prazo */

WITH Cancelados AS (
    SELECT oi.seller_id,
           COUNT(od.order_status) AS qtdCancelados
    FROM tb_OrderItems AS oi
    LEFT JOIN dim_Orders AS od
    ON oi.order_id = od.order_id
    WHERE od.order_status = 'canceled'
    GROUP BY oi.seller_id
),
TotalCancelados AS (
    SELECT COUNT(*) AS totalCancelados
    FROM tb_OrderItems AS oi
    LEFT JOIN dim_Orders AS od
    ON oi.order_id = od.order_id
    WHERE od.order_status = 'canceled'
)
SELECT TOP 10 c.seller_id,
       COALESCE(
           100.0 * c.qtdCancelados / t.totalCancelados,
           0
       ) AS percCancelados
FROM Cancelados AS c
CROSS JOIN TotalCancelados AS t
ORDER BY percCancelados DESC;

/* Explicação
WITH TotalCancelados AS (...):

Calcula o total geral de pedidos cancelados.
WITH CanceladosPorVendedor AS (...):

Calcula o total de pedidos cancelados por vendedor.
SELECT c.seller_id, COALESCE(100.0 * c.qtdCancelados / t.total_cancelados, 0) AS pctCancelados:

Calcula a porcentagem de pedidos cancelados por vendedor em relação ao total geral de pedidos cancelados.
COALESCE(..., 0): Garante que a porcentagem seja 0 se o total de pedidos cancelados for 0.
CROSS JOIN TotalCancelados AS t:

Combina os resultados da contagem de cancelamentos por vendedor com o total geral de cancelamentos.
ORDER BY pctCancelados DESC:

Ordena os resultados pela porcentagem de pedidos cancelados em ordem decrescente.


Com isso temos os 10 vendedores com mais taxa de cancelamentos */

/*
 => 2.2 Quais vendedores tem a melhor taxa de cumprimento de prazos de entrega?
 */

 WITH TotalPedidos AS (
	SELECT COUNT(*) AS total_pedidos
	FROM dim_Orders
),
NoPrazoPorVendedor AS (
	SELECT oi.seller_id,
		COUNT(*) AS qtdNoPrazo
	FROM tb_OrderItems as oi
	LEFT JOIN dim_Orders as od
	ON oi.order_id = od.order_id
	WHERE od.SituacaoEntrega = 'No Prazo' or od.SituacaoEntrega = 'Antes do Prazo'
	GROUP BY oi.seller_id
)
SELECT TOP 10 np.seller_id,
		COALESCE(
			100.0 * np.qtdNoPrazo / t.total_pedidos,
			0
		) AS percNoPrazo
FROM NoPrazoPorVendedor as np
CROSS JOIN TotalPedidos as t
ORDER BY percNoPrazo DESC;

/* Com isso, é possível verificar os 10 vendedores que possuem a melhor % de entregas no prazo ou antes do prazo */

/*
 <><><> QUESTÃO 3 <><><>
 => 3.1 Qual é a distribuição geográfica dos clientes em termos de volume de pedidos e valor gasto?

 Primeiro irei a distribuição geográfica em quantidade de pedidos
 */

 SELECT ct.customer_state, COUNT(od.order_id) AS qtdPedidos
 FROM dim_Orders AS od
 LEFT JOIN dim_Customers as ct
 ON od.customer_id = ct.customer_id
 GROUP BY ct.customer_state
 ORDER BY qtdPedidos DESC;

 /* Agora vou verificar com base no valor dos pedidos */

  SELECT ct.customer_state, SUM(oi.price) AS vlrPedidos
 FROM dim_Orders AS od
 LEFT JOIN dim_Customers as ct
 ON od.customer_id = ct.customer_id
 LEFT JOIN tb_OrderItems as oi
 ON oi.order_id = od.order_id
 GROUP BY ct.customer_state
 ORDER BY vlrPedidos DESC;


 /*
 <><><> QUESTÃO 4 <><><>
 => 4.1 Quais categorias de produtos geram mais receita e quais tem a maior taxa de cancelamento?

 Primeiro vou verificar as 10 categorias que geram mais receita
 */

SELECT TOP 10 pd.product_category_name, SUM(oi.price) AS receita
FROM dim_Products as pd
LEFT JOIN tb_OrderItems as oi
ON pd.product_id = oi.product_id
GROUP BY pd.product_category_name
ORDER BY receita DESC;

/* Agora vou analisar a taxa de cancelamento */

SELECT pd.product_category_name, COUNT(od.order_status) as qtdCancelamento
FROM dim_Products as pd
LEFT JOIN tb_OrderItems as oi
ON pd.product_id = oi.product_id
LEFT JOIN dim_Orders as od
ON od.order_id = oi.order_id
WHERE od.order_status = 'canceled'
GROUP BY pd.product_category_name
ORDER BY qtdCancelamento DESC;


 /*
 <><><> QUESTÃO 5 <><><>
 => 5.1 Qual é o método de pagamento mais utilizado e qual traz maior receita?

 Primeiro vou analisar o método de pagamento mais utilizado.
 */

SELECT py.payment_type, COUNT(od.order_id) AS qtdPgto
FROM tb_Payments AS py
LEFT JOIN dim_Orders AS od
ON od.order_id = py.order_id
GROUP BY py.payment_type
ORDER BY qtdPgto DESC;

/* Agora por receita */

SELECT py.payment_type, SUM(oi.price) AS receita
FROM tb_OrderItems AS oi
LEFT JOIN dim_Orders AS od
ON oi.order_id = od.order_id
LEFT JOIN tb_Payments AS py
ON py.order_id = od.order_id
GROUP BY py.payment_type
ORDER BY receita DESC;

 /* => 5.2 Como está distribuído o número de parcelas escolhidas pelos clientes para pagamentos a prazo?
 */

 SELECT payment_sequential, COUNT(payment_sequential) AS qtd
 FROM tb_Payments
 GROUP BY payment_sequential
 ORDER BY qtd DESC;

