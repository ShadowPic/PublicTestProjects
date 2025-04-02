CREATE TABLE [dbo].[TestRuns] (
    [TestRunId]         BIGINT         IDENTITY (100, 1) NOT NULL,
    [TestPlan]          NVARCHAR (500) NOT NULL,
    [StartTime]         DATETIME       NOT NULL,
    [TestRun]           NVARCHAR (100) NOT NULL,
    [DurationInMinutes] BIGINT         NULL,
    [IsTestOfRecord]    BIT            CONSTRAINT [DEFAULT_TestRuns_IsTestOfRecord] DEFAULT ((0)) NULL,
    [UsesThinkTimes]    BIT            NULL,
    [RunNotes]          NVARCHAR (500) NULL,
    [AppVersionRef]     NVARCHAR (500) NULL,
    CONSTRAINT [PK_TestRuns] PRIMARY KEY CLUSTERED ([TestRunId] ASC)
);

