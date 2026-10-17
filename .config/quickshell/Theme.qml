pragma Singleton

import Quickshell
import QtQuick

// Neutral graphite surfaces with a muted, evenly-weighted set of hues for icons.
// Hues share roughly the same lightness and saturation so no single module shouts.
Singleton {
    readonly property color crust: "#0b0b0c"
    readonly property color mantle: "#121213"
    readonly property color base: "#18181a"
    readonly property color surface0: "#232325"
    readonly property color surface1: "#2e2e31"
    readonly property color surface2: "#3f3f43"
    readonly property color overlay0: "#5c5c61"
    readonly property color overlay1: "#77777d"
    readonly property color subtext0: "#a0a0a6"
    readonly property color subtext1: "#c4c4c9"
    readonly property color text: "#ededef"

    readonly property color red: "#e8817f"
    readonly property color orange: "#e6a377"
    readonly property color yellow: "#e2c47f"
    readonly property color green: "#9ccc8f"
    readonly property color teal: "#80c8b4"
    readonly property color sky: "#82bfdc"
    readonly property color blue: "#8eaae6"
    readonly property color violet: "#b19ce4"
    readonly property color pink: "#dd95bd"
    readonly property color spotify: "#1db954"

    readonly property color accent: text
    readonly property color success: green
    readonly property color warning: orange
    readonly property color critical: red

    readonly property color icon: subtext1

    readonly property color pill: alpha(base, 0.62)
    readonly property color pillBorder: alpha(text, 0.09)
    readonly property color popup: alpha(mantle, 0.78)
    readonly property color popupBorder: alpha(text, 0.1)
    readonly property color hover: alpha(text, 0.1)
    readonly property color track: alpha(text, 0.12)

    readonly property string fontFamily: "JetBrainsMono Nerd Font Propo"
    readonly property int fontSize: 12
    readonly property int iconSize: 15

    readonly property int barHeight: 28
    readonly property int barMargin: 4
    readonly property int radius: 10
    readonly property int innerRadius: 7
    readonly property int pillSpacing: 6

    readonly property int animFast: 140
    readonly property int animNormal: 220

    function alpha(c: color, a: real): color {
        return Qt.rgba(c.r, c.g, c.b, a);
    }
}
