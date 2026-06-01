-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                         Keybinds                            ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

local defaults = require("config.defaults")
local home = os.getenv("HOME")

local mainMod = "SUPER"
local hyprMod = "SUPER + CTRL"

-- https://wiki.hyprland.org/Configuring/Basics/Binds/

-- ======= Apps =======
hl.bind(
	mainMod .. " + SHIFT + T",
	hl.dsp.exec_cmd(defaults.terminal),
	{ desc = "Opens your preferred terminal emulator" }
)
hl.bind(
	hyprMod .. " + T",
	hl.dsp.exec_cmd("[float; size (monitor_w*0.75) (monitor_h*0.75)] " .. defaults.terminal),
	{ desc = "Opens your preferred terminal as float" }
)
hl.bind(
	mainMod .. " + T",
	hl.dsp.exec_cmd(defaults.launch .. " " .. defaults.terminal),
	{ desc = "Open or go to your preferred terminal emulator" }
)
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(defaults.filemanager), { desc = "Opens your preferred filemanager" })
hl.bind(
	mainMod .. " + E",
	hl.dsp.exec_cmd(defaults.launch .. " " .. defaults.filemanager .. " 'org.gnome.Nautilus'"),
	{ desc = "Open or go to your preferred filemanager" }
)
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd(defaults.browser), { desc = "Opens preferred web browser" })
hl.bind(
	mainMod .. " + F",
	hl.dsp.exec_cmd(defaults.launch .. " " .. defaults.browser .. ' "helium"'),
	{ desc = "Open or go to preferred web browser" }
)
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd(defaults.editor), { desc = "Open preferred editor" })
hl.bind(
	mainMod .. " + C",
	hl.dsp.exec_cmd(defaults.launch .. " " .. defaults.editor),
	{ desc = "Open or go to preferred editor" }
)
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(defaults.launch .. " 'spotify-launcher'"), { desc = "Open spotify" })
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(defaults.launch .. " 'obsidian'"), { desc = "Open notes" })
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(defaults.capturing), { desc = "Screen capture selection" })
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(defaults.applauncher), { desc = "Runs your application launcher" })
hl.bind(mainMod .. " + Q", hl.dsp.window.close(), { desc = "Closes (not kill) current window" })
hl.bind(
	mainMod .. " + RETURN",
	hl.dsp.window.float({ action = "toggle" }),
	{ desc = "Switches current window between floating and tiling mode" }
)
hl.bind(
	"ALT + RETURN",
	hl.dsp.window.fullscreen({ action = "toggle" }),
	{ desc = "Toggles current window fullscreen mode" }
)
-- hl.bind(mainMod .. " + Y",     hl.dsp.pin(),                                                  { desc = "Pin current window (shows on all workspaces)" })
hl.bind(mainMod .. " + Backslash", hl.dsp.layout("togglesplit"), { desc = "Toggles current window split mode" })
hl.bind(mainMod .. " + Backspace", hl.dsp.exec_cmd("wlogout"), { desc = "Logout screen" })

hl.bind("ALT + Tab", hl.dsp.focus({workspace = "previous"}))

-- ======= Rofi =======
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(defaults.applauncher), { desc = "Runs your application launcher" })
hl.bind(mainMod .. " + TAB", hl.dsp.exec_cmd("rofi -show window"), { desc = "Rofi window select" })
hl.bind(mainMod .. " + PERIOD", hl.dsp.exec_cmd("rofi -modi emoji -show emoji"), { desc = "Show emoji" })
hl.bind(
	mainMod .. " + V",
	hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"),
	{ desc = "Clipboard" }
)
hl.bind(
	mainMod .. " + SHIFT + W",
	hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/wallpaper_select.sh"),
	{ desc = "Wallpaper" }
)

