WITH ranked_countries AS (
    SELECT
        continent_name,
        [dbo].[countries].[country_code],
        [dbo].[countries].[country_name], 
        format(gdp_per_capita, 'C') AS avg_gdp_per_capita,
        ROW_NUMBER() OVER (PARTITION BY continent_name ORDER BY CAST(REPLACE(REPLACE(gdp_per_capita, '$', ''), ',', '') AS DECIMAL(18,2)) DESC) AS rank
    FROM
        [dbo].[continent_map]
        JOIN [dbo].[continents] ON [dbo].[continent_map].[continent_code] = [dbo].[continents].[continent_code]
        JOIN [dbo].[countries] ON [dbo].[countries].[country_code] = [dbo].[continent_map].[country_code]
        JOIN [dbo].[per_capita] ON [dbo].[per_capita].[country_code] = [dbo].[continent_map].[country_code]
)
SELECT
	rank,
    continent_name,
    country_code,
    country_name,
    avg_gdp_per_capita
FROM
    ranked_countries
WHERE
    rank = 1