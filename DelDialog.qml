import QtQuick 2.0
import QtQuick.Dialogs 1.2
import QtQuick.LocalStorage 2.0

import "view.js" as View
import "backend.js" as DB
Dialog {
     id: delDialog
     title: "MNotes Delete Dialog"

     standardButtons: StandardButton.Ok | StandardButton.Abort
      Rectangle{
         implicitHeight: 30
         Text{
             text: "realy delete this note?"

             anchors.verticalCenter: parent.verticalCenter

         }
     }
     onAccepted: {
        DB.deleteNote(btnLabel);
        View.removeFromList(curIdx);
     }
 }
