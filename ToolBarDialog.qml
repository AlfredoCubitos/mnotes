import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.0
import QtQuick.Window 2.2

Window {
    id: configDlg
    title: "Config Dialog"
    width: 300
    height: 250

    flags: Qt.Dialog
    modality: Qt.WindowModal

    onActiveChanged:{
            if (tbmenu.title == "OneNote")
                dlgUrl.text = "https://"
    }


    GridLayout {
        columns: 2
        rowSpacing: 5
        columnSpacing: 5
        anchors.leftMargin: 10
        anchors.rightMargin: 10

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
            text: qsTr("URL")
        }
        TextField{
            id: dlgUrl
            Layout.fillWidth: true
        }

        Label {
            text: qsTr("Login")
        }
        TextField{
            id: dlgLogin
            Layout.fillWidth: true
        }

        Label {
            text: qsTr("Password")
        }
        TextField{
            id: dlgPassword
            Layout.fillWidth: true
        }

        Label{
            text: qsTr("visible")
        }
        CheckBox{
            id: dlgVisible
        }

        Item {
            id: cancel
            implicitHeight: cancelBtn.height
            implicitWidth: cancelBtn.width

            Button {
                id: cancelBtn
                text: qsTr("cancel")
                onClicked: configDlg.close()

            }
        }
        Item {
            id: ok
            implicitHeight: okBtn.height
            Layout.fillWidth: true

            Button {
                id: okBtn
                anchors.right: parent.right
                anchors.rightMargin:  10
                text: qsTr("save")
                onClicked: {
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

        }
    }

}


