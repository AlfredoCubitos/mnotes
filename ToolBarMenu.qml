import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.2

Item {
    id: tbRoot
    width: 150
    height: 100

    signal clicked
    property string title

    Rectangle{
        id: toolboxMenu
        width: parent.width
        height: parent.height
        color: "#f7f6f6"
        radius: 3
        border.color: "#ddd9d9"
        border.width: 4

        ColumnLayout{
            anchors.fill: parent

            Rectangle{
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.bottomMargin: 20


                height: menuName.height+5
                width: tbRoot.width-8
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Text {
                    width: parent.width
                    horizontalAlignment:  Text.AlignHCenter
                    id: menuName
                    style: Text.Sunken
                    text: qsTr("Available Backends")
                }

            }
            Button{
                id: ownCloudBtn
                width: parent.width

                text: qsTr("OwnCloud")
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
                onClicked: {
                  // export click event
                    tbRoot.title = text
                    tbRoot.clicked()
                }
            }

            Button{
                id: newBtn
                width: parent.width
                anchors.bottom: parent.bottom
                text: qsTr("New")
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
                onClicked: {
                  // export click event
                    tbRoot.clicked()
                }
            }
        }

    }


}
