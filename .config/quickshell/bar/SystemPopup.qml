import QtQuick
import qs
import qs.components
import qs.services

HoverPopup {
    id: root

    padding: 14

    function formatUptime(seconds: real): string {
        const d = Math.floor(seconds / 86400);
        const h = Math.floor(seconds % 86400 / 3600);
        const m = Math.floor(seconds % 3600 / 60);
        return (d > 0 ? `${d}d ` : "") + `${h}h ${m}m`;
    }

    Column {
        width: 270
        spacing: 12

        Column {
            width: parent.width
            spacing: 6

            Row {
                width: parent.width

                StyledText {
                    width: parent.width / 2
                    text: `${Icons.cpu}  CPU`
                    color: Theme.blue
                }

                StyledText {
                    width: parent.width / 2
                    horizontalAlignment: Text.AlignRight
                    text: `${Math.round(SystemStats.cpu * 100)}%  ·  ${Math.round(SystemStats.temperature)}°C`
                }
            }

            Canvas {
                id: graph

                width: parent.width
                height: 44

                onPaint: {
                    const ctx = getContext("2d");
                    const data = SystemStats.cpuHistory;
                    const n = SystemStats.historyLength;
                    ctx.reset();
                    ctx.fillStyle = Theme.alpha(Theme.text, 0.04);
                    ctx.fillRect(0, 0, width, height);
                    if (data.length < 2)
                        return;
                    const step = width / (n - 1);
                    const x0 = width - (data.length - 1) * step;
                    const y = v => height - 1 - v * (height - 2);
                    ctx.beginPath();
                    ctx.moveTo(x0, height);
                    data.forEach((v, i) => ctx.lineTo(x0 + i * step, y(v)));
                    ctx.lineTo(width, height);
                    ctx.closePath();
                    ctx.fillStyle = Theme.alpha(Theme.blue, 0.2);
                    ctx.fill();
                    ctx.beginPath();
                    data.forEach((v, i) => i === 0 ? ctx.moveTo(x0, y(v)) : ctx.lineTo(x0 + i * step, y(v)));
                    ctx.lineWidth = 1.5;
                    ctx.strokeStyle = Theme.blue;
                    ctx.stroke();
                }

                Connections {
                    target: SystemStats
                    enabled: root.visible
                    function onCpuHistoryChanged() {
                        graph.requestPaint();
                    }
                }

                Connections {
                    target: root
                    function onVisibleChanged() {
                        if (root.visible)
                            graph.requestPaint();
                    }
                }
            }
        }

        Column {
            width: parent.width
            spacing: 6

            Row {
                width: parent.width

                StyledText {
                    width: parent.width / 2
                    text: `${Icons.memory}  Memory`
                    color: Theme.violet
                }

                StyledText {
                    width: parent.width / 2
                    horizontalAlignment: Text.AlignRight
                    text: `${SystemStats.gib(SystemStats.memUsed)} / ${SystemStats.gib(SystemStats.memTotal)} GiB`
                }
            }

            Meter {
                width: parent.width
                value: SystemStats.memTotal > 0 ? SystemStats.memUsed / SystemStats.memTotal : 0
                fillColor: Theme.violet
            }

            Row {
                visible: SystemStats.swapTotal > 0
                width: parent.width

                StyledText {
                    width: parent.width / 2
                    text: "Swap"
                    color: Theme.subtext0
                    font.weight: Font.Medium
                }

                StyledText {
                    width: parent.width / 2
                    horizontalAlignment: Text.AlignRight
                    text: `${SystemStats.gib(SystemStats.swapUsed)} / ${SystemStats.gib(SystemStats.swapTotal)} GiB`
                    color: Theme.subtext0
                    font.weight: Font.Medium
                }
            }

            Meter {
                visible: SystemStats.swapTotal > 0
                width: parent.width
                value: SystemStats.swapTotal > 0 ? SystemStats.swapUsed / SystemStats.swapTotal : 0
                fillColor: Theme.alpha(Theme.violet, 0.5)
            }
        }

        Row {
            width: parent.width

            StyledText {
                width: parent.width / 2
                text: `Load ${SystemStats.loadAverage.map(v => v.toFixed(2)).join(" ")}`
                color: Theme.subtext0
                font.weight: Font.Medium
            }

            StyledText {
                width: parent.width / 2
                horizontalAlignment: Text.AlignRight
                text: `Up ${root.formatUptime(SystemStats.uptime)}`
                color: Theme.subtext0
                font.weight: Font.Medium
            }
        }

        Rectangle {
            visible: Updates.available
            width: parent.width
            height: 1
            color: Theme.popupBorder
        }

        Column {
            visible: Updates.available
            width: parent.width
            spacing: 4

            StyledText {
                text: Updates.count > 0 ? `${Icons.packageUp}  ${Updates.count} update${Updates.count === 1 ? "" : "s"} available` : `${Icons.packageOk}  System is up to date`
                color: Updates.count > 0 ? Theme.orange : Theme.subtext0
            }

            Repeater {
                model: Updates.packages.slice(0, 10)

                StyledText {
                    required property string modelData

                    width: parent.width
                    elide: Text.ElideRight
                    text: modelData
                    color: Theme.subtext1
                    font.weight: Font.Normal
                    font.pixelSize: Theme.fontSize - 1
                }
            }

            StyledText {
                visible: Updates.count > 10
                text: `… and ${Updates.count - 10} more`
                color: Theme.overlay1
                font.weight: Font.Normal
                font.pixelSize: Theme.fontSize - 1
            }

            StyledText {
                visible: Updates.count > 0
                topPadding: 4
                text: "Click the package icon to upgrade"
                color: Theme.overlay1
                font.weight: Font.Normal
                font.pixelSize: Theme.fontSize - 1
            }
        }
    }
}
