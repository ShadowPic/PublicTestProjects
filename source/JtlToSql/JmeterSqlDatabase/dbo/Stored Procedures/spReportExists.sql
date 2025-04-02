CREATE PROCEDURE [dbo].[spReportExists]
	@TestRun nvarchar(100), 
    @TestPlan nvarchar(500),
    @ReportExists integer output
    
AS

select @ReportExists= count(*)from TestRuns
where
    TestPlan = @TestPlan and TestRun=@TestRun

RETURN 0