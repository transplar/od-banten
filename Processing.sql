BEGIN TRANSACTION;

-- Selecting valid pergerakan data and save it into new table
create table proc_pergerakan as select * from pergerakan where asal_kecamatan is not null and tujuan_kecamatan is not null;

-- Save invalid pergerakan data for use later
create table no_origin as select * from pergerakan where asal_kecamatan is null or tujuan_kecamatan is null;

-- Create tenporary table to validate asal kota based on asal kecamatan
create table temp_pergerakan as
    select p.id, p.responden_id, p.asal_kelurahan, p.asal_kecamatan, p.asal_kota_kabupaten
    , p.tujuan_kelurahan, p.tujuan_kecamatan, p.tujuan_kota_kabupaten
    , a.kecamatan kecamatan_asal, a.kota kota_asal
    , at.kecamatan kecamatan_tujuan, at.kota kota_tujuan
    from proc_pergerakan p left join administrasi a on a.kecamatan = p.asal_kecamatan
    left join administrasi at on at.kecamatan = p.tujuan_kecamatan
    group by p.id
;

-- Update nama kota based it's kecamatan
--
-- Update asal kota
update temp_pergerakan set asal_kota_kabupaten = kota_asal
    where asal_kecamatan = kecamatan_asal
    and asal_kota_kabupaten <> kota_asal
    and (asal_kecamatan != 'Curug' and asal_kecamatan != 'Cibeber' and asal_kecamatan != 'Ciruas' and asal_kecamatan != 'Sobang')
;
-- Update kota for Kecamatan Curug
update temp_pergerakan set asal_kota_kabupaten = 'Kab. Tangerang' where asal_kecamatan = 'Curug' and asal_kelurahan = 'Binong';
update temp_pergerakan set asal_kota_kabupaten = 'Kab. Tangerang' where asal_kecamatan = 'Curug' and asal_kelurahan = 'Suka bakti';
update temp_pergerakan set asal_kota_kabupaten = 'Kab. Tangerang' where asal_kecamatan = 'Curug' and asal_kota_kabupaten = 'Kota Tangerang';
update temp_pergerakan set asal_kota_kabupaten = 'Kota Serang' where asal_kecamatan = 'Curug' and asal_kelurahan = 'Cisangku';
update temp_pergerakan set asal_kota_kabupaten = 'Kota Serang' where asal_kecamatan = 'Curug' and asal_kelurahan = 'Curug';
update temp_pergerakan set asal_kota_kabupaten = 'Kota Serang' where asal_kecamatan = 'Curug' and asal_kelurahan = 'Siketug';
-- Update tujuan kota
update temp_pergerakan set tujuan_kota_kabupaten = kota_tujuan
    where tujuan_kecamatan = kecamatan_tujuan
    and tujuan_kota_kabupaten <> kota_tujuan
    and (tujuan_kecamatan != 'Curug' and tujuan_kecamatan != 'Cibeber' and tujuan_kecamatan != 'Ciruas' and tujuan_kecamatan != 'Sobang')
;
-- Update kota for Kecamatan Ciruas
update temp_pergerakan set tujuan_kota_kabupaten = 'Kab. Serang' where tujuan_kecamatan = 'Ciruas' and tujuan_kelurahan = 'Citerep';
-- Update kota for Kecamatan Curug
update temp_pergerakan set tujuan_kota_kabupaten = 'Kab. Tangerang' where tujuan_kecamatan = 'Curug' and tujuan_kota_kabupaten = 'Kab. Pandeglang';
update temp_pergerakan set tujuan_kota_kabupaten = 'Kab. Tangerang' where tujuan_kecamatan = 'Curug' and tujuan_kota_kabupaten = 'Kota Tangerang';
update temp_pergerakan set tujuan_kota_kabupaten = 'Kota Serang' where tujuan_kecamatan = 'Curug' and tujuan_kota_kabupaten = 'Kab. Serang';

