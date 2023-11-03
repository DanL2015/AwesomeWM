local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local systray = require("components.bar.modules.systray").children[1]
local create_clickable = require("helpers.clickable_widget")

local function create_widget(s)
  local image = wibox.widget({
    markup = "",
    font = beautiful.font_icon,
    widget = wibox.widget.textbox,
		forced_width = beautiful.bar_button_size,
		forced_height = beautiful.bar_button_size,
    valign = "center",
    align = "center",
  })

  local rotate = wibox.widget({
    image,
    direction = "west",
    layout = wibox.container.rotate
  })

  local widget = create_clickable(rotate, image)

  rotate:buttons(gears.table.join(awful.button({}, 1, function()
    systray.visible = not systray.visible
    systray.screen = s
    awesome.emit_signal("systray::toggle")
  end)))

  awesome.connect_signal("systray::toggle", function()
    if systray.visible then
      rotate.direction = "east"
    else
      rotate.direction = "west"
    end
  end)
  return widget
end

return create_widget
