local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local helpers = require("helpers")
local rubato = require("rubato")
local pam = require("liblua_pam")

local backgrounds = require("themes.wallpaper")

local add_background = require("helpers.background_widget")
local add_clickable = require("helpers.clickable_widget")

local M = {}
M.visible = false

function M.auth()
    return pam.auth_current_user(M.input)
end

function M.create_wiboxes()
    for s in screen do
        M.wiboxes[s] = wibox({
            widget = wibox.widget({
                M.background,
                {
                    {
                        {
                            {
                                M.pfp,
                                add_background(wibox.widget({
                                    {
                                        M.greeting,
                                        M.status,
                                        {
                                            M.side_text,
                                            M.prompt,
                                            layout = wibox.layout.fixed.horizontal
                                        },
                                        spacing = beautiful.small_space,
                                        layout = wibox.layout.fixed.vertical
                                    },
                                    margins = beautiful.xlarge_space,
                                    layout = wibox.container.margin
                                })),
                                spacing = beautiful.lock_margin,
                                layout = wibox.layout.fixed.vertical
                            },
                            halign = "center",
                            valign = "center",
                            layout = wibox.container.place
                        },
                        bg = beautiful.bg0,
                        shape = helpers.rounded_rect(),
                        forced_width = beautiful.lock_bg_size,
                        forced_height = beautiful.lock_bg_size,
                        border_width = beautiful.border_width,
                        border_color = beautiful.border_color_normal,
                        layout = wibox.container.background
                    },
                    halign = "center",
                    valign = "center",
                    layout = wibox.container.place
                },
                {
                    {
                        {
                            M.time,
                            M.date,
                            spacing = beautiful.xlarge_space,
                            layout = wibox.layout.fixed.vertical
                        },
                        margins = beautiful.xlarge_space,
                        layout = wibox.container.margin
                    },
                    halign = "center",
                    valign = "top",
                    layout = wibox.container.place
                },
                layout = wibox.layout.stack
            }),
            visible = true,
            ontop = true,
            screen = s,
            width = s.geometry.width,
            height = s.geometry.height,
            x = s.geometry.x,
            y = s.geometry.y
        })
    end
end

function M.toggle()
    M.visible = not M.visible
    if M.visible then
        awful.spawn.easy_async("uptime -p", function(stdout)
            M.uptime.markup = (stdout:gsub("^%l", string.upper))
        end)
        awful.spawn.easy_async_with_shell("echo $USER", function(stdout)
            stdout = stdout:gsub("[\n\r]", ""):gsub("^%l", string.upper)
            M.greeting.markup = "<b>Welcome " .. stdout .. "!</b>"
        end)
        M.keygrabber:start()
        M.create_wiboxes()
    else
        M.input = ""
        M.prompt.markup = "|"
        M.status.markup = ""
        for _, widget in pairs(M.wiboxes) do
            widget.visible = false
        end
        M.keygrabber:stop()
    end
end

function M.stop()
    M.visible = false
    M.input = ""
    M.prompt.markup = "|"
    M.status.markup = ""
    for _, widget in pairs(M.wiboxes) do
        widget.visible = false
    end
    M.keygrabber:stop()
end

function M.new()

    M.background = wibox.widget({
        halign = "center",
        valign = "center",
        vertical_fit_policy = true,
        horizontal_fit_policy = true,
        resize = true,
        opacity = 0.5,
        clip_shape = helpers.rounded_rect(),
        widget = wibox.widget.imagebox
    })

    M.date = wibox.widget({
        format = "%A, %B %d.",
        refresh = 60,
        valign = "center",
        halign = "center",
        widget = wibox.widget.textclock
    })
    M.time = wibox.widget({
        format = "%I:%M:%S %p",
        refresh = 1,
        valign = "center",
        halign = "center",
        font = beautiful.lock_clock_font,
        widget = wibox.widget.textclock
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

    M.side_text = wibox.widget({
        markup = ": ",
        font = beautiful.font_icon,
        widget = wibox.widget.textbox
    })

    M.greeting = wibox.widget({
        markup = "Welcome!",
        valign = "center",
        halign = "center",
        widget = wibox.widget.textbox
    })

    M.uptime = wibox.widget({
        markup = "Uptime",
        valign = "center",
        halign = "center",
        widget = wibox.widget.textbox
    })

    M.status = wibox.widget({
        markup = "",
        valign = "center",
        halign = "center",
        widget = wibox.widget.textbox
    })

    M.prompt = wibox.widget({
        markup = "|",
        ellipsize = "start",
        forced_width = 150,
        widget = wibox.widget.textbox
    })

    M.input = ""
    M.wiboxes = {}

    M.keygrabber = awful.keygrabber({
        stop_event = 'release',
        mask_event_callback = true,
        keybindings = {awful.key {
            modifiers = {'Mod1', 'Mod4', 'Shift', 'Control'},
            key = 'Return',
            on_press = function(_)
                M.input = M.input
                M.prompt.markup = M.prompt.markup
            end
        }},
        keypressed_callback = function(_, _, key, event)
            if event == "release" then
                return
            end
            if key == 'Escape' then
                M.input = ""
                M.prompt.markup = ""
                return
            end

            if key == "BackSpace" then
                M.input = M.input:sub(1, -2)
                M.prompt.markup = M.prompt.markup:sub(1, -3) .. "|"
            end

            if #key == 1 then
                if not M.input then
                    M.input = key
                    M.prompt.markup = "*|"
                else
                    M.input = M.input .. key
                    M.prompt.markup = M.prompt.markup:sub(1, -2) .. "*|"
                end
            end
        end,
        keyreleased_callback = function(_, _, key, _)
            if key == "Return" then
                M.status.markup = "Verifying..."
                if M.auth() then
                    M.status.markup = "Correct!"
                    M.stop()
                else
                    M.input = ""
                    M.prompt.markup = ""
                    M.status.markup = "Wrong Password"
                end
            end
        end
    })

    awesome.connect_signal("theme::wallpaper::init", function()
        M.background.image = gears.surface.load_uncached(backgrounds.get_wallpaper_path(backgrounds.id))
    end)
    awesome.connect_signal("theme::wallpaper::change", function()
        M.background.image = gears.surface.load_uncached(backgrounds.get_wallpaper_path(backgrounds.id))
    end)

    screen.connect_signal("list", function()
        if M.visible then
            for s, wibox in pairs(M.wiboxes) do
                wibox.visible = false
            end
            M.wiboxes = {}
            M.create_wiboxes()
        end
    end)

    awesome.connect_signal("lockscreen::toggle", function()
        M.toggle()
    end)

    return M
end

return M.new()
