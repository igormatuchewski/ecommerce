use eCommerce
/* Primeira An�lise Explorat�ria dos Dados */

/* <><> TB_CUSTOMERS <><> */

SELECT *
FROM tb_Customers;

/* Na tabela tb_Customers, temos apenas algumas informa��es b�sicas a respeito dos clientes 
	Agora vou verificar se h� clientes registrados em duplicidade.*/

SELECT customer_id, COUNT(*) AS qtd
FROM tb_Customers
GROUP BY customer_id
HAVING COUNT(*) > 1;
/* Com base no c�digo acima, foi poss�vel verificar que n�o h� duplicidade, portanto essa � uma tabela DIMENS�O de clientes.
	Agora vou verificar se h� algum missing (valor nulo) nas colunas. */

SELECT *
FROM tb_Customers
WHERE 
    customer_id IS NULL OR
    customer_zip_code_prefix IS NULL OR
    customer_city IS NULL OR
	customer_state IS NULL;
/* N�o h� missings, portanto irei prosseguir para a pr�xima tabela */


/* <><> TB_ORDERITEMS<><> */
SELECT TOP 50 *
FROM tb_OrderItems;
/* Na tabela tb_OrderItems h� dados referentes aos produtos vendidos. N�mero do pedido, ID do produto vendido, ID do vendedor, o valor que o produto foi vendido e o valor do envio. � uma tabela FATO!
	Agora vou verificar se h� algum missing (valor nulo) nas colunas.*/

SELECT *
FROM tb_OrderItems
WHERE 
    order_id IS NULL OR
    product_id IS NULL OR
    seller_id IS NULL OR
	price IS NULL OR
	shipping_charges IS NULL;
/* N�o h� missings, portanto irei prosseguir para a pr�xima tabela */


/* <><> TB_ORDERS<><> */
SELECT TOP 50 *
FROM tb_Orders;
/* Na tabela tb_Orders h� todos os pedidos realizados, o ID de cada um, o ID do cliente, o status do pedido e hor�rios.
Agora vou verificar se h� algum missing (valor nulo) nas colunas.*/

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
/* Neste caso h� valores nulos nas colunas de data, como � algo que ser� necess�rio para an�lises futuras, irei tratar estes casos posteriormente. 
	Agora vou verificar se h� clientes registrados em duplicidade. */

SELECT order_id, COUNT(*) AS qtd
FROM tb_Orders
GROUP BY order_id
HAVING COUNT(*) > 1;
/* Com base no c�digo acima, foi poss�vel verificar que n�o h� duplicidade, portanto essa � uma tabela DIMENS�O de pedidos. */


/* <><> TB_PAYMENTS<><> */
SELECT TOP 50 *
FROM tb_Payments;
/* Na tabela tb_Payments h� dados de pagamentos: n�mero do pedido, forma de pagamento, quantidade de parcelas e valor do pagamento. � uma tabela FATO!
Agora vou verificar se h� algum missing (valor nulo) nas colunas.*/

SELECT *
FROM tb_Payments
WHERE 
    order_id IS NULL OR
    payment_sequential IS NULL OR
    payment_type IS NULL OR
	payment_installments IS NULL OR
	payment_value IS NULL
/* N�o h� missings, portanto irei prosseguir para a pr�xima tabela */


/* <><> TB_PRODUCTS<><> */
SELECT TOP 50 *
FROM tb_Products;
/* Na tabela tb_Products h� o registro de todos os produtos e suas informa��es. 
	Ela aparenta ser uma tabela dimens�o, no entanto vou verificar se h� duplicidades assim como feito anteriormente. */

SELECT product_id, COUNT(*) AS qtd
FROM tb_Products
GROUP BY product_id
HAVING COUNT(*) > 1;

/* Com base no resultado, foi poss�vel verificar que h� v�rios product_id em duplicidade.. agora vou ver se realmente � uma duplicidade ou h� algo que difere um do outro */

SELECT *
FROM tb_Products
WHERE product_id = 'Ph7gx9xXX1Y1';
SELECT *
FROM tb_Products
WHERE product_id = 'unyXXeCSrRdJ'
SELECT *
FROM tb_Products
WHERE product_id = 'HK7VO1IhaIbS'

/* Coletei alguns product_id aleat�rios e verifiquei que realmente s�o duplicidades, n�o h� nada que difere uma linha da outra. Devido a isso, ser� necess�rio realizar um tratamento nessa tabela e remover duplicadas.
	Por�m, irei criar uma view com base nela e remover as duplicidades. */

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

/* �timo, agora tenho uma tabela dimens�o dos produtos. 
Agora vou verificar se h� algum missing (valores nulos) nas colunas.*/

SELECT *
FROM dim_Products
WHERE 
    product_id IS NULL OR
    product_category_name IS NULL OR
    product_weight_g IS NULL OR
	product_length_cm IS NULL OR
	product_height_cm IS NULL OR
	product_weight_g IS NULL;

/* H� alguns missings, principalmente na coluna product_category_name, irei tratar eles substituindo por Not defined. J� os missings nas colunas de medidas e pesos, irei substituir por 0 momentaneamente, para que possa
	prosseguir com o projeto, ser f�cil de identificar posteriormente e fazer as corre��es corretamente. */

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

/* Verificando as altera��es */

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