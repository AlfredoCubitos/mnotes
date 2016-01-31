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
   height: 300
   visible: true


    signal sbSignal(string txt)
    signal winSignal(var win)
    signal sbActiveSignal(var obj)

  /*
   menuBar: MenuBar {
          Menu {
              title: "Config"
              MenuItem {
                  text: "OwnCloud"
                  onTriggered: ownclodDlg.open()
              }
          }

       }
*/
  ListModel{
      id: notesModel

  }

 Component{
     id: listHeader
     Rectangle{
         color:"#d7d7cd"
         width: ListView.view.width
         height: 32

         Image{
             anchors.right: parent.right

            anchors.margins: 10
             source: "images/list-add.png"

             MouseArea{
                 anchors.right: parent.right
                 width: 30
                 height: 25
                 onClicked:{ View.openNote(0) }
             }
         }


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


    ListView {
         anchors.fill: parent
        header: listHeader
        model: notesModel
         delegate: Elements {}

    }

    Item {

        Component.onCompleted:{
              DB.initDB();
              DB.getTitels();
          }

    }

Dialog {
    id: ownclodDlg
    title: "OwnCloud Access Dialog"
    GridLayout {
            columns: 2
            Label {
                text: "URL"
            }
            TextField{
                width: 180
            }

            Label {
                text: "Login"
            }
            TextField{
                width: 180
            }

            Label {
                text: "Password"
            }
            TextField{
                width: 180
            }
     }

}

}
