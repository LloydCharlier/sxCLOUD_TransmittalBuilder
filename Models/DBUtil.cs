using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Xml;


namespace TransmittalBuilder.Models
{
    public class DBUtil
    {
        public static SqlConnection Connection
        {
            get
            {
                SqlConnection connection;
                string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

                try
                {
                    connection = new SqlConnection(connectionString);
                    connection.Open();
                    if (connection.State != ConnectionState.Open)
                    {
                        connection = null;
                    }
                }
                catch (Exception ex)
                {
                    connection = null;
                }

                return connection;
            }
        }

        public static void CloseConnection()
        {
            if (Connection != null)
            {
                Connection.Close();
            }
        }

        public static string SqlEscape(string strInput)
        {
            return strInput.Replace("'", "''");
        }

        public static bool ExecNonqueryStatement(string sql)
        {
            try
            {
                SqlCommand oCommand = new SqlCommand(sql, Connection);
                oCommand.ExecuteNonQuery();
                return true;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public static DataTable CreateTable(string sql)
        {
            if (string.IsNullOrEmpty(sql))
            {
                return new DataTable();
            }


            for (int i = 0; i < 1; i++)
            {
                try
                {
                    //DateTime before = DateTime.Now;

                    SqlDataAdapter dataAdapter = new SqlDataAdapter(sql, Connection);
                    DataTable dataTable        = new DataTable();
                    dataAdapter.Fill(dataTable);

                    //DateTime after = DateTime.Now;
                    //TimeSpan time  = after - before;
                    //Util.Log("QueryTime = " + time.Seconds.ToString());
                    //Util.Log("Query = " + sql);

                    return dataTable;
                }
                catch (Exception ex)
                {
                }
            }

            return new DataTable();
        }

        public static DataSet CreateDataSet(string sql)
        {
            try
            {
                SqlDataAdapter dataAdapter = new SqlDataAdapter(sql, Connection);
                DataSet dataSet            = new DataSet();
                dataAdapter.Fill(dataSet);

                return dataSet;
            }
            catch
            {
                return new DataSet();
            }
        }

        public static DataSet XmlToDataSet(string xml)
        {
            DataSet ds = new DataSet();

            try
            {
                XmlReader xr = XmlReader.Create(new StringReader(xml));
                ds.ReadXml(xr);
                return ds;
            }
            catch
            {
                return ds;
            }
        }

        public static Guid GetFieldGuid(DataTable dt, int r, string fldName)
        {
            try
            {
                Guid guidReturn = Guid.Empty;
                Guid.TryParse(dt.Rows[r][fldName].ToString(), out guidReturn);
                return guidReturn;
            }
            catch
            {
                return Guid.Empty;
            }
        }

        public static string GetFieldString(DataTable dt, int r, string fldName)
        {
            try
            {
                return dt.Rows[r][fldName].ToString();
            }
            catch
            {
                return "";
            }
        }

        public static double GetFieldDouble(DataTable dt, int r, string fldName)
        {
            try
            {
                return double.Parse(dt.Rows[r][fldName].ToString());
            }
            catch
            {
                return 0;
            }
        }

        public static long GetFieldLong(DataTable dt, int r, string fldName)
        {
            try
            {
                return long.Parse(dt.Rows[r][fldName].ToString());
            }
            catch
            {
                return 0;
            }
        }

        public static bool GetFieldBool(DataTable dt, int r, string fldName)
        {
            try
            {
                return (bool)dt.Rows[r][fldName];
            }
            catch
            {
                return false;
            }
        }

        public static Guid GetFieldGuid(DataRow row, string fldName)
        {
            try
            {
                Guid guidReturn = Guid.Empty;
                Guid.TryParse(row[fldName].ToString(), out guidReturn);
                return guidReturn;
            }
            catch
            {
                return Guid.Empty;
            }
        }

        public static string GetFieldString(DataRow row, string fldName)
        {
            try
            {
                return row[fldName].ToString();
            }
            catch
            {
                return "";
            }
        }

        public static double GetFieldDouble(DataRow row, string fldName)
        {
            try
            {
                return double.Parse(row[fldName].ToString());
            }
            catch
            {
                return 0;
            }
        }

        public static long GetFieldLong(DataRow row, string fldName)
        {
            try
            {
                return long.Parse(row[fldName].ToString());
            }
            catch
            {
                return 0;
            }
        }

        public static bool GetFieldBool(DataRow row, string fldName)
        {
            try
            {
                return (bool)row[fldName];
            }
            catch
            {
                return false;
            }
        }

    }
}