import Quickshell
import Quickshell.Wayland
import QtQuick
import qs
import qs.components
import qs.services

PanelWindow {
    id: bar

    required property ShellScreen modelData

    screen: modelData
    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: Theme.barHeight + Theme.barMargin * 2
    color: "transparent"
    WlrLayershell.namespace: "quickshell:bar"

    IdleInhibitor {
        window: bar
        enabled: Caffeine.enabled
    }

    Item {
        anchors {
            fill: parent
            margins: Theme.barMargin
        }

        Row {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.pillSpacing

            Hardware {}

            Media {}
        }

        Workspaces {
            anchors.centerIn: parent
            screen: bar.screen
        }

        Row {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.pillSpacing

            Pill {
                Tray {
                    id: tray
                }

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    visible: tray.visible
                    width: 1
                    height: Theme.barHeight - 14
                    color: Theme.pillBorder
                }

                CaffeineButton {}

                BrightnessButton {}

                BatteryButton {}

                NetworkButton {}

                VolumeButton {}
            }

            Clock {}
        }
    }
}
