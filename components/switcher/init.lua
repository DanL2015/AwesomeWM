local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local helpers = require("helpers")

local add_background = require("helpers.background_widget")
local add_clickable = require("helpers.clickable_widget")

local M = {}

function M.create_default()
    local image = wibox.widget({
        markup = "",
        font = beautiful.font_icon,
        valign = "center",
        halign = "center",
        forced_height = beautiful.switcher_icon_size,
        forced_width = beautiful.switcher_icon_size,
        widget = wibox.widget.textbox
    })

    local name = wibox.widget({
        markup = "<b>Desktop</b>",
        valign = "center",
        halign = "center",
        forced_width = 150,
        forced_height = 50,
        widget = wibox.widget.textbox
    })

    local background = wibox.widget({
        bg = beautiful.bg0,
        shape = helpers.rounded_rect(),
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
    local icon = c.icon or helpers.get_icon(c.class) or beautiful.icon_command

    local image = wibox.widget({
        image = icon,
        resize = true,
        valign = "center",
        halign = "center",
        forced_height = beautiful.switcher_icon_size,
        forced_width = beautiful.switcher_icon_size,
        widget = wibox.widget.imagebox
    })

    local name = wibox.widget({
        markup = c.class or "Unknown",
        valign = "center",
        halign = "center",
        forced_width = 150,
        forced_height = 50,
        widget = wibox.widget.textbox
    })

    local background = wibox.widget({
        bg = beautiful.bg0,
        shape = helpers.rounded_rect(),
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
    for _, c in ipairs(awful.screen.focused().selected_tag:clients()) do
        M.create_widget(c)
    end
    if #M.clients == 0 then
        M.create_default()
        M.wibox.width = beautiful.switcher_client_width
    else
        M.wibox.width = #M.clients * beautiful.switcher_client_width
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

    if cur == -1 then
        return
    end

    M.clients[cur].background.bg = beautiful.bg0

    if cur == #M.clients then
        cur = 1
    else
        cur = cur + 1
    end

    M.clients[cur].background.bg = beautiful.bg1

    M.clients[cur].client:jump_to()
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

    M.keygrabber = awful.keygrabber({
        keypressed_callback = M.keypressed_callback,
        keyreleased_callback = M.keyreleased_callback
    })

    M.list = wibox.widget({
        spacing = beautiful.switcher_inner_margin,
        layout = wibox.layout.flex.horizontal
    })

    M.widget = wibox.widget({
        {
            M.list,
            margins = beautiful.switcher_inner_margin,
            layout = wibox.container.margin
        },
        bg = beautiful.bg0,
        border_width = beautiful.border_width,
        border_color = beautiful.border_color_normal,
        layout = wibox.container.background
    })

    M.wibox = wibox({
        widget = M.widget,
        screen = awful.screen.focused(),
        ontop = true,
        visible = false
    })

    awesome.connect_signal("switcher::toggle", function()
        M.toggle()
    end)

    return M
end

function M.toggle()
    M.wibox.visible = not M.wibox.visible
    if M.wibox.visible then
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
