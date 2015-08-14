import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.LocalStorage 2.0

import "backend.js" as DB
import "view.js" as View

ApplicationWindow  {
    id: notesApp
    width: 300
   height: 300
   visible: true

 // property var db


  ListModel{
      id: notesModel

  }

 Component{
     id: listHeader
     Rectangle{
         color:"#d7d7cd"
         width: ListView.view.width
         height: 25

         Image{
             anchors.right: parent.right
            // anchors.rightMargin: 10
            // anchors.topMargin: 10
             anchors.margins: 10
             source: "images/list-add.png"

             MouseArea{
                 anchors.fill: parent
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

}
