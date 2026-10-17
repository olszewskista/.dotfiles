import QtQuick
import qs
import qs.components
import qs.services

Pill {
    id: root

    visible: Spotify.active

    Item {
        id: body

        implicitHeight: Theme.barHeight - 6
        implicitWidth: row.implicitWidth + 16

        Rectangle {
            anchors.fill: parent
            radius: Theme.innerRadius
            color: mouse.containsMouse ? Theme.hover : "transparent"

            Behavior on color {
                ColorAnimation {
                    duration: Theme.animFast
                }
            }
        }

        Row {
            id: row

            anchors.centerIn: parent
            anchors.verticalCenterOffset: -1
            spacing: 7

            StyledText {
                anchors.verticalCenter: parent.verticalCenter
                text: Spotify.playing ? Icons.spotify : Icons.pause
                color: Spotify.playing ? Theme.spotify : Theme.overlay1
                font.pixelSize: Theme.iconSize

                Behavior on color {
                    ColorAnimation {
                        duration: Theme.animNormal
                    }
                }
            }

            StyledText {
                anchors.verticalCenter: parent.verticalCenter
                width: Math.min(implicitWidth, 220)
                elide: Text.ElideRight
                text: Spotify.title
                color: Spotify.playing ? Theme.text : Theme.subtext0
            }

            StyledText {
                anchors.verticalCenter: parent.verticalCenter
                visible: Spotify.artist.length > 0
                width: Math.min(implicitWidth, 150)
                elide: Text.ElideRight
                text: Spotify.artist
                color: Theme.overlay1
                font.weight: Font.Medium
            }
        }

        Rectangle {
            id: progressTrack

            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                leftMargin: 8
                rightMargin: 8
                bottomMargin: 1
            }
            height: 2
            radius: 1
            color: Theme.track

            Rectangle {
                height: parent.height
                radius: parent.radius
                width: parent.width * Spotify.progress
                color: Spotify.playing ? Theme.spotify : Theme.overlay0

                Behavior on width {
                    NumberAnimation {
                        duration: 950
                    }
                }
            }
        }

        MouseArea {
            id: mouse

            property real wheelAccumulator: 0

            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
            onClicked: event => {
                if (event.button === Qt.LeftButton)
                    Spotify.togglePlaying();
                else if (event.button === Qt.RightButton)
                    Spotify.raise();
                else
                    Spotify.next();
            }
            onWheel: event => {
                wheelAccumulator += event.angleDelta.y;
                if (Math.abs(wheelAccumulator) >= 120) {
                    wheelAccumulator > 0 ? Spotify.next() : Spotify.previous();
                    wheelAccumulator = 0;
                }
            }
        }

        MediaPopup {
            target: body
            hoverTarget: mouse.containsMouse
        }
    }
}
