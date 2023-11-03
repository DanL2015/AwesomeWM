local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful")
local helpers = require("helpers")
local backgrounds = require("themes.wallpaper")
local colorscheme = require("themes.colorscheme")

local add_background = require("helpers.background_widget")
local create_small_button = require("helpers.small_button_widget")

local M = {}

function M.prev()
    backgrounds.id = backgrounds.id - 1
    if backgrounds.id < 1 then
        backgrounds.id = backgrounds.id + backgrounds.background_num
    end
    M.textbox.markup = backgrounds.get_wallpaper_name(backgrounds.id)
    awesome.emit_signal("theme::wallpaper::load")
end

function M.next()
    backgrounds.id = backgrounds.id + 1
    if backgrounds.id > backgrounds.background_num then
        backgrounds.id = backgrounds.id - backgrounds.background_num
    end
    M.textbox.markup = backgrounds.get_wallpaper_name(backgrounds.id)
    awesome.emit_signal("theme::wallpaper::load")
end

function M.new()
    -- Wallpaper switcher widget
    M.theme_loaded = false

    M.textbox = wibox.widget({
        halign = "center",
        valign = "center",
        widget = wibox.widget.textbox
    })

    M.title = wibox.widget({
        halign = "center",
        valign = "center",
        markup = "<b>Wallpaper:</b>",
        widget = wibox.widget.textbox
    })

    M.image = wibox.widget({
        halign = "center",
        valign = "center",
        horizontal_fit_policy = true,
        vertical_fit_policy = true,
        resize = true,
        opacity = 0.5,
        clip_shape = helpers.rounded_rect(),
        widget = wibox.widget.imagebox
    })

    M.widget = wibox.widget({
        M.image,
        {
            {
                M.title,
                M.textbox,
                spacing = beautiful.panel_internal_margin,
                layout = wibox.layout.fixed.vertical
            },
            halign = "center",
            valign = "center",
            layout = wibox.container.place
        },
        layout = wibox.layout.stack
    })

    M.widget:buttons(gears.table.join(awful.button({}, 4, function()
        M.prev()
    end), awful.button({}, 5, function()
        M.next()
    end), awful.button({}, 1, function()
        backgrounds.set_wallpaper(backgrounds.id)
        awesome.restart()
    end)))

    awesome.connect_signal("theme::wallpaper::load", function()
        M.image.image = gears.surface.load_uncached(backgrounds.get_wallpaper_path(backgrounds.id))
        M.textbox.markup = backgrounds.get_wallpaper_name(backgrounds.id)
    end)

    return M
end

return M.new().widget
