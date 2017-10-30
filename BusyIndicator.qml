import QtQuick 2.0

Item {
    id: busyindicator


    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter

    Image {
        id: busyimage
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        source: "images/busy.png";

        NumberAnimation on rotation {
            running: container.visible
            from: 0; to: 360;
            loops: Animation.Infinite;
            duration: 1200
        }
    }
}
