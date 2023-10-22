local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

local color_file = gears.filesystem.get_configuration_dir() .. "themes/colors.lua"
local cache_file = gears.filesystem.get_cache_dir() .. "colors"
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
    M.id = 1
    M.file = color_file

    if not color_file_exists() then
        awful.spawn.with_shell("echo > " .. color_file)
    end

    local current_theme = io.popen("cat " .. cache_file):read("*all"):gsub("[\n\r]", "")
    local cmd = "bash -c 'ls " .. M.colors_path .. "'"
    awful.spawn.easy_async_with_shell(cmd, function(stdout)
        for s in stdout:gmatch("[^\r\n]+") do
            s = s:gsub("[\n\r]", ""):sub(1, -5)
            M.colors[M.colors_num] = s
            if s == current_theme then
                M.id = M.colors_num
            end
            M.colors_num = M.colors_num + 1
        end
        M.colors_num = M.colors_num - 1
        awesome.emit_signal("theme::colorscheme::load")
    end)
end

function M.get_color_name(i)
    i = i or M.id
    return tostring(M.colors[M.id])
end

function M.get_color_path(i)
    i = i or M.id
    return tostring(M.colors_path .."/".. M.colors[M.id] .. ".lua")
end

function M.set_color(i)
    i = i or M.id
    awful.spawn.with_shell("cp " .. M.get_color_path(i) .. " " .. color_file)
    awful.spawn.with_shell("echo " .. M.get_color_name(i) .. " > " .. cache_file)
end

return M
