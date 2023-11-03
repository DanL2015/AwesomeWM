local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local gears = require("gears")
local add_background = require("helpers.background_widget")
local helpers = require("helpers")

local function create_widget()
    local function create_large_button(image, text, on_command, off_command)
        local icon = wibox.widget({
            markup = image,
            font = beautiful.font_icon,
            align = "center",
            valign = "center",
            widget = wibox.widget.textbox
        })
        local text = wibox.widget({
            markup = text,
            widget = wibox.widget.textbox
        })

        local description = wibox.widget({
            markup = "Off",
            widget = wibox.widget.textbox
        })

        local background = wibox.widget({
            icon,
            forced_width = beautiful.panel_button_size,
            forced_height = beautiful.panel_button_size,
            bg = beautiful.panel_button_active_bg,
            shape = helpers.rounded_rect(),
            layout = wibox.container.background
        })

        local button = wibox.widget({
            {
                background,
                {
                    {
                        text,
                        description,
                        layout = wibox.layout.fixed.vertical
                    },
                    margins = beautiful.panel_internal_margin,
                    layout = wibox.container.margin
                },
                spacing = beautiful.panel_internal_margin,
                layout = wibox.layout.fixed.horizontal
            },
            margins = beautiful.panel_internal_margin,
            layout = wibox.container.margin
        })

        local buttons = gears.table.join(awful.button({}, 1, function()
            button.on = not button.on
            if button.on then
                awful.spawn.with_shell(on_command)
                background.bg = beautiful.panel_button_active_bg
                background.fg = beautiful.fg0
                description.markup = "On"
            else
                awful.spawn.with_shell(off_command)
                background.bg = beautiful.panel_button_inactive_bg
                description.markup = "Off"
            end
        end))

        background:buttons(buttons)

        return {
            icon = icon,
			image = image,
            text = text,
            description = description,
            button = button,
            background = background
        }
    end

    -- Left widgets
    local wifi = create_large_button("", "<b>Network</b>", "rfkill unblock wifi", "rfkill block wifi")
    local bluetooth = create_large_button("", "<b>Bluetooth</b>", "rfkill unblock bluetooth",
        "rfkill block bluetooth")
    local alerts = create_large_button("", "<b>Alerts</b>", "awesome-client 'require(\"naughty\").suspended=false'",
        "awesome-client 'require(\"naughty\").suspended=true'")

    if naughty.suspended then
        alerts.background.fg = beautiful.fg0
        alerts.description.markup = "Off"
        alerts.button.on = false
    else
        alerts.background.fg = beautiful.bg0
        alerts.description.markup = "On"
        alerts.button.on = true
    end

    local left_buttons_widget = add_background(wibox.widget({
        wifi.button,
        bluetooth.button,
        alerts.button,
        layout = wibox.layout.flex.vertical
    }), 0, 0)

    awesome.connect_signal("daemon::wifi::status", function(stdout)
        if stdout ~= nil and stdout ~= "" then
            wifi.background.bg = beautiful.panel_button_active_bg
            wifi.description.markup = stdout
            wifi.background.fg = beautiful.bg0
            wifi.button.on = true
        else
            wifi.background.bg = beautiful.panel_button_inactive_bg
            wifi.description.markup = "Off"
            wifi.background.fg = beautiful.fg0
            wifi.button.on = false
        end
    end)

    awesome.connect_signal("daemon::bluetooth::status", function(stdout)
        if stdout == "1" then
            bluetooth.description.markup = "On"
            bluetooth.background.bg = beautiful.panel_button_active_bg
            bluetooth.background.fg = beautiful.bg0
            bluetooth.button.on = true
        else
            bluetooth.description.markup = "Off"
            bluetooth.background.bg = beautiful.panel_button_inactive_bg
            bluetooth.background.fg = beautiful.fg0
            bluetooth.button.on = false
        end
    end)
    return left_buttons_widget
end

return create_widget
