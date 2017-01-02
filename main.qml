import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.LocalStorage 2.0
import QtQuick.Layouts 1.2
import QtQuick.Controls.Styles 1.4

import "backend.js" as DB
import "view.js" as View
import "OneNote.js" as One

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
    minimumHeight: 300
    visible: true


    signal sbSignal(string txt)
    signal winSignal(var win)
    signal sbActiveSignal(var obj)
    signal dialogOkSignal(var values)
    signal dialogSetGroups()

    property string dialogGroups: "Moin"

    property bool isPortrait: Screen.primaryOrientation === Qt.PortraitOrientation

    property bool isNote: false
    property string noteTitel: "New Note"
    property int curIndex
    property int noteID
    property int btnHeight: 38 // = Elements.container.height
    property int stackIndex

    property string token   //for oneNote Access Token

    property var stack
    property var oneNoteStack

    property var curpos: []
    property int countPos: 0



    ListModel{
        id: notesModel

    }
    /**
  * Menubar
  **/

    toolBar: ToolBar{
        id: toolbar
        implicitHeight: 29
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
            active: true

            Loader{
                id: tabloader
                property Component liste: Elements{}
                property string backend: "local"
                source:  "Local.qml"

            }
        }
       Tab{
            id: oneNote
            active: true
            title: qsTr("OneNote")
            Loader{
                property Component liste: Elements {}
                property string oneNoteToken
                source: "OneNote.qml"
            }
        }
        onCurrentIndexChanged:
        {
            console.log("Tab:" + tabView.getTab(tabView.currentIndex).title)
            notesModel.clear();
            switch(tabView.getTab(tabView.currentIndex).title){

            case "Local":
                DB.getTitels();
                break;
            case "OneNote":
                /*open sign in for MS here*/


                break;
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

    onClosing: {
        console.log("closing: "+ noteID)

    }

}
