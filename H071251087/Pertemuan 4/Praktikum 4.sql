-- No. 1
SELECT
	customerNumber,
	SUM(amount) AS "Total Dana yang Disetorkan",
	COUNT(*) AS "Jumlah Transaksi Penyetoran",
	MAX(amount) AS "Setoran Terbesar"
FROM payments
GROUP BY customerNumber
HAVING
	COUNT(DISTINCT amount) > 4 AND
	AVG(amount) > 20000

-- No. 2
SELECT
	c.customerNumber,
	SUM(p.amount) AS "Total Dana yang Disetorkan"
FROM customers c
JOIN payments p ON c.customerNumber = p.customerNumber
GROUP BY c.customerNumber
HAVING SUM(p.amount) > 80000
ORDER BY SUM(p.amount) DESC;

-- No. 3
SELECT
	productline AS "Nama Kategori Barang",
	COUNT(productline) AS "Jumlah Ragam Produk",
	ROUND(AVG(buyprice), 2) AS "Rata-Rata Harga Jual",
	STRING_AGG(productname, ', ' ORDER BY productname) AS "Daftar Nama Produk" 
FROM products
GROUP BY productline
HAVING COUNT(productline) > 10;

-- No. 4
SELECT DISTINCT reportsTo AS "Nomor Identifikasi" FROM employees
WHERE reportsTo IS NOT NULL
EXCEPT
SELECT employeeNumber FROM employees 
WHERE jobtitle LIKE '%VP%' OR jobtitle LIKE '%President%';

-- No. 5
SELECT
	productCode,
	SUM(o.quantityOrdered) AS "Total Unit yang Terjual",
	ROUND(AVG(o.priceEach), 2) AS "Rata-Rata Harga Penjualan"
FROM orderdetails o
WHERE priceEach > 100
GROUP BY productCode
HAVING SUM(o.quantityOrdered) > 50
ORDER BY SUM(o.quantityOrdered) DESC;

-- No. 6
SELECT
	productCode AS "Kode Barang",
	SUM(quantityOrdered) AS "Total Barang yang Dipesan",
	SUM(quantityOrdered * priceEach) AS kotor,
	ROUND(AVG(priceEach), 2) AS "Rata-Rata Harga Rill Satuan Barang",
	(MAX(priceEach) - MIN(priceEach)) AS "Rentang Volatilitas"
FROM orderdetails
WHERE quantityOrdered > 20
GROUP BY productCode
HAVING SUM(quantityOrdered * priceEach) > 50000
ORDER BY kotor DESC;

-- No. 7
SELECT customerNumber FROM customers
WHERE creditLimit > 80000
INTERSECT
SELECT c.customerNumber FROM customers c
JOIN orders o ON c.CustomerNumber = o.CustomerNumber
WHERE (o.status = 'Cancelled' OR o.status = 'On Hold')
EXCEPT
SELECT customerNumber FROM payments
GROUP BY customerNumber
HAVING SUM(amount) > 100000;