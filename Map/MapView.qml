import QtQuick 2.15
import QtLocation 5.11
import QtLocation 6.8
import QtPositioning 5.11

import "../UserDefined_functions"


Rectangle {

    property var uiConfig: {
        "fontSize": 14,
        "fontBold": false,
        "fontColor": "black",
        "spacingBetweenTopBarElements": 15
    }

    // Faculty of Engineering, AU Location
    property double latitude: 31.206346974078556
    property double longitude: 29.924636928942466

    id: mapView

    anchors {
        fill: parent
    }

    Plugin {
        id: mapPlugin
        name: "osm"
    }

    // GeoLocationHandler {
    //     id: geoHandler
    //     onLatitudeChanged: {
    //         map.center.latitude = latitude
    //         console.log("Latitude updated to:", latitude);
    //     }
    //     onLongitudeChanged: {
    //         map.center.longitude = longitude
    //         console.log("Longitude updated to:", longitude);
    //     }
    // }

    Map {
        id: map
        anchors.fill: parent
        plugin: mapPlugin
        center: QtPositioning.coordinate(latitude, longitude)
        zoomLevel: 15
        property geoCoordinate startCentroid

        MapQuickItem {
            id: locationMarker
            anchorPoint.x: markerImage.width / 2             // Center the marker
            anchorPoint.y: markerImage.height                // Align bottom of the marker with the coordinate

            coordinate: QtPositioning.coordinate(latitude, longitude) // Set marker position

            sourceItem: Image {
                id: markerImage
                source: "qrc:/Images/locationMarker.png"
                width: 40
                height: 40
            }
        }

        PinchHandler {
            id: pinch
            target: null
            onActiveChanged: if (active) {
                map.startCentroid = map.toCoordinate(pinch.centroid.position, false)
            }
            onScaleChanged: (delta) => {
                map.zoomLevel += Math.log2(delta)
                map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position)
            }
            onRotationChanged: (delta) => {
                map.bearing -= delta
                map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position)
            }
            grabPermissions: PointerHandler.TakeOverForbidden
        }
        WheelHandler {
            id: wheel
            // workaround for QTBUG-87646 / QTBUG-112394 / QTBUG-112432:
            // Magic Mouse pretends to be a trackpad but doesn't work with PinchHandler
            // and we don't yet distinguish mice and trackpads on Wayland either
            acceptedDevices: Qt.platform.pluginName === "cocoa" || Qt.platform.pluginName === "wayland"
                             ? PointerDevice.Mouse | PointerDevice.TouchPad
                             : PointerDevice.Mouse
            rotationScale: 1/120
            property: "zoomLevel"
        }
        DragHandler {
            id: drag
            target: null
            onTranslationChanged: (delta) => map.pan(-delta.x, -delta.y)
        }
        Shortcut {
            enabled: map.zoomLevel < map.maximumZoomLevel
            sequence: StandardKey.ZoomIn
            onActivated: map.zoomLevel = Math.round(map.zoomLevel + 1)
        }
        Shortcut {
            enabled: map.zoomLevel > map.minimumZoomLevel
            sequence: StandardKey.ZoomOut
            onActivated: map.zoomLevel = Math.round(map.zoomLevel - 1)
        }
    }

    ClickableImage {
        id: backArrow
        source: "qrc:Images/backArrow.png"

        anchors {
            left: parent.left
            leftMargin: 20
            top: parent.top
            topMargin: 25
        }

        antialiasing: true

        onClicked: {
            console.log("Back to Dashboard")
            mapView.visible = false             // Hide MapView
            showIcons()
        }
    }

    NavigationSearchBox {
        id: navSearchBox

        anchors {
            left: backArrow.right
            leftMargin: 20
            top: parent.top
            topMargin: 25
        }

    }

    function showIcons()
    {
        mainDashboard.visible = true       // show main Dashboard
        mapIcon.visible = true             // show map icon
        terminalIcon.visible = true        // show terminal icon
        rebootIcon.visible = true          // show reboot icon
        cameraIcon.visible = true          // show camera icon
    }
}
