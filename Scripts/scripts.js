(function (global, undefined)
{
    var EditorCommandList;
    var transmittalPackageID;
    var transmittalPackageName;
    var transmittalPackageDescription;

    var registerCustomCommands = function ()
    {
        EditorCommandList["LastName"]       =
        EditorCommandList["FirstName"]      =
        EditorCommandList["DocumentName"]   =
        EditorCommandList["DocumentAuthor"] = function (commandName, editor, args)
        {
            var smartTag = "<a href='{%SmartTag%}' title='{SmartTag: " + commandName + "}'>SmartTag</a>";
            editor.pasteHtml(smartTag);
        };
    };

    global.TransmittalBuilder =
    {
        RadEditor1_onClientLoad: function (editor, args)
        {
            var dvEditorWidth  = document.getElementById('dvEditor').clientWidth;
            var dvEditorHeight = document.getElementById('dvEditor').clientHeight;

            EditorCommandList = Telerik.Web.UI.Editor.CommandList;
            registerCustomCommands();
            editor.setSize(dvEditorWidth, dvEditorHeight);
        },
        RadToolbar1_onClientButtonClicked: function (sender, args)
        {
            var buttonClicked = args.get_item().get_value();

            switch (buttonClicked)
		    {
			    case "new":
				    function promptCallBackFn(arg)
				    {
                        var toolbarbutton        = sender.findItemByText("TransmittalPackageButton");
                        var tbTransmittalPackage = toolbarbutton.findControl("tbTransmittalPackage");
                        var toolBar              = $find("RadToolBar1");
                        var btnSave              = toolBar.findItemByText("Save");
                        var btnTest              = toolBar.findItemByText("Test");
                        var reEditor             = $find("RadEditor1");

                        if (arg !== null)
                        {
                            reEditor.enableEditing(true);
                            reEditor.set_editable(true);
                            reEditor.get_document().body.style.backgroundColor = "";
                            reEditor.set_html("");
                            transmittalPackageID   = TransmittalBuilder.createGuid();
                            transmittalPackageName = arg;
                            tbTransmittalPackage.set_value(transmittalPackageName);
                            btnSave.enable();
                            btnTest.enable();
					    }
				    }
				    radprompt("Transmittal Package Name", promptCallBackFn, 450, 230, null, "New Transmittal Package");
				    break;
                case "open":
                    TransmittalBuilder.openTransmittalPackage();
				    break;
                case "save":
                    TransmittalBuilder.saveTransmittalPackage();
                    break;
                case "test":
                    TransmittalBuilder.sendTestEmail();
                    break;
		    }
        },
        openTransmittalPackage: function ()
        {
            var dialogName = "OpenTransmittalPackage.aspx";
            var oWnd       = $find("rwOpenTransmittalPackage");

            oWnd.setUrl('Dialogs/' + dialogName);
            oWnd.show();
            oWnd.SetSize(600, 500);
            oWnd.SetTitle("sxCLOUD Transmittal Builder");
            oWnd.SetModal(true);
            oWnd.Center();
        },
        rwOpenTransmittalPackage_onClientClose: function (sender, args)
        {
            var ajaxMgr;
            var ajaxCmdStr;
            var btnSave  = $find("RadToolBar1").findItemByText("Save");
            var btnTest  = $find("RadToolBar1").findItemByText("Test");
            var reEditor = $find("RadEditor1");

            if (args.get_argument() != null)
            {
                btnSave.enable();
                btnTest.enable();
                reEditor.enableEditing(true);
                reEditor.set_editable(true);
                reEditor.get_document().body.style.backgroundColor = "";
                transmittalPackageID = args.get_argument();
                transmittalPackageID = transmittalPackageID.replace(/['"]+/g, '');
                ajaxMgr              = $find("RadAjaxManager1");
                ajaxCmdStr = "Open" + "|" + transmittalPackageID;
                ajaxMgr.ajaxRequest(ajaxCmdStr);
            }
        },
        updateTransmittalPackageTextbox: function (arg)
        {
            var toolbarbutton        = $find("RadToolBar1").findItemByText("TransmittalPackageButton");
            var tbTransmittalPackage = toolbarbutton.findControl("tbTransmittalPackagee");

            tbTransmittalPackage.set_value(arg);
        },
        saveTransmittalPackage: function ()
        {
            var ajaxMgr;
            var ajaxCmdStr;
            var btnSave                       = $find("RadToolBar1").findItemByText("Save");
            var btnTest                       = $find("RadToolBar1").findItemByText("Test");
            var toolbarbutton                 = $find("RadToolBar1").findItemByText("TransmittalPackageButton");
            var tbTransmittalPackage          = toolbarbutton.findControl("tbTransmittalPackagee");
            var transmittalPackageName        = tbTransmittalPackage.get_value();
            var transmittalPackageDescription = "";

            //btnSave.disable();
            //btnTest.disable();
            //tbTransmittalPackage.set_value("");
            ajaxMgr    = $find("RadAjaxManager1");
            ajaxCmdStr = "Save" + "|" + transmittalPackageID + "|" + transmittalPackageeName + "|" + transmittalPackageDescription;
            ajaxMgr.ajaxRequest(ajaxCmdStr);
        },
        sendTestEmail: function ()
        {
            var ajaxMgr;
            var ajaxCmdStr;

            ajaxMgr = $find("RadAjaxManager1");
            ajaxCmdStr = "Mail";
            ajaxMgr.ajaxRequest(ajaxCmdStr);
        },
        createGuid: function ()
        {
            var sGuid;

            sGuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c)
            {
                var r = Math.random() * 16 | 0, v = c === 'x' ? r : (r & 0x3 | 0x8);
                return v.toString(16);
            });

            return sGuid;
        }
    };
})(window);