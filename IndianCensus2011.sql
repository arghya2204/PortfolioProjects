SELECT *
FROM Data1

SELECT *
FROM Data2

--Number Of Rows Into Our Dataset


SELECT COUNT(*)
FROM Data1

SELECT COUNT(*)
FROM Data2


--Dataset For West Bengal


SELECT *
FROM Data1
WHERE State = 'West Bengal'

SELECT *
FROM Data2
WHERE State = 'West Bengal'

SELECT *
FROM Data1
WHERE State = 'West Bengal'
ORDER BY Sex_Ratio DESC

SELECT TOP 3 *
FROM Data1
WHERE State = 'West Bengal'
ORDER BY Literacy DESC


--Population Of India


SELECT SUM(Population) AS TotalPopulation
FROM Data2


--Avg Growth 


SELECT AVG(Growth)*100 Avg_growth
FROM Data1


SELECT State, AVG(Growth)*100 AS Avg_Growth
FROM Data1
GROUP BY State
ORDER BY Avg_Growth


--Avg Sex Ratio


SELECT State, ROUND(AVG(Sex_Ratio),0) AS Avg_Sex_Ratio
FROM Data1
GROUP BY State
ORDER BY Avg_Sex_Ratio


--Avg Literacy Rate



SELECT State, ROUND(AVG(Literacy),0) AS Avg_Literacy
FROM Data1
GROUP BY State
ORDER BY Avg_Literacy


SELECT State, ROUND(AVG(Literacy),0) AS Avg_Literacy
FROM Data1
GROUP BY State
HAVING ROUND(AVG(Literacy),0)>80
ORDER BY Avg_Literacy DESC


--Top 3 State Showing Highest Growth Ratio


SELECT TOP 3 State, AVG(Growth)*100 AS Avg_Growth
FROM Data1
GROUP BY State
ORDER BY Avg_Growth DESC


SELECT TOP 3 State, AVG(Growth)*100 AS Avg_Growth
FROM Data1
GROUP BY State
ORDER BY Avg_Growth


--Bottom 3 State Showing Lowest Sex Ratio


SELECT TOP 3 State, ROUND(AVG(Sex_Ratio),0) AS Avg_Sex_Ratio
FROM Data1
GROUP BY State
ORDER BY Avg_Sex_Ratio



--Top And Bottom 3 States In Literacy State


DROP TABLE IF EXISTS #LiteracyTOP3

CREATE TABLE #LiteracyTOP3
(State nvarchar(255),
Literacy float)

INSERT INTO #LiteracyTOP3
SELECT State, ROUND(AVG(Literacy),0) AS Avg_Literacy
FROM Data1
GROUP BY State
ORDER BY Avg_Literacy DESC

SELECT TOP 3 *
FROM #LiteracyTOP3
ORDER BY #LiteracyTOP3.Literacy DESC


DROP TABLE IF EXISTS #LiteracyBOTTOM3

CREATE TABLE #LiteracyBOTTOM3
(State nvarchar(255),
Literacy float)

INSERT INTO #LiteracyBOTTOM3
SELECT State, ROUND(AVG(Literacy),0) AS Avg_Literacy
FROM Data1
GROUP BY State
ORDER BY Avg_Literacy DESC

SELECT TOP 3 *
FROM #LiteracyBOTTOM3
ORDER BY #LiteracyBOTTOM3.Literacy ASC


--Union Opertor


