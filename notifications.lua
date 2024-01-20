local naughty = require("naughty")
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local rubato = require("rubato")
local helpers = require("helpers")

naughty.connect_signal("request::display", function(n)
    n.resident = true
    n.position = "top_right"

    local timeout = n.timeout or 20
    n.timeout = nil

    local close_icon = wibox.widget({
        valign = "center",
        halign = "center",
        forced_width = beautiful.icon_size[1],
        forced_height = beautiful.icon_size[1],
        markup = "",
        font = beautiful.font_icon,
        widget = wibox.widget.textbox
    })

    local close_button = helpers.add_bg0(close_icon)
    close_button.fg = beautiful.red

    local icon = nil
    if n.clients[1] ~= nil then
        icon = wibox.widget({
            client = n.clients[1],
            forced_height = beautiful.icon_size[0],
            forced_width = beautiful.icon_size[0],
            widget = awful.widget.clienticon
        })
    elseif n.app_icon then
        icon = wibox.widget({
            image = n.app_icon,
            resize = true,
            forced_height = beautiful.icon_size[0],
            forced_width = beautiful.icon_size[0],
            clip_shape = helpers.rrect(),
            widget = wibox.widget.imagebox
        })
    end

    local image = nil
    if n.icon then
        image = wibox.widget({
            image = n.icon,
            resize = true,
            forced_height = beautiful.icon_size[3],
            forced_width = beautiful.icon_size[3],
            halign = "right",
            valign = "center",
            clip_shape = helpers.rrect(),
            widget = wibox.widget.imagebox
        })
    end

    local title = wibox.widget({
        layout = wibox.container.scroll.horizontal,
        step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
        fps = 60,
        speed = 75,
        {
            halign = "left",
            valign = "center",
            markup = "<b>" .. n.title .. "</b>",
            widget = wibox.widget.textbox
        }
    })

    title:pause()

    local message = wibox.widget({
        layout = wibox.container.scroll.horizontal,
        step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
        fps = 60,
        speed = 75,
        {
            halign = "left",
            valign = "center",
            markup = n.message,
            widget = wibox.widget.textbox
        }
    })

    message:pause()

    local app_name = wibox.widget({
        valign = "center",
        halign = "left",
        markup = "<b>" .. n.app_name .. "</b>",
        widget = wibox.widget.textbox
    })

    local progressbar = wibox.widget({
        close_button,
        max_value = 1,
        border_width = beautiful.dpi(2),
        color = beautiful.blue,
        border_color = beautiful.bg0,
        layout = wibox.container.radialprogressbar
    })

    local timed = rubato.timed({
        duration = timeout,
        pos = 0,
        rate = 20,
        clamp_position = true,
        subscribed = function(pos)
            progressbar.value = pos
            if pos == 1 then
                n:destroy(naughty.notification_closed_reason.dismissed_by_user)
            end
        end
    })

    timed.target = 1

    close_button:buttons(gears.table.join(awful.button({}, 1, function()
        n:destroy(naughty.notification_closed_reason.dismissed_by_user)
    end)))

    local actions = wibox.widget({
        notification = n,
        base_layout = wibox.widget({
            spacing = beautiful.margin[1],
            layout = wibox.layout.flex.horizontal
        }),
        widget_template = {
            {
                id = "text_role",
                valign = "center",
                halign = "center",
                widget = wibox.widget.textbox
            },
            shape = helpers.rrect(),
            bg = beautiful.blue,
            fg = beautiful.bg0,
            forced_height = beautiful.dpi(30),
            visible = n.actions and #n.actions > 0,
            widget = wibox.container.background
        },
        style = {
            underline_normal = false,
            underline_selected = true
        },
        widget = naughty.list.actions
    })
    local time = wibox.widget({
        markup = os.date("%I:%M %p"),
        halign = "right",
        valign = "center",
        widget = wibox.widget.textbox
    })

    local title_bar = helpers.add_bg1(helpers.add_margin(wibox.widget({
        {
            {
                icon,
                valign = "center",
                halign = "center",
                layout = wibox.container.place,
            },
            app_name,
            spacing = beautiful.margin[0],
            layout = wibox.layout.fixed.horizontal
        },
        nil,
        {
            time,
            progressbar,
            spacing = beautiful.margin[0],
            layout = wibox.layout.fixed.horizontal
        },
        layout = wibox.layout.align.horizontal
    }), beautiful.margin[1], beautiful.margin[0]))
    title_bar.shape = nil

    local body = helpers.add_bg0(helpers.add_margin(wibox.widget({
        {
            image,
            {
                title,
                message,
                spacing = beautiful.margin[1],
                layout = wibox.layout.fixed.vertical
            },
            spacing = beautiful.margin[1],
            fill_space = true,
            layout = wibox.layout.fixed.horizontal
        },
        actions,
        layout = wibox.layout.fixed.vertical
    }), beautiful.margin[1], beautiful.margin[1]))
    body.shape = nil

    local widget = naughty.layout.box({
        notification = n,
        type = "notification",
        shape = helpers.rrect(),
        minimum_width = beautiful.dpi(400),
        maximum_width = beautiful.dpi(400),
        maximum_height = beautiful.dpi(150),
        widget_template = {
            title_bar,
            body,
            layout = wibox.layout.fixed.vertical
        },
        bg = beautiful.bg0,
        border_color = beautiful.bg0,
        border_width = beautiful.dpi(0),
        layout = naughty.container.background
    })

    widget.buttons = {}

    widget:connect_signal("mouse::enter", function()
        title:continue()
        message:continue()
        timed.pause = true
    end)

    widget:connect_signal("mouse::leave", function()
        title:pause()
        message:pause()
        timed.pause = false
    end)
end)
