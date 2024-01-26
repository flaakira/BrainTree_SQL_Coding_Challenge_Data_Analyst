WITH gdp_per_capita  AS
(
    SELECT
        [dbo].[continents].[continent_name] AS Continent_Name,
        [dbo].[countries].[country_code] AS Country_Code,
        [dbo].[countries].[country_name] AS Country_Name,
        [dbo].[per_capita].[year] AS Year_GDP,
        [dbo].[per_capita].[gdp_per_capita] AS GDP_Per_Capita,
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
    gp.Year_GDP AS year,
    COUNT(DISTINCT CASE WHEN gp.Year_GDP < 2012 AND gp.GDP_Per_Capita IS NOT NULL THEN gp.Country_Name END) AS country_count,
    format(round(ISNULL(SUM(gp.GDP_Per_Capita), 0),2),'C') AS total
FROM
    gdp_per_capita gp
LEFT JOIN (
    SELECT DISTINCT Country_Name
    FROM gdp_per_capita
    WHERE Year_GDP = 2012 AND GDP_Per_Capita IS NULL
) subquery ON gp.Country_Name = subquery.Country_Name
WHERE
    gp.Country_Name IS NOT NULL
    AND gp.Year_GDP < 2012
GROUP BY
    gp.Year_GDP
order by gp.Year_GDP