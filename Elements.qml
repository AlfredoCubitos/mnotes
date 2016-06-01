import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import QtQuick.Layouts 1.2
import "."
import "view.js" as View
import "backend.js" as DB

Rectangle {
	  id: container
      property int curIdx
      property alias btnLabel: buttonLabel.iD

      width: notesApp.width
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
		


	  Item {
        id: button
        anchors.top: container.top
        anchors.left: container.left
        anchors.bottom: container.bottom

        width: buttonLabel.width + 20
		 
        MouseArea {
            id: mouseArea
            height: container.height
            width: container.width - del.width - 8
            onClicked: {
               View.openNote(buttonLabel.iD);
                curIdx = index;
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
                    font.pixelSize: 12

                    styleColor: "white"
                    style: Text.Raised
                    property int iD: nId

                }

                /** horizontal separator **/
                Item { Layout.fillWidth: true }

                Image{
                    id: del
                    source: "images/list-remove.png"
                    anchors.right:  parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 18

                    MouseArea {
                        id: remove
                        anchors.fill: parent
                        onClicked:  delDialog.visible = true
                        hoverEnabled: true

                    }

                }

        }
    }

      DelDialog{
          id: delDialog
      }
	  
}

