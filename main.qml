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
    width: 800                      // Based on 1300
    height: 480                     // Based on 780
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

        width: parent.width * (80/1300)
        height: width

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: parent.height * (18/780)
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

        width: parent.width * (60/1300)
        height: width

        anchors {
            bottom: parent.bottom
            bottomMargin: parent.height * (25/780)
            left: mapIcon.right
            leftMargin: parent.width * (120/1300)
        }

        visible: true

        onClicked: {
            backend.openTerminal()
        }
    }

    ClickableImage {
        id: rebootIcon
        source: "qrc:/Images/reboot.png"

        width: parent.width * (80/1300)
        height: width

        anchors {
            bottom: parent.bottom
            bottomMargin: parent.height * (17/780)
            left: terminalIcon.right
            leftMargin: parent.width * (120/1300)
        }

        visible: true
        onClicked: {
            backend.rebootSystem()
        }
    }

    ClickableImage {
        id: cameraIcon
        source: "qrc:/Images/cameraicon.png"

        width: parent.width * (90/1300)
        height: parent.height * (60/780)

        anchors {
            bottom: parent.bottom
            bottomMargin: parent.height * (23/780)
            right: mapIcon.left
            rightMargin: parent.width * (120/1300)
        }

        visible: true

        onClicked: {
            backend.openCamera()
        }
    }

    ClickableImage {
        id: projectInfo
        source: "qrc:/Images/voiceInfo.png"

        width: parent.width * (80/1300)
        height: width

        anchors {
            bottom: parent.bottom
            bottomMargin: parent.height * (20/780)
            right: cameraIcon.left
            rightMargin: parent.width * (120/1300)
        }

        visible: true

        onClicked: {
            backend.projectInfo()
        }
    }

    Message {
        id: messagepage
        anchors.fill: parent
        visible: false
        // Listen for changes in backend.warningMessage
        Connections {
            target: backend
            onWarningMessageChanged: {
                //console.log("Warning message changed to:", backend.warningMessage)
                if(backend.warningMessage === "WARNING\nOVER SPEED"){
                    messagepage.visible = true

                }
                else if(backend.warningMessage === "WARNING\nAdaptive Cruise Activated"){
                    messagepage.visible = true

                }
                else if(backend.warningMessage === "WARNING\nBlind Spot Detected"){
                    messagepage.visible = true

                }
                else{
                     messagepage.visible = false
                }

                mainDashboard.visible = !messagepage.visible;
            }
        }
    }

    // Serial Port Controls
    Row {
        id: serialControls
        visible: true

        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            margins: parent.height * (10/780)
        }
        spacing: parent.width * (10/1300)

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

    function hideIcons()
    {
        mainDashboard.visible = false       // Hide main Dashboard
        mapIcon.visible = false             // Hide map icon
        terminalIcon.visible = false        // Hide terminal icon
        rebootIcon.visible = false          // Hide reboot icon
        cameraIcon.visible = false          // Hide camera icon
        serialControls.visible = false      // Hide serial port controls
    }
}

