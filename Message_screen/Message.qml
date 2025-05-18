import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Controls
import "../UserDefined_functions"


Item {
    id: messagepage
    width: window.width
    height: window.height
    anchors.centerIn: window.contentItem

    Image {
        id: message_bck
        anchors.fill: parent
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

        width: parent.width * (2500/1300)
        height: parent.height * (1500/780)
        anchors.centerIn: parent
    }

    Rectangle {
        width: parent.width * (690/1300)
        height: parent.height * (325/780)
        radius: 35
        color: "transparent"
        anchors {
            centerIn: parent
            horizontalCenterOffset: 10
            verticalCenterOffset: 4
        }

        Text {
            // text: qsTr("Warning\nKeep your hands\non steering Wheel")
            text: qsTr(backend.warningMessage)
            // messagepage.visible: backend.warningMessage
            font.family: "Helvetica"
            font.pointSize: messagepage.width * (25/800)
            font.bold: true
            color: "yellow"

            horizontalAlignment: Text.AlignHCenter
            anchors.centerIn: parent
        }
    }

    ClickableImage {
        id: ok_bottun
        source: "qrc:Images/ok-64.png"
        width: parent.width * (70/1300)
        height: width

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: parent.width * (40/780)
        }

        visible: true                           // Initially visible

        onClicked: {
            messagepage.visible = false              // Show MapView when clicked
            mainDashboard.visible = true             // Hide main Dashboard
            //backend.clearWarningMessage()
        }
    }
}
