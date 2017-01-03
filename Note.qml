import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.2
import QtQuick.LocalStorage 2.0

import de.bibuweb.mnotes 1.0

import "backend.js" as DB
import "view.js" as View
import "OneNote.js" as OneNote


Rectangle {

    property int noteId
    property string noteTab

    property string content: ""
    property var curpos: []
    property int countPos: 0
    property alias noteTxt: noteText


    function foundPos()
    {
        if (countPos >  curpos.length-1)
            countPos = 0;

        if (curpos[ countPos])
            noteText.cursorPosition = curpos[ countPos];

        countPos++;
     //   console.log(countPos)

    }


    id: note
    objectName: "noteWindow"
    color: "#FFFF00"
    visible: true
    width: 300
    height: 300

    TextArea {
        width: note.width
        id: noteText
        objectName: "noteText"
         Accessible.name: "mnotesHandler"
         focus: true
        selectByMouse: true
        anchors.fill: parent
        text:  mnotesHandler.text = content
        textFormat: TextEdit.AutoText
        Component.onCompleted: {

            switch(noteTab)
            {
            case "Local":
                DB.initDB();
                DB.getNoteData(noteId);
                break;
            case "OneNote":
                OneNote.getContent(buttonLabel.url)
                break;
            }




          // console.log("Note: ")
            notesApp.winSignal(noteText)

        }

        Keys.onPressed: {
            if (event.key == Qt.Key_F3  )
            {
              //  console.log("F3")
                if (curpos.length > 0)
                    foundPos();
            }
        }
    }


   MNotesHandler{
        id: mnotesHandler
        target: noteText

        onCurposChanged: {
            console.log("curpos:" + curpos)
        }

    }

}
