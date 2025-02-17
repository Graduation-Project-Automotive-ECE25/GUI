import QtQuick 2.11
import QtQuick.Window 2.11

import "UserDefined_functions"
import "Map"
import "Message_screen"


Window {
    id: window

    // function calculateDimensions() {
    //     var aspectRatio = 16 / 9;
    //     var width = Math.min(mainWindow.width, mainWindow.height * aspectRatio);
    //     var height = width / aspectRatio;
    //     return { width: width, height: height };
    // }

    visible: true
    // width: calculateDimensions().width
    // height: calculateDimensions().height
    width: 1300
    height: 780
    title: qsTr("Car Dashboard")

    color:"#F1F1F1"

    MainDashboard {
        id: mainDashboard
        anchors.centerIn: window.contentItem
        visible: true                           // Initially visible
    }

    ClickableImage {
        id: mapIcon
        source: "qrc:/Images/whiteMapIcon.png"

        width: 80
        height: 80

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 10
        }

        visible: true                           // Initially visible

        onClicked: {
            console.log("Open Navigation")
            mapView.visible = true              // Show MapView when clicked
            hideIcons()
        }
    }

    MapView {
        id: mapView
        anchors.fill: parent
        visible: false                          // Initially hidden
    }

    ClickableImage {
        id: terminalIcon
        source: "qrc:/Images/terminal.png"

        width: 60
        height: 60

        anchors {
            bottom: parent.bottom
            bottomMargin: 17
            left: mapIcon.right
            leftMargin: 120
        }

        visible: true                           // Initially visible

        onClicked: {
            console.log("Open Terminal")
        }
    }

    ClickableImage {
        id: rebootIcon
        source: "qrc:/Images/reboot.png"

        width: 80
        height: 80

        anchors {
            bottom: parent.bottom
            bottomMargin: 9
            left: terminalIcon.right
            leftMargin: 120
        }

        visible: true                           // Initially visible

        onClicked: {
            console.log("Reboot System")
        }
    }

    ClickableImage {
        id: cameraIcon
        source: "qrc:/Images/cameraicon.png"

        width: 90
        height: 60

        anchors {
            bottom: parent.bottom
            bottomMargin: 15
            right: mapIcon.left
            rightMargin: 120
        }

        visible: true                           // Initially visible

        onClicked: {
            console.log("Open Camera")
        }
    }

    Message {
        id: messagepage
        anchors.fill: parent
        visible: true                          // Initially visible
    }

    function hideIcons()
    {
        mainDashboard.visible = false       // Hide main Dashboard
        mapIcon.visible = false             // Hide map icon
        terminalIcon.visible = false        // Hide terminal icon
        rebootIcon.visible = false          // Hide reboot icon
        cameraIcon.visible = false          // Hide camera icon
    }
}
