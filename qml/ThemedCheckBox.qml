import QtQuick
import QtQuick.Controls

CheckBox {
    id: control

    contentItem: Text {
        text: control.text
        color: "#c9d1d9"
        font.pixelSize: 13
        leftPadding: control.indicator.width + control.spacing
        verticalAlignment: Text.AlignVCenter
    }

    indicator: Rectangle {
        implicitWidth: 18
        implicitHeight: 18
        x: control.leftPadding
        y: control.topPadding + (control.availableHeight - height) / 2
        radius: 3
        color: control.checked ? "#238636" : "#0d1117"
        border.color: control.checked ? "#238636" : "#30363d"
        border.width: 1

        Text {
            anchors.centerIn: parent
            text: "✓"
            color: "white"
            font.pixelSize: 11
            font.bold: true
            visible: control.checked
        }
    }
}
