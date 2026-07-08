create database nasa_neo

use nasa_neo

select count(id)
from close_approaches
where is_potentially_hazardous = 1

SELECT COUNT(*) FROM close_approaches;

create table detection_programs (
program_id int primary key auto_increment,
year int not null,
program_name varchar(100) not null,
description varchar(255) not null
);

insert into detection_programs (year, program_name, description) values
(1998, 'Spaceguard Survey', 'Primer mandato formal del Congreso para detectar NEOs mayores a 1km'),
(2005, 'NASA Authorization Act', 'Congreso exige encontrar 90% de objetos mayores a 140m para 2020'),
(2008, 'Catalina Sky Survey', 'Telescopio dedicado fulltime a búsqueda de NEOs, mayor descubridor histórico'),
(2010, 'NEOWISE', 'Telescopio infrarrojo espacial, detecta asteroides oscuros invisibles al ojo'),
(2016, 'Pan-STARRS', 'Sistema de múltiples telescopios de alta sensibilidad, cubre todo el cielo'),
(2022, 'DART Mission', 'Primera misión de defensa planetaria, prueba de desvío de asteroide'),
(2026, 'NEO Surveyor', 'Primer telescopio espacial diseñado específicamente para detectar PHAs');

select * from detection_programs dp 

create table yearly_summary as
select
    year(close_approach_date) AS year,
    count(*) as total_detections,
    sum(case when is_potentially_hazardous = 1 then 1 else 0 end) as total_pha,
    round(avg(miss_distance_km), 0) as avg_miss_distance_km,
    round(avg(velocity_kmh), 0) as avg_velocity_kmh,
    round(avg((diameter_km_min + diameter_km_max) / 2), 4) as avg_diameter_km
from close_approaches
group by year(close_approach_date)
order by year;

select * from yearly_summary;

CREATE TABLE program_impact AS
SELECT 
    dp.program_name,
    dp.year,
    y.total_detections,
    LAG(y.total_detections) OVER (ORDER BY y.year) AS prev_year_detections,
    ROUND((y.total_detections - LAG(y.total_detections) OVER (ORDER BY y.year)) * 100.0 / 
    LAG(y.total_detections) OVER (ORDER BY y.year), 2) AS yoy_growth_pct
FROM yearly_summary y
INNER JOIN detection_programs dp ON y.year = dp.year
ORDER BY y.year;

SELECT * FROM program_impact;

ALTER TABLE close_approaches 
ADD COLUMN is_clean_name BOOLEAN AS (name LIKE '(%');