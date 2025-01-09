CREATE view [dbo].[vwCompareTestRuns]
as
select TestPlan,TestRun,threadName,label,success,url,case when url='null' then 1 else 0 end "IsTransaction",avg(elapsed) "AverageResponseTimeMS",max(elapsed) "MaxResponseTimeMS",count(*) "Samplers",max(allThreads) "Users" from jmeterrawresults
group by TestPlan,TestRun,threadName,label,url,success