-- ======= Grouping Windows =======
hl.bind(mainMod .. " + G", hl.dsp.group.toggle(), { desc = "Toggles current window group mode (ungroup all related)" })
hl.bind(mainMod .. " + Grave", hl.dsp.group.next(), { desc = "Switches to the next window in the group" })
hl.bind(mainMod .. " + SHIFT + Grave", hl.dsp.group.prev(), { desc = "Switches to the previous window in the group" })

-- ======= Gestures =======
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
hl.gesture({
	fingers = 3,
	direction = "up",
	action = function()
		hl.exec_cmd(defaults.player .. " play-pause")
	end,
})
hl.gesture({
	fingers = 3,
	direction = "left",
	action = function()
		hl.exec_cmd(defaults.player .. " next")
	end,
})
hl.gesture({
	fingers = 3,
	direction = "right",
	action = function()
		hl.exec_cmd(defaults.player .. " previous")
	end,
})

-- ======= Volume Control =======
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd(
		[[pactl set-sink-volume @DEFAULT_SINK@ +5% && pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+(?=%)' | awk '{if($1>100) system("pactl set-sink-volume @DEFAULT_SINK@ 100%")}' && pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+(?=%)' | awk '{print $1}' | head -1 > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob]]
	),
	{ locked = true, repeating = true, desc = "Raise Volume" }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd(
		[[pactl set-sink-volume @DEFAULT_SINK@ -5% && pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+(?=%)' | awk '{print $1}' | head -1 > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob]]
	),
	{ locked = true, repeating = true, desc = "Lower Volume" }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd(
		[[amixer sset Master toggle | sed -En '/\[on\]/ s/.*\[([0-9]+)%\].*/\1/ p; /\[off\]/ s/.*/0/p' | head -1 > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob]]
	),
	{ locked = true, repeating = true, desc = "Mute audio" }
)

-- ======= Playback Control =======
hl.bind(
	"XF86AudioPlay",
	hl.dsp.exec_cmd(defaults.player .. " play-pause"),
	{ locked = true, desc = "Toggles play/pause" }
)
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(defaults.player .. " next"), { locked = true, desc = "Next track" })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(defaults.player .. " previous"), { locked = true, desc = "Previous track" })

-- ======= Screen Brightness =======
hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd(
		[[brightnessctl set +5% | sed -En 's/.*\(([0-9]+)%\).*/\1/p' > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob]]
	),
	{ repeating = true, locked = true }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd(
		[[brightnessctl set 5%- | sed -En 's/.*\(([0-9]+)%\).*/\1/p' > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob]]
	),
	{ repeating = true, locked = true }
)

hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("gnome-calculator"), { desc = "Runs the calculator application" })
hl.bind(
	mainMod .. " + Escape",
	hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/waybar.sh"),
	{ desc = "Reload/restarts Waybar" }
)
hl.bind(
	mainMod .. " + SHIFT + Backspace",
	hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/screen_toggle.sh"),
	{ locked = true, desc = "Toggle on/off laptop screen" }
)

-- ======= Window Actions =======

-- Move window towards a direction
-- hl.bind(hyprMod .. " + h", hl.dsp.movewindoworgroup("l"), { desc = "Move active window to the left" })
-- hl.bind(hyprMod .. " + l", hl.dsp.movewindoworgroup("r"), { desc = "Move active window to the right" })
-- hl.bind(hyprMod .. " + k", hl.dsp.movewindoworgroup("u"), { desc = "Move active window upwards" })
-- hl.bind(hyprMod .. " + j", hl.dsp.movewindoworgroup("d"), { desc = "Move active window downwards" })

hl.bind(hyprMod .. " + left", hl.dsp.window.move({ direction = "l" }), { desc = "Move active window to the left" })
hl.bind(hyprMod .. " + right", hl.dsp.window.move({ direction = "r" }), { desc = "Move active window to the right" })
hl.bind(hyprMod .. " + up", hl.dsp.window.move({ direction = "u" }), { desc = "Move active window upwards" })
hl.bind(hyprMod .. " + down", hl.dsp.window.move({ direction = "d" }), { desc = "Move active window downwards" })

