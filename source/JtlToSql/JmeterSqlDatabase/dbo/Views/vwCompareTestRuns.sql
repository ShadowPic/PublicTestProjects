CREATE view [dbo].[vwCompareTestRuns]
as
select TestPlan,TestRun,label,avg(elapsed) "AverageResponseTimeMS"
,max(elapsed) "MaxResponseTimeMS",count(label) "Samples",case when sum(TransactionFailedSamples)>0 then CONVERT(float,(sum(TransactionFailedSamples))/CONVERT(float,count(label)))else 0 end "ErrorPercent",max(allThreads) "Users"
, sum(TransactionSamples)"TransactionSamplers",sum(TransactionFailedSamples)"TransactionFailedSamplers",avg(bytes) "AvgBytes"
    from jmeterrawresults
        where IsTransaction=1
            and threadName not in (select ThreadName from ExcludedThreadNames)
        group by TestPlan,TestRun,label