local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local rubato = require("rubato")

local M = {}

function M.new()

    M.title = require("components.notifications.modules.notification_title")()
    M.notifs = require("components.notifications.modules.notifications")()

    -- notifications panel widget
    M.widget = wibox.widget({
        spacing = beautiful.panel_internal_margin,
        layout = wibox.layout.fixed.vertical
    })

    local panel_widget = wibox.widget({
        {
            M.widget,
            margins = beautiful.panel_internal_margin,
            layout = wibox.container.margin
        },
        bg = beautiful.panel_bg,
        shape = helpers.rounded_rect(8),
        border_color = beautiful.panel_border_color,
        border_width = beautiful.border_width,
        widget = wibox.container.background
    })

    M.wibox = wibox({
        width = beautiful.panel_minimize_width,
        height = beautiful.panel_minimize_height,
        widget = panel_widget,
        ontop = true
    })

    M.min_height = awful.screen.focused().geometry.height - beautiful.bar_height - beautiful.useless_gap - beautiful.panel_height - beautiful.panel_internal_margin
    M.max_height = awful.screen.focused().geometry.height - beautiful.bar_height - beautiful.useless_gap - beautiful.panel_minimize_height - beautiful.panel_internal_margin
    M.is_minimized = false

    M.fly_timer = rubato.timed({
        duration = 1 / 2,
        intro = 1 / 6,
        override_dt = true
    })

    M.fly_timer:subscribe(function(pos)
        M.wibox.y = pos
    end)

    M.minmax_timer = rubato.timed({
        duration = 1/2,
        intro = 1/6,
        override_dt = true
    })

    M.minmax_timer:subscribe(function(pos)
        M.wibox.y = beautiful.bar_height + beautiful.useless_gap + beautiful.panel_height + beautiful.panel_internal_margin - pos
        M.wibox.height = M.min_height + pos
        if pos == M.minmax_timer.target then
            M.add_widgets()
        end
    end)

    M.wibox.x = awful.screen.focused().geometry.width - beautiful.useless_gap - M.wibox.width
    M.wibox.height = M.min_height

    return M
end

function M.minimize()
    M.is_minimized = true
    M.reset()
    M.minmax_timer.pos = M.max_height - M.min_height
    M.minmax_timer.target = 0
end

function M.maximize()
    M.is_minimized = false
    M.reset()
    M.minmax_timer.pos = 0
    M.minmax_timer.target = M.max_height - M.min_height
end

function M.flyin()
    M.minimize()
    M.add_widgets()
    M.wibox.visible = true
    M.fly_timer.pos = awful.screen.focused().geometry.height + M.min_height
    M.fly_timer.target = awful.screen.focused().geometry.height - M.min_height
end

function M.flyout()
    M.fly_timer.pos = awful.screen.focused().geometry.height - M.min_height
    M.fly_timer.target = awful.screen.focused().geometry.height + M.min_height
end

function M.reset()
    M.widget:reset()
end

function M.add_widgets()
    M.reset()
    M.widget:add(M.title)
    M.widget:add(M.notifs)
end

return M.new()
