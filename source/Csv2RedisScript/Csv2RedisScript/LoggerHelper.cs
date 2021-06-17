using log4net;
using log4net.Config;
using System;
using System.IO;
using System.Reflection;

namespace Csv2RedisScript
{
    public class LoggerHelper
    {
        private static ILog _xmlLogger;
        private static string configPath = @"\logger.config";

        public static ILog GetXmlLogger(Type type)
        {
            if (_xmlLogger != null)
            {
                return _xmlLogger;
            }

            string path = Directory.GetCurrentDirectory();
            FileInfo fileInfo = new FileInfo(path + configPath);
            log4net.Repository.ILoggerRepository logRepository = LogManager.GetRepository(Assembly.GetEntryAssembly());
            XmlConfigurator.Configure(logRepository, fileInfo);
            _xmlLogger = LogManager.GetLogger(type);
            _xmlLogger.Info($"Local Time Zone: {TimeZoneInfo.Local.DisplayName}");
            _xmlLogger.Info($"Computer Name: {Environment.MachineName}");
            _xmlLogger.Info($"Running As User: {Environment.UserDomainName}\\{Environment.UserName}");
            return _xmlLogger;
        }

    }
}
