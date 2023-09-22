local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

local menu = require("components.menu")

local function create_widget()
	local image = wibox.widget {
		image = beautiful.icon_awesome,
    resize = true,
		widget = wibox.widget.imagebox,
	}

	local widget = require("widgets.clickable_widget")(wibox.widget({
		image,
		margins = beautiful.medium_space,
		layout = wibox.container.margin,
	}))

	widget:buttons(gears.table.join(awful.button({}, 1, function()
    menu.visible = not menu.visible
    awful.placement.next_to_mouse(menu)
	end)))

	return widget
end

return create_widget
