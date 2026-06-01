-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                    Windowrules Configuration                ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

local colors = require("config.colors")

-- Windows Rules https://wiki.hyprland.org/Configuring/Basics/Window-Rules/

-- Float Necessary Windows
hl.window_rule({ match = { class = "^(org.pulseaudio.pavucontrol)" }, float = true })
hl.window_rule({ match = { class = "^()$", title = "^(Picture in picture)$" }, float = true })
hl.window_rule({ match = { class = "^()$", title = "^(Save File)$" }, float = true })
hl.window_rule({ match = { class = "^()$", title = "^(Open File)$" }, float = true })
hl.window_rule({ match = { class = "^(LibreWolf)$", title = "^(Picture-in-Picture)$" }, float = true })
hl.window_rule({ match = { class = "^(blueman-manager)$" }, float = true })
hl.window_rule({
	match = { class = "^(xdg-desktop-portal-gtk|xdg-desktop-portal-kde|xdg-desktop-portal-hyprland)(.*)$" },
	float = true,
})
hl.window_rule({
	match = {
		class = "^(polkit-gnome-authentication-agent-1|hyprpolkitagent|org.org.kde.polkit-kde-authentication-agent-1)(.*)$",
	},
	float = true,
})
hl.window_rule({ match = { class = "^(CachyOSHello)$" }, float = true })
hl.window_rule({ match = { class = "^(zenity)$" }, float = true })
hl.window_rule({ match = { class = "^()$", title = "^(Steam - Self Updater)$" }, float = true })
hl.window_rule({
	match = { class = "kitty", title = "termfilechooser" },
	float = true,
	size = "(monitor_w*0.6) (monitor_h*0.6)",
})

-- Increase the opacity
hl.window_rule({ match = { class = "^(thunar|nemo)$" }, opacity = 0.92 })
hl.window_rule({ match = { class = "^(discord|armcord|webcord)$" }, opacity = 0.96 })
hl.window_rule({ match = { title = "^(QQ|Telegram)$" }, opacity = 0.95 })
hl.window_rule({ match = { title = "^(NetEase Cloud Music Gtk4)$" }, opacity = 0.95 })

-- General window rules
hl.window_rule({ match = { title = "^(Picture-in-Picture)$" }, float = true })
hl.window_rule({ match = { title = "^(Picture-in-Picture)$" }, size = "960 540" })
hl.window_rule({ match = { title = "^(imv|mpv|danmufloat|termfloat|nemo|ncmpcpp)$" }, float = true })
hl.window_rule({ match = { title = "^(imv|mpv|danmufloat|termfloat|nemo|ncmpcpp)$" }, size = "960 540" })
hl.window_rule({ match = { title = "^(danmufloat)$" }, pin = true })
hl.window_rule({ match = { title = "^(danmufloat|termfloat)$" }, rounding = 5 })
hl.window_rule({ match = { class = "^(org.mozilla.firefox)$" }, no_blur = true })

-- Decorations related to floating windows on workspaces 1 to 10
hl.window_rule({ match = { float = true, workspace = "w[fv1-10]" }, border_size = 2 })
hl.window_rule({ match = { float = true, workspace = "w[fv1-10]" }, border_color = colors.cachylblue })
hl.window_rule({ match = { float = true, workspace = "w[fv1-10]" }, rounding = 8 })

-- Decorations related to tiling windows on workspaces 1 to 10
hl.window_rule({ match = { float = false, workspace = "f[1-10]" }, border_size = 0 })

-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                     Layer Rules                              ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

hl.layer_rule({ match = { namespace = "logout_dialog" }, animation = "slide top" })
hl.layer_rule({ match = { namespace = "waybar" }, animation = "slide down" })
hl.layer_rule({ match = { namespace = "wallpaper" }, animation = "fade 50%" })
hl.layer_rule({ match = { namespace = "logout_dialog" }, blur = true })
hl.layer_rule({ match = { namespace = "logout_dialog" }, dim_around = true })
