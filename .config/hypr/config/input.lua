-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                      Input Configuration                    ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

-- Input wiki https://wiki.hyprland.org/Configuring/Basics/Variables/#input

hl.config({
	input = {
		follow_mouse = 1, -- 0|1|2|3
		float_switch_override_focus = 2,
		kb_layout = "pl",

		touchpad = {
			natural_scroll = true,
			scroll_factor = 0.5,
			drag_lock = false,
		},
	},
})

hl.device({
	name = "elan06fa:00-04f3:3293-touchpad",
	sensitivity = 0.2,
})
