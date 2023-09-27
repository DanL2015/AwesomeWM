local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local systray = require("widgets.systray").children[1]

local function create_widget(s)
  local button = wibox.widget({
    widget = wibox.widget.imagebox,
    image = beautiful.icon_chevron_right,
    valign = "center",
    halign = "center",
  })

  button:buttons(gears.table.join(awful.button({}, 1, function()
    systray.visible = not systray.visible
    systray.screen = s
    awesome.emit_signal("systray::toggle")
  end)))

  awesome.connect_signal("systray::toggle", function()
    if systray.visible then
      button.image = beautiful.icon_chevron_right
    else
      button.image = beautiful.icon_chevron_left
    end
  end)

  local widget = require("widgets.clickable_widget")(button)
  return widget
end

return create_widget
