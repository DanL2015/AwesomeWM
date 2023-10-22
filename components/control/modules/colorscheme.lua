local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful")
local backgrounds = require("themes.wallpaper")
local colorscheme = require("themes.colorscheme")

local add_background = require("helpers.background_widget")
local create_small_button = require("helpers.small_button_widget")
local last_theme_file = gears.filesystem.get_cache_dir() .. "last_theme"

local M = {}

function M.prev()
    colorscheme.id = colorscheme.id - 1
    if colorscheme.id < 1 then
        colorscheme.id = colorscheme.id + colorscheme.colors_num
    end
    M.textbox.markup = colorscheme.get_color_name(colorscheme.id)
end

function M.next()
    colorscheme.id = colorscheme.id + 1
    if colorscheme.id > colorscheme.colors_num then
        colorscheme.id = colorscheme.id - colorscheme.colors_num
    end
    M.textbox.markup = colorscheme.get_color_name(M.id)
end

function M.new()
    -- Theme switcher widget
    M.theme_loaded = false

    M.textbox = wibox.widget({
        halign = "center",
        valign = "center",
        widget = wibox.widget.textbox
    })

    M.title = wibox.widget({
        halign = "center",
        valign = "center",
        markup = "<b>Colorscheme:</b>",
        widget = wibox.widget.textbox
    })

    M.widget = add_background(wibox.widget({
        {
            M.title,
            M.textbox,
            spacing = beautiful.panel_internal_margin,
            layout = wibox.layout.fixed.vertical
        },
        halign = "center",
        valign = "center",
        layout = wibox.container.place
    }), 0, 0)

    M.widget:buttons(gears.table.join(awful.button({}, 4, function()
        M.prev()
    end), awful.button({}, 5, function()
        M.next()
    end), awful.button({}, 1, function()
        colorscheme.set_color()
        awesome.restart()
    end)))

    awesome.connect_signal("theme::colorscheme::load", function()
        M.textbox.markup = colorscheme.get_color_name()
    end)

    return M
end

return M.new().widget
