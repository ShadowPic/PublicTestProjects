using Microsoft.VisualStudio.TestTools.UnitTesting;
using JMeterTestsScript;
using System.IO;


namespace Csv2RedisTests
{
    [TestClass]
    public class JMeterTestScriptTests
    {
        string jmeterScriptFileName = "redis.jmx";

        [TestMethod]
        public void CopyJmeter()
        {
            //arrange
            string jmeterDestinationFileName = "redis-copy.jmx";
            JmeterScript jmeterScript = new JmeterScript(jmeterScriptFileName);
            //act
            jmeterScript.WriteNewFile(jmeterDestinationFileName);
            //assert
            bool fileWasCreated = File.Exists(jmeterDestinationFileName);
            Assert.IsTrue(fileWasCreated);
        }

        [TestMethod]
        public void JmeterTestHasCsvControl()
        {
            //arrange
            JmeterScript jmeterScript = new JmeterScript(jmeterScriptFileName);
            bool Expected = true;
            //act
            bool Actual = jmeterScript.HasEnabledCsvControl();
            //assert
            Assert.AreEqual(Expected, Actual);
        }

        [TestMethod]
        public void ConvertCsvToRedis()
        {
            //arrange
            string csvFileName = "search.csv";
            string csvFileName2 = "names.csv";
            string redisScriptFilename = "test.redis";
            //act
            File.Delete(redisScriptFilename);
            Csv2Redis.ConvertToRedis(csvFileName,redisScriptFilename);
            Csv2Redis.ConvertToRedis(csvFileName2,redisScriptFilename);
            //assert
            Assert.IsTrue(File.Exists(redisScriptFilename));
        }

        [TestMethod]
        public void AddRedisConfigControl()
        {
            //arrange
            JmeterScript jmeterScript = new JmeterScript(jmeterScriptFileName);
            bool Expected = true;
            //act
            bool Actual = jmeterScript.HasEnabledCsvControl();
            jmeterScript.AddRedisControl();
            jmeterScript.WriteNewFile("maybe.jmx");
            //assert
            Assert.AreEqual(Expected, Actual);
        }

        [TestMethod]
        public void AddBackendListener()
        {
            //arrange
            JmeterScript jmeterScript = new JmeterScript(jmeterScriptFileName);
            //act
            jmeterScript.AddBackEndListener();
            jmeterScript.WriteNewFile("backendlistener.jmx");
            //assert
            Assert.IsTrue(true);
        }

        [TestMethod]
        [ExpectedException(typeof(FileNotFoundException))]
        public void DetectsNoCsvFileNames()
        {
            //arrange
            string jmxWithNoCsvFileNames = "csv-missing-filenames.jmx";
            JmeterScript jmeterScript = new JmeterScript(jmxWithNoCsvFileNames);
            //act
            bool Actual = jmeterScript.HasEnabledCsvControl();
            jmeterScript.AddRedisControl();
            //assert
            Assert.IsTrue(true);
        }

    }

}
