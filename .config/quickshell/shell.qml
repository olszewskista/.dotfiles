//@ pragma UseQApplication

import Quickshell
import Quickshell.Io
import QtQuick
import qs.bar

ShellRoot {
    id: root

    property bool barVisible: true

    // `qs ipc call bar toggle`, e.g. bound to the old waybar toggle key.
    IpcHandler {
        target: "bar"

        function toggle(): void {
            root.barVisible = !root.barVisible;
        }

        function show(): void {
            root.barVisible = true;
        }

        function hide(): void {
            root.barVisible = false;
        }
    }

    Variants {
        model: Quickshell.screens

        Bar {
            visible: root.barVisible
        }
    }
}
