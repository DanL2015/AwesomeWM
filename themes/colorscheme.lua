local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

local color_file = gears.filesystem.get_configuration_dir() .. "themes/colors.lua"
local themes_path = gears.filesystem.get_configuration_dir()

local function color_file_exists()
    local f = io.open(color_file, "r")
    return f ~= nil and io.close(f)
end

local M = {}

function M.init()
    M.colors_path = themes_path .. "themes/colorschemes"
    M.colors = {}
    M.colors_num = 1
    M.file = color_file

    if not color_file_exists() then
        awful.spawn.with_shell("echo > " .. color_file)
    end
    local cmd = "bash -c 'ls " .. M.colors_path .. "'"
    awful.spawn.easy_async_with_shell(cmd, function(stdout)
        for s in stdout:gmatch("[^\r\n]+") do
            s = s:gsub("[\n\r]", ""):sub(1, -5)
            M.colors[M.colors_num] = s
            M.colors_num = M.colors_num + 1
        end
        M.colors_num = M.colors_num - 1
        awesome.emit_signal("theme::colorscheme::load")
    end)
end

function M.get_color_name(i)
    return tostring(M.colors[i])
end

function M.get_color_path(i)
    return tostring(M.colors_path .."/".. M.colors[i] .. ".lua")
end

function M.set_color(i)
    if i == nil or tonumber(i) == nil then
        i = 1
    end
    awful.spawn.with_shell("cp " .. M.get_color_path(i) .. " " .. color_file)
end

return M
