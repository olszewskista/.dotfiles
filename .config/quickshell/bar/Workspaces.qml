import Quickshell
import Quickshell.Hyprland
import QtQuick
import qs
import qs.components

Pill {
    id: root

    required property ShellScreen screen
    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(screen)
    readonly property var workspaces: Hyprland.workspaces.values.filter(w => w.id > 0 && w.monitor === monitor).sort((a, b) => a.id - b.id)

    spacing: 2
    padding: 3

    function cycle(steps: int) {
        const list = workspaces;
        const index = list.indexOf(monitor?.activeWorkspace);
        const target = list[Math.max(0, Math.min(list.length - 1, index - steps))];
        if (target && target !== monitor.activeWorkspace)
            target.activate();
    }

    Repeater {
        model: ScriptModel {
            values: root.workspaces
        }

        Item {
            id: button

            required property HyprlandWorkspace modelData
            readonly property bool active: root.monitor?.activeWorkspace === modelData
            readonly property bool occupied: (modelData.toplevels?.values.length ?? 0) > 0

            implicitHeight: Theme.barHeight - 6
            implicitWidth: active ? 34 : 24

            Behavior on implicitWidth {
                NumberAnimation {
                    duration: Theme.animNormal
                    easing.type: Easing.OutCubic
                }
            }

            Rectangle {
                anchors.fill: parent
                radius: Theme.innerRadius
                color: button.modelData.urgent ? Theme.red : button.active ? (button.modelData.focused ? Theme.accent : Theme.alpha(Theme.accent, 0.55)) : mouse.containsMouse ? Theme.hover : "transparent"

                Behavior on color {
                    ColorAnimation {
                        duration: Theme.animNormal
                    }
                }
            }

            StyledText {
                anchors.centerIn: parent
                text: button.modelData.name
                color: button.active || button.modelData.urgent ? Theme.crust : button.occupied ? Theme.text : Theme.overlay1
                font.weight: button.active ? Font.Bold : Font.DemiBold

                Behavior on color {
                    ColorAnimation {
                        duration: Theme.animNormal
                    }
                }
            }

            MouseArea {
                id: mouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: button.modelData.activate()
            }
        }
    }

    WheelHandler {
        property real accumulator: 0

        target: null
        onWheel: event => {
            accumulator += event.angleDelta.y;
            const steps = Math.trunc(accumulator / 120);
            if (steps !== 0) {
                accumulator -= steps * 120;
                root.cycle(steps);
            }
        }
    }
}
