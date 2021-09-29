using TransmittalBuilder.Models;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Net;
using System.Net.Mail;
using System.Text.RegularExpressions;
using System.Web.UI;
using Telerik.Web.UI;
using System.Collections;

public partial class Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void RadGrid1_NeedDataSource1(object source, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
    {
        ArrayList list = new ArrayList
        {
            "Document1.docx",
            "Document2.dwg",
            "Document3.pdf"
        };
        RadGrid1.DataSource = list;
    }

    protected void RadTabStrip1_TabClick(object sender, RadTabStripEventArgs e)
    {
        //lblSelectedTab.Text = "Selected tab: " + RadTabStrip1.SelectedTab.Text;
    }

    public static string ParseTagsFromHtmlBody(string pageContent)
    {
        string regexPattern        = "{SmartTag:(.*?)}"; // Matches {SmartTag: anytagname}
        string tagName             = "";
        string fieldName           = "";
        string replacement         = "";
        MatchCollection tagMatches = Regex.Matches(pageContent, regexPattern);

        foreach (Match match in tagMatches)
        {
            tagName   = match.ToString();
            fieldName = tagName.Replace("{SmartTag: ", "").Replace("}", "");

            //replacement = GetFieldValue(fieldName); // Lookup fieldname value in database
            switch (fieldName)
            {
                case "FirstName":
                    replacement = "Lloyd";
                    break;
                case "LastName":
                    replacement = "Charlier";
                    break;
                case "DocumentName":
                    replacement = "Technical Specifications.docx";
                    break;
                case "DocumentAuthor":
                    replacement = "Kenneth C. Werther, Jr., P.E.";
                    break;
            }

            pageContent = pageContent.Replace(tagName, replacement);
        }
        return pageContent;
    }

    public static bool SendEmail(string host, int port, string username, string password, string fromAddress, string toAddress, string subject, string tokenBody)
    {
        string body;

        tokenBody = tokenBody.Replace("<a href=\"{%SmartTag%}\" title=\"", string.Empty); // Remove HTML anchor tag garbage before token
        tokenBody = tokenBody.Replace("\">SmartTag</a>", string.Empty);                   // Remove HTML anchor tag garbage after token
        body      = ParseTagsFromHtmlBody(tokenBody);                                     // Replace tokens with associated values from database

        bool emailSent = false;
        MailMessage message = new MailMessage
        {
            From = new MailAddress(fromAddress)
        };
        //foreach (string address in toAddress)
        //{
        //    message.To.Add(address);
        //}
        message.To.Add(toAddress);

        message.Subject = subject;
        message.Body = body;
        message.IsBodyHtml = true;

        var client = new SmtpClient(host, Convert.ToInt32(port))
        {
            UseDefaultCredentials = true,
            Credentials = new NetworkCredential(username, password),
            EnableSsl = true
        };
        try
        {
            client.Send(message);
            emailSent = true;
            //logger.Info(string.Format("Email sent from {0} to {1}", fromAddress, string.Join(",", toAddress)));
        }
        catch (Exception ex)
        {
            emailSent = false;
            //logger.Error(ExceptionHandler.ToLongString(ex));
        }
        return emailSent;
    }

    protected void RadAjaxManager1_AjaxRequest(object sender, Telerik.Web.UI.AjaxRequestEventArgs e)
    {
        string argument;
        string cmd;
        string sql;
        string transmittalPackageId;
        string transmittalPackageName;
        string transmittalPackageBody;
        string transmittalPackageDescription;
        string ownerId;
        string[] stringArray;

        argument    = (e.Argument);
        stringArray = argument.Split("|".ToCharArray());
        cmd         = stringArray[0];

        switch (cmd)
        {
            case "Open":
                transmittalPackageId = stringArray[1];

                SqlConnection con            = new SqlConnection("Data Source=sxRSQLDB1.MySirruX.com;Initial Catalog=sxDocs;Persist Security Info=True;User ID=sa;Password=SirruX2014");
                SqlDataAdapter adapter       = new SqlDataAdapter("SELECT * FROM [TransmittalPackages] WHERE ID = '" + transmittalPackageId + "'", con);
                DataTable transmittalPackage = new DataTable();

                adapter.Fill(transmittalPackage);

                DataRow row            = transmittalPackage.Rows[0];
                string body            = row["body"].ToString();
                transmittalPackageName = row["pkgName"].ToString();

                RadEditor1.Content = body;

                ScriptManager.RegisterStartupScript(this, typeof(Page), "updateTransmittalPackageTextbox", "TransmittalBuilder.updateTransmittalPackageTextbox('" + transmittalPackageName + "');", true);

                break;
            case "Save":
                transmittalPackageId          = stringArray[1];
                transmittalPackageName        = stringArray[2];
                transmittalPackageDescription = stringArray[3];
                transmittalPackageBody        = RadEditor1.Content;
                ownerId                       = "01234567-0123-0123-0123-0123456789ab"; // !!!!! dummy owner ID !!!!!

                sql = String.Format(@"EXEC SaveTransmittalPackagee '{0}',
                                                             '{1}',
                                                             '{2}',
                                                             '{3}',
                                                             '{4}'",
                                                             transmittalPackageId,
                                                             transmittalPackageName,
                                                             transmittalPackageDescription,
                                                             transmittalPackageBody,
                                                             ownerId);

                DBUtil.CreateTable(sql);

                break;
            case "Mail":
                SendEmail("Mail.SirruX.com", 587, "SirruX\\LCharlier", "SirruX2014", "LCharlier@SirruX.com", "LCharlier@SirruX.com", "Test Email", RadEditor1.Content);
                break;
        }
    }
}