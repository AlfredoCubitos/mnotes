import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import QtQuick.Layouts 1.2
//import "."
import "view.js" as View
import "backend.js" as DB
import "OneNote.js" as OneNote
import "nextnote.js" as NN


/**
  * note: properties are initialized by a js function the first time
  * A new initialization of properties later is not possible !
  * This means properties not initalized could not initalize later
  * Also a new initialization e.g. with a a different type ist not possible
  * So the OneNoteUrl property used in OneNote.js has to be initilized in backend.js
  *
  **/

Rectangle {
	  id: container
      property int curIdx
   //   property string oneNoteUrl

      property alias btnLabel: buttonLabel.iD //used in DelDialog
     // property Component tab: TabElement{}

      width: notesApp.width - 4
      implicitHeight:48
      color: "#eeed94"
	  
      gradient: Gradient {
          GradientStop {
              position: 0
              Behavior on color {ColorAnimation { duration: 100 }}
              color: button.pressed ? "#C0C000" : "#EBEB00"
          }
          GradientStop {
              position: 1
              Behavior on color {ColorAnimation { duration: 100 }}
              color: button.pressed ? "#C0C000" : button.containsMouse ? "#F5F4CD" : "#F3F6B9"
          }
      }
		


	  Item {
        id: button
        anchors.top: container.top
        anchors.left: container.left
        anchors.bottom: container.bottom

        width: buttonLabel.width + 20
		 
        MouseArea {
            id: mouseArea
            height: container.height - 4
            // width: container.width - del.width - 8
            width: buttonLabel.width + 10
            onClicked: {
              // View.openNote(buttonLabel.iD);
                console.log("Tab "+tabView.currentItem.text)
                var tabTitle = tabView.currentItem.text;
                switch(tabTitle)
                {
                case "Local":
                    View.showNote(buttonLabel.iD, tabTitle);
                    notesApp.curIndex = index;
                    notesApp.noteID = buttonLabel.iD;
                    break;
                case "OneNote":
                    OneNote.showNote(0, tabTitle);
                    notesApp.noteTitel = buttonLabel.text
                    // console.log("click: " +  )
                    notesApp.curIndex = index;
                    break;
                case "Notes":
                    NN.showNote(buttonLabel.iD, tabTitle)
                    notesApp.curIndex = index;
                    notesApp.noteID = buttonLabel.iD;
                    break;
                }


                //curIdx = index;
            }
            hoverEnabled: true

        }
        

        RowLayout{
            id: col
            anchors.verticalCenter: parent.verticalCenter
            width: notesApp.width
            anchors.verticalCenterOffset: 0

                Text {
                    id: buttonLabel
                    anchors.left: parent.left
                    anchors.leftMargin: 10

                    text: titel
                    color: "black"
                    font.pixelSize: 14

                    styleColor: "white"
                    style: Text.Raised
                    property var iD: nId
                    property string url: typeof oneNoteUrl === "undefined" ? "?" : oneNoteUrl;

                }

                /** horizontal separator **/
                Item { Layout.fillWidth: true }

                Image{
                    id: del
                    fillMode: Image.PreserveAspectFit
                    source: "images/delete.png"
                    anchors.right:  parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 25

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
    }


	  
}

