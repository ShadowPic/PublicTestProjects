CREATE TABLE [dbo].[TestRuns] (
    [TestPlan]          NVARCHAR (500) NOT NULL,
    [StartTime]         DATETIME       NOT NULL,
    [TestRun]           NVARCHAR (100) NOT NULL,
    [DurationInMinutes] BIGINT         NULL,
    [IsTestOfRecord]    BIT            CONSTRAINT [DEFAULT_TestRuns_IsTestOfRecord] DEFAULT ((0)) NULL,
    [UsesThinkTimes]    BIT            NULL,
    [RunNotes]          NVARCHAR (500) NULL
);

