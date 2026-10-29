-- No. 1
SELECT
	c.contactfirstname,
	c.customername,
	o.city,
	CONCAT(e.firstname, ' ', e.lastname) AS sales_rep_name
FROM customers c
JOIN employees e ON  c.salesrepemployeenumber = e.employeenumber
JOIN offices o ON e.officecode = o.officecode
WHERE
	c.contactfirstname ILIKE 'A%' AND
	o.city != 'NYC'
ORDER BY c.customername ASC;

-- No. 2
SELECT
	c.customername,
	SUM(p.amount) AS total_payment,
	MAX(p.amount) AS max_single_payment
FROM customers c
JOIN payments p ON  c.customernumber = p.customernumber
GROUP BY customername
HAVING SUM(p.amount) > 50000
ORDER BY total_payment DESC;

-- No. 3
SELECT
	c.customername,
	COUNT(DISTINCT o.ordernumber) AS total_order,
	ROUND(AVG(od.quantityordered), 2) AS avg_quantity_per_order
FROM customers c
JOIN orders o ON c.customernumber = o.customernumber
JOIN orderdetails od ON o.ordernumber = od.ordernumber
GROUP BY c.customernumber
HAVING
	COUNT(DISTINCT o.ordernumber) > 3 AND
	ROUND(AVG(od.quantityordered), 2) > 35
ORDER BY total_order, avg_quantity_per_order DESC;

-- No. 4
SELECT
	p.productLine, 
	SUM(od.quantityOrdered) AS total_terjual,
	ROUND(AVG(od.priceEach), 2) AS rata_rata_harga,
	ROUND(AVG((p.msrp - od.priceEach)/p.msrp * 100), 2) AS avg_discount_percentage
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productLine
HAVING
	SUM(od.quantityOrdered) > 3000 AND
	AVG(od.priceEach) > 80
ORDER BY total_terjual DESC;

-- No. 5
SELECT
	c.customerName,
	SUM(od.quantityOrdered * od.priceEach) AS total_transaksi,
	COUNT(DISTINCT o.orderNumber) AS total_shipped_orders,
	ROUND(SUM(od.quantityOrdered * od.priceEach) / COUNT(DISTINCT o.orderNumber), 2) AS avg_transaction_per_order
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY c.customerName, o.status
HAVING
	COUNT(DISTINCT EXTRACT (YEAR FROM o.orderDate)) > 1 AND
	o.status = 'Shipped'
ORDER BY total_transaksi DESC
LIMIT 5;

-- No. 6
SELECT
	c.customerName,
	c.city AS customer_city,
	o.city AS office_city,
	SUM(od.quantityOrdered) AS total_unit_terjual,
	--ROUND(SUM(od.quantityOrdered * od.priceEach) / COUNT(DISTINCT ord.orderNumber), 2) AS avg_nilai_per_order
	ROUND(AVG(od.quantityOrdered * od.priceEach), 2) AS avg_nilai_per_order,
	SUM(od.quantityOrdered * od.priceEach) AS harga_total,
	COUNT(ord.*)
FROM customers c
JOIN employees e ON e.employeeNumber = c.salesrepemployeenumber
JOIN offices o ON e.officeCode = o.officeCode
JOIN orders ord ON c.customerNumber = ord.customerNumber
JOIN orderdetails od ON ord.orderNumber = od.orderNumber
WHERE o.territory = 'EMEA'
GROUP BY c.customerName, c.city, o.city
HAVING 
	COUNT(DISTINCT EXTRACT (YEAR FROM ord.orderDate)) > 2 AND
	SUM(od.quantityOrdered) > 1000 AND
	(SUM(od.quantityOrdered * od.priceEach) / COUNT(DISTINCT ord.orderNumber)) > 10000
	-- (AVG(od.quantityOrdered * od.priceEach)) > 10000
ORDER BY avg_nilai_per_order DESC;