import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.2
import QtQuick.LocalStorage 2.0

import de.bibuweb.mnotes 1.0

import "backend.js" as DB
import "view.js" as View
import "nextnote.js" as NN


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
        console.log("curpos: "+curpos.length)

    }



    id: note
    objectName: "noteWindow"
    color: "#FFFF00"
    visible: true
    focus: true
    /**
    * Using anchors on the items added to a StackView is not supported.
    * Error message: "QML Note: StackView has detected conflicting anchors."
    **/
   // anchors.fill: parent
    Flickable{
        id: flickTxt
       // anchors.fill: parent
        height: parent.height
        width: parent.width
        TextArea.flickable:  TextArea {      
            id: noteText

            width: note.width
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
                case notesApp.cloudTitle:
                    netWork.resultAvailable.connect(NN.parseJson)
                    NN.getNote(noteId);
                    break;
                }

                 //console.log("Note: "+noteTxt.text)
                notesApp.winSignal(noteText)


            }

            Keys.onPressed: {
                if (event.key === Qt.Key_F3  )
                {
                     console.log("F3 " + noteText.cursorPosition)
                   // noteText.cursorPosition = 1
                    if (curpos.length > 0)
                        foundPos();
                }

             //   if (( event.key === Qt.Key_F)  && (event.modifiers & Qt.ControlModifier) && (stackIndex  > 1))
                if (( event.key === Qt.Key_F)  && (event.modifiers & Qt.ControlModifier))
                {
                    console.log("StackStatus: " + stackIndex)
                    statusbar.visible = statusbar.visible ? false: true;
                    searchBox.focus = true;
                    notesApp.sbActiveSignal(searchBox)
                    /**
                     * put the window to right height, because not to hide the text with the statusbar
                     * note: this works only setting Flickable width and height manualy. This does not work with anchor.fill: parent
                     **/
                    notesApp.height = notesApp.height + statusbar.height + 30
                    noteText.height = noteText.height + statusbar.height
                    flickTxt.height = flickTxt.height + statusbar.height

                }

                notesApp.edited = true;

            }



        }
        ScrollBar.vertical: ScrollBar { }




    }

    MNotesHandler{
        id: mnotesHandler
        target: noteTxt

        onCurposChanged: {
            console.log("curpos:" + curpos)
        }

    }


}
