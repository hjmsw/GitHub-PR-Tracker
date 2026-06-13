import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import prtracker

Dialog {
    id: settingsDialog
    title: "Settings"
    modal: true
    anchors.centerIn: Overlay.overlay
    width: 380
    height: 300
    padding: 0

    background: Rectangle {
        color: "#161b22"
        border.color: "#30363d"
        border.width: 1
        radius: 6
    }

    contentItem: ColumnLayout {
        spacing: 0
        ColumnLayout {
            spacing: 16
            Layout.margins: 20

            GridLayout {
                columns: 2
                columnSpacing: 12
                rowSpacing: 12
                Layout.fillWidth: true

                Text {
                    text: "Working directory:"
                    color: "#8b949e"
                    font.pixelSize: 13
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                }

                TextField {
                    id: directoryField
                    text: PrFetcher.workingDirectory
                    placeholderText: "/path/to/repo"
                    Layout.fillWidth: true
                    color: "#c9d1d9"
                    font.pixelSize: 13
                    placeholderTextColor: "#484f58"
                    background: Rectangle {
                        color: "#0d1117"
                        border.color: directoryField.activeFocus ? "#58a6ff" : "#30363d"
                        border.width: 1
                        radius: 4
                    }
                    leftPadding: 8
                    rightPadding: 8
                }

                Text {
                    text: "Show tabs:"
                    color: "#8b949e"
                    font.pixelSize: 13
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                }

                ColumnLayout {
                    spacing: 6

                    ThemedCheckBox {
                        id: showMyPRsCheck
                        text: "My PRs"
                        checked: PrFetcher.showMyPRs
                    }

                    ThemedCheckBox {
                        id: showReviewRequestedCheck
                        text: "Review Requested"
                        checked: PrFetcher.showReviewRequested
                    }
                }
            }
        }
    }

    footer: Item {
        height: 56

        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 1
            anchors.rightMargin: 1
            height: 1
            color: "#30363d"
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            spacing: 8

            Item { Layout.fillWidth: true }

            Button {
                text: "Cancel"
                onClicked: settingsDialog.reject()
                contentItem: Text {
                    text: parent.text
                    color: "#c9d1d9"
                    font.pixelSize: 13
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: parent.parent.hovered ? "#30363d" : "transparent"
                    border.color: "#30363d"
                    border.width: 1
                    radius: 4
                }
                leftPadding: 16; rightPadding: 16
                topPadding: 6; bottomPadding: 6
            }

            Button {
                text: "Apply"
                onClicked: {
                    PrFetcher.workingDirectory = directoryField.text;
                    PrFetcher.showMyPRs = showMyPRsCheck.checked;
                    PrFetcher.showReviewRequested = showReviewRequestedCheck.checked;
                    settingsDialog.accept();
                }
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 13
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: parent.parent.hovered ? "#2ea043" : "#238636"
                    radius: 4
                }
                leftPadding: 16; rightPadding: 16
                topPadding: 6; bottomPadding: 6
            }
        }
    }
}
