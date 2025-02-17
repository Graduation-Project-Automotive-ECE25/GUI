import QtQuick 2.11
import Qt5Compat.GraphicalEffects
import "UserDefined_functions"
import "Map"

Item {
    id: mainDashboard
    width: bck.width
    height: bck.height

    property int speedValue : 0
    property int rpmValue : 0
    property int right_clicked : 0

    Image {
        id: bck

        anchors.centerIn: mainDashboard

        source: "qrc:Images/emptyBG.jpg"
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    Item {
        id: carguage_speed

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
            border.width: 4
            color: "transparent"
            Canvas{
                id: myCanvas3
                anchors.fill: parent
                onPaint: {
                    var ctx = myCanvas3.getContext("2d");
                    var atx = myCanvas3.getContext("2d");
                    ctx.clearRect(0, 0, myCanvas3.width, myCanvas3.height);


                    ctx.strokeStyle = "white";
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
                        if (i >= 9)
                            ctx.strokeStyle = "red";
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


                    ctx.strokeStyle = "white";
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
                        if (i >= 99)
                            ctx.strokeStyle = "red";
                    }

                    // Needle

                    ctx.beginPath();
                    ctx.moveTo(width / 2 , height / 2 );
                    var needleAngle = Math.PI / 2 + (speedValue / 120) * Math.PI * 1.6; // Update angle based on speed
                    var needleLength = 162;
                    ctx.lineTo(width / 2 + needleLength * Math.cos(needleAngle),
                               height / 2 + needleLength * Math.sin(needleAngle));
                    ctx.lineWidth = 5;
                    ctx.strokeStyle = "red";
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
                    font.pixelSize: 25
                    font.bold: true
                    color: (index < 5) ? "white" : "red"
                    x: parent.width / 2 + 150 * Math.cos(Math.PI / 2 + index * Math.PI / 6 * 1.6) - width / 2
                    y: parent.height / 2 + 150 * Math.sin(Math.PI / 2 + index * Math.PI / 6 * 1.6) - height / 2
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Rectangle {
                width: 60
                height: 60
                radius: width / 2
                anchors.centerIn: car_gauge
                color: car_gauge.color

                visible: true
                border.color: "grey"
                border.width : 2
            }

            Rectangle {
                width: 35
                height: 35
                radius: width / 2
                anchors.centerIn: car_gauge
                color: "red"
                visible: true
                border.color: car_gauge.color
                border.width : 2
            }
        }

        //////////////////////////////////////////////////////////////////////////////// will be removed
        Rectangle {
            id:speed_incrementer
            width: 40
            height: 40
            color: "transparent"
            x: parent.width / 2 - width / 2
            y: parent.height / 2 - height / 2

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    speedValue = speedValue + 1;  // Limit to max 120
                    myCanvas.requestPaint();
                    if (speedValue == 121)
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
        id: carguage_rpm

        visible: true
        anchors {
            left: parent.left
            leftMargin: 20
            verticalCenter: parent.verticalCenter
        }

        Rectangle {
            id: car_gauge_rpm
            width: 450
            height: width
            radius: width / 2
            anchors {
                left: parent.left
                leftMargin: 20
                verticalCenter: parent.verticalCenter
            }
            border.color: "white"
            border.width: 4
            color: "transparent"
            Canvas{
                id: myCanvas3_rpm
                anchors.fill: parent
                onPaint: {
                    var ctx = myCanvas3_rpm.getContext("2d");
                    var atx = myCanvas3_rpm.getContext("2d");
                    ctx.clearRect(0, 0, myCanvas3_rpm.width, myCanvas3_rpm.height);


                    ctx.strokeStyle = "white";
                    ctx.lineWidth = 3;

                    // Define center and radius for lines
                    var centerX = myCanvas3_rpm.width / 2;
                    var centerY = myCanvas3_rpm.height / 2;
                    var outerRadius = 205;  // Outer radius for the end of the lines
                    var innerRadius = 175;  // Inner radius for the start of the lines
                    var numMarkers = 14;    // Number of markers for 0 to 14

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
                        if (i >= 11)
                            ctx.strokeStyle = "red";
                    }
                }
                Connections {
                    target: parent
                    onRpmValueChanged: myCanvas3_rpm.requestPaint()
                }
            }

            Canvas {
                id: myCanvas_rpm
                anchors.fill: parent

                onPaint: {
                    var ctx = myCanvas_rpm.getContext("2d");
                    var atx = myCanvas_rpm.getContext("2d");
                    ctx.clearRect(0, 0, myCanvas_rpm.width, myCanvas_rpm.height);


                    ctx.strokeStyle = "white";
                    ctx.lineWidth = 2;

                    // Define center and radius for lines
                    var centerX = myCanvas_rpm.width / 2;
                    var centerY = myCanvas_rpm.height / 2;
                    var outerRadius = 205;  // Outer radius for the end of the lines
                    var innerRadius = 190;  // Inner radius for the start of the lines
                    var numMarkers = 28;    // Number of markers for 0 to 28

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
                        if (i >= 23)
                            ctx.strokeStyle = "red";
                    }

                    // Needle

                    ctx.beginPath();
                    ctx.moveTo(width / 2 , height / 2 );
                    var needleAngle = Math.PI / 2 + (rpmValue / 28) * Math.PI * 1.6; // Update angle based on RPM
                    var needleLength = 162;
                    ctx.lineTo(width / 2 + needleLength * Math.cos(needleAngle),
                               height / 2 + needleLength * Math.sin(needleAngle));
                    ctx.lineWidth = 5;
                    ctx.strokeStyle = "red";
                    ctx.stroke();
                }

                Connections {
                    target: parent
                    onRpmValueChanged: myCanvas_rpm.requestPaint()
                }
            }

            Repeater {
                model: 8  // Labels from 0 to 7 RPM
                delegate: Text {
                    text: index.toString()
                    font.pixelSize: 28
                    font.bold: true
                    color: (index < 6) ? "white" : "red"
                    x: parent.width / 2 + 150 * Math.cos(Math.PI / 2 + index * Math.PI / 7 * 1.6) - width / 2
                    y: parent.height / 2 + 150 * Math.sin(Math.PI / 2 + index * Math.PI / 7 * 1.6) - height / 2
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Rectangle {
                width: 60
                height: 60
                radius: width / 2
                anchors.centerIn: car_gauge_rpm
                color: car_gauge_rpm.color

                visible: true
                border.color: "grey"
                border.width : 2
            }

            Rectangle {
                width: 35
                height: 35
                radius: width / 2
                anchors.centerIn: car_gauge_rpm
                color: "red"
                visible: true
                border.color: car_gauge_rpm.color
                border.width : 2
            }
        }

        //////////////////////////////////////////////////////////////////////////////// will be removed
        Rectangle {
            id:speed_incrementer_rpm
            width: 40
            height: 40
            color: "transparent"
            x: parent.width / 2 - width / 2
            y: parent.height / 2 - height / 2

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    rpmValue = rpmValue + 1;  // Limit to max 7
                    myCanvas_rpm.requestPaint();
                    if (rpmValue == 29)
                        rpmValue = 0;
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

        width: 370
        height: 70

        anchors {
            top: parent.top
            topMargin: 100
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
                        turnsignalstimer.start()
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
                        turnsignalstimer.start()
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

            Timer {
                id: turnsignalstimer
                interval: 10000; running: true; repeat:false
                onTriggered:{
                    turnRight.visible = false
                    turnLeft.visible = false
                }
            }
        }
    }

    Item {
        id: movingcar
        width: 300
        height: 200

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 190
        }

        Image {
            id: car
            source: "qrc:/Images/Model_3.svg"
            width: 250
            height: 180
            anchors.centerIn: parent.Center
            x: x+25
        }

        Row {
            id: row1r
            visible: true
            anchors {
                centerIn: car.right
            }
            spacing: 15
            x: x+50
            y: y+20
            rotation: 80
            Repeater {
                model: 12 // or any number of dots you want
                Rectangle {width: 15; height: 3; color: "white"}
            }
        }

        Row {
            id: row2r
            visible: false
            anchors {
                centerIn: car.right
            }
            spacing: 15
            x: x+53
            y: y+35
            rotation: 80
            Repeater {
                model: 12 // or any number of dots you want
                Rectangle {width: 15; height: 3; color: "white"}
            }
        }

        Row {
            id: row1l
            visible: true
            anchors {
                centerIn: car.left
            }
            spacing: 15
            x: x-95
            y: y+20
            rotation: -80
            Repeater {
                model: 12 // or any number of dots you want
                Rectangle {width: 15; height: 3; color: "white"}
            }
        }

        Row {
            id: row2l
            visible: false
            anchors {
                centerIn: car.left
            }
            spacing: 15
            x: x-98
            y: y+35
            rotation: -80
            Repeater {
                model: 12 // or any number of dots you want
                Rectangle {width: 15; height: 3; color: "white"}
            }
        }

        Timer {
            interval: 50; running: true; repeat: true
            onTriggered:{
                row1r.visible = row2r.visible
                row2r.visible = !row1r.visible

                row1l.visible = row2l.visible
                row2l.visible = !row1l.visible
            }
        }
    }

    Image {
        id: headlights
        source: "qrc:/Images/headlights.svg"

        anchors {
            top: parent.top
            topMargin: 110
            horizontalCenter: parent.horizontalCenter
        }
    }

    Image {
        id: heater
        source: "qrc:/Images/heater.svg"

        anchors {
            top: parent.top
            topMargin: 110
            left: headlights.right
            leftMargin: 10

        }
    }

    Image {
        id: lock
        source: "qrc:/Images/lock.svg"

        anchors {
            top: parent.top
            topMargin: 110
            right: headlights.left
            rightMargin: 10

        }
    }

    Item {
        id: bottombar
        width: 1300
        height: 100
        anchors.bottom: parent.bottom

        Canvas {
            id: bar
            anchors.fill: parent

            onPaint: {
                var ctx = bar.getContext("2d");
                var atx = bar.getContext("2d");
                ctx.clearRect(0, 0, bar.width, bar.height);

                ctx.strokeStyle = "white";
                ctx.lineWidth = 7;

                var startX = 50;
                var startY = 0;
                var endX = bar.width - 50;
                var endY = 0;

                // Draw the line
                ctx.beginPath();
                ctx.moveTo(startX, startY);
                ctx.lineTo(endX, endY);
                ctx.stroke();
            }
        }
    }
}
