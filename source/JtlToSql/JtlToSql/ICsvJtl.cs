using System.IO;

namespace JtlToSql
{
    public interface ICsvJtl
    {
        void Dispose();
        void InitJtlReader(StreamReader jtlStream);
        bool ReadNextCsvLine();
        dynamic GetCsvRow();
        void AddCalculatedColumns(dynamic jtlRow);
    }
}