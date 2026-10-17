import QtQuick
import Quickshell.Services.UPower
import qs
import qs.components

BarButton {
    id: root

    readonly property UPowerDevice battery: UPower.displayDevice
    readonly property real level: battery.percentage
    readonly property int percent: Math.round(level * 100)
    readonly property bool charging: battery.state === UPowerDeviceState.Charging
    readonly property bool pluggedIn: !UPower.onBattery
    readonly property real secondsLeft: charging ? battery.timeToFull : battery.timeToEmpty
    property bool showTime: false

    function formatDuration(seconds: real): string {
        const h = Math.floor(seconds / 3600);
        const m = Math.round(seconds % 3600 / 60);
        return h > 0 ? `${h}h ${m}m` : `${m}m`;
    }

    function profileName(profile: int): string {
        return ["Power saver", "Balanced", "Performance"][profile] ?? "Unknown";
    }

    function cycleProfile() {
        const order = [PowerProfile.PowerSaver, PowerProfile.Balanced];
        if (PowerProfiles.hasPerformanceProfile)
            order.push(PowerProfile.Performance);
        PowerProfiles.profile = order[(order.indexOf(PowerProfiles.profile) + 1) % order.length];
    }

    visible: battery.ready && battery.isLaptopBattery
    icon: charging ? Icons.batteryCharging : pluggedIn ? Icons.plug : Icons.pick(Icons.battery, level)
    iconColor: charging ? Theme.success : percent <= 15 ? Theme.critical : percent <= 30 ? Theme.warning : Theme.text
    textColor: !charging && percent <= 15 ? Theme.critical : Theme.text
    text: showTime && secondsLeft > 0 ? formatDuration(secondsLeft) : `${percent}%`
    tooltip: {
        const lines = [];
        if (charging)
            lines.push(`Charging · ${percent}%` + (secondsLeft > 0 ? ` · full in ${formatDuration(secondsLeft)}` : ""));
        else if (pluggedIn)
            lines.push(`Plugged in · ${percent}%`);
        else
            lines.push(`On battery · ${percent}%` + (secondsLeft > 0 ? ` · ${formatDuration(secondsLeft)} left` : ""));
        if (Math.abs(battery.changeRate) > 0.1)
            lines.push(`Power draw ${Math.abs(battery.changeRate).toFixed(1)} W`);
        lines.push(`Profile: ${profileName(PowerProfiles.profile)} (right-click to switch)`);
        return lines.join("\n");
    }
    onClicked: button => {
        if (button === Qt.RightButton)
            cycleProfile();
        else
            showTime = !showTime;
    }
}
