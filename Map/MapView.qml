import QtQuick 2.15
import QtLocation 5.11
import QtLocation 6.8
import QtPositioning 5.11
import QtWebEngine 1.9

import "../UserDefined_functions"

Rectangle {

    property string calculatedDistance: ""
    property var uiConfig: {
        "fontSize": 14,
        "fontBold": false,
        "fontColor": "black",
        "spacingBetweenTopBarElements": 15
    }
    Rectangle {
        id: distanceDisplay
        width: 200
        height: 40
        radius: 10
        color: "#ffffffdd"
        border.color: "#999"
        anchors {
            right: parent.right
            rightMargin: 20
            top: parent.top
            topMargin: 20
        }

        Text {
            anchors.centerIn: parent
            text: calculatedDistance.length > 0 ? "Distance: " + calculatedDistance + " km" : ""
            font.pixelSize: 14
            color: "#333"
        }
    }

    WebEngineView {
        id: webView
        anchors.fill: parent
        url: "qrc:/Map/leaflet_map.html"

        onLoadingChanged: {
            if (loadRequest.status === WebEngineView.LoadSucceededStatus) {
                console.log("HTML page loaded");

                // Wait a bit before calling JS functions
                Qt.callLater(() => {
                    Qt.createQmlObject('import QtQuick 2.0; Timer { interval: 500; running: true; repeat: false; onTriggered: { webView.updateMapPosition(); } }',
                                       webView, "DelayedJSCall");
                });
                backend.onLatitudeChanged.connect(updateMapPosition)
                backend.onLongitudeChanged.connect(updateMapPosition)
                updateMapPosition()
            }
        }

        Connections {
            target: backend
            onDistanceChanged: {
                mapPage.calculatedDistance = backend.distance
            }
        }

        function updateMapPosition() {
            runJavaScript(`
                if (window.map && window.marker) {                          // if (window.map && window.marker)
                    // updateCurrentLocation(31.206346974078556, 29.924636928942466);
                    // map.setView([31.206346974078556, 29.924636928942466], 15);
                    // marker.setLatLng([31.206346974078556, 29.924636928942466]);
                    map.setView([${backend.latitude}, ${backend.longitude}], 15);
                    marker.setLatLng([${backend.latitude}, ${backend.longitude}]);
                }
            `)
        }
    }

    ClickableImage {
        id: backArrow
        source: "qrc:Images/backArrow.png"

        width: parent.width * (50/1300)
        height: width

        anchors {
            left: parent.left
            leftMargin: parent.width * (20/1300)
            top: parent.top
            topMargin: parent.height * (25/780)
        }

        //antialiasing: true

        onClicked: {
            console.log("Back to Dashboard")
            mapContainer.swipeOut()            // Hide mapPage
            sysBar.swipeIn()                   // Show system Bar
        }
    }

    NavigationSearchBox {
        id: navSearchBox

        anchors {
            left: backArrow.right
            leftMargin: parent.width * (20/1300)
            top: parent.top
            topMargin: parent.height * (25/780)
        }
        // onLocationSelected: {
        //     webView.runJavaScript(`map.setView([${coordinate.latitude}, ${coordinate.longitude}], 15); marker.setLatLng([${coordinate.latitude}, ${coordinate.longitude}]);`)
        // }
        onLocationSelected: {
            webView.runJavaScript(`
                updateRoute(${backend.latitude}, ${backend.longitude}, ${coordinate.latitude}, ${coordinate.longitude});
                // updateRoute(31.206346974078556, 29.924636928942466, ${coordinate.latitude}, ${coordinate.longitude});
                // updateDestination(${coordinate.latitude}, ${coordinate.longitude});
                map.setView([${coordinate.latitude}, ${coordinate.longitude}], 15);
            `);
        }


    }
}
