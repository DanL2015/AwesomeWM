local awful = require("awful")
local naughty = require("naughty")

local function apply_colors()
	local colors = {}
	colors[1] = "#2c323c"
	colors[9] = "#3e4452"
	colors[2] = "#e06c75"
	colors[10] = "#e06c75"
	colors[3] = "#98c379"
	colors[11] = "#98c379"
	colors[4] = "#e5c07b"
	colors[12] = "#e5c07b"
	colors[5] = "#61afef"
	colors[13] = "#61afef"
	colors[6] = "#c678dd"
	colors[14] = "#c678dd"
	colors[7] = "#56b6c2"
	colors[15] = "#56b6c2"
	colors[8] = "#abb2bf"
	colors[16] = "#5c6370"
	return colors
end

return apply_colors
