import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import prtracker

ApplicationWindow {
    id: root
    title: "🐱 Pull Request Tracker"
    minimumWidth: 550
    minimumHeight: 600
    visible: true

    color: "#0d1117"

    property bool showTabs: PrFetcher.showMyPRs || PrFetcher.showReviewRequested

    property var tabLabels: {
        var labels = ["All PRs"];
        if (PrFetcher.showMyPRs) labels.push("My PRs");
        if (PrFetcher.showReviewRequested) labels.push("Review Requested");
        return labels;
    }

    property var tabToStackIndex: {
        var map = [0];
        if (PrFetcher.showMyPRs) map.push(1);
        if (PrFetcher.showReviewRequested) map.push(2);
        return map;
    }

    // Settings dialog
    SettingsDialog {
        id: settingsDialog
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 0

        // Header row
        RowLayout {
            Layout.fillWidth: true

            Text {
                text: PrFetcher.repoTitle
                color: "#58a6ff"
                font.bold: true
                font.pixelSize: 16
                padding: 4
                bottomPadding: 8
                Layout.fillWidth: true
            }

            // Error indicator
            Text {
                visible: PrFetcher.lastError !== ""
                text: "⚠"
                color: "#e77d22"
                font.pixelSize: 16
                ToolTip.text: PrFetcher.lastError
                ToolTip.visible: errorMouseArea.containsMouse
                ToolTip.delay: 300
                padding: 4

                MouseArea {
                    id: errorMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                }
            }

            // Refresh button
            Button {
                text: "↻"
                flat: true
                font.pixelSize: 16
                implicitWidth: 32
                implicitHeight: 32
                ToolTip.text: "Refresh"
                ToolTip.visible: hovered
                ToolTip.delay: 300
                onClicked: PrFetcher.refresh()

                contentItem: Text {
                    text: parent.text
                    color: parent.hovered ? "#58a6ff" : "#8b949e"
                    font: parent.font
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle { color: "transparent" }
            }

            // Settings button
            Button {
                text: "⚙"
                flat: true
                font.pixelSize: 26
                implicitWidth: 32
                implicitHeight: 32
                ToolTip.text: "Settings"
                ToolTip.visible: hovered
                ToolTip.delay: 300
                onClicked: settingsDialog.open()

                contentItem: Text {
                    text: parent.text
                    color: parent.hovered ? "#58a6ff" : "#8b949e"
                    font: parent.font
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle { color: "transparent" }
            }
        }

        TabBar {
            id: bar
            visible: root.showTabs
            Layout.fillWidth: true

            background: Rectangle { color: "#161b22" }

            Repeater {
                model: root.tabLabels
                TabButton {
                    text: modelData

                    contentItem: Text {
                        text: parent.text
                        color: parent.checked ? "#58a6ff" : "#8b949e"
                        font.pixelSize: 13
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        color: "transparent"
                        Rectangle {
                            anchors.bottom: parent.bottom
                            width: parent.width
                            height: 2
                            color: "#58a6ff"
                            visible: parent.parent.checked
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#161b22"
            border.color: "#30363d"
            border.width: 1
            radius: 4
            topLeftRadius: root.showTabs ? 0 : 4
            topRightRadius: root.showTabs ? 0 : 4

            StackLayout {
                anchors.fill: parent
                anchors.margins: 8
                currentIndex: root.tabToStackIndex[bar.currentIndex] || 0

                PrList { pullRequests: PrFetcher.allPullRequests;              loading: PrFetcher.allLoading }
                PrList { pullRequests: PrFetcher.myPullRequests;               loading: PrFetcher.myLoading }
                PrList { pullRequests: PrFetcher.reviewRequestedPullRequests;  loading: PrFetcher.reviewLoading }
            }
        }
    }
}
