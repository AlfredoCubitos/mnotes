import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.2
import QtQuick.Controls.Styles 1.4
import QtQuick.LocalStorage 2.0
import QtQuick.Dialogs 1.2

import "nextnote.js" as NN
import "view.js" as View

ColumnLayout {

    spacing: 0

    property alias notesStack: notesStack



    ActionElement{
        id: noteslistHeader

        property string title: ""
        property int id: 0

        onBackButtonClicked: {
          //   console.log("clicked: "+ isNote)
            if (isNote)
            {
                var Note = notesStack.pop(null);
                if (notesApp.nTitel.length > 0)
                    noteTitle = notesApp.nTitel;

                if (noteID == 0) {
                    NN.newNote(newText.text)

                 if (id > 0)
                      View.addToList(inId, noteTitle)

                } else {
                    console.log("Title: "+noteTitle)
                    NN.updateNote(noteID, category, favorite, Note.noteTxt.text)
                    console.log("Text ",Note.noteTxt.text)

                    View.updateList(curIndex, noteTitle)
                }

                isNote = false;
                noteTitel = "New Note";
              //  console.log("Ende")

            }else{

               // console.log("ELSE")
                isNote = true
                notesStack.push(newNote, {visible: true})
            }
        }

    }


   StackView{
        id: notesStack
        initialItem: listview
         implicitWidth: notesApp.width-3
        width: notesApp.width-3
        implicitHeight: notesApp.height - noteslistHeader.height - toolbar.height - btnHeight

        Item{
            id: listview
            Rectangle{

                anchors.fill: parent
                color: "#eeec52"

                ListView {
                    id: locaListe
                    anchors.fill: parent
                    model: delegateModel
                   // delegate: liste
                    ScrollBar.vertical: ScrollBar {
                        active: notesModel.count > 3 ? true : false
                        parent: parent
                        anchors.top: parent.top
                        anchors.right: parent.right
                    }
                }

            }
        }
        onCurrentItemChanged: {
            stackIndex = notesStack.depth
        }

    }
   /**
    *  make stackview visible in nextnote.js
    *  define property var nextStack in main.qml
    */
    Component.onCompleted: {
        nextStack = notesStack;
        /**
          * make Connection to Notes
          **/

        netWork.clearNetwork();
        netWork.initConnect("OwnCloud");
        netWork.resultAvailable.connect(NN.parseJson);

    }


}
