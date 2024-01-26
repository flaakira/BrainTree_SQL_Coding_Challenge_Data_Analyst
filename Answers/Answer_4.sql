--4.a Not sensitive

With contryname as
(
	select
		[dbo].[continents].[continent_name] as Continent_Name, 
		[dbo].[countries].[country_code] as Country_Code, 
		[dbo].[countries].[country_name] as Country_Name,
		[dbo].[per_capita].[year] as year_gdp,
		[dbo].[per_capita].[gdp_per_capita] as [gdp_per_capita],
		round(([dbo].[per_capita].[gdp_per_capita]-
			lag([dbo].[per_capita].[gdp_per_capita]) over (order by [dbo].[per_capita].[year]))/
			lag([dbo].[per_capita].[gdp_per_capita]) over (order by [dbo].[per_capita].[year]),2) as Growth_Percentage
	from 
		[dbo].[continent_map]
		join [dbo].[continents] on [dbo].[continent_map].[continent_code] = [dbo].[continents].[continent_code]
		join [dbo].[countries] on [dbo].[countries].[country_code] = [dbo].[continent_map].[country_code]
		join [dbo].[per_capita] on [dbo].[per_capita].[country_code] = [dbo].[continent_map].[country_code]
)

Select 
	count(Country_Name) as Country_Name, 
	format(round(sum([gdp_per_capita]),2),'C') as [gdp_per_capita]
From 
	contryname
Where 
	Country_Name like '%an%'

--4.b Sensitive Case

WITH ContryName AS
(
    SELECT
        [dbo].[continents].[continent_name] AS Continent_Name,
        [dbo].[countries].[country_code] AS Country_Code,
        [dbo].[countries].[country_name] AS Country_Name,
        [dbo].[per_capita].[year] AS Year_GDP,
        [dbo].[per_capita].[gdp_per_capita] AS [GDP_Per_Capita],
        ROUND(([dbo].[per_capita].[gdp_per_capita] -
            LAG([dbo].[per_capita].[gdp_per_capita]) OVER (ORDER BY [dbo].[per_capita].[year])) /
            LAG([dbo].[per_capita].[gdp_per_capita]) OVER (ORDER BY [dbo].[per_capita].[year]), 2) AS Growth_Percentage
    FROM
        [dbo].[continent_map]
        JOIN [dbo].[continents] ON [dbo].[continent_map].[continent_code] = [dbo].[continents].[continent_code]
        JOIN [dbo].[countries] ON [dbo].[countries].[country_code] = [dbo].[continent_map].[country_code]
        JOIN [dbo].[per_capita] ON [dbo].[per_capita].[country_code] = [dbo].[continent_map].[country_code]
)

SELECT
    COUNT(Country_Name) AS Country_Name,
    FORMAT(ROUND(SUM([GDP_Per_Capita]), 2), 'C') AS [GDP_Per_Capita]
FROM
    ContryName
WHERE
    Country_Name LIKE '%an%';


