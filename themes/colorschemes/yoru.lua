local awful = require("awful")
local naughty = require("naughty")

local function apply_colors()
	local colors = {}
	colors[1] = "#232526"
	colors[9] = "#2c2e2f"
	colors[2] = "#df5b61"
	colors[10] = "#e8646a"
	colors[3] = "#78b892"
	colors[11] = "#81c19b"
	colors[4] = "#de8f78"
	colors[12] = "#e79881"
	colors[5] = "#6791c9"
	colors[13] = "#709ad2"
	colors[6] = "#bc83e3"
	colors[14] = "#c58cec"
	colors[7] = "#67afc1"
	colors[15] = "#70b8ca"
	colors[8] = "#e4e6e7"
	colors[16] = "#f2f4f5"
	return colors
end

return apply_colors
