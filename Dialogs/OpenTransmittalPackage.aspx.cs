using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using TransmittalBuilder.Models;

namespace TransmittalBuilder.Dialogs
{
    public partial class OpenTransmittalPackage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                BindToDataTable(rcbOpenTransmittalPackage);
            }
        }

        protected void OpenTransmittalPackage_DataBound(object sender, EventArgs e)
        {
            //set the initial footer label
            ((Literal)rcbOpenTransmittalPackage.Footer.FindControl("TransmittalPackageItemsCount")).Text = Convert.ToString(rcbOpenTransmittalPackage.Items.Count);
        }

        protected void OpenTransmittalPackage_ItemDataBound(object sender, RadComboBoxItemEventArgs e)
        {
            e.Item.Text = ((DataRowView)e.Item.DataItem)["pkgName"].ToString();
            e.Item.Value = ((DataRowView)e.Item.DataItem)["ID"].ToString();
        }

        private void BindToDataTable(RadComboBox transmittalPackageList)
        {
            SqlConnection con            = new SqlConnection("Data Source=sxRSQLDB1.MySirruX.com;Initial Catalog=sxDocs;Persist Security Info=True;User ID=sa;Password=SirruX2014");
            SqlDataAdapter adapter       = new SqlDataAdapter("SELECT [ID], [pkgName], [description] FROM [TransmittalPackages]", con);
            DataTable transmittalPackage = new DataTable();

            adapter.Fill(transmittalPackage);

            transmittalPackageList.DataTextField  = "pkgName";
            transmittalPackageList.DataValueField = "ID";
            transmittalPackageList.DataSource     = transmittalPackage;
            transmittalPackageList.DataBind();
        }
    }
}