pragma Singleton

import Quickshell
import QtQuick

// Nerd Font (Material Design) glyphs.
Singleton {
    readonly property string cpu: String.fromCodePoint(0xf0ee0)
    readonly property string memory: String.fromCodePoint(0xf035b)
    readonly property string thermometer: String.fromCodePoint(0xf050f)
    readonly property string thermometerHigh: String.fromCodePoint(0xf10c2)
    readonly property string packageUp: String.fromCodePoint(0xf03d5)
    readonly property string packageOk: String.fromCodePoint(0xf03d6)

    readonly property string spotify: String.fromCodePoint(0xf04c7)
    readonly property string music: String.fromCodePoint(0xf0387)
    readonly property string play: String.fromCodePoint(0xf040a)
    readonly property string pause: String.fromCodePoint(0xf03e4)
    readonly property string next: String.fromCodePoint(0xf04ad)
    readonly property string previous: String.fromCodePoint(0xf04ae)

    readonly property string coffee: String.fromCodePoint(0xf0176)
    readonly property string coffeeOff: String.fromCodePoint(0xf0faa)

    readonly property var brightness: [0xf00de, 0xf00df, 0xf00e0].map(c => String.fromCodePoint(c))

    readonly property var battery: [0xf008e, 0xf007a, 0xf007b, 0xf007c, 0xf007d, 0xf007e, 0xf007f, 0xf0080, 0xf0081, 0xf0082, 0xf0079].map(c => String.fromCodePoint(c))
    readonly property string batteryCharging: String.fromCodePoint(0xf0084)
    readonly property string plug: String.fromCodePoint(0xf06a5)

    readonly property var wifi: [0xf092f, 0xf091f, 0xf0922, 0xf0925, 0xf0928].map(c => String.fromCodePoint(c))
    readonly property string wifiOff: String.fromCodePoint(0xf05aa)
    readonly property string ethernet: String.fromCodePoint(0xf0200)
    readonly property string download: String.fromCodePoint(0xf01da)
    readonly property string upload: String.fromCodePoint(0xf0552)

    readonly property string volumeHigh: String.fromCodePoint(0xf057e)
    readonly property string volumeMedium: String.fromCodePoint(0xf0580)
    readonly property string volumeLow: String.fromCodePoint(0xf057f)
    readonly property string volumeMute: String.fromCodePoint(0xf075f)
    readonly property string headphones: String.fromCodePoint(0xf02cb)

    readonly property string clock: String.fromCodePoint(0xf0954)
    readonly property string chevronLeft: String.fromCodePoint(0xf0141)
    readonly property string chevronRight: String.fromCodePoint(0xf0142)

    function pick(list: var, fraction: real): string {
        const i = Math.round(Math.max(0, Math.min(1, fraction)) * (list.length - 1));
        return list[i];
    }
}
