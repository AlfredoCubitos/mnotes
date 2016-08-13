import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.LocalStorage 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.4

import "backend.js" as DB
import "view.js" as View

/*
* Ownnotes Datamodel
* id: integer
* modified: time in s since
* titel: String
* content: String
*
*/

/**
  MNotes Microsoft APPID: 0006d636-2cd2-47fd-b506-5239c842a064
  **/

ApplicationWindow  {
    id: notesApp
    width: 300
   //height: 300
   minimumHeight: 300
   visible: true


    signal sbSignal(string txt)
    signal winSignal(var win)
    signal sbActiveSignal(var obj)
    signal dialogOkSignal(var values)
    signal dialogSetGroups()

   property var dialogGroups: "Moin"

   property bool isPortrait: Screen.primaryOrientation === Qt.PortraitOrientation

   property bool isNote: false
   property string noteTitel: "New Note"
   property int curIndex
   property int noteID
   property int btnHeight: 38 // = Elements.container.height
   property int stackIndex

   property var curpos: []
   property int countPos: 0




   Action{
       id: callSync
       onTriggered:  View.menuItemAction(source.text)
   }

   ListModel{
       id: notesModel

   }
/**
  * Menubar for future use
  **/

   toolBar: ToolBar{
       id: toolbar
       height: 29
       RowLayout{
           anchors.fill: parent
           Item { Layout.fillWidth: true }
           ToolButton {
               implicitHeight: 22
               implicitWidth: 22
               iconSource: "images/menu.png"
               //onClicked: configDlg.open()
              onClicked:tbmenu.visible ? tbmenu.visible=false : tbmenu.visible= true

           }

       }
   }

   TabView{
       id: tabView

       Tab{
           id: localTab
         title: qsTr("Local")

           ColumnLayout {
               spacing: 0

               Rectangle{
                   id: listHeader

                   color:"#EBEBB1"
                   width: notesApp.width
                   implicitWidth: notesApp.width
                   height: 35
                   TextInput {
                       id: noteTitle
                       anchors.horizontalCenter: parent.horizontalCenter
                       anchors.verticalCenter: parent.verticalCenter
                       text: qsTr(noteTitel)
                       readOnly: isNote ? false : true;
                   }

                   Button{
                       width: 30
                       anchors.right: parent.right
                       anchors.rightMargin: 20
                       anchors.verticalCenter: parent.verticalCenter
                       height: 29
                       iconSource:  isNote ? "images/icon-back.png" : "images/list-add.png"
                       onClicked:{
                           if (isNote)
                           {
                                var Note = stackview.pop();
                               DB.initDB()
                               //+ Note.noteTxt.text
                               console.log("noteId: "+ noteID+ " "+noteTitle.text )


                               if (noteID == 0) {
                                   var inId = DB.insertData(noteTitle.text,   newText.text)
                                   //console.log("NewNote Text: "+newText.text)

                                   if (inId > 0)
                                      View.addToList(inId, noteTitle.text)
                               } else {
                                   DB.updateData(noteID, noteTitle.text, Note.noteTxt.text)

                                    View.updateList(curIndex, noteTitle.text)
                               }

                               isNote = false;
                              noteTitel = "New Note";

                           }else{
                              // View.showNote(0);
                               isNote = true
                               stackview.push({item:newNote, properties:{visible: true}, destroyOnPop: true})
                           }
                       }
                   }

               }

              StackView{
                   id: stackview
                   initialItem: scrollview
                    implicitWidth: notesApp.width-3
                   width: notesApp.width-3
                   implicitHeight: notesApp.height - listHeader.height - toolbar.height - btnHeight

                   ScrollView{
                       id: scrollview
                       implicitHeight: notesApp.height - listHeader.height - toolbar.height
                       style: ScrollViewStyle{
                           frame: Rectangle{
                               color: "#eeec52"
                               border.color: "#141312"
                           }

                           scrollBarBackground : Item  {
                               implicitWidth: 14
                               implicitHeight: 26
                           }
                       }

                       ListView {
                           id: listview
                           model: notesModel
                           delegate: Elements {}

                       }
                       // Stack.onStatusChanged:  console.log("Stackstatus: "+Stack.status )
                   }

                   onCurrentItemChanged: {
                       stackIndex = stackview.depth
                   }
               }
           }
       }
       Tab{
           id: owncloud
           title: qsTr("Owncloud")
       }
   }
    Item {

        Component.onCompleted:{

              DB.initDB();
              DB.getTitels();

            console.log("Group:" +dialogGroups )
          }

    }


    ToolBarMenu{
        id: tbmenu
        height: 32
        anchors.right: parent.right
        visible: false
        onClicked: {
            configDlg.show()
           tbmenu.visible = false
        }
    }

    ToolBarDialog{
        id: configDlg
    }

        Rectangle {

            id: newNote
            objectName: "noteWindow"
            color: "#FFFF00"
            visible: false
            width: 300
            height: 300

            TextArea {
                width: parent.width
                id: newText
                objectName: "noteText"
                 Accessible.name: "mnotesHandler"
                 focus: true
                backgroundVisible: false
                selectByMouse: true
                anchors.fill: parent
                text:  ""
               // textFormat: TextEdit.RichText

            }
            Component.onCompleted: {
                noteID = 0;

            }
            Keys.onPressed: {

                if (( event.key === Qt.Key_F)  && (event.modifiers & Qt.ControlModifier) && (stackIndex  > 1))
                {
                    console.log("StackStatus: " + stackIndex)
                    statusbar.visible = true;
                    searchBox.focus = true;
                    notesApp.sbActiveSignal(searchBox)

                }

            }

        }
        statusBar: StatusBar {
            id: statusbar
            objectName: "statusBar"
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
                            objectName: "searchbox"
                            property var svalues: []
                            width: 180
                            height: 18
                            focus: true
                            onEditingFinished:  {

                                notesApp.sbSignal(searchBox.text)

                                //noteText.focus = true;
                            }


                        }


                }

             /*   Keys.onPressed: {
                    if (event.key === Qt.Key_F3  )
                    {


                        console.log("F3 2 ")


                        if ( curpos.length > 0)
                            foundPos();
                    }

                }*/


            }

}
