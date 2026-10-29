-- No. 1
SELECT
	productCode, productName, msrp, quantityInStock,
CASE
	WHEN msrp < 50 AND quantityInStock > 500 THEN 'Ekonomis - Stok Tinggi'
	WHEN msrp < 50 AND quantityInStock <= 500 THEN 'Ekonomis - Stok Rendah'
	WHEN msrp > 50 AND msrp < 100 THEN 'Harga Menengah'
	WHEN msrp > 100 THEN 'Harga Preminum'
END
FROM products
ORDER BY msrp DESC;

-- No. 2
SELECT productCode, total_unit_terjual, jumlah_pesanan_berbeda
FROM (
	SELECT
		productCode, 
		SUM(quantityOrdered) AS total_unit_terjual,
		COUNT(orderNumber) AS jumlah_pesanan_berbeda
	FROM orderdetails
	GROUP BY productCode
)
WHERE
	total_unit_terjual > (SELECT AVG(quantityOrdered) FROM orderdetails) AND
	jumlah_pesanan_berbeda > 10
ORDER BY total_unit_terjual DESC;

-- No. 3
SELECT 
	productCode, productName, quantityInStock AS jumlah_stok, msrp
FROM products
WHERE
	quantityInStock > (SELECT AVG(quantityInStock) FROM products) AND
	msrp > (SELECT AVG(msrp) FROM products)
ORDER BY jumlah_stok DESC;

-- No. 4
BEGIN
UPDATE orders
SET status = 'Pengiriman'
WHERE orderNumber = '10100';
SAVEPOINT status_pengiriman;
UPDATE orders
SET status = 'Batal'
WHERE orderNumber = '10100';
ROLLBACK TO SAVEPOINT status_pengiriman;
COMMIT;