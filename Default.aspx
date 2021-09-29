<%@ Page
    Language        = "C#"
    AutoEventWireup = "true"
    CodeBehind      = "Default.aspx.cs"
    Inherits        = "Default" %>

<!DOCTYPE html>

<html xmlns = "http://www.w3.org/1999/xhtml">
    <head runat = "server">
		<title>sxCLOUD Transmittal Builder</title>
        <link
            href = "Styles/main.css"
            rel  = "stylesheet" />
        <link
            href = "Styles/styles.css"
            rel  = "stylesheet" />
        <telerik:RadStyleSheetManager
            id    = "RadStyleSheetManager1"
            runat = "server" />
        <style>
            html .RadAutoCompleteBox .racInput
            {
                font-size:   10px;
                height:      12px;
                line-height: 12px;
            }

            html .RadAutoCompleteBox
            {
                font-size:   10px;
                line-height: 12px;
            }

            .emailHeader
            {
                font:   14px "Segoe UI", Arial, Helvetica, sans-serif;
                margin: 5px 0 5px 75px;
            }

            .emailHeaderLabel
            {
                float:        left;
                margin-right: 5px;
                text-align:   right;
                width:        65px;
            }

            .transmittalPackage
            {
                font-size:   10px;
                height:      12px;
                line-height: 12px;
                clear:       both;
                display:     block !important;
                margin-left: 50px;
                width:       100% !important;
            }

            .transmittalPackageLabel
            {
                display:     block !important;
                float:       left;
                font-weight: bold;
                margin-left: 50px;
                width:       100% !important;
            }

            .p-icon, .t-icon, .t-font-icon, .t-efi
            {
                color:       #ffffff;
                font-size:   10px;
                font-weight: bold !important;
            }
        </style>
    </head>
    <body>
        <form
            id    = "form1"
            runat = "server">
            <telerik:RadScriptManager
                ID    = "RadScriptManager1"
                runat = "server" >
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
                    <asp:ScriptReference Path = "Scripts/scripts.js" />
                </Scripts>
            </telerik:RadScriptManager>
            <telerik:RadSkinManager
                ID          = "RadSkinManager1"
                runat       = "server"
                Skin        = "Bootstrap"
                ShowChooser = "false" />
            <asp:SqlDataSource
                ID               = "UserView"
                runat            = "server"
                ConnectionString = "<%$ ConnectionStrings:sxDataConnection %>"
                ProviderName     = "System.Data.SqlClient"
                SelectCommand    = "SELECT * FROM [sxUserView]">
            </asp:SqlDataSource> 
            <telerik:RadAjaxManager
                ID            = "RadAjaxManager1"
                runat         = "server"
                OnAjaxRequest = "RadAjaxManager1_AjaxRequest">
                <AjaxSettings> 
                    <telerik:AjaxSetting AjaxControlID = "RadAjaxManager1"> 
                        <UpdatedControls> 
                            <telerik:AjaxUpdatedControl ControlID = "RadEditor1" /> 
                        </UpdatedControls> 
                    </telerik:AjaxSetting>
                    <telerik:AjaxSetting AjaxControlID="RadTabStrip1">
                        <UpdatedControls>
                            <telerik:AjaxUpdatedControl ControlID="RadTabStrip1" />
                            <telerik:AjaxUpdatedControl ControlID="RadMultiPage1" />
                        </UpdatedControls>
                    </telerik:AjaxSetting>
                    <telerik:AjaxSetting AjaxControlID="RadMultiPage1">
                        <UpdatedControls>
                            <telerik:AjaxUpdatedControl ControlID="RadTabStrip1" />
                            <telerik:AjaxUpdatedControl ControlID="RadMultiPage1" />
                        </UpdatedControls>
                    </telerik:AjaxSetting>
                </AjaxSettings> 
            </telerik:RadAjaxManager>
            <div style = "height: 97%;">
	            <header id = "header">
		            <h1>sxCLOUD Transmittal Builder</h1>
	            </header>
                <div id = "toolbar-container">
                    <telerik:RadToolBar
                        ID                    = "RadToolBar1"
                        runat                 = "server"
                        RenderMode            = "Lightweight"
                        Width                 = "100%"
                        EnableRoundedCorners  = "true"
                        EnableShadows         = "true"
                        OnClientButtonClicked = "TransmittalBuilder.RadToolbar1_onClientButtonClicked">
                        <Items>
                            <telerik:RadToolBarButton
                                Value         = "new"
                                ImageUrl      = "Images/DocumentNew.png"
                                Enabled       = "true"
                                ImagePosition = "AboveText"
                                Text          = "New">
                            </telerik:RadToolBarButton>
                            <telerik:RadToolBarButton
                                Value         = "open"
                                ImageUrl      = "Images/DocumentOpen.png"
                                Enabled       = "true"
                                ImagePosition = "AboveText"
                                Text          = "Open">
                            </telerik:RadToolBarButton>
                            <telerik:RadToolBarButton
                                Value         = "save"
                                ImageUrl      = "Images/DocumentSave.png"
                                Enabled       = "false"
                                ImagePosition = "AboveText"
                                Text          = "Save">
                            </telerik:RadToolBarButton>
                            <telerik:RadToolBarButton
                                Value         = "test"
                                ImageUrl      = "Images/SendTestEmail.png"
                                Enabled       = "false"
                                ImagePosition = "AboveText"
                                Text          = "Test">
                            </telerik:RadToolBarButton>
                            <telerik:RadToolBarButton Text = "TransmittalPackageButton">
                                <ItemTemplate>
                                    <div class = "transmittalPackageLabel">
                                        <telerik:RadLabel
                                            ID         = "lblTransmittalBox"
                                            runat      = "server"
                                            RenderMode = "Lightweight"
                                            Width      = "100%"
                                            Text       = "Transmittal Package:" />
                                    </div>
                                    <div class = "transmittalPackage">
                                        <telerik:RadTextBox
                                            ID          = "tbTransmittalPackage"
                                            runat       = "server"
                                            BorderStyle = "None"
                                            ReadOnly    = "true"
                                            Font-Bold   = "false" />
                                    </div>
                                </ItemTemplate>
                            </telerik:RadToolBarButton>
                        </Items>
                    </telerik:RadToolBar>
                </div>
                <div style = "margin: 10px;">
                    <div class = "emailHeaderLabel">
                        <label>To:</label>
                    </div>
                    <div class = "emailHeader">
                        <telerik:RadAutoCompleteBox
                            ID                               = "emailTo"
                            runat                            = "server"
                            RenderMode                       = "Lightweight"
                            Width                            = "100%"
                            BackColor                        = "White"
                            ForeColor                        = "Black"
                            BorderColor                      = "#F5F5F5"
                            DataSourceID                     = "UserView"
                            DataTextField                    = "Email"
                            EmptyMessage                     = "Enter valid email address..."
                            TokensSettings-AllowTokenEditing = "true"
                            Localization-RemoveTokenTitle    = "Remove email"
                            AllowCustomEntry                 = "true">
                        </telerik:RadAutoCompleteBox>
                    </div>
                    <div class = "emailHeaderLabel">
                        <label>Cc:</label>
                    </div>
                    <div class = "emailHeader">
                        <telerik:RadAutoCompleteBox
                            ID                               = "emailCc"
                            runat                            = "server"
                            RenderMode                       = "Lightweight"
                            Width                            = "100%"
                            BackColor                        = "White"
                            ForeColor                        = "Black"
                            BorderColor                      = "#F5F5F5"
                            DataSourceID                     = "UserView"
                            DataTextField                    = "Email"
                            EmptyMessage                     = "Enter valid email address..."
                            TokensSettings-AllowTokenEditing = "true"
                            Localization-RemoveTokenTitle    = "Remove email"
                            AllowCustomEntry                 = "true">
                        </telerik:RadAutoCompleteBox>
                    </div>
                    <div class = "emailHeaderLabel">
                        <label>Bcc:</label>
                    </div>
                    <div class = "emailHeader">
                        <telerik:RadAutoCompleteBox
                            ID                               = "emailBcc"
                            runat                            = "server"
                            RenderMode                       = "Lightweight"
                            Width                            = "100%"
                            BackColor                        = "White"
                            ForeColor                        = "Black"
                            BorderColor                      = "#F5F5F5"
                            DataSourceID                     = "UserView"
                            DataTextField                    = "Email"
                            EmptyMessage                     = "Enter valid email address..."
                            TokensSettings-AllowTokenEditing = "true"
                            Localization-RemoveTokenTitle    = "Remove email"
                            AllowCustomEntry                 = "true">
                        </telerik:RadAutoCompleteBox>
                    </div>
                    <div class = "emailHeaderLabel">
                        <label>Subject:</label>
                    </div>
                    <div class = "emailHeader">
                        <telerik:RadTextBox
                            ID         = "subject"
                            Runat      = "server"
                            RenderMode = "Lightweight"
                            Font-Size  = "10px"
                            Width      = "100%">
                        </telerik:RadTextBox>
                    </div>
                </div>
                <div style="margin-top: 10px; padding: 10px;">
                    <telerik:RadTabStrip
                        ID           = "RadTabStrip1"
                        runat        = "server"
                        RenderMode   = "Lightweight"
                        MultiPageID  = "RadMultiPage1"
                        Width        = "720"
                        Align        = "Left"
                        OnTabClick   = "RadTabStrip1_TabClick"
                        AutoPostBack = "true" >
                        <Tabs>
                            <telerik:RadTab
                                PageViewID = "RadPageView1"
                                Text       = "Documents" />
                            <telerik:RadTab
                                PageViewID = "RadPageView2"
                                Text       = "Message" />
                        </Tabs>
                    </telerik:RadTabStrip>
                    <telerik:RadMultiPage
                        ID         = "RadMultiPage1"
                        runat      = "server"
                        RenderMode = "Lightweight"
                        CssClass   = "RadMultiPage"
                        Width      = "100%">
                        <telerik:RadPageView
                            ID         = "RadPageView1"
                            runat      = "server"
                            RenderMode = "Lightweight"
                            CssClass   = "pageView1"
                            Selected   = "true">
                            <telerik:RadGrid
                                ID               = "RadGrid1"
                                runat            = "server"
                                RenderMode       = "Lightweight"
                                Skin             = "MetroTouch"
                                OnNeedDataSource = "RadGrid1_NeedDataSource1"
                                CssClass         = "RadGrid_ModernBrowsers"
                                AllowPaging      = "True"
                                PageSize         = "5"
                                AllowSorting     = "True">
                                <PagerStyle></PagerStyle>
                                <MasterTableView
                                    AutoGenerateColumns = "true"
                                    Width               = "100%">
                                </MasterTableView>
                            </telerik:RadGrid>
                        </telerik:RadPageView>
                        <telerik:RadPageView
                            ID         = "RadPageView2"
                            runat      = "server"
                            RenderMode = "Lightweight"
                            CssClass   = "pageView2"
                            Selected   = "false">
                            <div id = "dvEditor" class = "demo-container no-bg">
                                <telerik:RadEditor ID="RadEditor1" runat="server" AutoResizeHeight="true" EditModes="Design, HTML, Preview" EnableComments="true" OnClientLoad="TransmittalBuilder.RadEditor1_onClientLoad" RenderMode="Lightweight" ToolbarMode="RibbonBar" ToolsFile="word-like-tools.xml" Width="100%">
                                    <ExportSettings>
                                    </ExportSettings>
                                    <ImageManager DeletePaths="~/Images" UploadPaths="~/Images" ViewPaths="~/Images" />
                                    <Tools>
                                    </Tools>
                                </telerik:RadEditor>
                            </div>
                        </telerik:RadPageView>
                    </telerik:RadMultiPage>
                </div>
                <telerik:RadWindowManager
                    ID    = "RadWindowManager1"
                    runat = "server"
                    Skin  = "Bootstrap">
                    <Windows>
                        <telerik:RadWindow
                            ID               = "rwOpenTransmittalPackage"
                            runat            = "server"
                            RenderMode       = "Lightweight"
                            Modal            = "true"
                            Behaviors        = "Close, Move"
                            Width            = "600px"
                            Height           = "500px"
                            OnClientClose    = "TransmittalBuilder.rwOpenTransmittalPackage_onClientClose"
                            ReloadOnShow     = "true"
                            VisibleStatusbar = "false">
                        </telerik:RadWindow>
                    </Windows>
                </telerik:RadWindowManager>
                <telerik:RadNotification
                    ID                   = "RadNotification1"
                    runat                = "server"
                    RenderMode           = "Lightweight"
                    Width                = "350px"
                    Height               = "150px"
                    Title                = "An error occured"
                    TitleIcon            = "warning"
                    ContentIcon          = "info"
                    Position             = "Center"
                    AutoCloseDelay       = "5000"
                    EnableRoundedCorners = "true"
                    EnableShadow         = "true">
                </telerik:RadNotification>
            </div>
            <script type = "text/javascript">
                window.onload = function ()
                {
                    var reEditor = $find("RadEditor1");
                    if (localStorage.getItem("hasCodeRunBefore") === null)
                    {
                        reEditor.enableEditing(false);
                        reEditor.set_editable(false);
                        reEditor.get_document().body.style.backgroundColor = "gray";
                    }
                };
            </script>
        </form>
    </body>
</html>