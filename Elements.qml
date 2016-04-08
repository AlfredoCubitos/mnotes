import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.2
import "."
import "view.js" as View
import "backend.js" as DB

Rectangle {
	  id: container
      property int curIdx


	  width: parent.width
	  height:38
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
		

      Dialog {
          id: delDialog
          title: "MNotes Delete Dialog"
          standardButtons: StandardButton.Ok | StandardButton.Abort
          Text{
              text: "realy delete this note?"
              anchors.centerIn: parent
          }
          onAccepted: {
              DB.deleteNote(buttonLabel.iD);
              View.removeFromList(index);
          }
      }
	  
	  Item {
        id: button
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
      //  implicitHeight: col.height
       // height: implicitHeight
        width: buttonLabel.width + 20
		 
        MouseArea {
            id: mouseArea
            height: parent.height
            width: parent.width + 70
            onClicked: {
               View.openNote(buttonLabel.iD);
                curIdx = index;
            }
            hoverEnabled: true

        }
        

        RowLayout{
            spacing: 2
            id: col
           // anchors.verticalCenter: parent.verticalCenter
            width: notesApp.width

                implicitWidth: notesApp.width
                Text {
                    id: buttonLabel
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    // anchors.right: parent.right
                    //   anchors.rightMargin: 10
                  //  anchors.horizontalCenter: parent.horizontalCenter
                //    anchors.verticalCenter: parent.verticalCenter
                    text: titel
                    color: "black"
                    font.pixelSize: 12
                    //      wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    styleColor: "white"
                    style: Text.Raised
                    property int iD: nId

                }


                Item { Layout.fillWidth: true }

                Image{
                    id: del
                    source: "images/list-remove.png"
                    anchors.right:  parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 8

                    MouseArea {
                        id: remove
                        anchors.fill: parent
                        onClicked:  delDialog.visible =true
                        hoverEnabled: true

                    }

                }

        }
    }
	  
}
