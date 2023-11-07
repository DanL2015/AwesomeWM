local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local config = require("config")

local function buttons()
    return gears.table.join(awful.button({}, 1, function()
        awful.spawn(config.apps.network_manager, false)
    end))
end

local function update_widget(image, tooltip, res)
    local status = "<b>Unknown</b>"

    -- Edit Image
    if res == nil then
        image.markup = ""
        status = "<b>Unknown</b>"
    elseif res == "" then
        image.markup = ""
        status = "<b>Disconnected</b>"
    else
        image.markup = ""
        status = "<b>Connected</b>: " .. res
    end

    -- Edit Tooltip
    tooltip.markup = status
end

local function create_widget()
    local image = wibox.widget({
        markup = "",
        font = beautiful.font_icon,
        forced_width = beautiful.bar_button_size,
        forced_height = beautiful.bar_button_size,
        valign = "center",
        halign = "center",
        widget = wibox.widget.textbox
    })

    local widget = require("helpers.clickable_widget")(image, image)

    widget:buttons(buttons())

    local tooltip = awful.tooltip({
        objects = {widget},
        markup = ""
    })

    awesome.connect_signal("daemon::wifi::status", function(res)
        update_widget(image, tooltip, res)
    end)

    return widget
end

return create_widget
