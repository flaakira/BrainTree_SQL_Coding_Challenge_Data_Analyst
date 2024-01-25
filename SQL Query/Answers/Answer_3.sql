with Growth_Percentage as(
	select
	[dbo].[continents].[continent_name] as Continent_Name, 
 [dbo].[countries].[country_code] as Country_Code, 
	[dbo].[countries].[country_name] as Country_Name,
	[dbo].[per_capita].[year] as year_gdp,
	round(([dbo].[per_capita].[gdp_per_capita]-
	lag([dbo].[per_capita].[gdp_per_capita]) over (order by [dbo].[per_capita].[year]))/
	lag([dbo].[per_capita].[gdp_per_capita]) over (order by [dbo].[per_capita].[year]),2) as Growth_Percentage
	from [dbo].[continent_map]
	join [dbo].[continents]
	on [dbo].[continent_map].[continent_code] = [dbo].[continents].[continent_code]
	join [dbo].[countries]
	on [dbo].[countries].[country_code] = [dbo].[continent_map].[country_code]
	join [dbo].[per_capita]
	on [dbo].[per_capita].[country_code] = [dbo].[continent_map].[country_code])

SELECT
    ROUND(SUM(CASE WHEN Continent_Name = 'Asia' AND year_gdp = 2012 THEN Growth_Percentage END) / 
          SUM(CASE WHEN year_gdp = 2012 THEN Growth_Percentage END) * 100, 1) AS Asia,
          
    ROUND(SUM(CASE WHEN Continent_Name = 'Europe' AND year_gdp = 2012 THEN Growth_Percentage END) / 
          SUM(CASE WHEN year_gdp = 2012 THEN Growth_Percentage END) * 100, 1) AS Europe,
          
    ROUND(SUM(CASE WHEN Continent_Name NOT IN ('Asia', 'Europe') AND year_gdp = 2012 THEN Growth_Percentage END) / 
          SUM(CASE WHEN year_gdp = 2012 THEN Growth_Percentage END) * 100, 1) AS "Rest of World"
FROM
    Growth_Percentage
WHERE
    year_gdp = 2012;