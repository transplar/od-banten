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
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Banjarsari', 'Kabupaten Lebak', 36, 25);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Malingping', 'Kabupaten Lebak', 36, 27);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cijaku', 'Kabupaten Lebak', 36, 12);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Gunungkencana', 'Kabupaten Lebak', 36, 14);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Wanasalam', 'Kabupaten Lebak', 36, 22);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Bayah', 'Kabupaten Lebak', 37, 32);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cilograng', 'Kabupaten Lebak', 37, 25);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cibeber', 'Kabupaten Lebak', 37, 43);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cikulur', 'Kabupaten Lebak', 38, 12);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Warunggunung', 'Kabupaten Lebak', 38, 14);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cibadak', 'Kabupaten Lebak', 38, 15);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Rangkasbitung', 'Kabupaten Lebak', 38, 30);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Curugbitung', 'Kabupaten Lebak', 38, 8);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Maja', 'Kabupaten Lebak', 38, 13);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Kalanganyar', 'Kabupaten Lebak', 38, 8);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Leuwidamar', 'Kabupaten Lebak', 39, 42);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cileles', 'Kabupaten Lebak', 39, 39);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Bojongmanik', 'Kabupaten Lebak', 39, 18);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Muncang', 'Kabupaten Lebak', 40, 13);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cimarga', 'Kabupaten Lebak', 40, 25);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Lebakgedong', 'Kabupaten Lebak', 40, 9);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Sajira', 'Kabupaten Lebak', 40, 19);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cipanas', 'Kabupaten Lebak', 40, 19);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Sobang', 'Kabupaten Lebak', 40, 14);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cigemblong', 'Kabupaten Lebak', 41, 18);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Panggarangan', 'Kabupaten Lebak', 41, 32);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cihara', 'Kabupaten Lebak', 41, 27);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cirinten', 'Kabupaten Lebak', 41, 23);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cimanggu', 'Kabupaten Pandeglang', 42, 14);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Panimbang', 'Kabupaten Pandeglang', 42, 19);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cigeulis', 'Kabupaten Pandeglang', 42, 13);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Sukaresmi', 'Kabupaten Pandeglang', 42, 13);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Sumur', 'Kabupaten Pandeglang', 42, 9);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Sobang', 'Kabupaten Pandeglang', 42, 13);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cibitung', 'Kabupaten Pandeglang', 42, 8);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cibaliung', 'Kabupaten Pandeglang', 42, 11);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Sindangresmi', 'Kabupaten Pandeglang', 43, 18);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cikeusik', 'Kabupaten Pandeglang', 43, 43);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Munjul', 'Kabupaten Pandeglang', 43, 18);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Angsana', 'Kabupaten Pandeglang', 43, 21);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Jiput', 'Kabupaten Pandeglang', 44, 10);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Menes', 'Kabupaten Pandeglang', 44, 12);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Mandalawangi', 'Kabupaten Pandeglang', 44, 16);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Pagelaran', 'Kabupaten Pandeglang', 44, 12);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Carita', 'Kabupaten Pandeglang', 44, 11);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cikedal', 'Kabupaten Pandeglang', 44, 11);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Pulosari', 'Kabupaten Pandeglang', 44, 10);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Labuan', 'Kabupaten Pandeglang', 44, 19);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cimanuk', 'Kabupaten Pandeglang', 45, 13);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Kaduhejo', 'Kabupaten Pandeglang', 45, 12);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Koroncong', 'Kabupaten Pandeglang', 45, 6);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Banjar', 'Kabupaten Pandeglang', 45, 10);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Majasari', 'Kabupaten Pandeglang', 45, 16);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Pandeglang', 'Kabupaten Pandeglang', 45, 14);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cadasari', 'Kabupaten Pandeglang', 45, 11);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Mekarjaya', 'Kabupaten Pandeglang', 45, 6);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Karangtanjung', 'Kabupaten Pandeglang', 45, 11);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Picung', 'Kabupaten Pandeglang', 46, 19);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Bojong', 'Kabupaten Pandeglang', 46, 18);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Saketi', 'Kabupaten Pandeglang', 46, 23);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cipeucang', 'Kabupaten Pandeglang', 46, 15);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Patia', 'Kabupaten Pandeglang', 46, 14);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cisata', 'Kabupaten Pandeglang', 46, 12);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Bojonegara', 'Kabupaten Serang', 47, 25);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Puloampel', 'Kabupaten Serang', 47, 21);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Kramatwatu', 'Kabupaten Serang', 47, 54);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cinangka', 'Kabupaten Serang', 48, 36);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Mancak', 'Kabupaten Serang', 48, 29);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Anyar', 'Kabupaten Serang', 48, 35);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Lebak Wangi', 'Kabupaten Serang', 49, 21);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Tanara', 'Kabupaten Serang', 49, 22);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Pontang', 'Kabupaten Serang', 49, 22);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Carenang', 'Kabupaten Serang', 49, 19);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Tirtayasa', 'Kabupaten Serang', 49, 16);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Jawilan', 'Kabupaten Serang', 50, 28);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Kopo', 'Kabupaten Serang', 50, 26);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Tunjungteja', 'Kabupaten Serang', 50, 21);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Pamarayan', 'Kabupaten Serang', 50, 26);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Petir', 'Kabupaten Serang', 51, 28);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Ciomas', 'Kabupaten Serang', 51, 21);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Baros', 'Kabupaten Serang', 51, 29);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Pabuaran', 'Kabupaten Serang', 51, 22);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Kibin', 'Kabupaten Serang', 52, 16);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Ciruas', 'Kabupaten Serang', 52, 16);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cikeusal', 'Kabupaten Serang', 52, 15);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Binuang', 'Kabupaten Serang', 52, 8);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cikande', 'Kabupaten Serang', 52, 21);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Kragilan', 'Kabupaten Serang', 52, 17);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Bandung', 'Kabupaten Serang', 52, 7);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Padarincang', 'Kabupaten Serang', 53, 50);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Waringinkurung', 'Kabupaten Serang', 53, 34);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Gunungsari', 'Kabupaten Serang', 53, 16);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Sukadiri', 'Kabupaten Tangerang', 54, 16);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Sepatan Timur', 'Kabupaten Tangerang', 54, 27);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Sepatan', 'Kabupaten Tangerang', 54, 34);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Mauk', 'Kabupaten Tangerang', 54, 23);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Pasarkemis', 'Kabupaten Tangerang', 55, 51);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Rajeg', 'Kabupaten Tangerang', 55, 27);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Sindangjaya', 'Kabupaten Tangerang', 55, 15);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Kemiri', 'Kabupaten Tangerang', 55, 7);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Kronjo', 'Kabupaten Tangerang', 56, 22);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Sukamulya', 'Kabupaten Tangerang', 56, 23);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Kresek', 'Kabupaten Tangerang', 56, 23);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Gunung Kaler', 'Kabupaten Tangerang', 56, 18);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Mekarbaru', 'Kabupaten Tangerang', 56, 13);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cisoka', 'Kabupaten Tangerang', 57, 32);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Jayanti', 'Kabupaten Tangerang', 57, 24);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Balaraja', 'Kabupaten Tangerang', 57, 44);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Solear', 'Kabupaten Tangerang', 58, 31);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Jambe', 'Kabupaten Tangerang', 58, 16);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Tigaraksa', 'Kabupaten Tangerang', 58, 53);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Curug', 'Kabupaten Tangerang', 59, 33);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Panongan', 'Kabupaten Tangerang', 59, 22);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cikupa', 'Kabupaten Tangerang', 59, 45);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Cisauk', 'Kabupaten Tangerang', 60, 15);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Pagedangan', 'Kabupaten Tangerang', 60, 21);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Kelapa Dua', 'Kabupaten Tangerang', 60, 41);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Legok', 'Kabupaten Tangerang', 60, 22);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Pakuhaji', 'Kabupaten Tangerang', 61, 26);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Kosambi', 'Kabupaten Tangerang', 61, 37);
INSERT INTO zonasi_kab (kecamatan, kota, zona_id, penduduk_proporsi) VALUES ('Teluknaga', 'Kabupaten Tangerang', 61, 37);

-- Create join data from pergerakan and responden
create table proc_data as select * from proc_pergerakan p left join responden r on r.id = p.responden_id;

COMMIT;
