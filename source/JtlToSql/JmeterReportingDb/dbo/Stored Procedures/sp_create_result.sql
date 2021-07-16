
Create procedure [dbo].[sp_create_result]
@storageaccountpath nvarchar(2048),
           @timeStamp nvarchar(25),
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
           @grpThreads nvarchar(50),
           @allThreads nvarchar(50),
           @URL nvarchar(2048),
           @Latency int,
           @IdleTime int,
           @Connect int
as
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
			   ,[Connect])
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
           @Connect
			   )
