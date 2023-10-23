local awful = require("awful")
local naughty = require("naughty")

local function apply_colors()
    local colors = {}
    colors[1] = "#0f0f0f"
    colors[9] = "#191919"
    colors[2] = "#ac8a8c"
    colors[10] = "#c49ea0"
    colors[3] = "#8aac8b"
    colors[11] = "#9ec49f"
    colors[4] = "#aca98a"
    colors[12] = "#c4c19e"
    colors[5] = "#8f8aac"
    colors[13] = "#a39ec4"
    colors[6] = "#ac8aac"
    colors[14] = "#c49ec4"
    colors[7] = "#8aabac"
    colors[15] = "#9ec3c4"
    colors[8] = "#cacaca"
    colors[16] = "#bfbfbf"
    return colors
end

return apply_colors
