import QtQuick
import qs

HoverPopup {
    property alias text: label.text

    padding: 9
    openDelay: 450

    StyledText {
        id: label
        font.weight: Font.Medium
        lineHeight: 1.25
    }
}
