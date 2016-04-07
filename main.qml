import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.LocalStorage 2.0
import QtQuick.Layouts 1.2

import "backend.js" as DB
import "view.js" as View


ApplicationWindow  {
    id: notesApp
    width: 300
   //height: 300
   minimumHeight: 300
   visible: true


    signal sbSignal(string txt)
    signal winSignal(var win)
    signal sbActiveSignal(var obj)
    signal dialogOkSignal(var values)
    signal dialogSetGroups()

   property var dialogGroups: "Moin"


   /**
     * functions call from C++ has to be defined here
     * call it from import doesn't work
     **/
   function addMenuItem(items)
   {
       for (var i=0;i<items.length;i++)
       {

            var itm = configMenu.addItem(items[i])
           itm.action = callSync

       }

     //  console.log("addMenuitem: " + items[0])
   }

   Action{
       id: callSync
       onTriggered:  View.menuItemAction(source.text)
   }
/**
  * Menubar for future use
  **/
  /* menuBar: MenuBar {
          Menu {
              id: configMenu
              title: "Config"
              MenuItem {
                  text: "New"
                  onTriggered: {
                      configDlg.open()
                  }
              }

          }

       }
*/

  ListModel{
      id: notesModel

  }


     Rectangle{
         id: listHeader
         color:"#C3C3C3"
         width: notesApp.width
         height: 29

         Button{
             width: notesApp.width
             height: 29
             text: qsTr("New Note")
        //     iconSource: "images/list-add.png"
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
    id: scrollview
    implicitHeight:  notesApp.minimumHeight
    height: notesApp.height
    width: notesApp.width
    anchors.top: listHeader.bottom
    anchors.topMargin: 0
    ListView {
        id: listview
      //   anchors.fill: parent
      //  header: listHeader
        model: notesModel
         delegate: Elements {}

    }
}

    Item {

        Component.onCompleted:{

              DB.initDB();
              DB.getTitels();
            scrollview.height = listview.height+5
            listview.width = scrollview.viewport.width
            console.log("Group:" +dialogGroups )
          }

    }

Dialog {
    id: configDlg

    title: "Config Dialog"
    GridLayout {
            columns: 2
            Label {
                text: "Name"
            }
            TextField{
                id: dlgGroupName
                width: 180
            }

            Label {
                text: "URL"
            }
            TextField{
                id: dlgUrl
                width: 180
            }

            Label {
                text: "Login"
            }
            TextField{
                id: dlgLogin
                width: 180
            }

            Label {
                text: "Password"
            }
            TextField{
                id: dlgPassword
                width: 180
            }
     }
    onAccepted: {
        var config = {}
        config["group"] = dlgGroupName.text
        config["url"] = dlgUrl.text
        config["login"] = dlgLogin.text
        config["password"] = dlgPassword.text

        dialogOkSignal(config)
    }



}

}
