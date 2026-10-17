import Quickshell
import QtQuick
import qs
import qs.components

HoverPopup {
    id: root

    property int monthOffset: 0
    readonly property date today: clock.date
    readonly property date month: new Date(today.getFullYear(), today.getMonth() + monthOffset, 1)
    readonly property int firstDay: Qt.locale().firstDayOfWeek
    readonly property int cellWidth: 32
    readonly property int cellHeight: 28
    readonly property var days: {
        const start = new Date(month);
        start.setDate(1 - (month.getDay() - firstDay + 7) % 7);
        return Array.from({
            length: 42
        }, (_, i) => new Date(start.getFullYear(), start.getMonth(), start.getDate() + i));
    }

    function isoWeek(d: date): int {
        const t = new Date(Date.UTC(d.getFullYear(), d.getMonth(), d.getDate()));
        t.setUTCDate(t.getUTCDate() + 4 - (t.getUTCDay() || 7));
        const yearStart = new Date(Date.UTC(t.getUTCFullYear(), 0, 1));
        return Math.ceil(((t - yearStart) / 86400000 + 1) / 7);
    }

    function sameDay(a: date, b: date): bool {
        return a.getFullYear() === b.getFullYear() && a.getMonth() === b.getMonth() && a.getDate() === b.getDate();
    }

    function capitalize(s: string): string {
        return s.charAt(0).toUpperCase() + s.slice(1);
    }

    padding: 14
    onOpenChanged: {
        if (!open)
            monthOffset = 0;
    }

    SystemClock {
        id: clock
        precision: SystemClock.Hours
    }

    Column {
        spacing: 10

        Column {
            spacing: 1

            StyledText {
                text: root.capitalize(root.today.toLocaleString(Qt.locale(), "dddd"))
                color: Theme.subtext0
                font.weight: Font.Medium
            }

            StyledText {
                text: root.today.toLocaleString(Qt.locale(), "d MMMM yyyy")
                font.pixelSize: Theme.fontSize + 6
                font.weight: Font.Bold
            }
        }

        Rectangle {
            width: grid.width
            height: 1
            color: Theme.popupBorder
        }

        Item {
            width: grid.width
            height: 26

            StyledText {
                anchors.left: parent.left
                anchors.leftMargin: 4
                anchors.verticalCenter: parent.verticalCenter
                text: `${root.capitalize(Qt.locale().standaloneMonthName(root.month.getMonth(), Locale.LongFormat))} ${root.month.getFullYear()}`
                color: Theme.text
                font.pixelSize: Theme.fontSize + 1
                font.weight: Font.Bold

                MouseArea {
                    anchors.fill: parent
                    cursorShape: root.monthOffset !== 0 ? Qt.PointingHandCursor : Qt.ArrowCursor
                    onClicked: root.monthOffset = 0
                }
            }

            Row {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                BarButton {
                    icon: Icons.chevronLeft
                    iconColor: Theme.subtext1
                    implicitHeight: 24
                    onClicked: root.monthOffset--
                }

                BarButton {
                    icon: Icons.chevronRight
                    iconColor: Theme.subtext1
                    implicitHeight: 24
                    onClicked: root.monthOffset++
                }
            }
        }

        Column {
            id: grid

            Row {
                Item {
                    width: root.cellWidth
                    height: root.cellHeight
                }

                Repeater {
                    model: 7

                    StyledText {
                        required property int index
                        readonly property int dow: (root.firstDay + index) % 7

                        width: root.cellWidth
                        height: root.cellHeight
                        horizontalAlignment: Text.AlignHCenter
                        text: root.capitalize(Qt.locale().dayName(dow, Locale.ShortFormat).replace(".", "").slice(0, 2))
                        color: dow === 0 || dow === 6 ? Theme.pink : Theme.subtext0
                        font.pixelSize: Theme.fontSize - 1
                    }
                }
            }

            Repeater {
                model: 6

                Item {
                    id: week

                    required property int index
                    readonly property var weekDays: root.days.slice(index * 7, index * 7 + 7)

                    width: root.cellWidth * 8
                    height: root.cellHeight

                    Row {
                        StyledText {
                            width: root.cellWidth
                            height: root.cellHeight
                            horizontalAlignment: Text.AlignHCenter
                            text: root.isoWeek(week.weekDays[3])
                            color: Theme.alpha(Theme.teal, 0.6)
                            font.pixelSize: Theme.fontSize - 2
                            font.weight: Font.Medium
                        }

                        Repeater {
                            model: week.weekDays

                            Item {
                                id: day

                                required property date modelData
                                readonly property bool isToday: root.sameDay(modelData, root.today)
                                readonly property bool inMonth: modelData.getMonth() === root.month.getMonth()
                                readonly property bool weekend: modelData.getDay() === 0 || modelData.getDay() === 6

                                width: root.cellWidth
                                height: root.cellHeight

                                Rectangle {
                                    anchors.centerIn: parent
                                    width: root.cellHeight - 2
                                    height: root.cellHeight - 2
                                    radius: Theme.innerRadius
                                    color: day.isToday ? Theme.pink : "transparent"
                                }

                                StyledText {
                                    anchors.centerIn: parent
                                    text: day.modelData.getDate()
                                    color: day.isToday ? Theme.crust : !day.inMonth ? Theme.surface2 : day.weekend ? Theme.subtext0 : Theme.text
                                    font.weight: day.isToday ? Font.Bold : Font.Medium
                                }
                            }
                        }
                    }
                }
            }
        }

        WheelHandler {
            property real accumulator: 0

            target: null
            onWheel: event => {
                accumulator += event.angleDelta.y;
                const steps = Math.trunc(accumulator / 120);
                if (steps !== 0) {
                    accumulator -= steps * 120;
                    root.monthOffset -= steps;
                }
            }
        }
    }
}
