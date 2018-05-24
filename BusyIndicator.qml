import QtQuick 2.4

Item {
    id: busyindicator

    Image {
        id: busyimage

        source: "qrc:/images/busy.png";

        NumberAnimation on rotation {
            running: busyindicator.visible
            from: 0; to: 360;
            loops: Animation.Infinite;
            duration: 1200
        }
    }
}
