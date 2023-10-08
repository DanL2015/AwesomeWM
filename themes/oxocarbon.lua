local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local set_theme = require("themes.theme")

local last_theme_file = gears.filesystem.get_cache_dir() .. "last_theme"

local function apply_colors()
	local colors = {}
	colors[1] = "#161616"
	colors[9] = "#262626"
	colors[2] = "#ff7eb6"
	colors[10] = "#ff7eb6"
	colors[3] = "#42be65"
	colors[11] = "#42be65"
	colors[4] = "#ffe97b"
	colors[12] = "#ffe97b"
	colors[5] = "#33b1ff"
	colors[13] = "#33b1ff"
	colors[6] = "#ee5396"
	colors[14] = "#ee5396"
	colors[7] = "#3ddbd9"
	colors[15] = "#3ddbd9"
	colors[8] = "#ffffff"
	colors[16] = "#f2f4f8"
	set_theme(colors)
	awful.spawn.with_shell("echo oxocarbon > "..last_theme_file)
  return 1
end

return apply_colors