SELECT * FROM (
SELECT TOP 3 *
FROM #LiteracyTOP3
ORDER BY #LiteracyTOP3.Literacy DESC) A
UNION
SELECT * FROM (
SELECT TOP 3 *
FROM #LiteracyBOTTOM3
ORDER BY #LiteracyBOTTOM3.Literacy ASC) B


--States Starting With Letter a


SELECT DISTINCT State
FROM Data1
WHERE lower(State) like 'a%'


SELECT DISTINCT State
FROM Data1
WHERE lower(State) like 'a%' OR lower(State) like 'b%'

SELECT DISTINCT State
FROM Data1
WHERE lower(State) like 'a%' and lower(State) like '%h'


--Total Male and Female Population


SELECT A.District, A.State, A.Sex_Ratio, B.Population,
Round(((B.Population*A.Sex_Ratio)/(1000+A.Sex_Ratio)),0) AS Female_population,
(B.Population-Round(((B.Population*A.Sex_Ratio)/(1000+A.Sex_Ratio)),0)) AS Male_population
FROM Data1 A
INNER JOIN Data2 B
ON A.District = B.District


SELECT A.State, Round(Avg(A.Sex_Ratio),0) AS Sex_Ratio, SUM(B.Population) AS Population ,
SUM (Round(((B.Population*A.Sex_Ratio)/(1000+A.Sex_Ratio)),0)) AS Female_population,
SUM((B.Population-Round(((B.Population*A.Sex_Ratio)/(1000+A.Sex_Ratio)),0))) AS Male_population
FROM Data1 A
INNER JOIN Data2 B
ON A.District = B.District
GROUP BY A.State


--Total Literate and Illiterate Polulation Of Districts

SELECT A.District, A.State, Round((A.Literacy),1) AS Literacy_Ratio, B.Population 
,(Round(((B.Population*A.Literacy)/100),0)) AS Literate
,(B.Population-(Round(((B.Population*A.Literacy)/100),0))) AS Illiterate
FROM Data1 A
INNER JOIN Data2 B
ON A.District = B.District


--Total Literate and Illiterate Polulation Of States

SELECT A.State, Round(Avg(A.Literacy),1) AS Literacy_Ratio, SUM(B.Population) AS Population 
,SUM (Round(((B.Population*A.Literacy)/100),0)) AS Literate
,SUM (B.Population-(Round(((B.Population*A.Literacy)/100),0))) AS Illiterate
FROM Data1 A
INNER JOIN Data2 B
ON A.District = B.District
GROUP BY A.State


--Population In Previous Census Of District

SELECT A.District, A.State,
Round((B.Population/(1+A.Growth)),0) Population_At_Previous_Census
,A.Growth*100 AS 'Growth%', B.Population AS Population_In_Current_Census
FROM Data1 A
INNER JOIN Data2 B
ON A.District = B.District
ORDER BY A.Growth DESC

--Population In Previous Census Of State

SELECT A.State,
SUM(Round((B.Population/(1+A.Growth)),0)) Population_At_Previous_Census
,Round(AVG(A.Growth),4)*100 AS 'Growth%'
,SUM(B.Population) AS Population_In_Current_Census
FROM Data1 A
INNER JOIN Data2 B
ON A.District = B.District
GROUP BY A.State
ORDER BY AVG(A.Growth) DESC


--Population In Previous Census Of India

SELECT 
SUM(Round((B.Population/(1+A.Growth)),0)) Population_At_Previous_Census
,Round(AVG(A.Growth),4)*100 AS 'Growth%'
,SUM(B.Population) AS Population_In_Current_Census
FROM Data1 A
INNER JOIN Data2 B
ON A.District = B.District

--Population Density In Previous Census Of District

SELECT A.District, A.State,
Round((B.Population/(1+A.Growth)/B.Area_km2),2) AS Population_Density_At_Previous_Census
,Round(((((B.Population/B.Area_km2)-((B.Population/(1+A.Growth))/B.Area_km2))/(B.Population/B.Area_km2))*100),2) AS 'DensityGrowth%'
,Round((B.Population/B.Area_km2),2) AS Population_Density_In_Current_Census
FROM Data1 A
INNER JOIN Data2 B
ON A.District = B.District
ORDER BY Round((B.Population/B.Area_km2),2) DESC


--Population Density In Previous Census Of State

SELECT A.State,
Round(AVG((B.Population/(1+A.Growth)/B.Area_km2)),0) AS Population_Density_At_Previous_Census
,Round(AVG(((((B.Population/B.Area_km2)-((B.Population/(1+A.Growth))/B.Area_km2))/((B.Population/(1+A.Growth))/B.Area_km2))*100)),2) AS 'DensityGrowth%'
,Round(AVG((B.Population/B.Area_km2)),0) AS Population_Density_In_Current_Census
FROM Data1 A
INNER JOIN Data2 B
ON A.District = B.District
GROUP BY A.State
ORDER BY AVG((B.Population/B.Area_km2))  DESC



--Population Density In Previous Census Of State

SELECT 
Round(AVG((B.Population/(1+A.Growth)/B.Area_km2)),0) AS Population_Density_At_Previous_Census
,Round(AVG(((((B.Population/B.Area_km2)-((B.Population/(1+A.Growth))/B.Area_km2))/((B.Population/(1+A.Growth))/B.Area_km2))*100)),2) AS 'DensityGrowth%'
,Round(AVG((B.Population/B.Area_km2)),0) AS Population_Density_In_Current_Census
FROM Data1 A
INNER JOIN Data2 B
ON A.District = B.District


--Top Three Districts Of Each State With Highest Literacy Rate


SELECT District, State, Literacy,
RANK() OVER (
PARTITION BY State
ORDER BY Literacy) 'rank'
FROM Data1

SELECT a.*
FROM (
SELECT District, State, Literacy,
RANK() OVER (
PARTITION BY State
ORDER BY Literacy) rnk
FROM Data1) a
WHERE a.rnk IN (1,2,3)
