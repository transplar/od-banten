BEGIN TRANSACTION;

CREATE TABLE sqlitestudio_temp_table AS SELECT * FROM hasil_survei;

DROP TABLE hasil_survei;

CREATE TABLE hasil_survei (
	TIMESTAMP,
	nama_ruas_jalan,
	lokasi_survei,
	nama_responden,
	jenis_kendaraan,
	alamat_asal,
	intra,
	alamat_tujuan,
	melintas,
	kode_pergerakan,
	jenis_pergerakan,
	maksud_perjalanan,
	frekuensi_perjalanan,
	jumlah_penumpang
	);

INSERT INTO tmp (
	TIMESTAMP,
	nama_ruas_jalan,
	lokasi_survei,
	nama_responden,
	jenis_kendaraan,
	alamat_asal,
	intra,
	alamat_tujuan,
	melintas,
	kode_pergerakan,
	jenis_pergerakan,
	maksud_perjalanan,
	frekuensi_perjalanan,
	jumlah_penumpang
	)
SELECT TIMESTAMP,
	"Nama Ruas Jalan",
	"Lokasi Titik Survei",
	"Nama Responden",
	"Jenis Kendaraan",
	"Alamat Asal (Desa/Kelurahan/Kecamatan)",
	"Di Banten",
	"Alamat Tujuan Perjalanan",
	"Numpang Lewat",
	"Kode Pergerakan",
	"Jenis Pergerakan",
	"Maksud Perjalanan",
	"Frekuensi Perjalanan",
	"Jumlah Penumpang"
FROM sqlitestudio_temp_table;

DROP TABLE sqlitestudio_temp_table;

UPDATE hasil_survei SET kode_pergerakan = cast(kode_pergerakan AS integer) WHERE 1;
UPDATE hasil_survei SET kode_pergerakan = 1 WHERE kode_pergerakan = 11;
UPDATE hasil_survei SET kode_pergerakan = 2 WHERE kode_pergerakan = 22;

COMMIT;
