import QtQuick
import qs

Rectangle {
    id: root

    default property alias content: row.data
    property alias spacing: row.spacing
    property int padding: 3

    implicitHeight: Theme.barHeight
    implicitWidth: row.implicitWidth + padding * 2
    radius: Theme.radius
    color: Theme.pill
    border.width: 1
    border.color: Theme.pillBorder

    Row {
        id: row
        anchors.centerIn: parent
    }
}
