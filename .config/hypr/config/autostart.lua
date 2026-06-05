-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                    Autostart Configuration                  ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

local defaults = require("config.defaults").defaults
local home = os.getenv("HOME")

-- Autostart wiki https://wiki.hyprland.org/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar &")
    hl.exec_cmd("fcitx5 -d &")
    hl.exec_cmd("mako &")
    hl.exec_cmd("nm-applet --indicator &")
    hl.exec_cmd(
    'bash -c "mkfifo /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob && tail -f /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob | wob & disown" &')
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1 &")
    hl.exec_cmd("awww-daemon &")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")  -- Stores only text data
    hl.exec_cmd("wl-paste --type image --watch cliphist store") -- Stores only image data
    hl.exec_cmd("blueman-applet &")
    hl.exec_cmd(home .. "/.config/hypr/scripts/battery.sh &")
    -- hl.exec_cmd(home .. "/.config/waybar/scripts/waybar_auto_hide &")

    hl.exec_cmd("snappy-switcher --daemon")


    -- Slow app launch fix
    hl.exec_cmd("systemctl --user import-environment &")
    hl.exec_cmd("hash dbus-update-activation-environment 2>/dev/null &")
    hl.exec_cmd("dbus-update-activation-environment --systemd &")

    -- Idle configuration
    hl.exec_cmd(defaults.idlehandler)
end)
