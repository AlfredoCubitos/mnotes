import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.LocalStorage 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.4

import "backend.js" as DB
import "view.js" as View


ApplicationWindow  {
    id: notesApp
    width: 300
   height: 300
 //  minimumHeight: 300
   visible: true


    signal sbSignal(string txt)
    signal winSignal(var win)
    signal sbActiveSignal(var obj)
    signal dialogOkSignal(var values)
    signal dialogSetGroups()

   property var dialogGroups: "Moin"

   property bool isPortrait: Screen.primaryOrientation === Qt.PortraitOrientation



   Action{
       id: callSync
       onTriggered:  View.menuItemAction(source.text)
   }

   ListModel{
       id: notesModel

   }
/**
  * Menubar for future use
  **/

   toolBar: ToolBar{
       id: toolbar
       height: 29
       RowLayout{
           anchors.fill: parent
           Item { Layout.fillWidth: true }
           ToolButton {
               implicitHeight: 22
               implicitWidth: 22
               iconSource: "images/menu.png"
               //onClicked: configDlg.open()
              onClicked:tbmenu.visible ? tbmenu.visible=false : tbmenu.visible= true

           }

       }
   }


ColumnLayout {
    spacing: 0

     Rectangle{
         id: listHeader
         color:"#EBEBB1"
         width: notesApp.width
         implicitWidth: notesApp.width
         height: 35
         Text {
             id: lh
             anchors.horizontalCenter: parent.horizontalCenter
             anchors.verticalCenter: parent.verticalCenter
             text: qsTr("New Note")
         }

         Button{
             width: 30
             anchors.right: parent.right
             anchors.rightMargin: 12
             anchors.verticalCenter: parent.verticalCenter
             height: 29
             iconSource: "images/list-add.png"
             onClicked:{ View.openNote(0) }
         }

     }


/*
 * Ownnotes Datamodel
 * id: integer
 * modified: time in s since
 * titel: String
 * content: String
 *
 */

     ScrollView{
         implicitWidth: notesApp.width
         implicitHeight: notesApp.height - listHeader.height - toolbar.height
         style: ScrollViewStyle{
            frame: Rectangle{
                 color: "#eeec52"
                 border.color: "#141312"
                // opacity: 0.7
             }

             scrollBarBackground : Item  {
                 implicitWidth: 14
                 implicitHeight: 26
             }
         }

         ListView {
             id: listview
             model: notesModel
             delegate: Elements {}

         }
     }
}
    Item {

        Component.onCompleted:{

              DB.initDB();
              DB.getTitels();

            console.log("Group:" +dialogGroups )
          }

    }

    ToolBarMenu{
        id: tbmenu
        height: 32
        anchors.right: parent.right
        visible: false
        onClicked: {
            configDlg.show()
           tbmenu.visible = false
        }
    }

    ToolBarDialog{
        id: configDlg
    }


}
