CREATE PROCEDURE [dbo].[spPostProcess]
as
    update jmeterrawresults set UtcStartTime=
    tr.StartTime from  TestRuns tr 
    where jmeterrawresults.TestRun = tr.TestRun 
        and UtcStartTime is null
    
    update TestRuns set DurationInMinutes=(select DATEDIFF(MINUTE,max(j.UtcStartTime),max(j.UtcTimeStamp))
                                        from jmeterrawresults j
                                        where j.TestRun = TestRuns.TestRun)
    where testruns.DurationInMinutes is null or testruns.DurationInMinutes = 0