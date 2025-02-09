import QtQuick 2.15

Rectangle {
    property var uiConfig: {
        "fontSize": 14,
        "fontBold": false,
        "fontColor": "black",
        "spacingBetweenTopBarElements": 15
    }

    id: leftScreen

    anchors {
        left: parent.left
        top: parent.top
        bottom: StatusBar.top
    }
    width : (parent.width * 1/2) - 70
    radius: 15
    color: "transparent"

    Image {
        id: car
        source: "qrc:/LeftScreen/Images/Model 3.svg"

        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
