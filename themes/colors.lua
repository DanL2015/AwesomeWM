local awful = require("awful")
local naughty = require("naughty")

local function apply_colors()
    local colors = {}
    colors[1] = "#13171b"
    colors[9] = "#171B20"
    colors[2] = "#e05f65"
    colors[10] = "#e05f65"
    colors[3] = "#78DBA9"
    colors[11] = "#78DBA9"
    colors[4] = "#f1cf8a"
    colors[12] = "#f1cf8a"
    colors[5] = "#70a5eb"
    colors[13] = "#70a5eb"
    colors[6] = "#c68aee"
    colors[14] = "#c68aee"
    colors[7] = "#74bee9"
    colors[15] = "#74bee9"
    colors[8] = "#b6beca"
    colors[16] = "#dee1e6"
    return colors
end

return apply_colors
