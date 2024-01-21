local awful = require("awful")
local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local config = require("config")

local function update(icon, background, tooltip, id, eth_state, wifi_state)
    if id and (eth_state == "ACTIVATED" or wifi_state == "ACTIVATED") then
        icon.markup = ""
        background.fg = beautiful.blue
        tooltip.markup = "<b>Wifi</b>: " .. id
        return
    end
    icon.markup = ""
    background.fg = beautiful.red
    tooltip.markup = "<b>Disconnected</b>"
end

local function create_widget()
    local icon = wibox.widget({
        font = beautiful.font_icon,
        markup = "",
        valign = "center",
        halign = "center",
        widget = wibox.widget.textbox
    })

    local background = helpers.add_bg0(icon)

    background:buttons({
        awful.button({}, 1, function()
            awful.spawn.with_shell(config.apps.network_manager)
        end)
    })

    local widget = helpers.add_margin(background, beautiful.margin[1], 0)

    local tooltip = awful.tooltip({
        objects = { widget },
        markup = "<b>Unknown</b>"
    })

    awesome.connect_signal("network::update", function(id, eth_state, wifi_state)
        update(icon, background, tooltip, id, eth_state, wifi_state)
    end)

    return widget
end
return create_widget
