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
