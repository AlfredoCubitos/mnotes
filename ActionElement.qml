import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import QtQuick.Controls.Styles 1.4
import QtQuick.LocalStorage 2.0

import "backend.js" as DB
import "view.js" as View

RowLayout {

    signal backButtonClicked(string noteTitle )
    signal loginClicked()
    property alias actionlogin: loginButton

    spacing: 0

    Rectangle{
        id: action

        color:"#EBEBB1"
        width: notesApp.width
        implicitWidth: notesApp.width
        height: 35

        Button{
            id: loginButton
            width: 40
            height: 29
            anchors.leftMargin: 5
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            text: "Login"
            visible: false
            onClicked: {
                loginClicked();
            }
        }

        TextInput {
            id: noteTitle
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr(noteTitel)
            readOnly: isNote ? false : true;
        }

        Button{
            width: 30
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            height: 29
            iconSource:  isNote ? "images/icon-back.png" : "images/list-add.png"
            onClicked:{
                backButtonClicked(noteTitle.text)

            }
        }

    }


}
