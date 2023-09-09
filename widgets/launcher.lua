local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

local menu_awesome = {
    { "Hotkeys",  function() hotkeys_popup.show_help(nil, awful.screen.focused()) end, beautiful.icon_command },
    { "Config",   apps.editor .. " " .. awesome.conffile,                              beautiful.icon_edit },
    { "Logout",   function() awesome.quit() end,                                       beautiful.icon_log_out },
    { "Restart",  "systemctl reboot",                                                  beautiful.icon_refresh_ccw },
    { "Shutdown", "systemctl poweroff",                                                beautiful.icon_power }
}

local menu = awful.menu({
    items = {
        { "Browser",  apps.browser,      beautiful.icon_globe },
        { "Terminal", apps.terminal,     beautiful.icon_terminal },
        { "Files",    apps.file_manager, beautiful.icon_folder },
        { "Awesome",  menu_awesome,      beautiful.icon_chevron_right },
    },
    icon_size = beautiful.menu_icon_size,
})

local function create_widget()
    return wibox.widget {
        widget = wibox.container.margin,
        left = beautiful.xlarge_space,
        right = beautiful.xlarge_space,
        top = beautiful.xlarge_space,
        bottom = beautiful.xlarge_space,
        awful.widget.launcher({
            image = beautiful.icon_awesome,
            menu = menu
        })
    }
end

return create_widget
