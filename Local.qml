import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.2
import QtQuick.Controls.Styles 1.4
import QtQuick.LocalStorage 2.0

import "backend.js" as DB
import "view.js" as View

ColumnLayout {

    spacing: 0

    property alias localListview: locaListe
    property alias notesStack: stackview

    ActionElement{
        id: listHeader
        onBackButtonClicked: {
          //  console.log("onButtonClicked.........")
            if (notesApp.isNote)
            {
                var Note = stackview.pop();
                DB.initDB()
                /**
                  * for save on exit
                  * signal connect cannot pass a variable
                **/
                if (notesApp.nTitel.length > 0)
                    noteTitle = notesApp.nTitel;
                  console.log("noteId: "+ noteID+ " ..."+ notesApp.nTitel +" :: "+ noteTitle)


                if (notesApp.noteID === 0) {
                    console.log("NewTitle: "+noteTitle,"NewNote Text: "+newText.text)

                    var inId = DB.insertData(noteTitle,   newText.text)

                    if (inId > 0)
                        View.addToList(inId, noteTitle)

                } else {
                    console.log("Title: "+noteTitle+" "+notesApp.noteID)
                    DB.updateData(notesApp.noteID, noteTitle, Note.noteTxt.text)

                    View.updateList(curIndex, noteTitle)
                }

                notesApp.isNote = false;
               // notesApp.noteTitel = "New Note";
              //   console.log("Ende "+notesApp.isNote)

            }else{

              //  console.log("ELSE")
                notesApp.isNote = true
                stackview.push(newNote, {visible: true})
                newText.text = ""
            }
        }
    }


    StackView{
        id: stackview
        initialItem: listview
        implicitWidth: notesApp.width-3
        implicitHeight: notesApp.height - listHeader.height - toolbar.height - btnHeight
        Item{
            id: listview

            Rectangle{
                id: listItem
                anchors.fill: parent
                color: "#eeec52"

                ListView {
                    id: locaListe
                    anchors.fill: parent
                    model: delegateModel
                    ScrollBar.vertical: ScrollBar {
                        active: delegateModel.items.count > 3 ? true : false
                        parent: parent
                        anchors.top: parent.top
                        anchors.right: parent.right
                    }

                }

            }

        }

        onCurrentItemChanged: {
           // stackIndex = stackview.depth
            stackIndex = notesStack.depth
            //console.log("idx: "+stackIndex)
        }

    }
    Component.onCompleted: {
        stack = stackview   //make stackview visible in view.js

    }


}
