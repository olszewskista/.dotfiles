-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                         Keybinds                            ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

local config = require("config.defaults")
local defaults = config.defaults
local player = require("scripts.player").player
local HOME = os.getenv("HOME")

local mainMod = "SUPER"
local hyprMod = "SUPER + CTRL"

local function launchApp(exec, class)
	local windows = hl.get_windows({ class = class or exec })
	local w = windows[1]

	if not w then
		hl.exec_cmd(exec)
		return
	end

	hl.dispatch(hl.dsp.focus({ window = w }))
end

-- https://wiki.hyprland.org/Configuring/Basics/Binds/

-- ======= Apps =======
local appKeybinds = {
	T = { "kitty" },
	E = { "nautilus", "org.gnome.Nautilus" },
	F = { "helium-browser", "helium" },
	C = { "code" },
	N = { "obsidian" },
	S = { "spotify-launcher", "Spotify" },
	B = { "brave", "brave-browser" },
}

for k, v in pairs(appKeybinds) do
	hl.bind(mainMod .. " + SHIFT + " .. k, hl.dsp.exec_cmd(v[1]), { desc = "Opens your preferred " .. k })
	hl.bind(mainMod .. " + " .. k, function()
		launchApp(v[1], v[2])
	end, { desc = "Open or go to your preferred " .. k })
end

hl.bind(
	hyprMod .. " + T",
	hl.dsp.exec_cmd("[float; size (monitor_w*0.75) (monitor_h*0.75)] " .. defaults.terminal),
	{ desc = "Opens your preferred terminal as float" }
)
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

hl.bind(mainMod .. " + Backslash", hl.dsp.layout("togglesplit"), { desc = "Toggles current window split mode" })
hl.bind(mainMod .. " + Backspace", hl.dsp.exec_cmd("wlogout"), { desc = "Logout screen" })

-- hl.bind("ALT + Tab", hl.dsp.focus({ workspace = "previous" }))

-- ======= Snappy =======

hl.bind("ALT + Tab", hl.dsp.exec_cmd("snappy-switcher next --mod alt"))


-- ======= Rofi =======
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(defaults.applauncher), { desc = "Runs your application launcher" })
-- hl.bind(mainMod .. " + TAB", hl.dsp.exec_cmd("rofi -show window"), { desc = "Rofi window select" })
hl.bind(mainMod .. " + PERIOD", hl.dsp.exec_cmd("rofi -modi emoji -show emoji"), { desc = "Show emoji" })
hl.bind(
	mainMod .. " + V",
	hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"),
	{ desc = "Clipboard" }
)
hl.bind(
	mainMod .. " + SHIFT + W",
	hl.dsp.exec_cmd(HOME .. "/.config/hypr/scripts/wallpaper_select.sh"),
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
		player("play-pause")
	end,
})
hl.gesture({
	fingers = 3,
	direction = "left",
	action = function()
		player("next")
	end,
})
hl.gesture({
	fingers = 3,
	direction = "right",
	action = function()
		player("previous")
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
hl.bind("XF86AudioPlay", function()
	player("play-pause")
end, { locked = true, desc = "Toggles play/pause" })
hl.bind("XF86AudioNext", function()
	player("next")
end, { locked = true, desc = "Next track" })
hl.bind("XF86AudioPrev", function()
	player("previous")
end, { locked = true, desc = "Previous track" })

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

hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("deepin-calculator"), { desc = "Runs the calculator application" })
-- hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("killall -SIGUSR1 waybar"), { desc = "Reload Waybar" })
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd(HOME .. "/.config/hypr/scripts/waybar.sh"))

-- ======= Laptop Screen Toggle =======

local function toggleLaptopScreen()
	local laptopOutput = "eDP-1"
	local mon = hl.get_monitor(laptopOutput)

	if mon then
		hl.notification.create({ text = tostring(mon), duration = 1000 })
		hl.monitor({ output = laptopOutput, disabled = true })
	else
		hl.monitor({
			output = laptopOutput,
			mode = "preferred",
			position = "0x0",
			scale = 1.6,
			disabled = false,
		})
	end
end

hl.bind(mainMod .. " + SHIFT + Backspace", toggleLaptopScreen, { locked = true, desc = "Toggle on/off laptop screen" })

-- ======= Window Actions =======

