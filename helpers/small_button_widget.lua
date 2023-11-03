local naughty = require("naughty")
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

local function create_small_button(image, command, description, bgcolor, fgcolor)
	bgcolor = bgcolor or beautiful.panel_button_active_bg
	fgcolor = fgcolor or beautiful.bg0
    local icon = wibox.widget({
        widget = wibox.widget.textbox,
        markup = image,
        font = beautiful.font_icon,
        align = "center",
        valign = "center"
    })
    local buttons = gears.table.join(awful.button({}, 1, function()
        awful.spawn.with_shell(command)
    end))
    local background = wibox.widget({
        icon,
        forced_width = beautiful.panel_button_size,
        forced_height = beautiful.panel_button_size,
        fg = fgcolor,
        bg = bgcolor,
        shape = helpers.rounded_rect(),
        layout = wibox.container.background
    })
    background:buttons(buttons)

    local tooltip = awful.tooltip({
        objects = {background},
        markup = description
    })

    return background
end

return create_small_button
