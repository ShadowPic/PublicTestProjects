﻿using Microsoft.VisualStudio.TestTools.UnitTesting;
using JtlToSql;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;

namespace JtlToSql.Tests
{
    [TestClass()]
    public class ProcessJtlFilesTests
    {
        [TestMethod()]
        public void SendJtlToSQLTest()
        {
            //arrange
            var testPlan = "total demo";
            var testRun = "total demo1";
            var processJtlFiles = new ProcessJtlFiles();
            string jtlFilePath = @"results.jtl";
            IConfigurationRoot configuration = new ConfigurationBuilder()
                .AddJsonFile("secrets.json")
                .Build();
            var sqlConnectionString = configuration["ConnectionStrings:JtlReportingDatabase"];
            //act
            
            processJtlFiles.SendJtlToSQL(jtlFilePath, sqlConnectionString,testPlan,testRun,testOfRecord:false,usesThinkTimes:true
                ,runNotes:"run notes",appVersionRef:"v1.2");
            //assert
            Assert.IsTrue(true);
        }
    }
}