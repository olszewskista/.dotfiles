import QtQuick
import qs

// Icon + optional label with hover feedback, click and accumulated wheel steps.
Item {
    id: root

    default property alias extra: row.data
    property string icon: ""
    property string text: ""
    property color iconColor: Theme.icon
    property color textColor: Theme.text
    property int iconSize: Theme.iconSize
    property real textMinWidth: 0
    property bool highlighted: false
    property string tooltip: ""
    property int horizontalPadding: 6
    readonly property bool hovered: mouse.containsMouse

    signal clicked(int button)
    signal scrolled(int steps)

    implicitHeight: Theme.barHeight - 6
    implicitWidth: row.implicitWidth + horizontalPadding * 2

    Rectangle {
        anchors.fill: parent
        radius: Theme.innerRadius
        color: root.hovered || root.highlighted ? Theme.hover : "transparent"

        Behavior on color {
            ColorAnimation {
                duration: Theme.animFast
            }
        }
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 5

        StyledText {
            anchors.verticalCenter: parent.verticalCenter
            visible: text.length > 0
            text: root.icon
            color: root.iconColor
            font.pixelSize: root.iconSize

            Behavior on color {
                ColorAnimation {
                    duration: Theme.animNormal
                }
            }
        }

        StyledText {
            anchors.verticalCenter: parent.verticalCenter
            visible: text.length > 0
            width: Math.max(implicitWidth, root.textMinWidth)
            horizontalAlignment: Text.AlignRight
            text: root.text
            color: root.textColor
        }
    }

    MouseArea {
        id: mouse

        property real wheelAccumulator: 0

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onClicked: event => root.clicked(event.button)
        onWheel: event => {
            wheelAccumulator += event.angleDelta.y;
            const steps = Math.trunc(wheelAccumulator / 120);
            if (steps !== 0) {
                wheelAccumulator -= steps * 120;
                root.scrolled(steps);
            }
        }
    }

    Tooltip {
        target: root
        hoverTarget: root.hovered
        active: root.tooltip.length > 0
        text: root.tooltip
    }
}
