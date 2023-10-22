local awful = require("awful")
local gears = require("gears")
local bling = require("bling")
local naughty = require("naughty")

local wall_file = gears.filesystem.get_cache_dir() .. "wallpaper"
local themes_path = gears.filesystem.get_configuration_dir()

local function wall_file_exists()
    local f = io.open(wall_file, "r")
    return f ~= nil and io.close(f)
end

local M = {}

function M.init()
    M.backgrounds_path = themes_path .. "backgrounds/"
    M.backgrounds = {}
    M.background_num = 1
    M.id = 1
    M.file = wall_file
    if not wall_file_exists() then
        awful.spawn.with_shell("echo > " .. wall_file)
    end

    local cmd = "bash -c 'ls " .. M.backgrounds_path .. "'"
    local current_wall = io.popen("cat " .. wall_file):read("*all"):gsub("[\n\r]", "")
    M.id = tonumber(current_wall) or M.id
    awful.spawn.easy_async_with_shell(cmd, function(stdout)
        for s in stdout:gmatch("[^\r\n]+") do
            s = s:gsub("[\n\r]", "")
            M.backgrounds[M.background_num] = s
            M.background_num = M.background_num + 1
        end
        M.background_num = M.background_num - 1
        M.ready = true
        awesome.emit_signal("theme::wallpaper::init")
        awesome.emit_signal("theme::wallpaper::load")
    end)
end

function M.get_wallpaper_name(i)
    return tostring(M.backgrounds[i])
end

function M.get_wallpaper_path(i)
    return tostring(M.backgrounds_path .. M.get_wallpaper_name(i))
end

function M.set_wallpaper(i)
    if tonumber(i) ~= nil then
        bling.module.wallpaper.setup({
            screen = screen,
            position = "maximized",
            wallpaper = M.get_wallpaper_path(i)
        })
        awful.spawn.with_shell("echo " .. i .. " > " .. M.file)
    else
        awful.spawn.easy_async_with_shell("cat " .. wall_file, function(stdout)
            stdout = stdout:gsub("[\n\r]", "")
            if stdout == "" or tonumber(stdout) == nil then
                stdout = 1
            end
            stdout = tonumber(stdout)
            bling.module.wallpaper.setup({
                screen = screen,
                position = "maximized",
                wallpaper = M.get_wallpaper_path(stdout)
            })
            awful.spawn.with_shell("echo " .. stdout .. " > " .. M.file)
        end)
    end
end

screen.connect_signal("request::desktop_decoration", M.set_wallpaper)
awesome.connect_signal("theme::wallpaper::init", M.set_wallpaper)

return M
