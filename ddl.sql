CREATE TABLE "gudang" (
  "id" int PRIMARY KEY,
  "kode" varchar(200),
  "nama" varchar(200) NOT NULL
);

CREATE TABLE "barang" (
  "id" int,
  "kode" varchar(200) PRIMARY KEY,
  "nama" varchar(200),
  "harga" int,
  "expired" timestamp,
  "id_gudang" int
);

ALTER TABLE "barang" ADD FOREIGN KEY ("id_gudang") REFERENCES "gudang" ("id");

-- GET BARANG Dengan Filter
CREATE OR REPLACE FUNCTION get_barang(
	fl_id_gudang INT, fl_nama_gudang VARCHAR(200),
	fl_id_barang INT, fl_nama_barang VARCHAR(200),
	fl_expired_start TIMESTAMP, fl_expired_end TIMESTAMP)
RETURNS TABLE(id_gudang INT, kode_gudang varchar(200), nama_gudang varchar(200),
			  id_barang INT, kode_barang varchar(200), nama_barang varchar(200),
			  harga_barang INT, expired_barang TIMESTAMP) AS $$
DECLARE
	query TEXT;
BEGIN
	query := 'SELECT
		g.id, g.kode, g.nama,
		b.id, b.kode, b.nama, b.harga, b.expired
		FROM barang AS b
		JOIN gudang as g
			ON b.id_gudang = g.id
		WHERE 1=1';
		
	IF fl_id_gudang IS NOT NULL THEN
		query := query || ' AND g.id = $1';
	END IF;
	
	IF fl_nama_gudang IS NOT NULL THEN
		query := query || ' AND g.nama = $2';
	END IF;
	
	IF fl_id_barang IS NOT NULL THEN
		query := query || ' AND b.id = $3';
	END IF;
	
	IF fl_nama_barang IS NOT NULL THEN
		query := query || ' AND b.nama = $4';
	END IF;
	
	IF (fl_expired_start IS NOT NULL) AND (fl_expired_end IS NOT NULL) THEN
		query := query || ' AND (b.expired >= $2 AND b.expired <= $3)';
	END IF;
	
    RETURN QUERY EXECUTE query USING fl_id_gudang, fl_nama_gudang,
		fl_id_barang, fl_nama_barang,
		fl_expired_start, fl_expired_end;
END;
$$ LANGUAGE plpgsql;

-- CHECK Expired Barang
CREATE OR REPLACE FUNCTION check_expired_barang()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.expired < CURRENT_DATE THEN
        RAISE NOTICE 'Barang Kedaluarsa -> ID: %, Kode: %, Nama: %, Harga: %, Expired: %, ID Gudang: %',
                     NEW.id, NEW.kode, NEW.nama,
                     NEW.harga, NEW.expired, NEW.id_gudang;
    END IF;

    RETURN NULL; -- Kembalikan NULL karena sudah meng-handle di dalam blok trigger
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_insert_barang
AFTER INSERT ON barang
FOR EACH ROW
EXECUTE PROCEDURE check_expired_barang();
