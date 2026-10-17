import Quickshell
import Quickshell.Services.Pipewire
import QtQuick
import qs
import qs.components

BarButton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property int percent: Math.round(volume * 100)
    readonly property bool headphones: {
        const props = sink?.properties ?? {};
        const hint = `${props["device.form-factor"] ?? ""} ${props["device.icon-name"] ?? ""} ${sink?.name ?? ""}`;
        return /head(phone|set)|bluez/.test(hint);
    }

    visible: sink !== null
    icon: muted ? Icons.volumeMute : headphones ? Icons.headphones : volume > 0.66 ? Icons.volumeHigh : volume > 0.33 ? Icons.volumeMedium : Icons.volumeLow
    iconColor: muted ? Theme.critical : Theme.green
    text: muted ? "" : `${percent}%`
    tooltip: `${sink?.description || sink?.name || "No output"} · ${muted ? "muted" : `${percent}%`}\nClick: mixer · Right-click: mute`
    onClicked: button => {
        if (button === Qt.RightButton)
            sink.audio.muted = !muted;
        else
            Quickshell.execDetached(["pavucontrol", "-t", "3"]);
    }
    onScrolled: steps => {
        if (sink?.audio)
            sink.audio.volume = Math.max(0, Math.min(1, Math.round((volume + steps * 0.05) * 100) / 100));
    }

    PwObjectTracker {
        objects: [root.sink]
    }
}
