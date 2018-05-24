import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.2

Dialog {
    id: configDlg
    title: "Config Dialog"
    implicitWidth: parent.width
    modal: true

    standardButtons: Dialog.Ok | Dialog.Cancel

    GridLayout {
        columns: 2
        rowSpacing: 5
        columnSpacing: 0

        anchors.fill: parent

        Item {
            id: headline
            Layout.columnSpan: 2
            Layout.fillWidth: true
            implicitHeight: headText.height
            width: parent.width

            Text {
                id: headText
                height: 20
                text: tbmenu.title

                horizontalAlignment: Text.AlignHCenter
                anchors.fill: parent
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }
        }

        Label {
            text: qsTr("URL: ")
        }
        TextField{
            id: dlgUrl
            Layout.fillWidth: true
        }

        Label {
            text: qsTr("Login: ")
        }
        TextField{
            id: dlgLogin
            Layout.fillWidth: true
        }

        Label {
            text: qsTr("Password: ")
        }
        TextField{
            id: dlgPassword
            Layout.fillWidth: true
            echoMode: TextInput.Password
            passwordCharacter: "*"
            passwordMaskDelay: 500
        }

        Label{
            text: qsTr("visible")
        }
        CheckBox{
            id: dlgVisible
            checked: true
        }
    }

    onOpened: {

        console.log("Dlg: "+tbmenu.title)
        var data;


        switch(tbmenu.title)
        {
            case "OwnCloud":
                data = configData.readConfig("OwnCloud");
               // console.log("Dlg: " +data)
                dlgUrl.text = data["url"];
                dlgLogin.text = data["login"];
                dlgPassword.text = data["password"];
                dlgVisible.checked = data["visible"];
                break;
            default:
                dlgUrl.text = "";
                dlgLogin.text = "";
                dlgPassword.text = "";
                dlgVisible.checked = false;
                break;

        }


    }

    onAccepted: {
        var config = {}
        config["group"] = tbmenu.title
        config["url"] = dlgUrl.text
        config["login"] = dlgLogin.text
        config["password"] = dlgPassword.text
        config["visible"] = dlgVisible.checked

        dialogOkSignal(config)

        configDlg.close()
    }

}


