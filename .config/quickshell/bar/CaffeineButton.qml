import QtQuick
import qs
import qs.components
import qs.services

BarButton {
    icon: Caffeine.enabled ? Icons.coffee : Icons.coffeeOff
    iconColor: Caffeine.enabled ? Theme.peach : Theme.overlay1
    highlighted: Caffeine.enabled
    tooltip: Caffeine.enabled ? "Caffeine on — screen won't idle or lock" : "Caffeine off — click to keep the screen awake"
    onClicked: Caffeine.enabled = !Caffeine.enabled
}
