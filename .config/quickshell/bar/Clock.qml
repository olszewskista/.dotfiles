import Quickshell
import QtQuick
import qs
import qs.components

Pill {
    id: root

    property bool expanded: false

    SystemClock {
        id: clock
        precision: root.expanded ? SystemClock.Seconds : SystemClock.Minutes
    }

    BarButton {
        id: button

        horizontalPadding: 8
        icon: Icons.clock
        iconColor: Theme.pink
        text: root.expanded ? clock.date.toLocaleString(Qt.locale(), "dddd, d MMMM yyyy  HH:mm:ss") : clock.date.toLocaleString(Qt.locale(), "HH:mm")
        onClicked: root.expanded = !root.expanded
        onScrolled: steps => calendar.monthOffset -= steps

        StyledText {
            anchors.verticalCenter: parent.verticalCenter
            visible: !root.expanded
            text: clock.date.toLocaleString(Qt.locale(), "ddd d MMM")
            color: Theme.subtext0
            font.weight: Font.Medium
        }
    }

    CalendarPopup {
        id: calendar
        target: root
        hoverTarget: button.hovered
    }
}
