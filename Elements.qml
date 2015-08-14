import QtQuick 2.4
import QtQuick.LocalStorage 2.0
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
		

	  
	  Item {
        id: button
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        implicitHeight: col.height
        height: implicitHeight
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
        

        Column {
            spacing: 2
            id: col
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            
            Text {
                id: buttonLabel
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.right: parent.right
                anchors.rightMargin: 10
                text: titel
                color: "black"
                font.pixelSize: 12
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                styleColor: "white"
                style: Text.Raised
                property int iD: nId

            }


            Image{
                id: del
                source: "images/list-remove.png"
                anchors.left: parent.right
                anchors.leftMargin:  notesApp.width - 50

                MouseArea {
                    id: remove
                    anchors.fill: parent
                    onClicked: {
                                        DB.deleteNote(buttonLabel.iD);
                                        View.removeFromList(index);
                                    }
                    hoverEnabled: true

                }

            }
            
        }
    }
	  
}
