CREATE TABLE [dbo].[jmeterrawresults] (
    [timeStamp]                BIGINT          NOT NULL,
    [elapsed]                  INT             NULL,
    [label]                    NVARCHAR (500)  NOT NULL,
    [responseCode]             INT             NULL,
    [responseMessage]          NVARCHAR (500)  NULL,
    [threadName]               NVARCHAR (200)  NOT NULL,
    [dataType]                 NVARCHAR (50)   NULL,
    [success]                  NVARCHAR (5)    NULL,
    [failureMessage]           NVARCHAR (500)  NULL,
    [bytes]                    BIGINT          NULL,
    [sentBytes]                INT             NULL,
    [grpThreads]               INT             NOT NULL,
    [allThreads]               INT             NOT NULL,
    [URL]                      NVARCHAR (2048) NULL,
    [Latency]                  INT             NULL,
    [IdleTime]                 INT             NULL,
    [Connect]                  INT             NULL,
    [TestRun]                  NVARCHAR (100)  NOT NULL,
    [TestPlan]                 NVARCHAR (500)  NOT NULL,
    [UtcTimeStamp]             DATETIME        NULL,
    [ElapsedMS]                INT             NULL,
    [LabelPlusTestRun]         NVARCHAR (500)  NULL,
    [UtcStartTime]             DATETIME        NULL,
    [IsTransaction]            BIT             NULL,
    [TransactionSamples]       INT             NULL,
    [TransactionFailedSamples] INT             NULL
);










GO



GO
CREATE NONCLUSTERED INDEX [Index_jmeterrawresults_testplan_testrun]
    ON [dbo].[jmeterrawresults]([TestPlan] ASC, [TestRun] ASC);

