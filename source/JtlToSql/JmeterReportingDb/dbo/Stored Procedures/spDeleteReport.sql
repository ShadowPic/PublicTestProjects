CREATE PROCEDURE [dbo].[spDeleteReport]
	@TestRun nvarchar(100), 
    @TestPlan nvarchar(500) 
    
AS

delete from jmeterrawresults
where
    TestPlan = @TestPlan and TestRun=@TestRun


delete from TestRuns
where
    TestPlan = @TestPlan and TestRun=@TestRun

RETURN 0
