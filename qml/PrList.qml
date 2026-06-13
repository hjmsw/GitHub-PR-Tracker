import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    required property var pullRequests
    required property bool loading

    Layout.fillWidth: true
    Layout.fillHeight: true

    BusyIndicator {
        anchors.centerIn: parent
        running: loading
        visible: loading
    }

    Flickable {
        anchors.fill: parent
        contentWidth: width
        contentHeight: contentColumn.implicitHeight
        clip: true
        visible: !loading

        ColumnLayout {
            id: contentColumn
            width: parent.width
            spacing: 8

            Text {
                text: "No matching Pull Requests tracked."
                color: "#8b949e"
                font.italic: true
                visible: pullRequests.length === 0
            }

            Repeater {
                model: pullRequests
                delegate: PrCard {}
            }
        }

        ScrollBar.vertical: ScrollBar {
            opacity: active || hovered ? 1.0 : 0.0
            Behavior on opacity {
                NumberAnimation { duration: 300 }
            }
        }
    }
}
