-- Contains a bunch of useful helper functions

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local lgi = require("lgi")
local Gio = lgi.Gio
local Gtk = lgi.require("Gtk", "3.0")

local M = {}

function M.rrect()
    return function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, beautiful.radius)
    end
end

function M.circle()
    return function(cr, width, height)
        gears.shape.circle(cr, width, height)
    end
end

-- Makes widget change color on hover
function M.add_click(widget, color)
    color = color or beautiful.blue
    local background = wibox.widget({
        widget,
        shape = M.rrect(),
        layout = wibox.container.background,
    })

    background:connect_signal("mouse::enter", function()
        background.fg = beautiful.bg0
        background.bg = color
    end)

    background:connect_signal("mouse::leave", function()
        background.fg = beautiful.fg0
        background.bg = "#00000000"
    end)

    return background
end

-- Adds background to widget
function M.add_bg0(widget)
    local background = wibox.widget({
        widget,
        layout = wibox.container.background,
        bg = beautiful.bg0,
        fg = beautiful.fg0,
        shape = M.rrect()
    })
    return background
end

function M.add_bg1(widget)
    local background = wibox.widget({
        widget,
        layout = wibox.container.background,
        bg = beautiful.bg1,
        fg = beautiful.fg0,
        shape = M.rrect()
    })
    return background
end

-- Adds margin to widget
function M.add_margin(widget, h, v)
    h = h or beautiful.margin[0]
    v = v or beautiful.margin[0]
    return wibox.container.margin(widget, h, h, v, v)
end

-- Icons
M.gtk_theme = Gtk.IconTheme.get_default()
M.apps = Gio.AppInfo.get_all()

function M.get_icon(client_name)
    if not client_name then
        return nil
    end

    local icon_info = M.gtk_theme:lookup_icon(client_name, beautiful.icon_size[3], 0)
    if icon_info then
        local icon_path = icon_info:get_filename()
        if icon_path then
            return icon_path
        end
    end

    return nil
end

function M.get_gicon_path(gicon)
    if not gicon then
        return nil
    end

    local info = M.gtk_theme:lookup_by_gicon(gicon, beautiful.icon_size[3], 0)
    if info then
        return info:get_filename()
    end
end

return M
