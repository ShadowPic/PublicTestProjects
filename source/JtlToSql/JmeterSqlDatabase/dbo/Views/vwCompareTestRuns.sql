CREATE view [dbo].[vwCompareTestRuns]
as
select TestPlan,TestRun,label,avg(elapsed) "AverageResponseTimeMS"
,max(elapsed) "MaxResponseTimeMS",count(label) "Samples",CONVERT(float,(sum(TransactionFailedSamples))/CONVERT(float,count(label)))"ErrorPercent",max(allThreads) "Users"
, sum(TransactionSamples)"TransactionSamplers",sum(TransactionFailedSamples)"TransactionFailedSamplers",avg(bytes) "AvgBytes"
    from jmeterrawresults
        where responseMessage like 'Number of samples in transaction%'
            and threadName not in (select ThreadName from ExcludedThreadNames)
        group by TestPlan,TestRun,label