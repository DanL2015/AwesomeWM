local beautiful = require("beautiful")
local wibox = require("wibox")
local helpers = require("helpers")

local function create_widget()
	local systray = wibox.widget({
		widget = wibox.widget.systray(),
        horizontal = false,
	})

    return helpers.add_margin(systray, beautiful.margin[2], beautiful.margin[2])
end

return create_widget
