import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.2
import QtQuick.LocalStorage 2.0

import de.bibuweb.mnotes 1.0

import "backend.js" as DB
import "view.js" as View

ApplicationWindow {

    property int noteId
    property string content: ""
    property var curpos: []
    property int countPos: 0

    function foundPos()
    {
        if (countPos > curpos.length-1)
            countPos = 0;

        noteText.cursorPosition = curpos[ countPos]

        countPos++;

    }

    id: note
    objectName: "noteWindow"
    color: "#FFFF00"
    visible: true
    width: 300
    height: 300
    toolBar: ToolBar {
        height: 30
        width: parent.width
        RowLayout {
            anchors.fill: parent
            Rectangle {
                id: titelinput
                anchors.fill: parent
                radius: 4
                color: "#EEE"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        titelinput.border.color = "#FFDCA8"
                        titelinput.color = "#FFF"
                    }
                }

                TextInput {
                    id: noteTitel
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    text: titel
                }
            }
        }
    }
    onClosing: {

        DB.initDB()

        if (noteId == 0) {
            var inId = DB.insertData(noteTitel.text, noteText.text)

            if (inId > 0)
                View.addToList(inId, noteTitel.text)
        } else {
            DB.updateData(noteId, noteTitel.text, noteText.text)
            View.updateList(container.curIdx, noteTitel.text)
        }
    }

    TextArea {
        id: noteText
        objectName: "noteText"
         Accessible.name: "mnotesHandler"
         focus: true
        backgroundVisible: false
        selectByMouse: true
        anchors.fill: parent
        text:  mnotesHandler.text = content
       // textFormat: TextEdit.RichText
        Component.onCompleted: {
            DB.initDB()
            DB.getNoteData(noteId)

            //console.log("contentHeight: " + noteText.text.length + ":: "+ noteText.lineCount)

            if (noteTitel.text.length < 1)
                noteTitel.text = "New Note"

            if (noteText.text.length > 0)
                note.height = noteText.contentHeight + 30

            notesApp.winSignal(noteText)


        }
        Keys.onPressed: {
            if (event.key == Qt.Key_F3  )
            {
                if (curpos.length > 0)
                    foundPos();
            }

            if (( event.key === Qt.Key_F)  && (event.modifiers & Qt.ControlModifier) )
            {
                statusbar.visible = true;
                noteText.focus = false;
                statusbar.focus = true;

            }

        }

    }

    statusBar: StatusBar {
        id: statusbar
        visible: false
        height: 30
            Row {
                anchors.fill: parent
                spacing: 5

                    Label {
                        text: "Search:"
                    }


                    TextField{
                        id: searchBox
                        property var svalues: []
                        width: 150
                        onEditingFinished:  {

                            notesApp.sbSignal(searchBox.text)
                            noteText.focus = true;
                        }
                    }

            }

            Keys.onPressed: {
                if (event.key == Qt.Key_F3  )
                {
                    if (curpos.length > 0)
                        foundPos();
                }

            }

        }

   MNotesHandler{
        id: mnotesHandler
        target: noteText

        onCurposChanged: {
           // console.log("curpos:" + curpos)
        }

    }

}