-- Update kota from temporary table
update proc_pergerakan
    set asal_kota_kabupaten = (select asal_kota_kabupaten from temp_pergerakan where id = proc_pergerakan.id),
        tujuan_kota_kabupaten = (select tujuan_kota_kabupaten from temp_pergerakan where id = proc_pergerakan.id)
    where id in (select id from temp_pergerakan)
;

-- Zonasi data
-- Table: zonasi_kab
DROP TABLE IF EXISTS zonasi_kab;
CREATE TABLE zonasi_kab (kecamatan TEXT, kota TEXT, zona_id INT, penduduk_proporsi INTEGER);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Banjarsari', 'Kab. Lebak', 36, 25);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Malingping', 'Kab. Lebak', 36, 27);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cijaku', 'Kab. Lebak', 36, 12);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Gunungkencana', 'Kab. Lebak', 36, 14);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Wanasalam', 'Kab. Lebak', 36, 22);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Bayah', 'Kab. Lebak', 37, 32);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cilograng', 'Kab. Lebak', 37, 25);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cibeber', 'Kab. Lebak', 37, 43);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cikulur', 'Kab. Lebak', 38, 12);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Warunggunung', 'Kab. Lebak', 38, 14);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cibadak', 'Kab. Lebak', 38, 15);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Rangkasbitung', 'Kab. Lebak', 38, 30);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Curugbitung', 'Kab. Lebak', 38, 8);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Maja', 'Kab. Lebak', 38, 13);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Kalanganyar', 'Kab. Lebak', 38, 8);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Leuwidamar', 'Kab. Lebak', 39, 42);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cileles', 'Kab. Lebak', 39, 39);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Bojongmanik', 'Kab. Lebak', 39, 18);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Muncang', 'Kab. Lebak', 40, 13);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cimarga', 'Kab. Lebak', 40, 25);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Lebakgedong', 'Kab. Lebak', 40, 9);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Sajira', 'Kab. Lebak', 40, 19);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cipanas', 'Kab. Lebak', 40, 19);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Sobang', 'Kab. Lebak', 40, 14);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cigemblong', 'Kab. Lebak', 41, 18);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Panggarangan', 'Kab. Lebak', 41, 32);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cihara', 'Kab. Lebak', 41, 27);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cirinten', 'Kab. Lebak', 41, 23);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cimanggu', 'Kab. Pandeglang', 42, 14);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Panimbang', 'Kab. Pandeglang', 42, 19);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cigeulis', 'Kab. Pandeglang', 42, 13);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Sukaresmi', 'Kab. Pandeglang', 42, 13);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Sumur', 'Kab. Pandeglang', 42, 9);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Sobang', 'Kab. Pandeglang', 42, 13);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cibitung', 'Kab. Pandeglang', 42, 8);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cibaliung', 'Kab. Pandeglang', 42, 11);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Sindangresmi', 'Kab. Pandeglang', 43, 18);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cikeusik', 'Kab. Pandeglang', 43, 43);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Munjul', 'Kab. Pandeglang', 43, 18);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Angsana', 'Kab. Pandeglang', 43, 21);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Jiput', 'Kab. Pandeglang', 44, 10);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Menes', 'Kab. Pandeglang', 44, 12);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Mandalawangi', 'Kab. Pandeglang', 44, 16);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Pagelaran', 'Kab. Pandeglang', 44, 12);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Carita', 'Kab. Pandeglang', 44, 11);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cikedal', 'Kab. Pandeglang', 44, 11);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Pulosari', 'Kab. Pandeglang', 44, 10);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Labuan', 'Kab. Pandeglang', 44, 19);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cimanuk', 'Kab. Pandeglang', 45, 13);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Kaduhejo', 'Kab. Pandeglang', 45, 12);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Koroncong', 'Kab. Pandeglang', 45, 6);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Banjar', 'Kab. Pandeglang', 45, 10);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Majasari', 'Kab. Pandeglang', 45, 16);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Pandeglang', 'Kab. Pandeglang', 45, 14);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cadasari', 'Kab. Pandeglang', 45, 11);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Mekarjaya', 'Kab. Pandeglang', 45, 6);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Karangtanjung', 'Kab. Pandeglang', 45, 11);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Picung', 'Kab. Pandeglang', 46, 19);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Bojong', 'Kab. Pandeglang', 46, 18);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Saketi', 'Kab. Pandeglang', 46, 23);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cipeucang', 'Kab. Pandeglang', 46, 15);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Patia', 'Kab. Pandeglang', 46, 14);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cisata', 'Kab. Pandeglang', 46, 12);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Bojonegara', 'Kab. Serang', 47, 25);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Puloampel', 'Kab. Serang', 47, 21);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Kramatwatu', 'Kab. Serang', 47, 54);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cinangka', 'Kab. Serang', 48, 36);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Mancak', 'Kab. Serang', 48, 29);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Anyar', 'Kab. Serang', 48, 35);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Lebak Wangi', 'Kab. Serang', 49, 21);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Tanara', 'Kab. Serang', 49, 22);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Pontang', 'Kab. Serang', 49, 22);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Carenang', 'Kab. Serang', 49, 19);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Tirtayasa', 'Kab. Serang', 49, 16);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Jawilan', 'Kab. Serang', 50, 28);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Kopo', 'Kab. Serang', 50, 26);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Tunjungteja', 'Kab. Serang', 50, 21);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Pamarayan', 'Kab. Serang', 50, 26);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Petir', 'Kab. Serang', 51, 28);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Ciomas', 'Kab. Serang', 51, 21);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Baros', 'Kab. Serang', 51, 29);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Pabuaran', 'Kab. Serang', 51, 22);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Kibin', 'Kab. Serang', 52, 16);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Ciruas', 'Kab. Serang', 52, 16);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cikeusal', 'Kab. Serang', 52, 15);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Binuang', 'Kab. Serang', 52, 8);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cikande', 'Kab. Serang', 52, 21);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Kragilan', 'Kab. Serang', 52, 17);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Bandung', 'Kab. Serang', 52, 7);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Padarincang', 'Kab. Serang', 53, 50);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Waringinkurung', 'Kab. Serang', 53, 34);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Gunungsari', 'Kab. Serang', 53, 16);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Sukadiri', 'Kab. Tangerang', 54, 16);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Sepatan Timur', 'Kab. Tangerang', 54, 27);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Sepatan', 'Kab. Tangerang', 54, 34);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Mauk', 'Kab. Tangerang', 54, 23);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Pasarkemis', 'Kab. Tangerang', 55, 51);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Rajeg', 'Kab. Tangerang', 55, 27);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Sindangjaya', 'Kab. Tangerang', 55, 15);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Kemiri', 'Kab. Tangerang', 55, 7);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Kronjo', 'Kab. Tangerang', 56, 22);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Sukamulya', 'Kab. Tangerang', 56, 23);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Kresek', 'Kab. Tangerang', 56, 23);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Gunung Kaler', 'Kab. Tangerang', 56, 18);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Mekarbaru', 'Kab. Tangerang', 56, 13);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cisoka', 'Kab. Tangerang', 57, 32);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Jayanti', 'Kab. Tangerang', 57, 24);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Balaraja', 'Kab. Tangerang', 57, 44);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Solear', 'Kab. Tangerang', 58, 31);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Jambe', 'Kab. Tangerang', 58, 16);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Tigaraksa', 'Kab. Tangerang', 58, 53);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Curug', 'Kab. Tangerang', 59, 33);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Panongan', 'Kab. Tangerang', 59, 22);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cikupa', 'Kab. Tangerang', 59, 45);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cisauk', 'Kab. Tangerang', 60, 15);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Pagedangan', 'Kab. Tangerang', 60, 21);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Kelapa Dua', 'Kab. Tangerang', 60, 41);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Legok', 'Kab. Tangerang', 60, 22);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Pakuhaji', 'Kab. Tangerang', 61, 26);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Kosambi', 'Kab. Tangerang', 61, 37);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Teluknaga', 'Kab. Tangerang', 61, 37);

-- Create join data from pergerakan and responden
create table proc_data as select * from proc_pergerakan p left join responden r on r.id = p.responden_id;

COMMIT;
