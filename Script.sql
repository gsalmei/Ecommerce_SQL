"1. Buscando produtos mais vendidos:"

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