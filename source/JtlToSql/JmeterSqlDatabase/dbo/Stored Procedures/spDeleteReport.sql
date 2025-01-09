CREATE PROCEDURE [dbo].[spDeleteReport]
	@TestRun nvarchar(100), 
    @TestPlan nvarchar(500) 
    
AS

declare @TestRunId bigint
select @TestRunId=TestRunId from TestRuns where TestRun=@TestRun
delete from SUTMetric where TestRunId = @TestRunId

delete from jmeterrawresults
where
    TestPlan = @TestPlan and TestRun=@TestRun


delete from TestRuns
where
    TestPlan = @TestPlan and TestRun=@TestRun

RETURN 0