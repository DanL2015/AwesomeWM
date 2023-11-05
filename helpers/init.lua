local gears = require("gears")
local beautiful = require("beautiful")
local lgi = require("lgi")
local Gio = lgi.Gio
local Gtk = lgi.require("Gtk", "3.0")
local M = {}

M.rounded_rect = function()
    return function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, beautiful.border_radius)
    end
end

M.rounded_square = function()
    return function(cr, width, height)
        local len = width > height and width or height
        gears.shape.rounded_rect(cr, len, len, beautiful.border_radius)
    end
end

M.gtk_theme = Gtk.IconTheme.get_default()
M.apps = Gio.AppInfo.get_all()

function M.get_icon(client_name)
    if not client_name then
        return nil
    end

    local icon_info = M.gtk_theme:lookup_icon(client_name, beautiful.icon_size or 48, 0)
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

    local info = M.gtk_theme:lookup_by_gicon(gicon, beautiful.icon_size, 0)
    if info then
        return info:get_filename()
    end
end

return M
