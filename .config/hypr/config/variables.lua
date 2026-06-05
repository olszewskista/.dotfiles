-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                    Variables Configuration                  ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

local colors = require("config.colors")

-- Variables wiki https://wiki.hyprland.org/Configuring/Basics/Variables/

-- https://wiki.hyprland.org/Configuring/Basics/Variables/#general
hl.config({
    general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 1,
        ["col.active_border"] = colors.cachylgreen,
        ["col.inactive_border"] = colors.cachymblue,
        layout = "dwindle", -- master|dwindle

        -- https://wiki.hyprland.org/Configuring/Basics/Variables/#snap
        snap = {
            enabled = true,
        },
    },

    -- https://wiki.hyprland.org/Configuring/Basics/Variables/#gestures
    gestures = {
        workspace_swipe_distance = 250,
        workspace_swipe_min_speed_to_force = 15,
        workspace_swipe_create_new = true,
    },

    -- https://wiki.hyprland.org/Configuring/Basics/Variables/#group
    group = {
        ["col.border_active"] = colors.cachydgreen,
        ["col.border_inactive"] = colors.cachylgreen,
        ["col.border_locked_active"] = colors.cachymgreen,
        ["col.border_locked_inactive"] = colors.cachydblue,
        drag_into_group = 2,

        -- https://wiki.hyprland.org/Configuring/Basics/Variables/#groupbar
        groupbar = {
            font_family = "Fira Sans",
            text_color = colors.cachydblue,
            ["col.active"] = colors.cachylgreen,
            ["col.inactive"] = colors.cachydgreen,
            ["col.locked_active"] = colors.cachymgreen,
            ["col.locked_inactive"] = colors.cachydblue,
            font_size = 12,
            gradients = true,
            font_weight_active = "bold",
        },
    },

    -- https://wiki.hyprland.org/Configuring/Basics/Variables/#misc
    misc = {
        font_family = "Fira Sans",
        splash_font_family = "Fira Sans",
        disable_hyprland_logo = true,
        ["col.splash"] = colors.cachylgreen,
        background_color = colors.cachydblue,
        enable_swallow = true,
        swallow_regex = "^(cachy-browser|firefox|nautilus|nemo|thunar|btrfs-assistant.)$",
        focus_on_activate = true,
        vrr = 2,
        key_press_enables_dpms = true,
        animate_manual_resizes = true,
    },

    -- https://wiki.hyprland.org/Configuring/Basics/Variables/#render
    render = {
        direct_scanout = true,
    },

    -- See https://wiki.hyprland.org/Configuring/Layouts/Dwindle-Layout/ for more
    dwindle = {
        special_scale_factor = 0.8,
        preserve_split = true,
    },

    -- See https://wiki.hyprland.org/Configuring/Layouts/Master-Layout/ for more
    master = {
        new_status = "master",
        special_scale_factor = 0.8,
    },
})
