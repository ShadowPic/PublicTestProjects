using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using EncryptUtils;
namespace EncryptUtilsTests
{
    [TestClass]
    public class EncryptStringsTests
    {
        [TestMethod]
        public void EncryptStringTest()
        {
            //arrange
            string OriginalString = "This is not encrypted";
            string EncryptionKey = "really lame encryption key";
            //act
            var EncryptedString = EncryptUtils.EncryptStrings.Encrypt(OriginalString, true, EncryptionKey);
            var DecryptedString = EncryptUtils.EncryptStrings.Decrypt(EncryptedString, true, EncryptionKey);
            //assert
            Assert.AreEqual(OriginalString, DecryptedString);
        }

        [TestMethod]
        public void DecryptStringTest()
        { }
    }
}