-- Move focus with mainMod + hjkl
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "l" }), { desc = "Move focus to the left" })
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "r" }), { desc = "Move focus to the right" })
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "u" }), { desc = "Move focus upwards" })
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "d" }), { desc = "Move focus downwards" })
-- hl.bind(mainMod .. " + left", hl.dsp.movefocus("l"), { desc = "Move focus to the left" })
-- hl.bind(mainMod .. " + right", hl.dsp.movefocus("r"), { desc = "Move focus to the right" })
-- hl.bind(mainMod .. " + up", hl.dsp.movefocus("u"), { desc = "Move focus upwards" })
-- hl.bind(mainMod .. " + down", hl.dsp.movefocus("d"), { desc = "Move focus downwards" })

-- ======= Resizing Windows =======

-- Activate keyboard window resize mode
-- https://wiki.hyprland.org/Configuring/Basics/Binds/#submaps
hl.bind(mainMod .. " + R", hl.dsp.submap("resize"), { desc = "Activates window resizing mode" })

hl.define_submap("resize", function()
	hl.bind(
		"right",
		hl.dsp.window.resize({ x = 15, y = 0 }),
		{ repeating = true, desc = "Resize to the right (resizing mode)" }
	)
	hl.bind(
		"left",
		hl.dsp.window.resize({ x = -15, y = 0 }),
		{ repeating = true, desc = "Resize to the left (resizing mode)" }
	)
	hl.bind(
		"up",
		hl.dsp.window.resize({ x = 0, y = -15 }),
		{ repeating = true, desc = "Resize upwards (resizing mode)" }
	)
	hl.bind(
		"down",
		hl.dsp.window.resize({ x = 0, y = 15 }),
		{ repeating = true, desc = "Resize downwards (resizing mode)" }
	)
	hl.bind(
		"l",
		hl.dsp.window.resize({ x = 15, y = 0 }),
		{ repeating = true, desc = "Resize to the right (resizing mode)" }
	)
	hl.bind(
		"h",
		hl.dsp.window.resize({ x = -15, y = 0 }),
		{ repeating = true, desc = "Resize to the left (resizing mode)" }
	)
	hl.bind(
		"k",
		hl.dsp.window.resize({ x = 0, y = -15 }),
		{ repeating = true, desc = "Resize upwards (resizing mode)" }
	)
	hl.bind(
		"j",
		hl.dsp.window.resize({ x = 0, y = 15 }),
		{ repeating = true, desc = "Resize downwards (resizing mode)" }
	)
	hl.bind("escape", hl.dsp.submap("reset"), { repeating = true, desc = "Ends window resizing mode" })
end)

-- Quick resize window with keyboard
-- !!! added mainMod here because CTRL + SHIFT is used for word selection in various text editors
hl.bind(
	mainMod .. " + ALT + right",
	hl.dsp.window.resize({ x = 15, y = 0 }),
	{ repeating = true, desc = "Resize to the right" }
)
hl.bind(
	mainMod .. " + ALT + left",
	hl.dsp.window.resize({ x = -15, y = 0 }),
	{ repeating = true, desc = "Resize to the left" }
)
hl.bind(
	mainMod .. " + ALT + up",
	hl.dsp.window.resize({ x = 0, y = -15 }),
	{ repeating = true, desc = "Resize upwards" }
)
hl.bind(
	mainMod .. " + ALT + down",
	hl.dsp.window.resize({ x = 0, y = 15 }),
	{ repeating = true, desc = "Resize downwards" }
)
hl.bind(
	mainMod .. " + ALT + l",
	hl.dsp.window.resize({ x = 15, y = 0 }),
	{ repeating = true, desc = "Resize to the right" }
)
hl.bind(
	mainMod .. " + ALT + h",
	hl.dsp.window.resize({ x = -15, y = 0 }),
	{ repeating = true, desc = "Resize to the left" }
)
hl.bind(
	mainMod .. " + ALT + k",
	hl.dsp.window.resize({ x = 0, y = -15 }),
	{ repeating = true, desc = "Resize upwards" }
)
hl.bind(
	mainMod .. " + ALT + j",
	hl.dsp.window.resize({ x = 0, y = 15 }),
	{ repeating = true, desc = "Resize downwards" }
)

