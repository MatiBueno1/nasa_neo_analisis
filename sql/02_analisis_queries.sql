use nasa_neo

-- pregunta 1

select 
	ys.year,
	ys.total_detections,
	ys.total_pha, 
	round((ys.total_pha * 100 / ys.total_detections), 2) as pha_ratio_pct, 
	ys.avg_miss_distance_km, 
	dp.program_name
from yearly_summary ys
left join detection_programs dp on dp.year = ys.year
order by ys.year

-- pregunta 2

select
	year,
	total_detections,
	sum(total_detections) over (order by year) as cumulative_detections,
	total_pha,
	sum(total_pha) over (order by year) as cumulative_pha
from (
	select
		ys.year,
		ys.total_detections,
		ys.total_pha,
		round((ys.total_pha * 100 / ys.total_detections), 2) as pha_ratio_pc
	from yearly_summary ys
	where ys.year < 2025
) base
order by year;

-- pregunta 3

select
    name,
    close_approach_date,
    miss_distance_km,
    velocity_kmh,
    round((diameter_km_min + diameter_km_max) / 2, 4) as avg_diameter_km,
    rank() over (order by miss_distance_km asc) as danger_rank
from close_approaches
where is_potentially_hazardous = 1
order by miss_distance_km ASC
limit 20;

-- pregunta 4

select 
    dp.program_name,
    dp.year as program_start,
    ys.year,
    ys.total_detections,
    ys.total_pha,
    round((ys.total_pha * 100.0 / ys.total_detections), 2) as pha_ratio_pct,
    lag(ys.total_detections) over (order by ys.year) as prev_year_detections,
    round((ys.total_detections - lag(ys.total_detections) over (order by ys.year)) * 100.0 / 
    lag(ys.total_detections) over (order by ys.year), 2) as yoy_growth_pct
from yearly_summary ys
left join detection_programs dp on ys.year = dp.year
where dp.program_name is not null
order by ys.year;



