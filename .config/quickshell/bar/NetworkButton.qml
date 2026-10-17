import Quickshell
import Quickshell.Io
import Quickshell.Networking
import QtQuick
import qs
import qs.components

BarButton {
    id: root

    readonly property var devices: Networking.devices.values
    readonly property var wired: devices.find(d => d.type === DeviceType.Wired && d.connected) ?? null
    readonly property var wifi: devices.find(d => d.type === DeviceType.Wifi) ?? null
    readonly property var wifiNetwork: wifi?.networks.values.find(n => n.connected) ?? null
    readonly property var device: wired ?? (wifiNetwork ? wifi : null)
    readonly property real signal: wifiNetwork?.signalStrength ?? 0
    property bool showBandwidth: false
    property string address: ""
    property real rxRate: 0
    property real txRate: 0
    property var lastSample: null

    function formatRate(bytes: real): string {
        const units = ["B", "kB", "MB", "GB"];
        let i = 0;
        while (bytes >= 1000 && i < units.length - 1) {
            bytes /= 1000;
            i++;
        }
        return `${bytes.toFixed(bytes < 10 && i > 0 ? 1 : 0)} ${units[i]}/s`;
    }

    function sample(data: string) {
        const line = data.split("\n").find(l => l.trim().startsWith(`${device?.name}:`));
        if (!line)
            return;
        const fields = line.split(":")[1].trim().split(/\s+/).map(Number);
        const now = Date.now();
        if (lastSample) {
            const dt = (now - lastSample.time) / 1000;
            rxRate = Math.max(0, (fields[0] - lastSample.rx) / dt);
            txRate = Math.max(0, (fields[8] - lastSample.tx) / dt);
        }
        lastSample = {
            time: now,
            rx: fields[0],
            tx: fields[8]
        };
    }

    onDeviceChanged: {
        lastSample = null;
        rxRate = 0;
        txRate = 0;
        address = "";
    }
    onHoveredChanged: {
        if (hovered && device) {
            addressProc.command = ["ip", "-4", "-o", "addr", "show", "dev", device.name];
            addressProc.running = true;
        }
    }

    icon: wired ? Icons.ethernet : wifiNetwork ? Icons.pick(Icons.wifi, signal) : Icons.wifiOff
    iconColor: device ? Theme.sky : Theme.critical
    text: showBandwidth && device ? `${Icons.download} ${formatRate(rxRate)}  ${Icons.upload} ${formatRate(txRate)}` : ""
    tooltip: {
        if (!device)
            return "Disconnected\nRight-click for network settings";
        const lines = [wired ? `Ethernet · ${device.name}` : `${wifiNetwork.name} · ${Math.round(signal * 100)}%`];
        if (address)
            lines.push(`${address} on ${device.name}`);
        lines.push(`${Icons.download} ${formatRate(rxRate)}   ${Icons.upload} ${formatRate(txRate)}`);
        lines.push("Click: toggle speed · Right-click: settings");
        return lines.join("\n");
    }
    onClicked: button => {
        if (button === Qt.RightButton)
            Quickshell.execDetached(["nm-connection-editor"]);
        else
            showBandwidth = !showBandwidth;
    }

    Timer {
        interval: 2000
        repeat: true
        triggeredOnStart: true
        running: root.device !== null && (root.showBandwidth || root.hovered)
        onTriggered: netDev.reload()
    }

    FileView {
        id: netDev
        path: "/proc/net/dev"
        onLoaded: root.sample(text())
    }

    Process {
        id: addressProc
        stdout: StdioCollector {
            onStreamFinished: root.address = text.match(/inet (\S+)/)?.[1] ?? ""
        }
    }
}
