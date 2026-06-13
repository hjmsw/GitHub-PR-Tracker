import QtQuick
import QtQuick.Layouts

Rectangle {
    required property var modelData
    Layout.fillWidth: true
    implicitHeight: prColumn.height + 60
    color: mouseZone.containsMouse ? "#2d333b" : "#1f242c"
    radius: 5
    border.color: mouseZone.containsMouse ? "#58a6ff" : "#30363d"
    border.width: 1

    MouseArea {
        id: mouseZone
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (modelData.url) {
                Qt.openUrlExternally(modelData.url);
            }
        }
    }

    ColumnLayout {
        id: prColumn
        anchors.fill: parent
        anchors.margins: 8
        spacing: 4

        RowLayout {
            Layout.fillWidth: true

            Text {
                text: "#" + modelData.number
                color: "#8b949e"
                font.pixelSize: 11
            }

            Text {
                text: modelData.reviewDecision !== "" ? "[" + modelData.reviewDecision.replace("_", " ") + "]" : "[UNREVIEWED]"
                font.bold: true
                font.pixelSize: 11
                color: {
                    switch (modelData.reviewDecision) {
                        case "APPROVED":       return "#238636";
                        case "REVIEW_REQUIRED":return "#e77d22";
                        case "CHANGES_REQUESTED": return "#c21807";
                        default:               return "#8b949e";
                    }
                }
            }

            Text {
                text: "[" + modelData.mergeable + "]"
                font.bold: true
                font.pixelSize: 11
                color: modelData.mergeable === "CONFLICTING" ? "#c21807" : "#238636"
            }
        }

        Text {
            text: modelData.title
            color: "#c9d1d9"
            font.bold: true
            font.pixelSize: 13
            wrapMode: Text.Wrap
            maximumLineCount: 2
            elide: Text.ElideRight
            Layout.fillWidth: true
        }

        RowLayout {
            Text { text: "Merging:";              color: "#8b949e"; font.pixelSize: 11 }
            Text { text: modelData.headRefName;   color: "#8b949e"; font.pixelSize: 11; font.bold: true }
            Text { text: "into:";                 color: "#8b949e"; font.pixelSize: 11 }
            Text { text: modelData.baseRefName;   color: "#8b949e"; font.pixelSize: 11; font.bold: true }
        }

        RowLayout {
            Text {
                text: "Opened by @" + modelData.author.login + " at: " + ((new Date(modelData.createdAt)).toLocaleString(Qt.locale()))
                color: "#8b949e"
                font.pixelSize: 11
            }

            Item { Layout.fillWidth: true }

            RowLayout {
                Text { text: "+" + modelData.additions; font.bold: true; font.pixelSize: 11; color: "#238636" }
                Text { text: "-" + modelData.deletions;  font.bold: true; font.pixelSize: 11; color: "#c21807" }
            }
        }
    }
}
