local awful = require("awful")
local gears = require("gears")
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
    i = i or 1
    if not M.backgrounds then
        return nil
    end
    return tostring(M.backgrounds[i])
end

function M.get_wallpaper_path(i)
    i = i or 1
    local name = M.get_wallpaper_name(i)
    if name then
        return tostring(M.backgrounds_path .. name)
    end
    return nil
end

function M.set_wallpaper(i)
    if tonumber(i) ~= nil then
        for s in screen do
            gears.wallpaper.maximized(M.get_wallpaper_path(i), s, true)
        end
        awful.spawn.with_shell("echo " .. i .. " > " .. M.file)
        awesome.emit_signal("theme::wallpaper::change")
    else
        awful.spawn.easy_async_with_shell("cat " .. wall_file, function(stdout)
            stdout = stdout:gsub("[\n\r]", "")
            if stdout == "" or tonumber(stdout) == nil then
                stdout = 1
            end
            stdout = tonumber(stdout) or 1
            local path = M.get_wallpaper_path(stdout)
            if path then
                for s in screen do
                    gears.wallpaper.maximized(M.get_wallpaper_path(stdout), s, true)
                end
                awful.spawn.with_shell("echo " .. stdout .. " > " .. M.file)
            end
            awesome.emit_signal("theme::wallpaper::change")
        end)
    end
end

screen.connect_signal("request::desktop_decoration", M.set_wallpaper)
awesome.connect_signal("theme::wallpaper::init", M.set_wallpaper)

return M
