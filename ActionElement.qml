import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.2
import QtQuick.Controls.Styles 1.4
import QtQuick.LocalStorage 2.0

import "backend.js" as DB
import "view.js" as View
import "nextnote.js" as NN

RowLayout {

    signal backButtonClicked(string noteTitle )

    property alias actionback: backBtn
    property string noteTt: noteTitle.text
    property bool isNote: notesApp.isNote


    spacing: 0

    Rectangle{
        id: action

        color:"#EBEBB1"
        width: notesApp.width
     //   implicitWidth: notesApp.width
        implicitHeight: 48

        Button{
            id: loginButton
            implicitWidth: 60
            implicitHeight:  29
            anchors.leftMargin: 5
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            text: "Login"
            visible: false
            onClicked: {
                loginClicked();
            }
        }

        TextField {
            id: noteTitle
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: noteTitel
            font.pixelSize: 16
            width: implicitWidth + 14
            height: 44

            readOnly: isNote ? false : true;
            background: Rectangle{
                implicitHeight:40
                color: isNote ? "#dfdfa8" : action.color
                border.color: isNote ? "#dfdfa8" : "transparent"

            }
        }

        Button{
            id: backBtn
            width: 44
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            height: 44
            background: Image {
                id: btimage
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                fillMode: Image.PreserveAspectFit
                source: isNote ? "images/go-previous.png" : "images/list.png"
            }

            onClicked:{
                backButtonClicked(noteTitle.text)
                isNote ? null : statusbar.visible = false

            }
        }

    }

}
