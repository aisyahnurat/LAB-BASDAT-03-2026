-- No. 5
CREATE TABLE anggota (
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	nama_anggota VARCHAR(50) NOT NULL,
	kota_domisili VARCHAR(20) NOT NULL
);

DROP TABLE buku;
CREATE TABLE buku (
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	judul_buku VARCHAR(100) NOT NULL,
	genre VARCHAR(20) NOT NULL,
	stok INT DEFAULT 1
);

CREATE TABLE peminjaman (
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	id_anggota INT,
	FOREIGN KEY (id_anggota) REFERENCES anggota(id),
	id_buku INT,
	FOREIGN KEY (id_buku) REFERENCES buku(id),
	tanggal_pinjam DATE NOT NULL,
	tanggal_kembali DATE NULL,
	denda INT DEFAULT 0
);

CREATE INDEX index_genre ON buku(genre);
CREATE INDEX index_kota_domisili ON anggota(kota_domisili);

SELECT pg_indexes.tablename, indexname, indexdef 
FROM pg_indexes
WHERE schemaname = 'public' AND tablename = 'buku';