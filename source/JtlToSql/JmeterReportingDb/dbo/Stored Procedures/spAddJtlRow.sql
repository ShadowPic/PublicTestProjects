CREATE PROCEDURE [dbo].[spAddJtlRow]
	@storageaccountpath nvarchar(500), 
    @timeStamp bigint, 
    @elapsed int, 
    @label nvarchar(500), 
    @responseCode int, 
    @responseMessage nvarchar(50), 
    @threadName nvarchar(200), 
    @dataType nvarchar(50), 
    @success nvarchar(5), 
    @failureMessage nvarchar(50), 
    @bytes int, 
    @sentBytes int, 
    @grpThreads int, 
    @allThreads int, 
    @URL nvarchar(500), 
    @Latency int, 
    @IdleTime int, 
    @Connect int, 
    @TestRun nvarchar(100), 
    @TestPlan nvarchar(500), 
    @UtcTimeStamp datetime, 
    @ElapsedMS int, 
    @LabelPlusTestRun nvarchar(500)
AS

INSERT INTO [dbo].[jmeterrawresults]
           ([storageaccountpath]
           ,[timeStamp]
           ,[elapsed]
           ,[label]
           ,[responseCode]
           ,[responseMessage]
           ,[threadName]
           ,[dataType]
           ,[success]
           ,[failureMessage]
           ,[bytes]
           ,[sentBytes]
           ,[grpThreads]
           ,[allThreads]
           ,[URL]
           ,[Latency]
           ,[IdleTime]
           ,[Connect]
           ,[TestRun]
           ,[TestPlan]
           ,[UtcTimeStamp]
           ,[ElapsedMS]
           ,[LabelPlusTestRun])
     VALUES
           (
           @storageaccountpath, 
            @timeStamp, 
            @elapsed, 
            @label, 
            @responseCode, 
            @responseMessage, 
            @threadName, 
            @dataType, 
            @success, 
            @failureMessage, 
            @bytes, 
            @sentBytes, 
            @grpThreads, 
            @allThreads, 
            @URL, 
            @Latency, 
            @IdleTime, 
            @Connect, 
            @TestRun, 
            @TestPlan, 
            @UtcTimeStamp, 
            @ElapsedMS, 
            @LabelPlusTestRun
           )

RETURN 0
