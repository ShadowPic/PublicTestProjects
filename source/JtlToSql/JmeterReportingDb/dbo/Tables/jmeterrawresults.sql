CREATE TABLE [dbo].[jmeterrawresults] (
    [timeStamp]          BIGINT  NOT NULL,
    [elapsed]            INT            NULL,
    [label]              NVARCHAR (500) NOT NULL,
    [responseCode]       INT            NULL,
    [responseMessage]    NVARCHAR (50)  NULL,
    [threadName]         NVARCHAR (200) NOT NULL,
    [dataType]           NVARCHAR (50)  NULL,
    [success]            NVARCHAR (5)   NULL,
    [failureMessage]     NVARCHAR (50)  NULL,
    [bytes]              INT            NULL,
    [sentBytes]          INT            NULL,
    [grpThreads]         INT  NOT NULL,
    [allThreads]         INT  NOT NULL,
    [URL]                NVARCHAR (500) NULL,
    [Latency]            INT            NULL,
    [IdleTime]           INT            NULL,
    [Connect]            INT            NULL,
    [TestRun]            NVARCHAR (100) NOT NULL,
    [TestPlan]           NVARCHAR (500) NOT NULL,
    [UtcTimeStamp]       DATETIME       NULL,
    [ElapsedMS]     INT            NULL,
    [LabelPlusTestRun]   NVARCHAR (500) NULL, 
    
);

-- Create index template for Azure SQL Database and Azure SQL Data Warehouse Database 
-- ==================================================================================
go
CREATE INDEX testRunIndex
ON jmeterrawresults
(
	TestPlan asc,
    TestRun asc
)
GO


