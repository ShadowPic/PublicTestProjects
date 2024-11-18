CREATE PROCEDURE [dbo].[spAddReport]
	@TestRun nvarchar(100), 
    @TestPlan nvarchar(500),
    @StartTime datetime
AS

INSERT INTO [dbo].[TestRuns]
           (
           [TestPlan],
           [TestRun],
           [StartTime],
           IsTestOfRecord
           )
     VALUES
           (
           @TestPlan,
           @TestRun,
           @StartTime,
           1
           )

RETURN 0