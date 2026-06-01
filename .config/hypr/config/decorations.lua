-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                    Decorations Configuration                ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

-- https://wiki.hyprland.org/Configuring/Basics/Variables/#decoration

hl.config({
    decoration = {
        active_opacity = 1,
        rounding = 0,

        -- https://wiki.hyprland.org/Configuring/Basics/Variables/#blur
        blur = {
            size = 10,
            passes = 3, -- more passes = more resource intensive
            xray = true,
        },

        -- https://wiki.hyprland.org/Configuring/Basics/Variables/#shadow
        shadow = {
            enabled = false,
        },
    },
})
