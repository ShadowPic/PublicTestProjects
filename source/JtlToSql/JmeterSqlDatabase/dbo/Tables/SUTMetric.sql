CREATE TABLE [dbo].[SUTMetric] (
    [SUTMetricId]            BIGINT        IDENTITY (1, 1) NOT NULL,
    [TestRunId]              BIGINT        NOT NULL,
    [Resource]               VARCHAR (500) NULL,
    [PerformanceCounterName] VARCHAR (500) NULL,
    [AverageValue]           FLOAT (53)    NULL,
    [MaxValue]               FLOAT (53)    NULL,
    CONSTRAINT [PK_SUTMetric] PRIMARY KEY CLUSTERED ([SUTMetricId] ASC),
    CONSTRAINT [FK_SUTMetric_TestRuns] FOREIGN KEY ([TestRunId]) REFERENCES [dbo].[TestRuns] ([TestRunId])
);

