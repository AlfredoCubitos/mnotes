import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.2
import QtQuick.Controls.Styles 1.4
import QtQuick.LocalStorage 2.0

import "backend.js" as DB
import "view.js" as View

ColumnLayout {

    spacing: 0
  //  property var stack

    ActionElement{
        id: listHeader
        onBackButtonClicked: {
            if (isNote)
            {
                var Note = stackview.pop();
                DB.initDB()
                //+ Note.noteTxt.text
                //  console.log("noteId: "+ noteID+ " "+noteTitle.text )


                if (noteID == 0) {
                   // console.log("NewTitle: "+noteTitle,"NewNote Text: "+newText.text)

                    var inId = DB.insertData(noteTitle,   newText.text)

                    if (inId > 0)
                        View.addToList(inId, noteTitle)

                } else {
                   // console.log("Title: "+noteTitle)
                    DB.updateData(noteID, noteTitle, Note.noteTxt.text)

                    View.updateList(curIndex, noteTitle)
                }

                isNote = false;
                noteTitel = "New Note";
                console.log("Ende")

            }else{

               // console.log("ELSE")
                isNote = true
                stackview.push({item:newNote, properties:{visible: true}, destroyOnPop: false})
            }
        }
    }


    StackView{
        id: stackview
        initialItem: listview
        implicitWidth: notesApp.width-3
        implicitHeight: notesApp.height - listHeader.height - toolbar.height - btnHeight
        Rectangle{
            id: listview
            anchors.fill: parent
            color: "#eeec52"
            ListView {
                anchors.fill: parent
                model: notesModel
                delegate: liste
            }
        }

        onCurrentItemChanged: {
            stackIndex = stackview.depth
            console.log("idx: "+stackIndex)
        }

    }
    Component.onCompleted: {stack = stackview} //make stackview visible in view.js
}
