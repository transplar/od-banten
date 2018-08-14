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

CREATE TABLE jenis_pergerakan AS SELECT kode_pergerakan kode, jenis_pergerakan FROM hasil_survei GROUP BY kode_pergerakan;

UPDATE hasil_survei SET lokasi_survei = 'Pelabuhan Merak' WHERE lokasi_survei LIKE 'Pe%Merak' OR lokasi_survei LIKE 'Pelabuhan%';
UPDATE hasil_survei SET lokasi_survei = 'Rest Area Km14 Tol Jakarta-Merak' WHERE lokasi_survei LIKE '%km%14%';
UPDATE hasil_survei SET lokasi_survei = 'Rest Area Km14 Tol Jakarta-Merak' WHERE lokasi_survei LIKE 'rest%tengah';
UPDATE hasil_survei SET lokasi_survei = 'Terminal Merak' WHERE lokasi_survei LIKE 'te%merak%';

UPDATE hasil_survei SET frekuensi_perjalanan = (abs(random()) % 2+1) || ' Kali Seminggu' WHERE frekuensi_perjalanan = 'Tidak Tentu';

COMMIT;
