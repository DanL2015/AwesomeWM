local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local helpers = require("helpers")

local M = {}

function M.new()
  M.art = wibox.widget({
    image = beautiful.icon_music,
    resize = true,
    halign = "center",
    valign = "center",
    forced_height = beautiful.icon_size[3],
    forced_width = beautiful.icon_size[3],
    clip_shape = helpers.rrect(),
    widget = wibox.widget.imagebox
  })

  M.title_text = wibox.widget({
    markup = "Playing",
    halign = "left",
    valign = "center",
    widget = wibox.widget.textbox
  })

  M.title = wibox.widget({
    layout = wibox.container.scroll.horizontal,
    step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
    fps = 60,
    speed = 75,
    M.title_text
  })

  M.title:pause()

  M.artist_text = wibox.widget({
    markup = "Nothing",
    halign = "left",
    valign = "center",
    widget = wibox.widget.textbox
  })

  M.artist = wibox.widget({
    layout = wibox.container.scroll.horizontal,
    step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
    fps = 60,
    speed = 75,
    M.artist_text
  })

  M.artist:pause()

  M.toggle_icon = wibox.widget({
    markup = "",
    widget = wibox.widget.textbox,
    font = beautiful.font_icon_large,
    forced_height = beautiful.icon_size[1],
    forced_width = beautiful.icon_size[1],
    halign = "center",
    valign = "center"
  })

  M.prev_icon = wibox.widget({
    markup = "",
    widget = wibox.widget.textbox,
    font = beautiful.font_icon_large,
    forced_height = beautiful.icon_size[1],
    forced_width = beautiful.icon_size[1],
    halign = "center",
    valign = "center"
  })

  M.next_icon = wibox.widget({
    markup = "",
    widget = wibox.widget.textbox,
    font = beautiful.font_icon_large,
    forced_height = beautiful.icon_size[1],
    forced_width = beautiful.icon_size[1],
    halign = "center",
    valign = "center"
  })

  M.toggle = helpers.add_bg1(helpers.add_margin(M.toggle_icon))
  M.prev = helpers.add_bg1(helpers.add_margin(M.prev_icon))
  M.next = helpers.add_bg1(helpers.add_margin(M.next_icon))

  M.prev.fg = beautiful.blue
  M.next.fg = beautiful.blue

  M.toggle_icon:buttons(gears.table.join(awful.button({}, 1, function()
    awesome.emit_signal("playerctl::toggle")
  end)))

  M.next_icon:buttons(gears.table.join(awful.button({}, 1, function()
    awesome.emit_signal("playerctl::next")
  end)))

  M.prev_icon:buttons(gears.table.join(awful.button({}, 1, function()
    awesome.emit_signal("playerctl::prev")
  end)))

  M.button_group = helpers.add_margin(wibox.widget({
    M.prev,
    M.toggle,
    M.next,
    layout = wibox.layout.flex.horizontal
  }))

  M.text_group = helpers.add_margin(wibox.widget({
    M.artist,
    M.title,
    layout = wibox.layout.flex.vertical
  }))

  M.widget = helpers.add_margin(helpers.add_bg1(helpers.add_margin(wibox.widget({
    helpers.add_margin(M.art, beautiful.margin[1], beautiful.margin[1]),
    M.text_group,
    M.button_group,
    layout = wibox.layout.align.horizontal
  }))))

  M.widget:connect_signal("mouse::enter", function()
    M.title:continue()
    M.artist:continue()
  end)

  M.widget:connect_signal("mouse::leave", function()
    M.title:pause()
    M.artist:pause()
  end)

  awesome.connect_signal("playerctl::metadata::update", function(title, artist, player_name, album)
    M.artist_text.markup = artist or "Nothing"
    M.title_text.markup = title or "Playing"
  end)

  awesome.connect_signal("playerctl::art::update", function(art_path)
    M.art.image = art_path and gears.surface.load_uncached_silently(art_path) or beautiful.icon_music
  end)

  awesome.connect_signal("playerctl::toggle::update", function(playing)
    if playing then
      M.toggle_icon.markup = ""
    else
      M.toggle_icon.markup = ""
    end
  end)

  return M.widget
end

return M