-- Resize window with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true }) -- Resize the window towards a direction
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true }) -- Drag window

-- ======= Move active window to a workspace =======

-- Move window and switch to workspace with mainMod + SHIFT + [0-9]
for i = 1, 9 do
	hl.bind(
		mainMod .. " + SHIFT + " .. i,
		hl.dsp.window.move({ workspace = i, follow = true }),
		{ desc = "Move window and switch to workspace " .. i }
	)
end
hl.bind(
	mainMod .. " + SHIFT + 0",
	hl.dsp.window.move({ workspace = 10, follow = true }),
	{ desc = "Move window and switch to workspace 10" }
)
hl.bind(
	mainMod .. " + CTRL + SHIFT + h",
	-- hl.dsp.movetoworkspace("r-1"),
	hl.dsp.window.move({ workspace = "r-1", follow = true }),
	{ desc = "Move window and switch to the next workspace" }
)
hl.bind(
	mainMod .. " + CTRL + SHIFT + l",
	hl.dsp.window.move({ workspace = "r+1", follow = true }),
	{ desc = "Move window and switch to the previous workspace" }
)

hl.bind(
	mainMod .. " + SHIFT + l",
	hl.dsp.focus({ workspace = "r+1" }),
	{ desc = "Change active workspace forwards" }
)
hl.bind(
	mainMod .. " + SHIFT + h",
	hl.dsp.focus({ workspace = "r-1" }),
	{ desc = "Change active workspace backwards" }
)

-- Same as above, but doesn't switch to the workspace
for i = 1, 9 do
	hl.bind(
		hyprMod .. " + " .. i,
		hl.dsp.window.move({ workspace = i }),
		{ desc = "Move window silently to workspace " .. i }
	)
end
hl.bind(hyprMod .. " + 0", hl.dsp.window.move({ workspace = 10 }), { desc = "Move window silently to workspace 10" })

-- ======= Workspace Actions =======

-- Switch workspaces with mainMod + [0-9]
for i = 1, 9 do
	hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }), { desc = "Switch to workspace " .. i })
end
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }), { desc = "Switch to workspace 10" })

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(
	mainMod .. " + mouse_down",
	hl.dsp.focus({ workspace = "e+1" }),
	{ desc = "Scroll through workspaces incrementally" }
)
hl.bind(
	mainMod .. " + mouse_up",
	hl.dsp.focus({ workspace = "e-1" }),
	{ desc = "Scroll through workspaces decrementally" }
)
hl.bind(
	mainMod .. " + slash",
	hl.dsp.focus({ workspace = "previous" }),
	{ desc = "Switch to the previous workspace" }
)

-- TODO
-- Special workspaces (scratchpads)
-- hl.bind(mainMod .. " + minus", hl.dsp.movetoworkspace("special"), { desc = "Move active window to Special workspace" })
-- hl.bind(mainMod .. " + equal", hl.dsp.togglespecialworkspace("special"), { desc = "Toggles the Special workspace" })
-- hl.bind(mainMod .. " + F1", hl.dsp.togglespecialworkspace("scratchpad"), { desc = "Call special workspace scratchpad" })
-- hl.bind(
-- 	mainMod .. " + ALT + SHIFT + F1",
-- 	hl.dsp.movetoworkspacesilent("special:scratchpad"),
-- 	{ desc = "Move active window to special workspace scratchpad" }
-- )

-- ======= Additional Settings =======

-- https://wiki.hyprland.org/Configuring/Basics/Binds
hl.config({
	binds = {
		workspace_center_on = 1,
		window_direction_monitor_fallback = true,
	},
})
