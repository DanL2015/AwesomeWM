local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

local M = {}

function M.create_default()
  local image = wibox.widget({
    markup = "",
    font = beautiful.font_icon_large,
    valign = "center",
    halign = "center",
    widget = wibox.widget.textbox
  })

  local name = wibox.widget({
    markup = "<b>Desktop</b>",
    valign = "center",
    halign = "center",
    forced_width = beautiful.dpi(150),
    forced_height = beautiful.dpi(50),
    widget = wibox.widget.textbox
  })

  local background = wibox.widget({
    bg = beautiful.bg0,
    shape = helpers.rrect(),
    widget = wibox.container.background
  })

  local widget = wibox.widget({
    background,
    {
      image,
      valign = "center",
      halign = "center",
      layout = wibox.container.place
    },
    {
      name,
      valign = "bottom",
      halign = "center",
      layout = wibox.container.place
    },
    layout = wibox.layout.stack
  })

  M.list:add(widget)
end

function M.create_widget(c)
  local icon = c.icon or helpers.get_icon(c.class) or beautiful.icon_default

  local image = wibox.widget({
    image = icon,
    resize = true,
    valign = "center",
    halign = "center",
    forced_width = beautiful.icon_size[3],
    forced_height = beautiful.icon_size[3],
    widget = wibox.widget.imagebox
  })

  local name = wibox.widget({
    markup = c.class and c.class:gsub("^%l", string.upper) or "Unknown",
    valign = "center",
    halign = "center",
    forced_width = beautiful.dpi(150),
    forced_height = beautiful.dpi(50),
    widget = wibox.widget.textbox
  })

  local background = wibox.widget({
    bg = beautiful.bg0,
    shape = helpers.rrect(),
    widget = wibox.container.background
  })

  local widget = wibox.widget({
    background,
    {
      image,
      valign = "center",
      halign = "center",
      layout = wibox.container.place
    },
    {
      name,
      valign = "bottom",
      halign = "center",
      layout = wibox.container.place
    },
    layout = wibox.layout.stack
  })

  M.list:add(widget)

  table.insert(M.clients, {
    background = background,
    client = c
  })
end

function M.place()
  M.wibox.screen = awful.screen.focused()
  awful.placement.centered(M.wibox)
end

function M.update_clients()
  M.list:reset()
  M.clients = {}
  for _, c in ipairs(M.history) do
    M.create_widget(c)
  end

  for _, i in ipairs(awful.screen.focused().selected_tag:clients()) do
    local in_history = false
    for _, j in ipairs(M.history) do
      if i == j then
        in_history = true
        break
      end
    end
    if not in_history then
      M.create_widget(i)
    end
  end

  if #M.clients == 0 then
    M.create_default()
    M.wibox.width = beautiful.switcher_width
  else
    M.wibox.width = #M.clients * beautiful.switcher_width
  end
  M.wibox.height = beautiful.switcher_height
  M.place()
end

function M.cycle()
  local cur = -1
  for i, c in ipairs(M.clients) do
    if c.client == client.focus then
      cur = i
      break
    end
  end

  if cur ~= -1 then
    M.clients[cur].background.bg = beautiful.bg0
    M.clients[cur].client.minimized = M.client_minimized
  else
    cur = 1
  end

  if cur == #M.clients then
    cur = 1
  else
    cur = cur + 1
  end

  if M.clients[cur] then
    M.clients[cur].background.bg = beautiful.bg2

    M.client_minimized = M.clients[cur].client.minimized
    M.clients[cur].client:jump_to()
    for i, c in ipairs(M.history) do
      if c == M.clients[cur].client then
        table.remove(M.history, i)
      end
    end
    table.insert(M.history, 1, M.clients[cur].client)
  end
end

function M.keypressed_callback(_, mod, key, event)
  if key == "Tab" then
    M.cycle()
  end
end

function M.keyreleased_callback(_, mod, key, event)
  if key:match("Alt") then
    M.stop()
  end
end

function M.new()
  M.clients = {}
  M.history = {}

  M.keygrabber = awful.keygrabber({
    keypressed_callback = M.keypressed_callback,
    keyreleased_callback = M.keyreleased_callback
  })

  M.list = wibox.widget({
    spacing = beautiful.margin[0],
    layout = wibox.layout.flex.horizontal
  })

  M.widget = helpers.add_bg0(helpers.add_margin(M.list))

  M.wibox = wibox({
    widget = M.widget,
    screen = awful.screen.focused(),
    ontop = true,
    visible = false,
    shape = helpers.rrect(),
    border_color = beautiful.border_color_active,
    border_width = beautiful.border_width,
  })

  awesome.connect_signal("switcher::toggle", function()
    M.toggle()
  end)

  tag.connect_signal("property::selected", function(t)
    M.history = {}
  end)

  return M
end

function M.toggle()
  M.wibox.visible = not M.wibox.visible
  if M.wibox.visible then
    M.client_minimized = false
    M.place()
    M.update_clients()
    M.cycle()
    M.keygrabber:start()
  else
    M.keygrabber:stop()
  end
end

function M.stop()
  M.wibox.visible = false
  M.keygrabber:stop()
end

return M.new()
