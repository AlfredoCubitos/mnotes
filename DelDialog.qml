import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.LocalStorage 2.0

import "backend.js" as DB
Dialog {
     id: delDialog
     modal: true
     title: "MNotes Delete Dialog"
     implicitWidth: notesApp.width - 10

     contentItem:
         Text{
            height: 30
            horizontalAlignment: Text.AlignHCenter
             text: "realy delete this note?"

             anchors.verticalCenter: parent.verticalCenter

         }

     standardButtons: Dialog.Ok | Dialog.Abort
     onAccepted: {
        // console.log("del id: " +notesApp.noteID)
        // console.log("del index: " + curIndex)
         DB.deleteNote(noteID);
         notesModel.remove(curIndex)

     }
 }
