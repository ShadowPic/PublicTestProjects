CREATE view [dbo].[vwCompareTestRuns]
as
select TestPlan,TestRun,j.label,avg(elapsed) "AverageResponseTimeMS",  max(p.ResponseTimeMS)/cast(1000 as float) "TargetResponseTime"
,max(elapsed) "MaxResponseTimeMS",count(j.label) "Samples",case when sum(TransactionFailedSamples)>0 then CONVERT(float,(sum(TransactionFailedSamples))/CONVERT(float,count(j.label)))else 0 end "ErrorPercent",max(allThreads) "Users"
, sum(TransactionSamples)"TransactionSamplers",sum(TransactionFailedSamples)"TransactionFailedSamplers",avg(bytes) "AvgBytes",(select count(success) from jmeterrawresults where label=j.label and success='false' and TestRun=j.TestRun and IsTransaction=1)"FailedRuns"
    from jmeterrawresults j
    left outer  join PerformanceTargets p on p.label = j.label
        where IsTransaction=1
            and threadName not in (select ThreadName from ExcludedThreadNames)
            and UserCategory = 'Small Users'
        group by TestPlan,TestRun,j.label