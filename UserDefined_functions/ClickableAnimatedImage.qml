import QtQuick 2.11

AnimatedImage {
    id: root
    signal clicked

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: root.clicked()
    }
}