-- key -> direction
for k, v in pairs({
	h = "l",
	l = "r",
	k = "u",
	j = "d",
	left = "l",
	right = "r",
	up = "u",
	down = "d",
}) do
	hl.bind(mainMod .. " + " .. k, hl.dsp.focus({ direction = v }), { desc = "Move focus to the " .. v })
	hl.bind(
		mainMod .. " + CTRL + " .. k,
		hl.dsp.window.move({ direction = v }),
		{ desc = "Move active window to the " .. v }
	)
end

-- ======= Resizing Windows =======

-- key -> resize
local resizeBinds = {
	{ key = "right", resize = { x = 15, y = 0, relative = true }, desc = "Resize to the right (resizing mode)" },
	{ key = "left", resize = { x = -15, y = 0, relative = true }, desc = "Resize to the left (resizing mode)" },
	{ key = "up", resize = { x = 0, y = -15, relative = true }, desc = "Resize upwards (resizing mode)" },
	{ key = "down", resize = { x = 0, y = 15, relative = true }, desc = "Resize downwards (resizing mode)" },
	{ key = "l", resize = { x = 15, y = 0, relative = true }, desc = "Resize to the right (resizing mode)" },
	{ key = "h", resize = { x = -15, y = 0, relative = true }, desc = "Resize to the left (resizing mode)" },
	{ key = "k", resize = { x = 0, y = -15, relative = true }, desc = "Resize upwards (resizing mode)" },
	{ key = "j", resize = { x = 0, y = 15, relative = true }, desc = "Resize downwards (resizing mode)" },
}

-- https://wiki.hyprland.org/Configuring/Basics/Binds/#submaps
hl.bind(mainMod .. " + R", hl.dsp.submap("resize"), { desc = "Activates window resizing mode" })

-- Activate keyboard window resize mode
hl.define_submap("resize", function()
	for _, bind in pairs(resizeBinds) do
		hl.bind(bind.key, hl.dsp.window.resize(bind.resize), { repeating = true, desc = bind.desc })
	end
	hl.bind("escape", hl.dsp.submap("reset"), { repeating = true, desc = "Ends window resizing mode" })
end)

-- Quick resize window with keyboard
for _, bind in ipairs(resizeBinds) do
	hl.bind(
		mainMod .. " + ALT + " .. bind.key,
		hl.dsp.window.resize(bind.resize),
		{ repeating = true, desc = bind.desc:gsub(" %(resizing mode%)", "") }
	)
end

-- Resize window with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true }) -- Resize the window towards a direction
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true }) -- Drag window

-- ======= Workspace Navigation =======

for i = 1, 10 do
	local workspaceKey = tostring(i % 10)

	hl.bind(
		mainMod .. " + SHIFT + " .. workspaceKey,
		hl.dsp.window.move({ workspace = i, follow = true }),
		{ desc = "Move window and switch to workspace " .. i }
	)
	hl.bind(
		mainMod .. " + " .. tostring(i % 10),
		hl.dsp.focus({ workspace = i }),
		{ desc = "Switch to workspace " .. i }
	)
end

hl.bind(
	mainMod .. " + CTRL + SHIFT + h",
	hl.dsp.window.move({ workspace = "r-1", follow = true }),
	{ desc = "Move window and switch to the next workspace" }
)
hl.bind(
	mainMod .. " + CTRL + SHIFT + l",
	hl.dsp.window.move({ workspace = "r+1", follow = true }),
	{ desc = "Move window and switch to the previous workspace" }
)
-- hl.bind(mainMod .. " + SHIFT + l", function()
-- 	local x = hl.get_workspaces()
-- end, { desc = "Change active workspace forwards" })

hl.bind(mainMod .. " + SHIFT + l", hl.dsp.focus({ workspace = "r+1" }), { desc = "Change active workspace forwards" })
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.focus({ workspace = "r-1" }), { desc = "Change active workspace backwards" })

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(
	mainMod .. " + mouse_down",
	hl.dsp.focus({ workspace = "m+1" }),
	{ desc = "Scroll through workspaces incrementally" }
)
hl.bind(
	mainMod .. " + mouse_up",
	hl.dsp.focus({ workspace = "m-1" }),
	{ desc = "Scroll through workspaces decrementally" }
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
