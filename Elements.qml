import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import QtQuick.Layouts 1.2
import QtQml.Models 2.2

import de.bibuweb.mnotes 1.0

//import "."
import "view.js" as View
import "backend.js" as DB
import "nextnote.js" as NN


/**
  * note: properties are initialized by a js function the first time
  * A new initialization of properties later is not possible !
  * This means properties not initalized could not initalize later
  * Also a new initialization e.g. with a a different type ist not possible
  * So the OneNoteUrl property used in OneNote.js has to be initilized in backend.js
  *
  **/

Component{
    id:elements


    MouseArea {
        id: mouseArea


        property bool held: false
        property int visualIndex: DelegateModel.itemsIndex
        property DelegateModelGroup visualItems: delegateModel.items
        property string oneNoteUrl

        // holds drag parent information
        // property Item dragparent

        anchors { left: parent.left; right: parent.right }
        height: content.height

        // height: container.height - 4
        //width: container.width - del.width - 8

        onClicked: {

             // console.log("Tab "+ mouseArea.parent.parent.parent)
            var tabTitle = tabView.currentItem.text;

            switch(tabTitle)
            {
            case "Local":
                View.showNote(buttonLabel.iD, tabTitle);
                notesApp.curIndex = index;
                notesApp.noteID = buttonLabel.iD;
                break;
            case "OwnCloud":
                NN.showNote(buttonLabel.iD, tabTitle)
                notesApp.curIndex = index;
                notesApp.noteID = buttonLabel.iD;
                notesApp.category = buttonLabel.category
                notesApp.favorite = buttonLabel.favorite

                break;
            }


        }
        // hoverEnabled: true

        drag.target: held ? content : undefined
        drag.axis: Drag.YAxis
        onPressAndHold: held = true
        onReleased:    held = false


        Rectangle{
            id: content
            width: mouseArea.width-4
            height: 48
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
                right: parent.right
            }

            color: "#eeed94"

            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    Behavior on color {ColorAnimation { duration: 100 }}
                    color: mouseArea.pressed ? "#C0C000" : "#EBEB00"
                }
                GradientStop {
                    position: 1.0
                    Behavior on color {ColorAnimation { duration: 100 }}
                    color: mouseArea.pressed ? "#dddea7" : "#F3F6B9"
                }
            }

            scale: mouseArea.held ? 0.9 : 1.0

            Drag.active: mouseArea.held
            Drag.source: mouseArea
            Drag.hotSpot.x: width / 2
            Drag.hotSpot.y: height / 2



            states: State {
                when: mouseArea.held

              /*
              * ParentChange places the drop element into the right view position (layout hierachie)
              * In dynamic layouts you have to find the right parent
              * in this case its Rectangle from the Component loaded the ListView
              */
                //ParentChange { target: content; parent: mouseArea.parent}
                ParentChange { target: content; parent: mouseArea.parent.parent}
                AnchorChanges {
                    target: content
                    anchors { horizontalCenter: undefined; verticalCenter: undefined; right: undefined }

                }

            }


            RowLayout{
                id: col
                anchors.verticalCenter: parent.verticalCenter
                width: content.width

                Text {
                    id: buttonLabel
                    Layout.alignment: Qt.AlignLeft
                    Layout.leftMargin: 10

                    text: titel
                    color: "black"
                    font.pixelSize: 14

                    styleColor: "white"
                    style: Text.Raised
                    property var iD: nId
                    property string category
                    property bool favorite
                    property string url: typeof oneNoteUrl === "undefined" ? "?" : oneNoteUrl;

                }

                Image{
                    id: del
                    fillMode: Image.PreserveAspectFit
                    source: "images/delete.png"
                    Layout.alignment: Qt.AlignRight
                    Layout.rightMargin: 25


                    MouseArea {
                        id: remove
                        //anchors.fill: parent
                        width: 40
                        height: 40
                        onClicked:  {
                            notesApp.curIndex = index;
                            notesApp.noteID = buttonLabel.iD;
                            notesApp.delDialog.visible = true
                        }
                        hoverEnabled: true

                    }

                }

            }

        } //Rectangle

        DropArea {
            anchors { fill: parent; margins: 10 }

            onEntered: {


                console.log("Drop: "+ drag.source.DelegateModel.itemsIndex +" , "+mouseArea.DelegateModel.itemsIndex)

               //  delegateModel.items.move( drag.source.visualIndex, mouseArea.visualIndex)
                // visualItems.move( drag.source.visualIndex, mouseArea.visualIndex)
                delegateModel.items.move(drag.source.DelegateModel.itemsIndex, mouseArea.DelegateModel.itemsIndex)


                // console.log("Drop: "+ mouseArea.parent.parent.parent)
            }

            onPositionChanged: {
                console.log("Drop: "+ drag.source.visualIndex+" , "+mouseArea.visualIndex)
            }
        }


    }


}


