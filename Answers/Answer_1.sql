-- visualize all data

SELECT TOP (1000) [country_code]
      ,[continent_code]
  FROM [BrainTree].[dbo].[continent_map]

--update null cases

update [dbo].[continent_map]
set [country_code] = 'FOO'
where [country_code] is NULL

-- reorder the view( Make 'FOO' row first then order by alphabetic)

SELECT [country_code],[continent_code]
  FROM [BrainTree].[dbo].[continent_map]
  order by 
	case when([country_code] ='FOO') then 0 else 1 end,
	[country_code]

-- Create a column named RN that count duplicates rows:
with cte
as
(select row_number() over (partition by 
	[country_code],
	[continent_code]
	order by [continent_code])
	RN, * from [dbo].[continent_map])
select * from cte where RN > 1

--The original data without duplicates before deleted:

with cte
as
(select row_number() over (partition by 
	[country_code],
	[continent_code]
	order by [continent_code])
	RN, * from [dbo].[continent_map])
select * from cte where RN = 1

-- Deleted formula:
with cte
as
(select row_number() over (partition by 
	[country_code],
	[continent_code]
	order by [continent_code])
	RN, * from [dbo].[continent_map])
delete from cte where RN > 1

BEGIN TRANSACTION

commit
