local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local create_small_button = require("helpers.small_button_widget")
local helpers = require("helpers")
local naughty = require("naughty")

local function create_widget()

    local power_widget = create_small_button("",
        "awesome-client 'awesome.emit_signal(\"powermenu::toggle\")'", "Powermenu", "#00000000", beautiful.fg0)
    local name = wibox.widget({
        markup = "Name",
        widget = wibox.widget.textbox
    })

    awful.spawn.easy_async_with_shell("echo $USER", function(stdout)
        stdout = stdout:gsub("[\n\r]", ""):gsub("^%l", string.upper)
        name.markup = "Welcome <b>"..stdout.."</b>"
    end)

    local small_widgets = wibox.widget({
        {
            {
                name,
                nil,
                power_widget,
                layout = wibox.layout.align.horizontal
            },
            margins = beautiful.panel_internal_margin,
            layout = wibox.container.margin
        },
        bg = beautiful.panel_widget_bg,
        shape = helpers.rounded_rect(),
        layout = wibox.container.background
    })

    return small_widgets
end

return create_widget
