import QtQuick 2.11
import QtQuick.Window 2.11

import "Map"
import "LeftScreen"
import "ClickableImage"
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
        source: "qrc:Images/mapIcon.png"

        width: 80
        height: 80

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 110
        }

        visible: true                           // Initially visible

        onClicked: {
            console.log("Open Navigation")
            mapView.visible = true              // Show MapView when clicked
            mainDashboard.visible = false       // Hide main Dashboard
            mapIcon.visible = false             // Hide map icon
        }
    }

    MapView {
        id: mapView
        anchors.fill: parent
        visible: false                          // Initially hidden
    }

    Message {
        id: messagepage
        anchors.fill: parent
        visible: true                          // Initially hidden
    }

}
