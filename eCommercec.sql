use eCommerce
/* Primeira Análise Exploratória dos Dados */

/* <><> TB_CUSTOMERS <><> */

SELECT *
FROM tb_Customers;

/* Na tabela tb_Customers, temos apenas algumas informações básicas a respeito dos clientes 
	Agora vou verificar se há clientes registrados em duplicidade.*/

SELECT customer_id, COUNT(*) AS qtd
FROM tb_Customers
GROUP BY customer_id
HAVING COUNT(*) > 1;
/* Com base no código acima, foi possível verificar que não há duplicidade, portanto essa é uma tabela DIMENSÃO de clientes.
	Agora vou verificar se há algum missing (valor nulo) nas colunas. */

SELECT *
FROM tb_Customers
WHERE 
    customer_id IS NULL OR
    customer_zip_code_prefix IS NULL OR
    customer_city IS NULL OR
	customer_state IS NULL;
/* Não há missings, portanto irei prosseguir para a próxima tabela */


/* <><> TB_ORDERITEMS<><> */
SELECT TOP 50 *
FROM tb_OrderItems;
/* Na tabela tb_OrderItems há dados referentes aos produtos vendidos. Número do pedido, ID do produto vendido, ID do vendedor, o valor que o produto foi vendido e o valor do envio. É uma tabela FATO!
	Agora vou verificar se há algum missing (valor nulo) nas colunas.*/

SELECT *
FROM tb_OrderItems
WHERE 
    order_id IS NULL OR
    product_id IS NULL OR
    seller_id IS NULL OR
	price IS NULL OR
	shipping_charges IS NULL;
/* Não há missings, portanto irei prosseguir para a próxima tabela */


/* <><> TB_ORDERS<><> */
SELECT TOP 50 *
FROM tb_Orders;
/* Na tabela tb_Orders há todos os pedidos realizados, o ID de cada um, o ID do cliente, o status do pedido e horários.
Agora vou verificar se há algum missing (valor nulo) nas colunas.*/

SELECT *
FROM tb_Orders
WHERE 
    order_id IS NULL OR
    customer_id IS NULL OR
    order_status IS NULL OR
	order_purchase_timestamp IS NULL OR
	order_approved_at IS NULL OR
	order_delivered_timestamp IS NULL OR
	order_estimated_delivery_date IS NULL;
/* Neste caso há valores nulos nas colunas de data, como é algo que será necessário para análises futuras, irei tratar estes casos posteriormente. 
	Agora vou verificar se há clientes registrados em duplicidade. */

SELECT order_id, COUNT(*) AS qtd
FROM tb_Orders
GROUP BY order_id
HAVING COUNT(*) > 1;
/* Com base no código acima, foi possível verificar que não há duplicidade, portanto essa é uma tabela DIMENSÃO de pedidos. */


/* <><> TB_PAYMENTS<><> */
SELECT TOP 50 *
FROM tb_Payments;
/* Na tabela tb_Payments há dados de pagamentos: número do pedido, forma de pagamento, quantidade de parcelas e valor do pagamento. É uma tabela FATO!
Agora vou verificar se há algum missing (valor nulo) nas colunas.*/

SELECT *
FROM tb_Payments
WHERE 
    order_id IS NULL OR
    payment_sequential IS NULL OR
    payment_type IS NULL OR
	payment_installments IS NULL OR
	payment_value IS NULL
/* Não há missings, portanto irei prosseguir para a próxima tabela */


/* <><> TB_PRODUCTS<><> */
SELECT TOP 50 *
FROM tb_Products;
/* Na tabela tb_Products há o registro de todos os produtos e suas informações. 
	Ela aparenta ser uma tabela dimensão, no entanto vou verificar se há duplicidades assim como feito anteriormente. */

SELECT product_id, COUNT(*) AS qtd
FROM tb_Products
GROUP BY product_id
HAVING COUNT(*) > 1;

/* Com base no resultado, foi possível verificar que há vários product_id em duplicidade.. agora vou ver se realmente é uma duplicidade ou há algo que difere um do outro */

SELECT *
FROM tb_Products
WHERE product_id = 'Ph7gx9xXX1Y1';
SELECT *
FROM tb_Products
WHERE product_id = 'unyXXeCSrRdJ'
SELECT *
FROM tb_Products
WHERE product_id = 'HK7VO1IhaIbS'

/* Coletei alguns product_id aleatórios e verifiquei que realmente são duplicidades, não há nada que difere uma linha da outra. Devido a isso, será necessário realizar um tratamento nessa tabela e remover duplicadas.
	Porém, irei criar uma view com base nela e remover as duplicidades. */

CREATE VIEW dim_Products AS
WITH dProducts AS (
	SELECT *,
		ROW_NUMBER() OVER(PARTITION BY product_id ORDER BY (SELECT NULL)) AS num
	FROM tb_Products
)
SELECT
	product_id,
	product_category_name,
	product_weight_g,
	product_length_cm,
	product_height_cm,
	product_width_cm
FROM dProducts
WHERE num = 1;

/* Vou verificar se funcionou */

SELECT product_id, COUNT(*) AS qtd
FROM dim_Products
GROUP BY product_id
HAVING COUNT(*) > 1;

/* Ótimo, agora tenho uma tabela dimensão dos produtos. 
Agora vou verificar se há algum missing (valores nulos) nas colunas.*/

SELECT *
FROM dim_Products
WHERE 
    product_id IS NULL OR
    product_category_name IS NULL OR
    product_weight_g IS NULL OR
	product_length_cm IS NULL OR
	product_height_cm IS NULL OR
	product_weight_g IS NULL;

/* Há alguns missings, principalmente na coluna product_category_name, irei tratar eles substituindo por Not defined. Já os missings nas colunas de medidas e pesos, irei substituir por 0 momentaneamente, para que possa
	prosseguir com o projeto, ser fácil de identificar posteriormente e fazer as correções corretamente. */

UPDATE dim_Products
SET product_category_name = 'Not defined'
WHERE product_category_name IS NULL;

UPDATE dim_Products
SET product_weight_g = 0
WHERE product_weight_g IS NULL;

UPDATE dim_Products
SET product_length_cm = 0
WHERE product_length_cm IS NULL;

UPDATE dim_Products
SET product_height_cm= 0
WHERE product_height_cm IS NULL;

UPDATE dim_Products
SET product_width_cm = 0
WHERE product_width_cm IS NULL;

/* Verificando as alterações */

SELECT *
FROM dim_Products
WHERE 
    product_id IS NULL OR
    product_category_name IS NULL OR
    product_weight_g IS NULL OR
	product_length_cm IS NULL OR
	product_height_cm IS NULL OR
	product_weight_g IS NULL;

/* Agora eliminei os missings */