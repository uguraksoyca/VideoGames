# VIDEO GAME SALES ANALYSIS

# SQL
In this code I used games, videogamessales, developers and publishers excel files. <br> 
You can import this files to an SQL database. I created these excel files based on total sales. <br> 

### - select games table <br> 

select * from games LIMIT 5; <br> 

![games](https://user-images.githubusercontent.com/114496063/208733418-eb030315-b423-4975-91b7-1563d02d16ac.png)

select COUNT(*) from games; <br> 

![gamescount](https://user-images.githubusercontent.com/114496063/208733494-f4029cf4-76eb-4e01-aad8-e2804ebbd296.png)

### - check duplicates in games table <br> 

SELECT g.Game_Id , COUNT(*) as DuplicateGameId
FROM games g
GROUP BY g.Game_Id
HAVING COUNT(*) > 1;

![GamesDuplicates](https://user-images.githubusercontent.com/114496063/208740744-9a07a0ad-b5b0-4ea0-a93e-b233a36c7c49.png)

### - select videogamessales table. videogamessales table has Total_Sales, Revenue, Development_Cost and Countries. This means there are GameIds more than 1 in this table. Also, We can create Profit Column. <br> 

select * from videogamessales LIMIT 5; <br> 

![videogamesales](https://user-images.githubusercontent.com/114496063/208733774-4e09133b-7158-4879-b5d2-9820b40966e2.png)

select COUNT(*) from videogamessales; <br>

![videogamesalescount](https://user-images.githubusercontent.com/114496063/208733808-3b8a50ba-5bc9-4c72-8a1f-a2adbeeb72be.png)

### - select developers table <br> 

select * from developers LIMIT 5; <br> 

![Developers](https://user-images.githubusercontent.com/114496063/208733349-6103d92e-0a50-4ea2-b968-5cd2ca3b254f.png)

select COUNT(*) from developers; <br> 

![DevelopersCount](https://user-images.githubusercontent.com/114496063/208733383-1a15c421-9f03-4d45-9829-c5af2148a52a.png)

### - select publishers table <br> 

select * from publishers LIMIT 5; <br> 

![publishers](https://user-images.githubusercontent.com/114496063/208733547-98b4c99d-cb3e-4850-a4a8-82a4ab140849.png)

select COUNT(*) from publishers; <br> 

![publishersCount](https://user-images.githubusercontent.com/114496063/208733578-895dad3f-879c-4402-874a-ab40b5c869d3.png)

### - Creating one single view to combine all data. To create one single view first let's join tables. We can use inner join to join all tables and then we can use create view function to create a new view. <br> 

create view videogamesalesview as  <br> 
SELECT v.Game_Id,v.Platform,v.Region,v.Country,v.Total_Sales,v.Revenue,v.Development_Cost,(v.Revenue-v.Development_Cost) as Profit, <br> 
g.`Name` as GameTitle,d.Developer,d.`Dev. Score` as DeveloperScore,p.Publisher,p.`Publishers Score` as PublisherScore FROM videogamessales v <br> 
inner join games g <br> 
on g.Game_Id=v.Game_Id <br> 
inner join developers d <br> 
on d.Developer_ID=g.Developer_ID <br> 
inner join publishers p <br> 
on p.Publisher_ID=g.Publisher_ID; <br> 

### - select videogamesalesview view <br> 
select * from videogamesalesview limit 5; <br> 

![VideoGameSalesView](https://user-images.githubusercontent.com/114496063/208733834-44be431e-1c5b-495c-a232-546414ac1edd.png)

### - Top 5 Video Games based on profit <br> 

select v.GameTitle,sum(v.profit) as profit from videogamesalesview v <br> 
group by v.GameTitle  <br> 
order by profit desc  <br> 
limit 5; <br> 

![Top5Profit](https://user-images.githubusercontent.com/114496063/208733728-a205c802-4e1b-4521-8af5-fee50a231448.png)

### - Profit across selected Publisher  <br> 

select v.GameTitle,sum(v.profit) as profit,sum(v.total_sales) as TotalSales from videogamesalesview v <br> 
where v.Publisher='Electronic Arts' <br> 
group by v.GameTitle ,v.Platform <br> 
order by profit desc LIMIT 5; <br> 

![PublisherProfit](https://user-images.githubusercontent.com/114496063/208733522-1e066266-c977-4c74-9c86-22234145f152.png)

### - Percentage of sales across countries for a selected game  <br> 

select v.`Name` as GameTitle,x.country,y.TotalSales,CountrySales,x.CountrySales/y.TotalSales*100 as CountryPercentage from Games v inner join ( <br> 
select v2.Game_Id,v2.GameTitle,sum(v2.total_Sales) as TotalSales from videogamesalesview v2  <br> 
group by  v2.Game_Id,v2.GameTitle) y <br> 
on y.Game_Id=v.Game_Id <br> 
inner join <br> 
(select v3.Game_Id,v3.GameTitle,v3.country,sum(v3.total_Sales) as CountrySales from videogamesalesview v3 <br> 
group by  v3.Game_Id,v3.GameTitle,v3.country) x <br> 
on x.Game_Id=v.Game_Id <br> 
where v.`Name`='FIFA 17' <br> 
order by CountryPercentage desc LIMIT 5; <br> 

![GameSalesPercentage](https://user-images.githubusercontent.com/114496063/208733469-10f40c01-c3a1-4382-97db-4a0ecb26d5e7.png)

### - Creating Groups across Sales. Using case when to create groups <br> 

select g.Game_Id,g.`Name` as GameTitle,y.TotalSales, <br> 
case when y.TotalSales >15000000 then 'More Than 15M' <br> 
when y.TotalSales >10000000 then 'Between 10M-15M' <br> 
when y.TotalSales >5000000 then 'Between 5M-10M' <br> 
else 'Less than 5M' end as SalesGroup from Games g <br> 
inner join ( <br> 
select v2.Game_Id,v2.GameTitle,sum(v2.total_Sales) as TotalSales from videogamesalesview v2  <br> 
group by  v2.Game_Id,v2.GameTitle) y <br> 
on y.Game_Id=g.Game_Id	 <br> 
order by y.TotalSales desc LIMIT 5; <br> 

![SalesGroup](https://user-images.githubusercontent.com/114496063/208733678-9dfad441-afcc-4060-a317-26791cd9efa9.png)



### - Counting Groups to see distribution <br> 
select z.SalesGroup,count(z.SalesGroup) as CountSalesGroup from games g2 <br> 
inner join (select g.Game_Id,g.`Name` as GameTitle,y.TotalSales, <br> 
case when y.TotalSales >15000000 then '1-More Than 15M' <br> 
when y.TotalSales >10000000 then '2-Between 10M-15M' <br> 
when y.TotalSales >5000000 then '3-Between 5M-10M' <br> 
else '4-Less than 5M' end as SalesGroup from Games g <br> 
inner join ( <br> 
select v2.Game_Id,v2.GameTitle,sum(v2.total_Sales) as TotalSales from videogamesalesview v2  <br> 
group by  v2.Game_Id,v2.GameTitle) y <br> 
on y.Game_Id=g.Game_Id	 <br> 
order by y.TotalSales desc) z <br> 
on z.Game_Id=g2.Game_Id <br> 
group by z.SalesGroup  <br> 
order by z.SalesGroup; <br> 

![SalesDistribution](https://user-images.githubusercontent.com/114496063/208733614-802ccff4-b54d-41ff-bd5f-199fc3c5dddb.png)

### - Best selling Country in every continent for a selected game  <br> 

select * from (  <br> 
select v.Game_Id,v.`Name` as GameTitle,y.Region,y.Country,y.TotalSales, <br> 
rank () over (partition by GameTitle,Region order by y.TotalSales desc) TotalSalesRank from Games v inner join ( <br> 
select v2.Game_Id,v2.GameTitle,v2.country,v2.Region,sum(v2.total_Sales) as TotalSales from videogamesalesview v2  <br> 
group by  v2.Game_Id,v2.GameTitle,v2.country) y <br> 
on y.Game_Id=v.Game_Id) t <br> 
where t.TotalSalesRank=1 and GameTitle='FIFA 17' <br> 
order by TotalSales desc <br> 

![SalesforSelectedGame](https://user-images.githubusercontent.com/114496063/208733649-2668e3e2-d897-4944-b1f5-fd9a112c3272.png)

# TABLEAU DASHBOARDS

![Total Sales Dashboard](https://user-images.githubusercontent.com/114496063/208736991-4501d616-23cb-4484-83da-c6fce9bd1003.png)

![Publisher Dashboard](https://user-images.githubusercontent.com/114496063/208736928-65c7153d-f35f-4726-9d6d-21bf15ff94a2.png)



