local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local helpers = require("helpers")

local config = require("config")

local entries = {{"separator"}, {"", config.apps.browser, "Browser"}, {"", config.apps.terminal, "Terminal"},
                 {"", config.apps.file_manager, "Files"}, {"", config.apps.settings, "Settings"}, {"separator"},
                 {"", "systemctl suspend", "Suspend"},
                 {"", "awesome-client 'awesome.emit_signal(\"lockscreen::toggle\")'", "Lock"},
                 {"", "systemctl poweroff", "Poweroff"}}

local menu = {}

local function create_menu()
    local widget = wibox.widget({
        {
            valign = "center",
            halign = "center",
            markup = "<b>Menu</b>",
            widget = wibox.widget.textbox
        },
        layout = wibox.layout.fixed.vertical,
        spacing = beautiful.small_space
    })

    for _, entry in ipairs(entries) do
        if entry[1] == "separator" then
            local separator = wibox.widget({
                thickness = 2,
                shape = helpers.rounded_rect(),
                forced_height = 2,
                forced_width = 10,
                widget = wibox.widget.separator
            })
            widget:add(separator)
        else
            local icon = wibox.widget({
                markup = entry[1],
                font = beautiful.font_icon,
                forced_width = 30,
                forced_height = 30,
                widget = wibox.widget.textbox
            })

            local title = wibox.widget({
                markup = entry[3],
                widget = wibox.widget.textbox
            })

            local button = wibox.widget({
                icon,
                title,
                layout = wibox.layout.fixed.horizontal,
                spacing = beautiful.medium_space
            })

            local template = require("helpers.clickable_widget")(button, button)

            template:buttons(gears.table.join(awful.button({}, 1, function()
                awful.spawn(entry[2])
            end)))

            widget:add(template)
        end
    end

    local menu = awful.popup({
        widget = {
            widget,
            margins = beautiful.menu_padding,
            layout = wibox.container.margin
        },
        shape = helpers.rounded_rect(),
        border_width = beautiful.border_width,
        border_color = beautiful.border_color_normal,
        ontop = true,
        visible = false,
        hide_on_right_click = true
    })

    return menu
end

menu.widget = create_menu()

function menu:set_pos()
    local coords = mouse.coords()
    local workarea = mouse.screen.workarea
    menu.widget.x = coords.x
    menu.widget.y = coords.y

    -- Check if needs to be spawned above mouse
    if menu.widget.y + menu.widget.height - workarea.y >= workarea.height then
        menu.widget.y = menu.widget.y - menu.widget.height
    end

    -- Check if needs to be spawned to left of mouse
    if menu.widget.x + menu.widget.width - workarea.x >= workarea.width then
        menu.widget.x = menu.widget.x - menu.widget.width
    end
end

function menu:toggle()
    menu.widget.visible = not menu.widget.visible
    if menu.widget.visible == true then
        self:set_pos()
    end
end

return menu
