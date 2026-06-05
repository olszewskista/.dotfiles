-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                     Media Player Control                    ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

local function spotifyRunning()
	for _, w in ipairs(hl.get_windows()) do
		if w.class:lower() == "spotify" then
			return true
		end
	end
	return false
end

--- Run playerctl, targeting Spotify when its window is open.
---@param ... string playerctl arguments (e.g. "play-pause", "next", "previous")
local function player(...)
	local args = table.concat({ ... }, " ")
	local cmd = spotifyRunning() and ("playerctl -p spotify " .. args) or ("playerctl " .. args)
	hl.exec_cmd(cmd)
end

return {
	player = player,
}
