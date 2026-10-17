import QtQuick
import qs

Rectangle {
    id: root

    property real value: 0
    property color fillColor: Theme.accent

    implicitHeight: 5
    radius: height / 2
    color: Theme.track

    Rectangle {
        height: parent.height
        width: parent.width * Math.max(0, Math.min(1, root.value))
        radius: parent.radius
        color: root.fillColor

        Behavior on width {
            NumberAnimation {
                duration: Theme.animNormal
                easing.type: Easing.OutCubic
            }
        }
    }
}
