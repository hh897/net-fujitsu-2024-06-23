INSERT INTO gudang(id, kode, nama)
 	VALUES
 		(1, 'g1', 'gudang 1'),
		(2, 'g2', 'gudang 2');
		

INSERT INTO BARANG(id, kode, nama, harga, expired, id_gudang)
 	VALUES
 		(1, '1001', 'Mie Sedap Goreng', 3000, '2024-06-23', 1),
 		(2, '1002', 'Sari Roti Sandwich Coklat', 5000, '2024-07-10', 1);

INSERT INTO BARANG(id, kode, nama, harga, expired, id_gudang)
	VALUES
		(3, '1003', 'Indomie Goreng', 3000, '2024-06-22', 1),
		(4, '1004', 'Sari Roti Sandwich Keju', 5000, '2024-07-10', 1);
		
INSERT INTO BARANG(id, kode, nama, harga, expired, id_gudang)
	VALUES
		(5, '1005', 'Indomie Kuah Soto', 3000, '2024-06-22', 1),
		(6, '1006', 'Sari Roti Sandwich Apel', 5000, '2024-07-10', 1),
		(7, '1007', 'Mie Ramen', 5000, '2024-06-20', 1);
