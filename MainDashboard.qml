import QtQuick 2.11
import Qt5Compat.GraphicalEffects
import "UserDefined_functions"
import "Map"

Item {
    id: mainDashboard
    width: window.width
    height: window.height

    property int speedValue : 0
    property int rpmValue : 0
    property int right_clicked : 0
    property bool isFlashing: false

    Image {
        id: bck
        anchors.fill: parent
        source: "qrc:Images/emptyBG.jpg"
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    Item {
        id: carguage_speed

        width: parent.width * (450/1300)
        height: width

        visible: true
        anchors {
            right: parent.right
            rightMargin: parent.width * (20/1300)
            verticalCenter: parent.verticalCenter
        }

        Rectangle {
            id: car_gauge
            width: parent.width
            height: width
            radius: width / 2
            anchors.fill: parent

            border.color: "white"
            border.width: 3
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
                    var outerRadius = parent.radius * (205/225);  // Outer radius for the end of the lines
                    var innerRadius = parent.radius * (175/225);  // Inner radius for the start of the lines
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
                    target: backend
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
                    var outerRadius = parent.radius * (205/225);  // Outer radius for the end of the lines
                    var innerRadius = parent.radius * (190/225);  // Inner radius for the start of the lines
                    var numMarkers = 120;    // Number of markers for 0 to 120

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
                    var needleAngle = Math.PI / 2 + (backend.speedValue / 120) * Math.PI * 1.6;
                    var needleLength = parent.width * (160/450);
                    ctx.lineTo(width / 2 + needleLength * Math.cos(needleAngle),
                               height / 2 + needleLength * Math.sin(needleAngle));
                    ctx.lineWidth = 5;
                    ctx.strokeStyle = "red";
                    ctx.stroke();
                }

                Connections {
                    target: backend
                    onSpeedValueChanged: myCanvas.requestPaint()
                }
            }

            Repeater {
                model: 7  // Labels from 0 to 120 at 10 km/h intervals
                delegate: Text {
                    text: (index * 20).toString()
                    font.pixelSize: parent.width/18
                    font.bold: true
                    color: (index < 5) ? "white" : "red"
                    x: parent.width / 2 + (parent.width * (150/450)) * Math.cos(Math.PI / 2 + index * Math.PI / 6 * 1.6) - width / 2
                    y: parent.height / 2 + (parent.height * (150/450)) * Math.sin(Math.PI / 2 + index * Math.PI / 6 * 1.6) - height / 2
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Rectangle {
                width: parent.width * (60/450)
                height: width
                radius: width / 2
                anchors.centerIn: parent
                color: car_gauge.color
                visible: true
                border.color: "grey"
                border.width : 2

                Rectangle {
                    width: parent.width * (30/60)
                    height: width
                    radius: width / 2
                    anchors.centerIn: parent
                    color: "red"
                    visible: true
                    border.color: car_gauge.color
                    border.width : 2
                }
            }
        }

        //////////////////////////////////////////////////////////////////////////////// will be removed
        Rectangle {
            id: speed_incrementer
            width: parent.width * (80/450)
            height: parent.height * (50/450)
            border.color: "black"
            border.width: 1
            color: car_gauge.color
            anchors {
                right: car_gauge.right
                rightMargin: parent.width * (95/450)
                bottom: parent.bottom
                bottomMargin: parent.height * (110/450)
            }
            Text {
                id: speedText
                anchors.centerIn: parent
                text: backend.speedValue.toString()
                color: "blue"
                font.pixelSize: parent.width/1.5
                font.bold: true
            }
        }
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    Item {
        id: carguage_rpm

        width: parent.width * (450/1300)
        height: width

        visible: true
        anchors {
            left: parent.left
            leftMargin: parent.width * (20/1300)
            verticalCenter: parent.verticalCenter
        }

        Rectangle {
            id: car_gauge_rpm
            width: parent.width
            height: width
            radius: width / 2
            anchors.fill: parent

            border.color: "white"
            border.width: 3
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
                    var outerRadius = parent.radius * (205/225);  // Outer radius for the end of the lines
                    var innerRadius = parent.radius * (175/225);  // Inner radius for the start of the lines
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
                    var outerRadius = parent.radius * (205/225);  // Outer radius for the end of the lines
                    var innerRadius = parent.radius * (190/225);  // Inner radius for the start of the lines
                    var numMarkers = 28;    // Number of markers for 0 to 28

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
                    var needleLength = parent.width * (160/450);
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
                    font.pixelSize: parent.width/17
                    font.bold: true
                    color: (index < 6) ? "white" : "red"
                    x: parent.width / 2 + (parent.width * (150/450)) * Math.cos(Math.PI / 2 + index * Math.PI / 7 * 1.6) - width / 2
                    y: parent.height / 2 + (parent.width * (150/450)) * Math.sin(Math.PI / 2 + index * Math.PI / 7 * 1.6) - height / 2
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Rectangle {
                width: parent.width * (60/450)
                height: width
                radius: width / 2
                anchors.centerIn: parent
                color: car_gauge_rpm.color
                visible: true
                border.color: "grey"
                border.width : 2

                Rectangle {
                    width: parent.width * (30/60)
                    height: width
                    radius: width / 2
                    anchors.centerIn: parent
                    color: "red"
                    visible: true
                    border.color: car_gauge_rpm.color
                    border.width : 2
                }
            }  
        }

        //////////////////////////////////////////////////////////////////////////////// will be removed
        Rectangle {
            id:speed_incrementer_rpm
            width: parent.width * (40/450)
            height: width
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
        }
        /////////////////////////////////////////////////////////////////////////////////////////
    }

    Item {
        id: turnsignals

        width: parent.width * (500/1300)
        height: parent.height * (100/780)

        anchors {
            top: parent.top
            topMargin: parent.height * (50/780)
            horizontalCenter: parent.horizontalCenter
        }

        Rectangle {
            color: "transparent"
            anchors.fill: parent

            MouseArea {
                width: turnsignals.width * (100/500)
                height: width
                anchors.right: parent.right

                hoverEnabled: true
                cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
                // onClicked: {
                //     if (turnRight.visible) {
                //         turnRight.visible = false
                //     }

                //     else {
                //         flashingTimerR.start()
                //         turnsignalstimer.start()
                //         turnRight.visible = true
                //         console.log("Turn Right")
                //     }
                // }
                // onDoubleClicked: {
                //     if (!isFlashing) {
                //         // Start flashing both signals
                //         flashingTimerL.start()
                //         flashingTimerR.start()
                //         turnLeft.visible = true
                //         turnRight.visible = true
                //         turnsignalstimer.start()
                //         isFlashing = true
                //         console.log("Waiting")
                //     }
                //     else {
                //         // Stop flashing
                //         flashingTimerL.stop()
                //         flashingTimerR.stop()
                //         turnLeft.visible = false
                //         turnRight.visible = false
                //         turnsignalstimer.stop()
                //         isFlashing = false
                //     }
                // }
                Image {
                    id: turnRight
                    source: "qrc:/Images/right.png"
                    anchors.fill: parent
                    visible: false
                }
            }

            MouseArea {
                width: turnsignals.width * (70/400)
                height: width
                anchors.left: parent.left

                hoverEnabled: true
                cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
                // onClicked: {
                //     if (turnLeft.visible) {
                //         turnLeft.visible = false
                //     }
                //     else {
                //         flashingTimerL.start()
                //         turnsignalstimer.start()
                //         turnLeft.visible = true
                //         console.log("Turn Left")
                //     }
                // }
                // onDoubleClicked: {
                //     if (!isFlashing) {
                //         // Start flashing both signals
                //         flashingTimerL.start()
                //         flashingTimerR.start()
                //         turnLeft.visible = true
                //         turnRight.visible = true
                //         turnsignalstimer.start()
                //         isFlashing = true
                //         console.log("Waiting")
                //     }
                //     else {
                //         // Stop flashing
                //         flashingTimerL.stop()
                //         flashingTimerR.stop()
                //         turnLeft.visible = false
                //         turnRight.visible = false
                //         turnsignalstimer.stop()
                //         isFlashing = false
                //     }
                // }
                Image {
                    id: turnLeft
                    source: "qrc:/Images/left.png"
                    anchors.fill: parent
                    visible: false
                }
            }

            Timer {
                id: flashingTimerR
                interval: 500; running: false; repeat: true
                onTriggered:{
                    turnRight.visible = !turnRight.visible
                }
            }

            Timer {
                id: flashingTimerL
                interval: 500; running: false; repeat: true
                onTriggered:{
                    turnLeft.visible = !turnLeft.visible
                }
            }

            Timer {
                id: turnsignalstimer
                interval: 10000; running: false; repeat:false
                onTriggered:{
                    flashingTimerR.stop()
                    flashingTimerL.stop()
                    turnRight.visible = false
                    turnLeft.visible = false
                }
            }
        }

        Connections {
            target: backend
            onSignMessageChanged:{
                if(backend.signMessage === "right"){
                    if (turnRight.visible) {
                        turnRight.visible = false
                    }
                    else {
                        flashingTimerR.start()
                        turnsignalstimer.start()
                        turnRight.visible = true
                        console.log("Turn Right")
                    }
                }
                else if(backend.signMessage === "left"){
                    if (turnLeft.visible) {
                        turnLeft.visible = false
                    }
                    else {
                        flashingTimerL.start()
                        turnsignalstimer.start()
                        turnLeft.visible = true
                        console.log("Turn left")
                    }
                }
                else if(backend.signMessage === "wait"){
                    if (!isFlashing) {
                        // Start flashing both signals
                        flashingTimerL.start()
                        flashingTimerR.start()
                        turnLeft.visible = true
                        turnRight.visible = true
                        turnsignalstimer.start()
                        isFlashing = true
                        console.log("Waiting")
                    }
                    else {
                        // Stop flashing
                        flashingTimerL.stop()
                        flashingTimerR.stop()
                        turnLeft.visible = false
                        turnRight.visible = false
                        turnsignalstimer.stop()
                        isFlashing = false
                    }
                }
            }
        }
    }

    Item {
        id: movingcar
        width: parent.width * (300/1300)
        height: parent.height * (480/780)

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: parent.height * (150/780)
        }

        Image {
            id: car
            source: "qrc:/Images/Model_3.svg"
            width: parent.width * (250/300)
            height: parent.height * (180/480)
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: parent.height * (50/480)
            }
        }

        Item {
            id: rowR
            anchors {
                verticalCenterOffset: -1 * parent.height/2
                horizontalCenterOffset: parent.width/9
                centerIn: parent
            }
            rotation: 80
            Row {
                id: row1r
                visible: true
                x: x - movingcar.height/48
                spacing: movingcar.height/24

                Repeater {
                    model: 12 // or any number of dots you want
                    Rectangle {width: movingcar.height/24; height: 2; color: "white"}
                }
            }
            Row {
                id: row2r
                visible: false
                x: x + movingcar.height/48
                spacing: movingcar.height/24

                Repeater {
                    model: 12 // or any number of dots you want
                    Rectangle {width: movingcar.height/24; height: 2; color: "white"}
                }
            }
        }

        Item {
            id: rowL
            anchors {
                verticalCenterOffset: -1 * parent.height/2
                horizontalCenterOffset: -1 * parent.width/9
                centerIn: parent
            }
            rotation: 100
            Row {
                id: row1l
                visible: true
                x: x - movingcar.height/48
                spacing: movingcar.height/24

                Repeater {
                    model: 12 // or any number of dots you want
                    Rectangle {width: movingcar.height/24; height: 2; color: "white"}
                }
            }
            Row {
                id: row2l
                visible: true
                x: x + movingcar.height/48
                spacing: movingcar.height/24

                Repeater {
                    model: 12 // or any number of dots you want
                    Rectangle {width: movingcar.height/24; height: 2; color: "white"}
                }
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

        width: parent.width * (48/1300)
        height: width
        anchors {
            top: parent.top
            topMargin: parent.height * (70/780)
            horizontalCenter: parent.horizontalCenter
        }
    }

    Image {
        id: heater
        source: "qrc:/Images/heater.svg"

        width: parent.width * (48/1300)
        height: width
        anchors {
            top: parent.top
            topMargin: parent.height * (75/780)
            left: headlights.right
            leftMargin: parent.width * (30/1300)
        }
    }

    Image {
        id: lock
        source: "qrc:/Images/lock.svg"

        width: parent.width * (48/1300)
        height: width
        anchors {
            top: parent.top
            topMargin: parent.height * (70/780)
            right: headlights.left
            rightMargin: parent.width * (30/1300)
        }
    }

    Item {
        id: bottombar
        width: parent.width
        height: parent.height * (120/780)
        anchors.bottom: parent.bottom

        Canvas {
            id: bar
            anchors.fill: parent

            onPaint: {
                var ctx = bar.getContext("2d");
                var atx = bar.getContext("2d");
                ctx.clearRect(0, 0, bar.width, bar.height);

                ctx.strokeStyle = "white";
                ctx.lineWidth = 5;

                var startX = parent.width * (50/1300);
                var startY = 0;
                var endX = bar.width - startX;
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
