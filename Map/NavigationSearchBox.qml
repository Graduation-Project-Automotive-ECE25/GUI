import QtQuick 2.15
import QtQuick.Controls 2.15
import QtNetwork 6.5
import QtPositioning 5.15

Rectangle {
    id: navSearchBox
    color: "#fbfbfb"
    radius: 7
    width: parent.width / 4
    height: parent.height * (50/780)

    property var searchResults: []
    property var selectedLocation: null
    signal locationSelected(var coordinate)

    border {
        color: "#d9d9d9"
        width: 0.5
    }

    Image {
        id: searchBoxIcon
        source: "qrc:/Images/Icon-Search.png"
        fillMode: Image.PreserveAspectFit
        height: parent.height * 0.35
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: (parent.height - height) / 2
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(searchBoxTextInput.text.length > 0) {
                    searchLocation(searchBoxTextInput.text)
                }
            }
        }
    }

    Text {
        id: searchBoxTextBox
        color: "#a7a7a7"
        visible: (searchBoxTextInput.text === "")
        text: "Navigate..."
        anchors {
            left: searchBoxIcon.right
            leftMargin: searchBoxIcon.anchors.leftMargin
            verticalCenter: parent.verticalCenter
        }
    }

    TextInput {
        id: searchBoxTextInput
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
            rightMargin: 10
            left: searchBoxIcon.right
            leftMargin: searchBoxIcon.anchors.leftMargin
        }
        verticalAlignment: Text.AlignVCenter
        clip: true
        focus: true

        onTextChanged: {
            if (text.length > 2) {
                searchTimer.restart()
            } else {
                searchResults = []
            }
        }

        Keys.onReturnPressed: {
            if(text.length > 0) {
                searchLocation(text)
            }
        }

        Keys.onEnterPressed: {
            if(text.length > 0) {
                searchLocation(text)
            }
        }

        Timer {
            id: searchTimer
            interval: 500
            onTriggered: {
                if(searchBoxTextInput.text.length > 0) {
                    searchLocation(searchBoxTextInput.text)
                }
            }
        }
    }

    Rectangle {
        id: resultsDropdown
        visible: searchResults.length > 0
        width: parent.width
        height: Math.min(200, searchResults.length * 40)
        anchors.top: parent.bottom
        anchors.topMargin: 5
        color: "#ffffff"
        border.color: "#d9d9d9"
        radius: 5

        ListView {
            id: resultsListView
            anchors.fill: parent
            model: searchResults
            clip: true

            delegate: Rectangle {
                width: parent.width
                height: 40
                color: ListView.isCurrentItem ? "#e6e6e6" : "#ffffff"

                Text {
                    text: modelData.display_name
                    anchors.fill: parent
                    anchors.margins: 5
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        selectedLocation = modelData
                        locationSelected(QtPositioning.coordinate(parseFloat(modelData.lat), parseFloat(modelData.lon)))
                        searchResults = []
                        searchBoxTextInput.text = modelData.display_name
                        searchBoxTextInput.focus = false
                    }
                }
            }
        }
    }

    function searchLocation(query) {
        if(query.trim().length === 0) return;

        var url = "https://nominatim.openstreetmap.org/search?format=json&q=" + encodeURIComponent(query) + "&limit=5"

        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    try {
                        var results = JSON.parse(xhr.responseText)
                        searchResults = results
                    } catch (e) {
                        console.error("Error parsing JSON:", e)
                    }
                } else {
                    console.error("Search failed:", xhr.status, xhr.statusText)
                }
            }
        }
        xhr.open("GET", url)
        xhr.send()
    }
}
