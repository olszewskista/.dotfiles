pragma Singleton

import Quickshell
import QtQuick

Singleton {
    property alias enabled: persist.enabled

    PersistentProperties {
        id: persist
        reloadableId: "caffeine"

        property bool enabled: false
    }
}
