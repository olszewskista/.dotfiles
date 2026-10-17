import Quickshell
import QtQuick
import qs

// Card that drops below `target` while the target or the card itself is hovered.
PopupWindow {
    id: root

    required property Item target
    property bool hoverTarget: false
    property bool active: true
    property int openDelay: 250
    property int closeDelay: 180
    property int padding: 12
    property int gap: 6
    property bool open: false
    readonly property bool hovered: hover.hovered
    readonly property bool wanted: active && (hoverTarget || hovered)
    default property alias content: inner.data

    anchor.item: target
    anchor.rect.width: target.width
    anchor.rect.height: target.height
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom
    implicitWidth: card.implicitWidth
    implicitHeight: card.implicitHeight + gap + 6
    color: "transparent"
    visible: false

    onWantedChanged: {
        if (wanted) {
            closeTimer.stop();
            if (!open)
                openTimer.restart();
        } else {
            openTimer.stop();
            closeTimer.restart();
        }
    }
    onOpenChanged: {
        if (open)
            visible = true;
    }

    Timer {
        id: openTimer
        interval: root.openDelay
        onTriggered: root.open = true
    }

    Timer {
        id: closeTimer
        interval: root.closeDelay
        onTriggered: root.open = false
    }

    Item {
        anchors.fill: parent

        HoverHandler {
            id: hover
        }

        Rectangle {
            id: card

            anchors.horizontalCenter: parent.horizontalCenter
            y: root.gap + (root.open ? 0 : -6)
            implicitWidth: inner.implicitWidth + root.padding * 2
            implicitHeight: inner.implicitHeight + root.padding * 2
            radius: Theme.radius + 2
            color: Theme.popup
            border.width: 1
            border.color: Theme.popupBorder
            opacity: root.open ? 1 : 0

            onOpacityChanged: {
                if (opacity === 0 && !root.open)
                    root.visible = false;
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: Theme.animFast
                }
            }

            Behavior on y {
                NumberAnimation {
                    duration: Theme.animNormal
                    easing.type: Easing.OutCubic
                }
            }

            Item {
                id: inner
                x: root.padding
                y: root.padding
                implicitWidth: childrenRect.width
                implicitHeight: childrenRect.height
            }
        }
    }
}
