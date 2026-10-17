pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string device: ""
    property int current: 0
    property int max: 0
    readonly property bool available: device.length > 0 && max > 0
    readonly property real level: max > 0 ? current / max : 0

    function change(steps: int) {
        const amount = `${Math.abs(steps) * 5}%${steps > 0 ? "+" : "-"}`;
        Quickshell.execDetached(["brightnessctl", "-q", "set", amount]);
        refreshTimer.restart();
    }

    Process {
        running: true
        command: ["sh", "-c", "ls -1 /sys/class/backlight | head -n1"]
        stdout: StdioCollector {
            onStreamFinished: root.device = text.trim()
        }
    }

    FileView {
        path: root.device ? `/sys/class/backlight/${root.device}/max_brightness` : ""
        onLoaded: root.max = parseInt(text())
    }

    FileView {
        id: currentFile
        path: root.device ? `/sys/class/backlight/${root.device}/brightness` : ""
        onLoaded: root.current = parseInt(text())
    }

    // sysfs doesn't emit inotify events, so external changes (keybinds) are polled.
    Timer {
        interval: 1000
        repeat: true
        running: root.available
        onTriggered: currentFile.reload()
    }

    Timer {
        id: refreshTimer
        interval: 120
        onTriggered: currentFile.reload()
    }
}
