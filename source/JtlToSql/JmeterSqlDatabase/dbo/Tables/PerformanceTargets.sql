CREATE TABLE [dbo].[PerformanceTargets] (
    [PerformanceTargetId] BIGINT         IDENTITY (1, 1) NOT NULL,
    [label]               NVARCHAR (500) NOT NULL,
    [UserCategory]        NVARCHAR (50)  NULL,
    [ResponseTimeMS]      BIGINT         NULL,
    [FailureRate]         FLOAT (53)     NULL,
    CONSTRAINT [PK_PerformanceTargets] PRIMARY KEY CLUSTERED ([PerformanceTargetId] ASC)
);

