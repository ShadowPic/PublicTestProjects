CREATE PROCEDURE [dbo].[spAddReport]
	@TestRun nvarchar(100), 
    @TestPlan nvarchar(500),
    @StartTime datetime,
    @TestOfRecord BIT = 0,
    @UsesThinkTimes BIT = 0,
    @RunNotes nvarchar(500)=null,
    @AppVersionRef NVARCHAR(500)=null
AS

INSERT INTO [dbo].[TestRuns]
           (
           [TestPlan],
           [TestRun],
           [StartTime],
           IsTestOfRecord,
           UsesThinkTimes,
           RunNotes,
           AppVersionRef
           )
     VALUES
           (
           @TestPlan,
           @TestRun,
           @StartTime,
           @TestOfRecord,
           @UsesThinkTimes,
           @RunNotes,
           @AppVersionRef)

RETURN 0