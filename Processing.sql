-- Selecting valid pergerakan data and save it into new table
create table proc_pergerakan as select * from pergerakan where asal_kecamatan is not null and tujuan_kecamatan is not null;

-- Create join data from pergerakan and responden
create table proc_data as select * from proc_pergerakan p left join responden r on r.id = p.responden_id;

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
