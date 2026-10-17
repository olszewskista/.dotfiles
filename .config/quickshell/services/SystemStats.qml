pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property int historyLength: 45
    property real cpu: 0
    property var cpuHistory: []
    property real temperature: 0
    // KiB, as reported by /proc/meminfo
    property real memTotal: 0
    property real memUsed: 0
    property real swapTotal: 0
    property real swapUsed: 0
    property var loadAverage: [0, 0, 0]
    property real uptime: 0
    property string temperaturePath: ""
    property var lastCpu: null

    function gib(kib: real): string {
        return (kib / 1048576).toFixed(1);
    }

    function parseStat(data: string) {
        const match = data.match(/^cpu\s+(.+)$/m);
        if (!match)
            return;
        const v = match[1].trim().split(/\s+/).map(Number);
        const idle = v[3] + (v[4] || 0);
        const total = v.slice(0, 8).reduce((a, b) => a + b, 0);
        if (lastCpu && total > lastCpu.total) {
            cpu = 1 - (idle - lastCpu.idle) / (total - lastCpu.total);
            cpuHistory = cpuHistory.concat([cpu]).slice(-historyLength);
        }
        lastCpu = {
            total,
            idle
        };
    }

    function parseMeminfo(data: string) {
        const get = key => {
            const m = data.match(new RegExp(`^${key}:\\s+(\\d+)`, "m"));
            return m ? Number(m[1]) : 0;
        };
        memTotal = get("MemTotal");
        memUsed = memTotal - get("MemAvailable");
        swapTotal = get("SwapTotal");
        swapUsed = swapTotal - get("SwapFree");
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            stat.reload();
            meminfo.reload();
            loadavg.reload();
            uptimeFile.reload();
            if (root.temperaturePath)
                temperatureFile.reload();
        }
    }

    FileView {
        id: stat
        path: "/proc/stat"
        onLoaded: root.parseStat(text())
    }

    FileView {
        id: meminfo
        path: "/proc/meminfo"
        onLoaded: root.parseMeminfo(text())
    }

    FileView {
        id: loadavg
        path: "/proc/loadavg"
        onLoaded: root.loadAverage = text().split(" ").slice(0, 3).map(Number)
    }

    FileView {
        id: uptimeFile
        path: "/proc/uptime"
        onLoaded: root.uptime = Number(text().split(" ")[0])
    }

    FileView {
        id: temperatureFile
        path: root.temperaturePath
        onLoaded: root.temperature = Number(text()) / 1000
    }

    // Prefer the CPU package sensor over the generic ACPI thermal zone.
    Process {
        running: true
        command: ["sh", "-c", `
            for d in /sys/class/hwmon/hwmon*; do
                case "$(cat "$d/name")" in
                    k10temp|zenpower|coretemp|cpu_thermal) echo "$d/temp1_input"; exit ;;
                esac
            done
            echo /sys/class/thermal/thermal_zone0/temp`]
        stdout: StdioCollector {
            onStreamFinished: root.temperaturePath = text.trim()
        }
    }
}
