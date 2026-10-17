import Quickshell
import QtQuick
import qs
import qs.components
import qs.services

Pill {
    id: root

    function openMonitor() {
        Quickshell.execDetached(["kitty", "btop"]);
    }

    FontMetrics {
        id: metrics
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        font.weight: Font.DemiBold
    }

    BarButton {
        icon: Icons.cpu
        iconColor: Theme.blue
        text: `${Math.round(SystemStats.cpu * 100)}%`
        textMinWidth: metrics.advanceWidth("00%")
        onClicked: root.openMonitor()
    }

    BarButton {
        icon: Icons.memory
        iconColor: Theme.red
        text: `${SystemStats.gib(SystemStats.memUsed)}G`
        textMinWidth: metrics.advanceWidth("00.0G")
        onClicked: root.openMonitor()
    }

    BarButton {
        readonly property real t: SystemStats.temperature

        icon: t >= 80 ? Icons.thermometerHigh : Icons.thermometer
        iconColor: t >= 85 ? Theme.red : t >= 70 ? Theme.peach : Theme.teal
        textColor: t >= 85 ? Theme.red : Theme.text
        text: `${Math.round(t)}°C`
        onClicked: root.openMonitor()
    }

    BarButton {
        visible: Updates.available
        icon: Updates.count > 0 ? Icons.packageUp : Icons.packageOk
        iconColor: Updates.count > 0 ? Theme.peach : Theme.overlay1
        text: Updates.count > 0 ? String(Updates.count) : ""
        onClicked: Updates.upgrade()
    }

    HoverHandler {
        id: hover
    }

    SystemPopup {
        target: root
        hoverTarget: hover.hovered
    }
}
