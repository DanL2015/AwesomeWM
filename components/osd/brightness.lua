local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

local M = {}

M.timeout = 2

function M.update_widget(value)
  M.slider.value = value
  M.text.markup = tostring(value) .. "%"
end

function M.display_widget()
  M.wibox.screen = awful.screen.focused()
  awful.placement.bottom(M.wibox, {
    margins = {
      bottom = 2 * beautiful.useless_gap,
    }
  })
  M.wibox.visible = true
  M.timer:again()
end

function M.hide_widget()
  M.wibox.visible = false
  M.timer:stop()
end

function M.new()
  M.icon = wibox.widget({
    widget = wibox.widget.textbox,
    font = beautiful.font_icon_large,
    markup = "",
    halign = "center",
    valign = "center",
    forced_width = beautiful.icon_size[2],
    forced_height = beautiful.icon_size[2]
  })

  M.background = helpers.add_bg0(M.icon)

  M.text = wibox.widget({
    widget = wibox.widget.textbox,
    markup = "0%",
    halign = "center",
    valign = "center",
    forced_width = beautiful.icon_size[2],
    forced_height = beautiful.icon_size[2]
  })

  M.slider = wibox.widget({
    background_color = beautiful.bg1,
    color = beautiful.blue,
    thickness = beautiful.dpi(8),
    shape = helpers.rrect(),
    bar_shape = helpers.rrect(),
    max_value = 100,
    start_angle = 0,
    forced_width = beautiful.dpi(200),
    forced_height = beautiful.dpi(20),
    widget = wibox.widget.progressbar
  })

  M.widget = helpers.add_bg0(helpers.add_margin(wibox.widget({
    M.background,
    helpers.add_margin(M.slider, beautiful.margin[2], beautiful.margin[2]),
    M.text,
    layout = wibox.layout.fixed.horizontal
  }), beautiful.margin[2], beautiful.margin[2]))

  M.wibox = awful.popup({
    width = beautiful.dpi(400),
    height = beautiful.dpi(400),
    widget = M.widget,
    ontop = true,
    visible = false,
    border_color = beautiful.border_color_active,
    border_width = beautiful.border_width,
    shape = helpers.rrect(),
  })

  M.timer = gears.timer({
    timeout = M.timeout,
    autostart = false,
    call_now = false,
    callback = function()
      M.wibox.visible = false
    end,
    single_shot = true
  })

  awesome.connect_signal("brightness::update", function(value)
    M.update_widget(value)
  end)

  awesome.connect_signal("brightness::osd", function()
    M.display_widget()
  end)

  awesome.connect_signal("volume::osd", function()
    M.hide_widget()
  end)

  return M.wibox
end

return M
