pragma Singleton

import Quickshell
import QtQuick

// Catppuccin Mocha, matching the GTK theme waybar used to inherit.
Singleton {
    readonly property color crust: "#11111b"
    readonly property color mantle: "#181825"
    readonly property color base: "#1e1e2e"
    readonly property color surface0: "#313244"
    readonly property color surface1: "#45475a"
    readonly property color surface2: "#585b70"
    readonly property color overlay0: "#6c7086"
    readonly property color overlay1: "#7f849c"
    readonly property color subtext0: "#a6adc8"
    readonly property color subtext1: "#bac2de"
    readonly property color text: "#cdd6f4"

    readonly property color rosewater: "#f5e0dc"
    readonly property color pink: "#f5c2e7"
    readonly property color mauve: "#cba6f7"
    readonly property color red: "#f38ba8"
    readonly property color peach: "#fab387"
    readonly property color yellow: "#f9e2af"
    readonly property color green: "#a6e3a1"
    readonly property color teal: "#94e2d5"
    readonly property color sapphire: "#74c7ec"
    readonly property color blue: "#89b4fa"
    readonly property color lavender: "#b4befe"
    readonly property color spotify: "#1db954"

    readonly property color accent: blue

    readonly property color pill: alpha(base, 0.86)
    readonly property color pillBorder: alpha(text, 0.07)
    readonly property color popup: alpha(mantle, 0.97)
    readonly property color popupBorder: alpha(text, 0.09)
    readonly property color hover: alpha(text, 0.09)
    readonly property color track: alpha(text, 0.1)

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
