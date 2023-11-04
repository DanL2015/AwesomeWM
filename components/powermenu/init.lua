local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local helpers = require("helpers")
local rubato = require("rubato")

local backgrounds = require("themes.wallpaper")

local add_background = require("helpers.background_widget")
local add_clickable = require("helpers.clickable_widget")

local M = {}
M.buttons = {{
    icon = "⏻",
    description = "Power",
    cmd = "systemctl poweroff"
}, {
    icon = "⏼",
    description = "Restart",
    cmd = "systemctl reboot"
}, {
    icon = "",
    description = "Lock",
    cmd = "awesome-client 'awesome.emit_signal(\"lockscreen::toggle\")'"
}, {
    icon = "⏏",
    description = "Exit",
    cmd = "awesome-client 'awesome.quit()'"
}}

function M.toggle()
    M.wibox.visible = not M.wibox.visible
    if M.wibox.visible then
        awful.spawn.easy_async("uptime -p", function(stdout)
            M.uptime.markup = (stdout:gsub("^%l", string.upper))
        end)
        awful.spawn.easy_async_with_shell("echo $USER", function(stdout)
            stdout = stdout:gsub("[\n\r]", ""):gsub("^%l", string.upper)
            M.greeting.markup = "<b>Welcome " .. stdout .. "!</b>"
        end)
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
        markup = icon,
        font = beautiful.font_icon,
        valign = "center",
        align = "center",
        forced_width = beautiful.powermenu_icon_size,
        forced_height = beautiful.powermenu_icon_size,
        widget = wibox.widget.textbox
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
        forced_height = beautiful.powermenu_button_size,
        forced_width = beautiful.powermenu_button_size,
        layout = wibox.container.background
    })

    button:add_button(awful.button({}, 1, function()
        M.toggle()
        awful.spawn.with_shell(cmd)
    end))

    M.button_group:add(add_clickable(button, 0, 0))
end

function M.new()
    M.button_group = wibox.widget({
        layout = wibox.layout.fixed.vertical,
    })

    M.image = wibox.widget({
        halign = "center",
        valign = "center",
        vertical_fit_policy = true,
        resize = true,
        opacity = 0.4,
        clip_shape = helpers.rounded_rect(),
        widget = wibox.widget.imagebox
    })

    M.pfp = wibox.widget({
        image = gears.filesystem.get_configuration_dir() .. "/pfp.jpg",
        halign = "center",
        valign = "center",
        forced_height = beautiful.powermenu_pfp_size,
        forced_width = beautiful.powermenu_pfp_size,
        resize = true,
        clip_shape = gears.shape.circle,
        widget = wibox.widget.imagebox
    })

    M.uptime = wibox.widget({
        halign = "center",
        valign = "center",
        widget = wibox.widget.textbox
    })

    M.greeting = wibox.widget({
        halign = "center",
        valign = "center",
        markup = "<b>Welcome!</b>",
        widget = wibox.widget.textbox
    })

    awesome.connect_signal("theme::wallpaper::init", function()
        M.image.image = gears.surface.load_uncached(backgrounds.get_wallpaper_path(backgrounds.id))
    end)

    for _, i in ipairs(M.buttons) do
        M.add_button(i.icon, i.description, i.cmd)
    end

    M.wibox = wibox({
        widget = wibox.widget({
            M.image,
            {
                {
                    M.pfp,
                    {
                        M.greeting,
                        M.uptime,
                        spacing = beautiful.large_space,
                        layout = wibox.layout.fixed.vertical
                    },
                    spacing = beautiful.large_space,
                    layout = wibox.layout.fixed.vertical
                },
                halign = "center",
                valign = "center",
                layout = wibox.container.place
            },
            {
                add_background(M.button_group, beautiful.xlarge_space, beautiful.xlarge_space),
                halign = "right",
                valign = "center",
                layout = wibox.container.place
            },
            layout = wibox.layout.stack
        }),
        screen = awful.screen.focused(),
        shape = helpers.rounded_rect(),
        width = 600,
        height = 400,
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
