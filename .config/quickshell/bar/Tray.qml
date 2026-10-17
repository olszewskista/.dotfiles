import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import qs
import qs.components

Row {
    id: root

    readonly property int visibleCount: SystemTray.items.values.filter(i => i.status !== Status.Passive).length

    visible: visibleCount > 0

    Repeater {
        model: SystemTray.items

        Item {
            id: trayItem

            required property SystemTrayItem modelData

            visible: modelData.status !== Status.Passive
            implicitWidth: Theme.barHeight - 4
            implicitHeight: Theme.barHeight - 6

            Rectangle {
                anchors.fill: parent
                radius: Theme.innerRadius
                color: mouse.containsMouse ? Theme.hover : "transparent"

                Behavior on color {
                    ColorAnimation {
                        duration: Theme.animFast
                    }
                }
            }

            IconImage {
                anchors.centerIn: parent
                implicitSize: 15
                source: {
                    // Some apps (Electron, Spotify) send "name?path=/dir" instead of a resolvable icon.
                    const icon = trayItem.modelData.icon;
                    if (!icon.includes("?path=")) return icon;
                    const [name, path] = icon.split("?path=");
                    return `file://${path}/${name.slice(name.lastIndexOf("/") + 1)}`;
                }
            }

            QsMenuAnchor {
                id: menu
                menu: trayItem.modelData.menu
                anchor.item: trayItem
                anchor.rect.width: trayItem.width
                anchor.rect.height: trayItem.height + 6
                anchor.edges: Edges.Bottom
                anchor.gravity: Edges.Bottom
            }

            MouseArea {
                id: mouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                onClicked: event => {
                    const item = trayItem.modelData;
                    if (event.button === Qt.MiddleButton)
                        item.secondaryActivate();
                    else if (event.button === Qt.RightButton || item.onlyMenu) {
                        if (item.hasMenu)
                            menu.open();
                    } else
                        item.activate();
                }
                onWheel: event => trayItem.modelData.scroll(event.angleDelta.y / 120, false)
            }

            Tooltip {
                target: trayItem
                hoverTarget: mouse.containsMouse && !menu.visible
                text: trayItem.modelData.tooltipTitle || trayItem.modelData.title || trayItem.modelData.id
            }
        }
    }
}
