local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")

local function create_widget()
  local image = wibox.widget {
    image = beautiful.icon_awesome,
    resize = true,
    widget = wibox.widget.imagebox,
  }

  local widget = helpers.add_margin(
  helpers.add_click(helpers.add_margin(image, beautiful.margin[1], beautiful.margin[1])), beautiful.margin[0],
    beautiful.margin[0])

  local tooltip = helpers.add_tooltip(widget, "<b>Launch</b>")

  widget:buttons({
    awful.button({}, 1, function()
      awesome.emit_signal("launcher::toggle")
    end)
  })

  return widget
end

return create_widget
