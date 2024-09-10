CREATE PROCEDURE [dbo].[spSetRawSTartTime]
as
update jmeterrawresults set UtcStartTime=
  tr.StartTime from  TestRuns tr 
  where jmeterrawresults.TestRun = tr.TestRun 
    and UtcStartTime is null