local awful = require("awful")
local naughty = require("naughty")

local function apply_colors()
    local colors = {}
    colors[1] = "#151b1d"
    colors[9] = "#22292b"
    colors[2] = "#e06e6e"
    colors[10] = "#e06e6e"
    colors[3] = "#8ccf7e"
    colors[11] = "#8ccf7e"
    colors[4] = "#e5c76b"
    colors[12] = "#e5c76b"
    colors[5] = "#67b0e8"
    colors[13] = "#67b0e8"
    colors[6] = "#c47fd5"
    colors[14] = "#c47fd5"
    colors[7] = "#6cd0ca"
    colors[15] = "#6cd0ca"
    colors[8] = "#dadada"
    colors[16] = "#b3b9b8"
    return colors
end

return apply_colors
