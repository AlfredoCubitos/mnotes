import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.2
import QtQuick.Controls.Styles 1.4
import QtQuick.LocalStorage 2.0

import "nextnote.js" as NN

ColumnLayout {

    spacing: 0

    property alias notesStack: notesStack


    ActionElement{
        id: listHeader
        onBackButtonClicked: {
        /** put code for handling data here **/
        }
    }

   StackView{
        id: notesStack
        initialItem: listview
         implicitWidth: notesApp.width-3
        width: notesApp.width-3
        implicitHeight: notesApp.height - listHeader.height - toolbar.height - btnHeight

        Item{
            id: listview
            Rectangle{

                anchors.fill: parent
                color: "#eeec52"

                ListView {
                    id: locaListe
                    anchors.fill: parent
                    model: notesModel
                    delegate: liste
                    ScrollBar.vertical: ScrollBar {
                        active: notesModel.count > 3 ? true : false
                        parent: parent
                        anchors.top: parent.top
                        anchors.right: parent.right
                    }
                }

            }
        }
        onCurrentItemChanged: {
            stackIndex = notesStack.depth
        }

    }
   /**
    *  make stackview visible in nextnote.js
    *  define property var nextStack in main.qml
    */
    Component.onCompleted: {nextStack = notesStack}
}
