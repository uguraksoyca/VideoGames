/*Creating one single view to combine all data*/

create view videogamesalesview as 
SELECT v.Game_Id,v.Platform,v.Region,v.Country,v.Total_Sales,v.Revenue,v.Development_Cost,(v.Revenue-v.Development_Cost) as Profit,
g.`Name` as GameTitle,d.Developer,d.`Dev. Score` as DeveloperScore,p.Publisher,p.`Publishers Score` as PublisherScore FROM videogamessales v
inner join games g
on g.Game_Id=v.Game_Id
inner join developers d
on d.Developer_ID=g.Developer_ID
inner join publishers p
on p.Publisher_ID=g.Publisher_ID;

/*Selecting the view I created*/
select * from videogamesalesview;

/* Top 10 Video Games based on profit*/
select v.GameTitle,sum(v.profit) as profit from videogamesalesview v
group by v.GameTitle 
order by profit desc 
limit 10;

/*Profit across selected Publisher*/
select v.GameTitle,sum(v.profit) as profit,sum(v.total_sales) as TotalSales from videogamesalesview v
where v.Publisher='Electronic Arts'
group by v.GameTitle ,v.Platform
order by profit desc ;


/*percentage of sales across countries for a selected game*/
select v.`Name` as GameTitle,x.country,y.TotalSales,CountrySales,x.CountrySales/y.TotalSales*100 as CountryPercentage from Games v inner join (
select v2.Game_Id,v2.GameTitle,sum(v2.total_Sales) as TotalSales from videogamesalesview v2 
group by  v2.Game_Id,v2.GameTitle) y
on y.Game_Id=v.Game_Id
inner join
(select v3.Game_Id,v3.GameTitle,v3.country,sum(v3.total_Sales) as CountrySales from videogamesalesview v3
group by  v3.Game_Id,v3.GameTitle,v3.country) x
on x.Game_Id=v.Game_Id
where v.`Name`='FIFA 17'
order by CountryPercentage desc;

/*Creating Groups across Sales */
/*Using case when to create groups*/
select g.Game_Id,g.`Name` as GameTitle,y.TotalSales,
case when y.TotalSales >15000000 then 'More Than 15M'
when y.TotalSales >10000000 then 'Between 10M-15M'
when y.TotalSales >5000000 then 'Between 5M-10M'
else 'Less than 5M' end as SalesGroup from Games g
inner join (
select v2.Game_Id,v2.GameTitle,sum(v2.total_Sales) as TotalSales from videogamesalesview v2 
group by  v2.Game_Id,v2.GameTitle) y
on y.Game_Id=g.Game_Id	
order by y.TotalSales desc;

/*Counting Groups to see distribution */
select z.SalesGroup,count(z.SalesGroup) as CountSalesGroup from games g2
inner join (select g.Game_Id,g.`Name` as GameTitle,y.TotalSales,
case when y.TotalSales >15000000 then '1-More Than 15M'
when y.TotalSales >10000000 then '2-Between 10M-15M'
when y.TotalSales >5000000 then '3-Between 5M-10M'
else '4-Less than 5M' end as SalesGroup from Games g
inner join (
select v2.Game_Id,v2.GameTitle,sum(v2.total_Sales) as TotalSales from videogamesalesview v2 
group by  v2.Game_Id,v2.GameTitle) y
on y.Game_Id=g.Game_Id	
order by y.TotalSales desc) z
on z.Game_Id=g2.Game_Id
group by z.SalesGroup 
order by z.SalesGroup;


/*Best selling Country in every continent for a selected game*/
select * from (
select v.Game_Id,v.`Name` as GameTitle,y.Region,y.Country,y.TotalSales,
rank () over (partition by GameTitle,Region order by y.TotalSales desc) TotalSalesRank from Games v inner join (
select v2.Game_Id,v2.GameTitle,v2.country,v2.Region,sum(v2.total_Sales) as TotalSales from videogamesalesview v2 
group by  v2.Game_Id,v2.GameTitle,v2.country) y
on y.Game_Id=v.Game_Id) t
where t.TotalSalesRank=1 and GameTitle='FIFA 17'
order by TotalSales desc




