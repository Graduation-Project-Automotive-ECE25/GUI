import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.15

import "UserDefined_functions"
import "Map"
import "Message_screen"


Window {
    id: window


    visible: true
    width: 1300
    height: 780
    title: qsTr("Car Dashboard")

    color:"#F1F1F1"

    MainDashboard {
        id: mainDashboard
        anchors.centerIn: window.contentItem

        visible: true
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

        visible: true                         // Initially visible

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

        visible: true

        onClicked: {
            backend.openTerminal()
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

        visible: true
        onClicked: {
            backend.rebootSystem()
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

        visible: true // backend.warningMessage !== "OVER_SPEED"// Initially visible

        onClicked: {
            backend.openCamera()
        }
    }

    Message {
        id: messagepage
        anchors.fill: parent
        visible: false /*backend.warningMessage === "OVER_SPEED"*/
        // Listen for changes in backend.warningMessage
        Connections {
            target: backend
            onWarningMessageChanged: {
                //console.log("Warning message changed to:", backend.warningMessage)
                if(backend.warningMessage === "OVER_SPEED"){
                    messagepage.visible = true

                }
                else if(backend.warningMessage === "Adaptive_Cruise_Activated"){
                    messagepage.visible = true

                }
                else if(backend.warningMessage === "Blind_Spot_Detected"){
                    messagepage.visible = true

                }
                else{
                     messagepage.visible = false
                }

                mainDashboard.visible = !messagepage.visible;
            }
        }

    }
    function hideIcons()
    {
        mainDashboard.visible = false       // Hide main Dashboard
        mapIcon.visible = false             // Hide map icon
        terminalIcon.visible = false        // Hide terminal icon
        rebootIcon.visible = false          // Hide reboot icon
        cameraIcon.visible = false          // Hide camera icon
    }

    // Serial Port Controls
    Row {
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            margins: 20
        }
        spacing: 10

        ComboBox {
            id: portSelector
            model: backend.availableSerialPorts()
            width: 200
        }

        Button {
            text: "Open Serial"
            onClicked: backend.openSerialPort(portSelector.currentText)
        }

        Button {
            text: "Stop Serial"
            onClicked: backend.stopSerialPort()
        }
    }
}
