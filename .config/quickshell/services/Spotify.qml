pragma Singleton

import Quickshell
import Quickshell.Services.Mpris
import QtQuick

Singleton {
    id: root

    readonly property MprisPlayer player: Mpris.players.values.find(p => p.dbusName.startsWith("org.mpris.MediaPlayer2.spotify")) ?? null
    readonly property bool active: player !== null && player.playbackState !== MprisPlaybackState.Stopped
    readonly property bool playing: player?.isPlaying ?? false
    readonly property string title: player?.trackTitle ?? ""
    readonly property string artist: player?.trackArtist ?? ""
    readonly property string album: player?.trackAlbum ?? ""
    readonly property string artUrl: player?.trackArtUrl ?? ""
    readonly property real position: player?.position ?? 0
    readonly property real length: player?.length ?? 0
    readonly property real progress: length > 0 ? Math.min(1, position / length) : 0

    function togglePlaying() {
        player?.togglePlaying();
    }

    function next() {
        player?.next();
    }

    function previous() {
        player?.previous();
    }

    function seek(fraction: real) {
        if (player?.canSeek && length > 0)
            player.position = fraction * length;
    }

    function raise() {
        if (player?.canRaise)
            player.raise();
        else
            Quickshell.execDetached(["spotify-launcher"]);
    }

    function formatTime(seconds: real): string {
        const s = Math.max(0, Math.floor(seconds));
        return `${Math.floor(s / 60)}:${String(s % 60).padStart(2, "0")}`;
    }

    // MPRIS doesn't push position updates, so poll while playing.
    Timer {
        interval: 1000
        repeat: true
        running: root.playing
        onTriggered: root.player.positionChanged()
    }
}
