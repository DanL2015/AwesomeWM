local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local systray = require("components.bar.modules.systray").children[1]
local create_clickable = require("helpers.clickable_widget")

local function create_widget(s)
    local image = wibox.widget({
        markup = "",
        font = beautiful.font_icon,
        valign = "center",
        halign = "center",
        widget = wibox.widget.textbox
    })

    local widget = create_clickable(image, image)

    widget:buttons(gears.table.join(awful.button({}, 1, function()
        systray.visible = not systray.visible
        systray.screen = s
        awesome.emit_signal("systray::toggle")
    end)))

    awesome.connect_signal("systray::toggle", function()
        if systray.visible then
            image.markup = ""
        else
            image.markup = ""
        end
    end)
    return widget
end

return create_widget
