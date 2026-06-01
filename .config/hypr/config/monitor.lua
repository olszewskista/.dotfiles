-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                     Monitor Configuration                   ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

-- Monitor wiki https://wiki.hyprland.org/Configuring/Basics/Monitors/

hl.monitor({ output = "eDP-1",     mode = "preferred", position = "0x0", scale = 1.6 })
-- hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@120", position = "auto", scale = 1 })
-- hl.monitor({ output = "DP-2",     mode = "1920x1080@120", position = "auto", scale = 1 })
-- hl.monitor({ output = "DP-8",     mode = "1920x1200@60",  position = "auto", scale = 1 })
-- hl.monitor({ output = "DP-9",     mode = "2560x1440@120", position = "auto", scale = 1 })
hl.monitor({ output = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. MO27Q28G 25372F000333", mode = "2560x1440@120", position = "auto", scale = 1 })
-- hl.monitor({ output = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. MO27Q28G 25372F000333", disabled = true })
hl.monitor({ output = "",           mode = "preferred", position = "auto", scale = 1 })
-- hl.monitor({ output = "",         mode = "1920x1080", position = "auto", scale = 1, mirror = "eDP-1" })
-- hl.monitor({ output = "HDMI-A-1", mode = "3840x2160@60",  position = "auto", scale = 1 })
-- hl.monitor({ output = "HDMI-A-1", mode = "2560x1440@120", position = "auto", scale = 1 })
-- hl.monitor({ output = "",         disabled = true })

-- If you need to scale things like steam etc, please uncomment these lines.
-- Adjust GDK_SCALE accordingly to your liking.
hl.config({
    xwayland = {
        force_zero_scaling = true, -- Unscale XWayland
    },
})

-- hl.env("GDK_SCALE", "1.25") -- GDK Scaling Factor
