CREATE view [dbo].[vwRawResults] AS
 SELECT
    j.[timeStamp]
    ,j.[elapsed]
    ,j.[label]
    ,j.[responseCode]
    ,j.[responseMessage]
    ,j.[threadName]
    ,j.[dataType]
    ,j.[success]
    ,j.[failureMessage]
    ,j.[bytes]
    ,j.[sentBytes]
    ,j.[grpThreads]
    ,j.[allThreads]
    ,j.[URL]
    ,j.[Latency]
    ,j.[IdleTime]
    ,j.[Connect]
    ,j.[TestRun]
    ,j.[TestPlan]
    ,tr.StartTime
    ,j.[UtcTimeStamp]
    ,j.[ElapsedMS]
    ,j.[LabelPlusTestRun]
    ,DATEDIFF(second,tr.StartTime,j.UtcTimeStamp) as 'SecondsIndex'
    ,DATEDIFF(MINUTE,tr.StartTime,j.UtcTimeStamp) as 'Minutes Index'
    ,CONCAT(tr.TestPlan,tr.TestRun) as 'TestPlanAndTestRun'
    ,case when url = 'null' then 1 else 0 end IsTransaction
  FROM [JmeterReportingDb].[dbo].[jmeterrawresults] j
  join TestRuns tr on tr.TestRun = j.TestRun and tr.TestPlan=j.TestPlan