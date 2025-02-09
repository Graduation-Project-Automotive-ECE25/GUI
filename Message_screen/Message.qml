import QtQuick 2.15
import Qt5Compat.GraphicalEffects

import "../ClickableImage"


Item {
    id: messagepage
    width: 1300
    height: 780
    anchors.centerIn: window.contentItem

    Image {
        id: message_bck
        anchors.centerIn: parent.Center
        source: "qrc:Images/emptyBG.jpg"
    }
    ColorOverlay {
        anchors.fill: message_bck
        source: message_bck
        color: "#8000131a"
    }
    Image {
        id: border
        source: "qrc:Images/rectangle.png"
        anchors.centerIn: parent.Center
    }

    Rectangle {
        width: 340
        height: 80
        color: "transparent"
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 220
        }

        Text {
            text: qsTr("Warning")
            font.family: "Helvetica"
            font.pointSize: 40
            font.bold: true
            color: "yellow"
            style: Text.Outline
            styleColor: "#fefe00"

            width: 340
            horizontalAlignment: Text.AlignHCenter
            anchors.centerIn: parent.Center
        }
    }

    ClickableImage {
        id: ok_bottun
        source: "qrc:Images/ok-64.png"

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 200
        }

        visible: true                           // Initially visible

        onClicked: {
            messagepage.visible = false              // Show MapView when clicked
            mainDashboard.visible = true             // Hide main Dashboard
        }
    }
}
