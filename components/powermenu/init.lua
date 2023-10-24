local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local helpers = require("helpers")
local rubato = require("rubato")

local add_background = require("helpers.background_widget")
local add_clickable = require("helpers.clickable_widget")

local M = {}
M.buttons = {{
    icon = beautiful.icon_power,
    description = "Power",
    cmd = "systemctl poweroff"
}, {
    icon = beautiful.icon_refresh_ccw,
    description = "Restart",
    cmd = "systemctl reboot"
}, {
    icon = beautiful.icon_lock,
    description = "Lock",
    cmd = "sh $HOME/.config/i3lock-color/lock.sh"
}, {
    icon = beautiful.icon_log_out,
    description = "Exit",
    cmd = "awesome-client 'awesome.quit()'"
}}

function M.toggle()
    M.wibox.visible = not M.wibox.visible
    if M.wibox.visible then
        M.keygrabber:start()
    else
        M.keygrabber:stop()
    end
end

function M.stop()
    M.wibox.visible = false
end

function M.add_button(icon, description, cmd)
    local image = wibox.widget({
        image = icon,
        resize = true,
        valign = "center",
        halign = "center",
        forced_width = 48,
        forced_height = 48,
        widget = wibox.widget.imagebox
    })

    local text = wibox.widget({
        markup = "<b>" .. description .. "</b>",
        valign = "center",
        halign = "center",
        widget = wibox.widget.textbox
    })

    local button = wibox.widget({
        {
            {
                image,
                text,
                layout = wibox.layout.fixed.vertical
            },
            valign = "center",
            halign = "center",
            layout = wibox.container.place
        },
        forced_height = 100,
        forced_width = 100,
        layout = wibox.container.background
    })

    button:add_button(awful.button({}, 1, function()
        M.toggle()
        awful.spawn.with_shell(cmd)
    end))

    M.widget:add(add_clickable(button, 0, 0))
end

function M.new()
    M.widget = wibox.widget({
        layout = wibox.layout.fixed.horizontal
    })

    for _, i in ipairs(M.buttons) do
        M.add_button(i.icon, i.description, i.cmd)
    end

    M.wibox = wibox({
        widget = add_background(M.widget, 0, 0),
        screen = awful.screen.focused(),
        shape = helpers.rounded_rect(8),
        width = 400,
        height = 100,
        ontop = true
    })

    M.keygrabber = awful.keygrabber({
        stop_key = "Escape",
        stop_callback = function()
            M.stop()
        end
    })

    awful.placement.centered(M.wibox)

    awesome.connect_signal("powermenu::toggle", function()
        M.toggle()
    end)

    return M
end

return M.new()
