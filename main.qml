import QtQuick 2.11
import QtQuick.Window 2.11

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

    Item {
        id: mapContainer
        width: parent.width
        height: parent.height
        visible: false
        x: -width

        Behavior on x {
            NumberAnimation {
                duration: 300
                easing.type: Easing.InOutQuad
            }
        }

        MapView {
            id: mapPage
            anchors.fill: parent
        }

        function swipeIn() {
            visible = true
            x = 0
        }

        function swipeOut() {
            x = -width
            Qt.createQmlObject('import QtQuick 2.0; Timer { interval: 300; repeat: false;
                                onTriggered: mapContainer.visible = false; running: true }', mapContainer, "SwipeOutTimer")
        }
    }

    Rectangle {
        id: sysBar
        width: parent.width * 0.9
        height: parent.height * (70/480)

        property int offscreenY: parent.height  // below screen
        property int onscreenY: parent.height - height - 10

        y: onscreenY
        anchors.horizontalCenter: parent.horizontalCenter
        visible: true

        radius: 20
        color: "#801E1E1E"        // semi-transparent dark gray
        border.color: "#40FFFFFF" // light semi-transparent border
        border.width: 1

        Behavior on y {
            NumberAnimation {
                duration: 300
                easing.type: Easing.InOutQuad
            }
        }

        function swipeIn() {
            visible = true
            y = onscreenY
        }

        function swipeOut() {
            y = offscreenY
            Qt.createQmlObject('import QtQuick 2.0; Timer { interval: 300; repeat: false;
                                onTriggered: sysBar.visible = false; running: true }', sysBar, "SwipeOutTimer")
        }

        ClickableImage {
            id: mapIcon
            source: "qrc:/Images/whiteMapIcon.png"

            width: window.width * (85/1300)
            height: width

            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }

            visible: true                           // Initially visible

            onClicked: {
                console.log("Open Navigation")
                mapContainer.swipeIn()              // Show mapPage when clicked
                sysBar.swipeOut()                   // Hide system bar
            }
        }

        ClickableImage {
            id: terminalIcon
            source: "qrc:/Images/terminal.png"

            width: window.width * (60/1300)
            height: width

            anchors {
                verticalCenter: parent.verticalCenter
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

            width: window.width * (80/1300)
            height: width

            anchors {
                verticalCenter: parent.verticalCenter
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

            width: window.width * (90/1300)
            height: window.height * (60/780)

            anchors {
                verticalCenter: parent.verticalCenter
                right: mapIcon.left
                rightMargin: parent.width * (120/1300)
            }

            visible: true

            onClicked: {
                backend.openCamera()
            }
        }

        ClickableImage {
            id: projectInfoIcon
            source: "qrc:/Images/voiceInfo.png"

            width: window.width * (80/1300)
            height: width

            anchors {
                verticalCenter: parent.verticalCenter
                right: cameraIcon.left
                rightMargin: parent.width * (120/1300)
            }

            visible: true

            onClicked: {
                backend.projectInfo()
            }
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
}

