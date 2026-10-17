import QtQuick
import qs
import qs.components
import qs.services

BarButton {
    readonly property int percent: Math.round(Brightness.level * 100)

    visible: Brightness.available
    icon: Icons.pick(Icons.brightness, Brightness.level)
    iconColor: Theme.yellow
    text: `${percent}%`
    tooltip: `Brightness ${percent}%\nScroll to adjust`
    onScrolled: steps => Brightness.change(steps)
}
