<%@ Page
    Language        = "C#"
    AutoEventWireup = "true"
    CodeBehind      = "OpenTransmittalPackage.aspx.cs"
    Inherits        = "TransmittalBuilder.Dialogs.OpenTransmittalPackage" %>

<!DOCTYPE html>

<html>
    <head runat = "server">
        <title></title>
        <link
            href = "../Styles/styles_dialogs.css"
            rel  = "stylesheet" />
    </head>
    <body>
        <form
            id    = "form1"
            runat = "server">
            <telerik:RadScriptManager
                ID    = "RadScriptManager1"
                runat = "server">
                <Scripts>
                    <asp:ScriptReference
                        Assembly = "Telerik.Web.UI"
                        Name     = "Telerik.Web.UI.Common.Core.js" />
                    <asp:ScriptReference
                        Assembly = "Telerik.Web.UI"
                        Name     = "Telerik.Web.UI.Common.jQuery.js" />
                    <asp:ScriptReference
                        Assembly = "Telerik.Web.UI"
                        Name     = "Telerik.Web.UI.Common.jQueryInclude.js" />
                </Scripts>
            </telerik:RadScriptManager>
            <script type = "text/javascript">
                var taskInfo;

                function pageLoad()
                {
                }

                function getRadWindow()
                {
                    var oWindow = null;

                    if (window.radWindow)
                    {
                        oWindow = window.radWindow;
                    }
                    else if (window.frameElement.radWindow)
                    {
                        oWindow = window.frameElement.radWindow;
                    }
                    return oWindow;
                }

                function closeRadWindow()
                {
                    var currentWindow = getRadWindow();

                    currentWindow.close();
                }

                //Close the dialog and return the argument to the OnClientClose event handler
                function returnArg()
                {
                    var oWnd               = getRadWindow();
                    var transmittalPackage = $find("rcbOpenTransmittalPackage");
                    var transmittalPackageID;

                    transmittalPackageID = transmittalPackage.get_selectedItem().get_value();

                    oWnd.close(Sys.Serialization.JavaScriptSerializer.serialize(transmittalPackageID));
                }
            </script>
            <div id = "dvOpenTransmittalPackage">
                <ul class = "formItems">
                    <li>
                        <label for = "rcbOpenTransmittalPackage" id = "lblOpenTransmittalPackage">Transmittal Packages:</label>
                    </li>
                    <li>
                        <telerik:RadComboBox 
                            ID                      = "rcbOpenTransmittalPackage"
                            runat                   = "server"
                            RenderMode              = "Lightweight"
                            Height                  = "190px"
                            Width                   = "100%" 
                            MarkFirstMatch          = "true"
                            EnableLoadOnDemand      = "true"
                            HighlightTemplatedItems = "true"
                            OnClientItemsRequested  = "rcbOpenTransmittalPackage_onClientItemsRequested"
                            OnDataBound             = "OpenTransmittalPackage_DataBound"
                            OnItemDataBound         = "OpenTransmittalPackage_ItemDataBound"
                            DropDownCssClass        = "DialogDropdowns">
                            <HeaderTemplate>
                                <ul>
                                    <li class="col1">Transmittal Package Name</li>
                                    <li class="col2">Author</li>
                                    <li class="col3">Last Access Date</li>
                                </ul>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <ul>
                                    <li class="col1">
                                        <%# DataBinder.Eval(Container.DataItem, "pkgName") %>
                                    </li>
<%--                                    <li class="col2">
                                        <%# DataBinder.Eval(Container.DataItem, "author") %>
                                    </li>
                                    <li class="col3">
                                        <%# DataBinder.Eval(Container.DataItem, "lastAccessDate") %>
                                    </li>--%>
                                </ul>
                            </ItemTemplate>
                            <FooterTemplate>
                                A total of <asp:Literal runat = "server" ID = "TransmittalPackageItemsCount" /> items
                            </FooterTemplate>
                        </telerik:RadComboBox>
                    </li>
                </ul>
            </div>
            <div id = "btnDiv">
                <input
                    id      = "btnOpen"
                    type    = "button"
                    value   = "Open"
                    class   = "dialogButton"
                    onclick = "returnArg(); return false;" />
                <input
                    id      = "btnCancel"
                    type    = "button"
                    value   = "Cancel"
                    class   = "dialogButton"
                    onclick = "closeRadWindow(); return false;" />
            </div>
            <telerik:RadScriptBlock runat="server">
                <script type="text/javascript">
                    function rcbOpenTransmittalPackage_onClientItemsRequested(sender, args)
                    {
                        //Set the footer text.
                        sender.get_dropDownElement().lastChild.innerHTML = "A total of " + sender.get_items().get_count() + " items";
                    }
                </script>
            </telerik:RadScriptBlock>
        </form>
    </body>
</html>