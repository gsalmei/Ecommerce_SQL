-- Buscando os produtos mais vendidos em quantidade

SELECT
	opd.product_category_name,
	count(ood.order_id) AS qtd_pedidos
FROM
	olist_orders_dataset ood
LEFT JOIN olist_order_items_dataset ooid 
ON
	ood.order_id = ooid.order_id
LEFT JOIN olist_products_dataset opd 
ON
	ooid.product_id = opd.product_id
WHERE 
	opd.product_category_name <> ''
GROUP BY 
	opd.product_category_name 
ORDER BY 
	qtd_pedidos DESC
	
-- Buscando os produtos com maior receita

SELECT 
	opd.product_category_name,
	sum(ooid.price) as preco_pedidos 
FROM 
	olist_orders_dataset ood
LEFT JOIN olist_order_items_dataset ooid 
ON
	ood.order_id = ooid.order_id 
LEFT JOIN olist_products_dataset opd 
ON
	ooid.product_id = opd.product_id 
WHERE 
	opd.product_category_name <> ''
GROUP BY 
	opd.product_category_name 
ORDER BY 
	preco_pedidos DESC 
	
-- Buscando os produtos mais vendidos por categoria em um determinado estado
SELECT 
	opd.product_category_name, 
	sum(ooid.price) as preco_estado  
FROM
	olist_orders_dataset ood 
LEFT JOIN olist_order_items_dataset ooid 
ON
	ood.order_id = ooid.order_id 
LEFT JOIN olist_products_dataset opd 
ON
	ooid.product_id  = opd.product_id
LEFT JOIN olist_customers_dataset ocd 
ON
	ood.customer_id = ocd.customer_id 
WHERE 
	opd.product_category_name <> '' AND 
	ocd.customer_state = 'SP'
GROUP BY 
	opd.product_category_name 
ORDER BY 
	preco_estado DESC 

	
-- Total de vendas por estado (Top 5)

SELECT 
	ocd.customer_state,
	sum(ooid.price) as total_estado 
FROM 
	olist_orders_dataset ood 
LEFT JOIN
	olist_order_items_dataset ooid 
ON
	ood.order_id = ooid.order_id 
LEFT JOIN 
	olist_customers_dataset ocd 
ON
	ood.customer_id = ocd.customer_id 
LEFT JOIN 
	olist_products_dataset opd 
ON 
	ooid.product_id = opd.product_id 
WHERE 
	opd.product_category_name <> ''
GROUP BY 
	ocd.customer_state 
ORDER BY 
	total_estado DESC 
LIMIT 
	5

-- Top 5 produtos mais vendidos por estado (usando window functions)
	
WITH AUX AS (
SELECT 
	ocd.customer_state,
	ooid.product_id,
	sum(ooid.price) as soma_preco, 
	RANK () OVER(PARTITION BY ocd.customer_state ORDER BY SUM(ooid.price) DESC )
FROM 
	olist_orders_dataset ood 
LEFT JOIN
	olist_order_items_dataset ooid 
ON
	ood.order_id = ooid.order_id 
LEFT JOIN 
	olist_customers_dataset ocd 
ON
	ood.customer_id = ocd.customer_id 
LEFT JOIN 
	olist_products_dataset opd 
ON 
	ooid.product_id = opd.product_id 
WHERE 
	opd.product_category_name <> ''
GROUP BY 
	ocd.customer_state, ooid.product_id
ORDER BY 
	soma_preco DESC 
)
	
SELECT 
	*
FROM
	AUX
WHERE 
	rank = 1


	
