-- No. 1
SELECT
	orderNumber,
	UPPER(productCode) AS "Kode Produk",
	quantityOrdered,
	priceEach
FROM orderdetails
WHERE
	(quantityOrdered BETWEEN 20 AND 50 OR priceEach < 30) AND
	productCode LIKE 'S18%'
ORDER BY quantityOrdered DESC;

-- No. 2
SELECT
	customerNumber, customerName, country,
	CONCAT(contactFirstName, ' ', contactLastName) AS "Nama Kontak",
	creditLimit, 
	GREATEST(creditLimit, 10000) AS "Selisih Kredit"
FROM customers
WHERE
	creditLimit > 30000 AND
	(country = 'USA' OR country = 'France' OR country = 'Canada')
ORDER BY creditLimit DESC;

-- No. 3
SELECT
	productCode, productName, buyPrice, msrp,
	GREATEST(buyPrice, msrp) AS "Harga Tertinggi",
	LEAST(buyPrice, msrp) AS "Harga Terendah"
FROM products
WHERE productName ILIKE '%car%'

-- No. 4
SELECT
	orderNumber, orderDate, shippedDate,
	EXTRACT(YEAR FROM orderDate) AS "Tahun",
	EXTRACT(MONTH FROM orderDate) AS "Bulan",
	AGE(shippedDate, orderDate) AS "Lama Pengiriman",
	AGE(shippedDate, orderDate) AS "Interval Pengiriman",
	CURRENT_DATE AS "Tanggal Laporan",
	CURRENT_TIME AS "Waktu Laporan"
FROM orders
WHERE shippedDate IS NOT NULL;

-- No. 5
SELECT
	orderNumber, orderDate, shippedDate,
	orderDate + INTERVAL '10 days' AS "Estimasi Kirim",
	COALESCE(shippedDate, (orderdate + INTERVAL '10 days')) AS "Tanggal Aktual",
	AGE(shippedDate, orderDate) AS "Selisih Waktu"
FROM orders
WHERE comments ILIKE '%customer%'
	AND EXTRACT (MONTH FROM orderDate) BETWEEN 10 AND 12
	AND orderNumber % 2 != 0
ORDER BY orderDate DESC;