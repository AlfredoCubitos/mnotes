import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.2
import QtQuick.LocalStorage 2.0
import "backend.js" as DB
import "view.js" as View

ApplicationWindow {

    property int noteId
    property string content: ""

    id: note
    color: "#FFFF00"
    visible: true
    width: 300
    height: 300
    toolBar: ToolBar {
        height: 30
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
        backgroundVisible: false
        selectByMouse: true
        anchors.fill: parent
        text: content
        Component.onCompleted: {
            DB.initDB()
            DB.getNoteData(noteId)

            console.log("contentHeight: " + noteText.text.length)

            if (noteTitel.text.length < 1)
                noteTitel.text = "New Note"

            if (noteText.text.length > 0)
                note.height = noteText.contentHeight + 30
        }
    }
}
