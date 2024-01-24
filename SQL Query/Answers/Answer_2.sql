with Growth_Percentage as(
	select
	[dbo].[continents].[continent_name] as Continent_Name, 
	[dbo].[countries].[country_code] as Country_Code, 
	[dbo].[countries].[country_name] as Country_Name,
	cast(round(([dbo].[per_capita].[gdp_per_capita]-
	lag([dbo].[per_capita].[gdp_per_capita]) over (order by [dbo].[per_capita].[year]))/
	lag([dbo].[per_capita].[gdp_per_capita]) over (order by [dbo].[per_capita].[year]),2) as varchar(20)) + ' %' as Growth_Percentage
	from [dbo].[continent_map]
	join [dbo].[continents]
	on [dbo].[continent_map].[continent_code] = [dbo].[continents].[continent_code]
	join [dbo].[countries]
	on [dbo].[countries].[country_code] = [dbo].[continent_map].[country_code]
	join [dbo].[per_capita]
	on [dbo].[per_capita].[country_code] = [dbo].[continent_map].[country_code]),

 Rank_gdp as(
	select 	
	Continent_Name,
	Country_Code,
	Country_Name, 
	Growth_Percentage, 
	dense_rank() over(partition by Continent_Name order by Growth_Percentage) as Rank_gdp
	from Growth_Percentage)

select *
	from Rank_gdp
	where Rank_gdp between 10 and 12
	order by Rank_gdp desc