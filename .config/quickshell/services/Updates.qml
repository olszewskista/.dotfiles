pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// Reuses the `waybar-updates` checker; it streams one JSON object per check.
Singleton {
    id: root

    property bool available: false
    property int count: 0
    property var packages: []

    function upgrade() {
        Quickshell.execDetached(["kitty", "sh", "-c", "paru && read -p done!"]);
    }

    function parse(line: string) {
        let data;
        try {
            data = JSON.parse(line);
        } catch (e) {
            return;
        }
        available = true;
        count = parseInt(data.text) || 0;
        packages = (data.tooltip || "").split(/[\n\r]/).map(s => s.trim()).filter(s => s.includes(" -> "));
    }

    Process {
        id: checker
        running: true
        command: ["waybar-updates"]
        stdout: SplitParser {
            onRead: line => root.parse(line)
        }
        onExited: restartTimer.start()
    }

    Timer {
        id: restartTimer
        interval: 60000
        onTriggered: checker.running = true
    }
}
