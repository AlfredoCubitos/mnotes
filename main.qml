import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.LocalStorage 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.2

import "backend.js" as DB
import "nextnote.js" as NN
import "view.js" as View
import "OneNote.js" as One
import org.kde.plasma.components 3.0 as PlasmaComponents
/*
* Ownnotes Datamodel
* id: integer
* modified: time in s since
* titel: String
* content: String
*
*/



ApplicationWindow  {
    id: notesApp
    minimumWidth: 300
    minimumHeight: 400
    visible: true
    background: Rectangle {
        color: "#eeeeee"
    }

    signal sbSignal(string txt)
    signal winSignal(var win)
    signal sbActiveSignal(var obj)
    signal dialogOkSignal(var values)
    signal dialogSetGroups()

 //   property string dialogGroups: "Moin"

    property bool isPortrait: Screen.primaryOrientation === Qt.PortraitOrientation

    property bool isNote: false
    property string noteTitel: "New Note"
    property string nTitel: ""  // for saving titles when switching tabs
    property string nextTitel: "" // for saving titles
    property int curIndex
    property int noteID
    property string category:  "" // Category used by notes in Nextcloud
    property bool favorite: false // used by notes in Nextcloud
    property int btnHeight: 38 // = Elements.container.height
    property int stackIndex

    property string token   //for oneNote Access Token

    property var stack
    property var oneNoteStack
    property var nextStack

    property var curpos: []
    property int countPos: 0
    property alias delDialog: delDialog

    property string request // request property for nextNote


    ListModel{
        id: notesModel

    }
    /**
  * Menubar
  **/

    header: ToolBar{
        id: toolbar
        implicitHeight: 29
        RowLayout{
            anchors.fill: parent
            Item { Layout.fillWidth: true }
            ToolButton {
                implicitHeight: 22
                implicitWidth: 22
                background: Image {
                    source: "images/menu.png"
                }

                //onClicked: configDlg.open()
                onClicked:tbmenu.visible ? tbmenu.visible=false : tbmenu.visible= true

            }

        }
    }


    ColumnLayout{
        TabBar{
            id: tabView
            width: parent.width
            background: Rectangle {
                    color: "#eeeeee"

            }
            TabButton{
                id: tabButton
                text: qsTr("Local")
                width: 80
                height: 40
                background: Rectangle{
                    opacity: parent.checked ? 1.0 : 0.3
                    color: parent.checked ? "#eeeeee" : "#999797"
                   // border.width: 1
                  //  radius: 4
                  //  border.color: "#a09f9f"
                }
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    opacity: parent.checked ? 1.0 : 0.3
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
            }
            TabButton{
                id: nextNotes
                width: 80
                text: qsTr("Notes")
                height: 40
                background: Rectangle{
                    opacity: parent.checked ? 1.0 : 0.3
                    color: parent.checked ? "#eeeeee" : "#999797"
                   // border.width: 1
                   // radius: 4
                   // border.color: "#999f9f"
                }
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    opacity: parent.checked ? 1.0 : 0.3
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

            }
            TabButton{
                width: 80
                text: qsTr("OneNote")
                height: 40
                background: Rectangle{
                    opacity: parent.checked ? 1.0 : 0.3
                    color: parent.checked ? "#eeeeee" : "#999797"
                   // border.width: 1
                   // radius: 4
                   // border.color: "#999f9f"
                }
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    opacity: parent.checked ? 1.0 : 0.3
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

            }




            onCurrentIndexChanged:
            {
                console.log("Tab changed:" )

                nextTitel = noteTitel;
                if (nTitel.length == 0)
                    noteTitel = "New Note"
                else
                    noteTitel = nTitel

                nTitel = nextTitel;

                notesModel.clear();


                switch(tabView.currentItem.text){

                case "Local":
                    DB.getTitels();
                    break;
                case "OneNote":
                    /*open sign in for MS here*/
                    if (notesApp.token)
                        One.getPages(notesApp.token)
                    console.log("Index OneNote")

                    break;
                case "Notes":

                  // netWork.resultAvailable.connect(NN.parseJson)
                    console.log("Index Notes " )
                    NN.getList();

                    break;
                }
            }

        }
        StackLayout {
            width: parent.width
            currentIndex: tabView.currentIndex

            Item {
                id: localTab
                anchors.fill: parent
                width: implicitWidth
                property alias listview: tabloader.liste
                Loader{
                    id: tabloader
                    property Component liste: Elements{}
                    property string backend: "local"
                    x: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    source:  "Local.qml"

                }

            }
            Item{
                id: notes
                Loader{
                    property Component liste: Elements {}

                    source: "nextNote.qml"
                }
            }
            Item {
                id: oneNote
                Loader{
                    property Component liste: Elements {}
                    property string oneNoteToken
                    source: "OneNote.qml"
                }
            }

        }
    }
    Item {

        Component.onCompleted:{

            /**
            *  create initial model from local
            *  this is only called once when the view is created the first time (I hope so)
            **/
            DB.initDB();
            DB.getTitels(); // create model

            /**
              * make Connection to Notes
              **/
            netWork.resultAvailable.connect(NN.parseJson)

        }

    }


    ToolBarMenu{
        id: tbmenu
        height: 32
        anchors.right: parent.right
        visible: false
        onClicked: {
            configDlg.visible = true
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

        TextArea {
            width: parent.width
            id: newText
            objectName: "noteText"
            Accessible.name: "mnotesHandler"
            focus: true
           // backgroundVisible: false
            selectByMouse: true
            anchors.fill: parent
            text:  ""
            // textFormat: TextEdit.RichText

        }
        Component.onCompleted: {
            noteID = 0;

        }


    }
    footer: ToolBar{
        id: statusbar
        objectName: "statusBar"
        visible: false
        height: 40
        RowLayout {
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
                height: 25
                focus: true
                onEditingFinished:  {

                    notesApp.sbSignal(searchBox.text)

                }

            }

        }
        Keys.onPressed: {
            if (( event.key === Qt.Key_F)  && (event.modifiers & Qt.ControlModifier))
            {
                // console.log("StackStatus: " + stackIndex)
                statusbar.visible = statusbar.visible ? false: true;

            }
        }

    }

    onClosing: {
        console.log("closing: "+ noteID)

    }

    DelDialog{
        id: delDialog
        onAccepted: {
           // console.log("del id: " +notesApp.noteID)
           // console.log("del index: " + curIndex)
            var curTab = ""
            curTab = tabView.itemAt(tabView.currentIndex).text
           // console.log("del "+ tabView.itemAt(tabView.currentIndex).text)

            switch(curTab){
            case "Local":
                DB.deleteNote(noteID);
                notesModel.remove(curIndex);
                break;
            case "Notes":
                NN.delNote(noteID);
                notesModel.remove(curIndex);
                break;
            }




        }
    }



}
