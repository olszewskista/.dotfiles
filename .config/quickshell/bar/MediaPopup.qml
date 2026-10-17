import Quickshell.Widgets
import QtQuick
import qs
import qs.components
import qs.services

HoverPopup {
    id: root

    padding: 12
    active: Spotify.active

    Row {
        spacing: 14

        ClippingRectangle {
            width: 96
            height: 96
            radius: Theme.radius
            color: Theme.surface0

            StyledText {
                anchors.centerIn: parent
                visible: art.status !== Image.Ready
                text: Icons.music
                color: Theme.overlay1
                font.pixelSize: 32
            }

            Image {
                id: art
                anchors.fill: parent
                source: Spotify.artUrl
                sourceSize: Qt.size(192, 192)
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                opacity: status === Image.Ready ? 1 : 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: Theme.animNormal
                    }
                }
            }
        }

        Column {
            width: 230
            height: 96

            StyledText {
                width: parent.width
                elide: Text.ElideRight
                text: Spotify.title
                font.pixelSize: Theme.fontSize + 2
                font.weight: Font.Bold
            }

            StyledText {
                width: parent.width
                elide: Text.ElideRight
                topPadding: 2
                text: Spotify.artist
                color: Theme.subtext1
                font.weight: Font.Medium
            }

            StyledText {
                width: parent.width
                elide: Text.ElideRight
                topPadding: 1
                visible: Spotify.album.length > 0
                text: Spotify.album
                color: Theme.overlay1
                font.weight: Font.Normal
                font.pixelSize: Theme.fontSize - 1
            }
        }
    }

    Column {
        y: 96 + 12
        width: 96 + 14 + 230
        spacing: 6

        Item {
            width: parent.width
            height: 10

            Meter {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                height: seekArea.containsMouse ? 6 : 4
                value: Spotify.progress
                fillColor: Spotify.playing ? Theme.spotify : Theme.overlay1

                Behavior on height {
                    NumberAnimation {
                        duration: Theme.animFast
                    }
                }
            }

            MouseArea {
                id: seekArea
                anchors.fill: parent
                hoverEnabled: true
                enabled: Spotify.player?.canSeek ?? false
                cursorShape: Qt.PointingHandCursor
                onClicked: event => Spotify.seek(event.x / width)
            }
        }

        Item {
            width: parent.width
            height: controls.height

            StyledText {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: Spotify.formatTime(Spotify.position)
                color: Theme.overlay1
                font.weight: Font.Medium
                font.pixelSize: Theme.fontSize - 1
            }

            Row {
                id: controls
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 4

                BarButton {
                    icon: Icons.previous
                    iconSize: 18
                    implicitHeight: 32
                    horizontalPadding: 8
                    onClicked: Spotify.previous()
                }

                Rectangle {
                    width: 32
                    height: 32
                    radius: 16
                    color: playArea.containsMouse ? Qt.lighter(Theme.spotify, 1.15) : Theme.spotify
                    scale: playArea.pressed ? 0.92 : 1

                    Behavior on scale {
                        NumberAnimation {
                            duration: Theme.animFast
                        }
                    }

                    StyledText {
                        anchors.centerIn: parent
                        text: Spotify.playing ? Icons.pause : Icons.play
                        color: Theme.crust
                        font.pixelSize: 20
                    }

                    MouseArea {
                        id: playArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Spotify.togglePlaying()
                    }
                }

                BarButton {
                    icon: Icons.next
                    iconSize: 18
                    implicitHeight: 32
                    horizontalPadding: 8
                    onClicked: Spotify.next()
                }
            }

            StyledText {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                text: Spotify.formatTime(Spotify.length)
                color: Theme.overlay1
                font.weight: Font.Medium
                font.pixelSize: Theme.fontSize - 1
            }
        }
    }
}
