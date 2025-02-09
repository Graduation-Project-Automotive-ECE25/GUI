import QtQuick 2.11
import "Map"
import "LeftScreen"
import "ClickableImage"

Item {
    id: mainDashboard
    width: bck.width
    height: bck.height

    property int speedValue : 0
    property int right_clicked : 0

    Image {
        id: bck

        anchors.centerIn: mainDashboard

        source: "qrc:Images/emptyBG.jpg"
    }

    Image {
        id: carimage
        source: "qrc:Images/Car.png"

        width: 300
        height: 183

        anchors {
            left: parent.left
            leftMargin: 70
            bottom: parent.bottom
            bottomMargin: 90
        }
    }

    Item {
        id: carguage

        visible: true
        anchors {
            right: parent.right
            rightMargin: 20
            verticalCenter: parent.verticalCenter
        }

        Rectangle {
            id: car_gauge
            width: 450
            height: width
            radius: width / 2
            anchors {
                right: parent.right
                rightMargin: 20
                verticalCenter: parent.verticalCenter
            }
            border.color: "white"
            border.width: 2
            color: "transparent"
            Canvas{
                id: myCanvas3
                anchors.fill: parent
                onPaint: {
                    var ctx = myCanvas3.getContext("2d");
                    var atx = myCanvas3.getContext("2d");
                    ctx.clearRect(0, 0, myCanvas3.width, myCanvas3.height);


                    ctx.strokeStyle = "grey";
                    ctx.lineWidth = 3;

                    // Define center and radius for lines
                    var centerX = myCanvas3.width / 2;
                    var centerY = myCanvas3.height / 2;
                    var outerRadius = 205;  // Outer radius for the end of the lines
                    var innerRadius = 175;  // Inner radius for the start of the lines
                    var numMarkers = 12;    // Number of markers for 0 to 120

                    for (var i = 0; i <= numMarkers; i++) {
                        var angle = (i / numMarkers) * Math.PI * 1.6; // Divide a 180-degree arc

                        // Calculate the start and end points for each line based on angle
                        var startX = centerX + innerRadius * Math.cos(angle + Math.PI / 2);
                        var startY = centerY + innerRadius * Math.sin(angle + Math.PI / 2);
                        var endX = centerX + outerRadius * Math.cos(angle + Math.PI / 2);
                        var endY = centerY + outerRadius * Math.sin(angle + Math.PI / 2);

                        // Draw the main marker line
                        ctx.beginPath();
                        ctx.moveTo(startX, startY);
                        ctx.lineTo(endX, endY);
                        ctx.stroke();
                    }
                }
                Connections {
                    target: parent
                    onSpeedValueChanged: myCanvas3.requestPaint()
                }
            }

            Canvas {
                id: myCanvas
                anchors.fill: parent

                onPaint: {
                    var ctx = myCanvas.getContext("2d");
                    var atx = myCanvas.getContext("2d");
                    ctx.clearRect(0, 0, myCanvas.width, myCanvas.height);


                    ctx.strokeStyle = "grey";
                    ctx.lineWidth = 2;

                    // Define center and radius for lines
                    var centerX = myCanvas.width / 2;
                    var centerY = myCanvas.height / 2;
                    var outerRadius = 205;  // Outer radius for the end of the lines
                    var innerRadius = 190;  // Inner radius for the start of the lines
                    var numMarkers = 120;    // Number of markers for 0 to 120

                    // Draw each marker line around a 180-degree arc
                    var smallInnerRadius = innerRadius + 15;  // Inner radius for small slits
                    var smallOuterRadius = outerRadius - 15;

                    for (var i = 0; i <= numMarkers; i++) {
                        var angle = (i / numMarkers) * Math.PI * 1.6; // Divide a 180-degree arc

                        // Calculate the start and end points for each line based on angle
                        var startX = centerX + innerRadius * Math.cos(angle + Math.PI / 2);
                        var startY = centerY + innerRadius * Math.sin(angle + Math.PI / 2);
                        var endX = centerX + outerRadius * Math.cos(angle + Math.PI / 2);
                        var endY = centerY + outerRadius * Math.sin(angle + Math.PI / 2);

                        // Draw the main marker line
                        ctx.beginPath();
                        ctx.moveTo(startX, startY);
                        ctx.lineTo(endX, endY);
                        ctx.stroke();
                    }

                    // Needle

                    ctx.beginPath();
                    ctx.moveTo(width / 2, height / 2);
                    var needleAngle = Math.PI / 2 + (speedValue / 120) * Math.PI * 1.6; // Update angle based on speed
                    var needleLength = 130;
                    ctx.lineTo(width / 2 + needleLength * Math.cos(needleAngle),
                               height / 2 + needleLength * Math.sin(needleAngle));
                    ctx.lineWidth = 3;
                    ctx.strokeStyle = "white";
                    ctx.stroke();
                }

                Connections {
                    target: parent
                    onSpeedValueChanged: myCanvas.requestPaint()
                }
            }

            Repeater {
                model: 7  // Labels from 0 to 120 at 10 km/h intervals
                delegate: Text {
                    text: (index * 20).toString()
                    font.pixelSize: 24
                    font.bold: true
                    color: "#cb1510"
                    x: parent.width / 2 + 150 * Math.cos(Math.PI / 2 + index * Math.PI / 6 * 1.6) - width / 2
                    y: parent.height / 2 + 150 * Math.sin(Math.PI / 2 + index * Math.PI / 6 * 1.6) - height / 2
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        // Image {
        //     id: alarm_driver
        //     anchors {
        //         right: parent.right
        //         rightMargin: 30
        //         verticalCenter: parent.verticalCenter
        //     }
        //     height: parent.height * .9
        //     //fillMode: Image.PreserveAspectFit
        //     source: "../../../ui/logo.jpg"
        // }

        //////////////////////////////////////////////////////////////////////////////// will be removed
        Rectangle {
            id:speed_incrementer
            width: 40
            height: 40
            color: "transparent"
            x: parent.width / 2 - width / 2
            y: parent.height / 2 - height / 2
            // anchors.left: parent.left
            // anchors.leftMargin: 20
            // anchors.bottom: parent.bottom
            // anchors.bottomMargin: 20

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    speedValue = speedValue + 1;  // Limit to max 120
                    myCanvas.requestPaint();
                    if (speedValue === 121)
                        speedValue = 0;
                }
            }

            // Text {
            //     id: speedText
            //     anchors.centerIn: parent
            //     text: speedValue.toString()
            //     color: "white"
            //     font.pixelSize: 15
            // }
        }
        /////////////////////////////////////////////////////////////////////////////////////////
    }

    Item {
        id: turnsignals

        width: 170
        height: 70

        anchors {
            top: parent.top
            topMargin: 50
            horizontalCenter: parent.horizontalCenter
        }

        Rectangle {
            color: "transparent"
            anchors.fill: parent

            // AnimatedImage {                                      // for ongoing use (after backend)
            //     id: turnRight
            //     source: "qrc:Images/rightArrow.gif"
            //     width: 70
            //     height: 70
            //     anchors.right: parent.right
            //     visible: false

            //     // onCurrentIndexChanged:{
            //     //     console.log("Turn Right")
            //     //     visible: {
            //     //         switch(currentIndex) {
            //     //             case 0: return true;
            //     //             case 1: return false;
            //     //             default: return false;
            //     //         }
            //     //     }
            //     // }
            // }

            // AnimatedImage {                                      // for ongoing use (after backend)
            //     id: turnLeft
            //     source: "qrc:Images/leftArrow.gif"
            //     width: 70
            //     height: 70
            //     anchors.left: parent.left
            //     visible: false

            //     // onCurrentIndexChanged:{
            //     //     console.log("Turn Left")
            //     //     visible: {
            //     //         switch(currentIndex) {
            //     //             case 0: return true;
            //     //             case 1: return false;
            //     //             default: return false;
            //     //         }
            //     //     }
            //     // }
            // }

            MouseArea {
                width: 70
                height: 70
                anchors.right: parent.right

                hoverEnabled: true
                cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
                onClicked: {
                    if (turnRight.visible) {
                        turnRight.visible = false
                    }
                    else {
                        turnRight.visible = true
                        console.log("Turn Right")
                    }
                }

                AnimatedImage {
                    id: turnRight
                    source: "qrc:Images/rightArrow.gif"
                    anchors.fill: parent
                    visible: false
                }
            }

            MouseArea {
                width: 70
                height: 70
                anchors.left: parent.left
                hoverEnabled: true
                cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
                onClicked: {
                    if (turnLeft.visible) {
                        turnLeft.visible = false
                    }
                    else {
                        turnLeft.visible = true
                        console.log("Turn Left")
                    }
                }

                AnimatedImage {
                    id: turnLeft
                    source: "qrc:Images/leftArrow.gif"
                    anchors.fill: parent
                    visible: false
                }
            }
        }
    }

    Item {
        id: bottombar
        width: 1300
        anchors.bottom: parent.bottom

        Image {
            id: bar
            source: "qrc:Images/main\ control\ bar.svg"
        }
    }

}
