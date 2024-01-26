--6a

SELECT
    Continent_Name,
    [dbo].[continent_map].[country_code] as Country_Code,
    Country_Name,
    GDP_Per_Capita
FROM
    [dbo].[continent_map]
    JOIN [dbo].[continents] ON [dbo].[continent_map].[continent_code] = [dbo].[continents].[continent_code]
    JOIN [dbo].[countries] ON [dbo].[countries].[country_code] = [dbo].[continent_map].[country_code]
    JOIN [dbo].[per_capita] ON [dbo].[per_capita].[country_code] = [dbo].[continent_map].[country_code]


--6b

SELECT
    Continent_Name,
    Country_Code,
    Country_Name,
    GDP_Per_Capita
FROM (
    SELECT
        [dbo].[continents].[continent_name] AS Continent_Name,
        [dbo].[countries].[country_code] AS Country_Code,
        [dbo].[countries].[country_name] AS Country_Name,
        FORMAT(ROUND([dbo].[per_capita].[gdp_per_capita], 2), 'C') AS GDP_Per_Capita,
        ROW_NUMBER() OVER (ORDER BY SUBSTRING([dbo].[countries].[country_name], 2, 3) DESC) AS RowNum
    FROM
        [dbo].[continent_map]
        JOIN [dbo].[continents] ON [dbo].[continent_map].[continent_code] = [dbo].[continents].[continent_code]
        JOIN [dbo].[countries] ON [dbo].[countries].[country_code] = [dbo].[continent_map].[country_code]
        JOIN [dbo].[per_capita] ON [dbo].[per_capita].[country_code] = [dbo].[continent_map].[country_code]
    WHERE
        [dbo].[per_capita].[year] = 2009
) AS Subquery
ORDER BY
    Continent_Name;

--6c

SELECT
    Continent_Name,
    Country_Code,
    Country_Name,
    GDP_Per_Capita,
	running_total
FROM (
    SELECT
        [dbo].[continents].[continent_name] AS Continent_Name,
        [dbo].[countries].[country_code] AS Country_Code,
        [dbo].[countries].[country_name] AS Country_Name,
		FORMAT(ROUND([dbo].[per_capita].[gdp_per_capita], 2), 'C') AS GDP_Per_Capita,
        format(round(sum([dbo].[per_capita].[gdp_per_capita]) over( order by Continent_Name),2),'C') AS running_total,
        ROW_NUMBER() OVER (ORDER BY SUBSTRING([dbo].[countries].[country_name], 2, 3) DESC) AS RowNum
    FROM
        [dbo].[continent_map]
        JOIN [dbo].[continents] ON [dbo].[continent_map].[continent_code] = [dbo].[continents].[continent_code]
        JOIN [dbo].[countries] ON [dbo].[countries].[country_code] = [dbo].[continent_map].[country_code]
        JOIN [dbo].[per_capita] ON [dbo].[per_capita].[country_code] = [dbo].[continent_map].[country_code]
    WHERE
        [dbo].[per_capita].[year] = 2009
) AS Subquery
ORDER BY
    Continent_Name;

--6d

SELECT
    Continent_Name,
    Country_Code,
    Country_Name,
    GDP_Per_Capita,
	running_total
FROM (
    SELECT
        [dbo].[continents].[continent_name] AS Continent_Name,
        [dbo].[countries].[country_code] AS Country_Code,
        [dbo].[countries].[country_name] AS Country_Name,
		sum([dbo].[per_capita].[gdp_per_capita]) over( order by Continent_Name) as GDP_Per_Capita2,
		FORMAT(ROUND([dbo].[per_capita].[gdp_per_capita], 2), 'C') AS GDP_Per_Capita,
        format(round(sum([dbo].[per_capita].[gdp_per_capita]) over( order by Continent_Name),2),'C') AS running_total,
        ROW_NUMBER() OVER (ORDER BY SUBSTRING([dbo].[countries].[country_name], 2, 3) DESC) AS RowNum,
		ROW_NUMBER() over ( partition by Continent_Name order by GDP_Per_Capita desc) as RowNum2
    FROM
        [dbo].[continent_map]
        JOIN [dbo].[continents] ON [dbo].[continent_map].[continent_code] = [dbo].[continents].[continent_code]
        JOIN [dbo].[countries] ON [dbo].[countries].[country_code] = [dbo].[continent_map].[country_code]
        JOIN [dbo].[per_capita] ON [dbo].[per_capita].[country_code] = [dbo].[continent_map].[country_code]
    WHERE
        [dbo].[per_capita].[year] = 2009
) AS Subquery
where RowNum2 = 1 and GDP_Per_Capita2 >= 70000
ORDER BY
    Continent_Name;