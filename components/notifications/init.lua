local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
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
        shape = helpers.rounded_rect(),
        border_color = beautiful.panel_border_color,
        border_width = beautiful.border_width,
        widget = wibox.container.background
    })

    M.min_height = awful.screen.focused().geometry.height - beautiful.bar_height - 4 * beautiful.margins - beautiful.panel_height
    M.max_height = awful.screen.focused().geometry.height - beautiful.bar_height - 3 * beautiful.margins - beautiful.panel_minimize_height - beautiful.margins

    M.wibox = wibox({
        width = beautiful.panel_minimize_width,
        height = M.min_height,
        widget = panel_widget,
        y = awful.screen.focused().geometry.height + M.min_height,
        ontop = true
    })

    M.is_minimized = true
    M.is_visible = false

    M.fly_timer = rubato.timed({
        duration = 0.4,
        override_dt = true,
        clamp_position = true
    })

    M.fly_timer:subscribe(function(pos)
        M.wibox.y = pos - 2 * beautiful.margins
        if not M.is_visible and pos == M.fly_timer.target then
            M.wibox.visible = false
        end
    end)

    M.minmax_timer = rubato.timed({
        duration = 0.4,
        override_dt = true,
        clamp_position = true,
        pos = 1
    })

    M.minmax_timer:subscribe(function(pos)
        M.wibox.y = awful.screen.focused().geometry.height - beautiful.margins - pos
        M.wibox.height = pos
    end)

    M.add_widgets()
    M.update_screen()
    return M
end

function M.update_screen()
    M.wibox.x = awful.screen.focused().geometry.width + awful.screen.focused().geometry.x - beautiful.margins - M.wibox.width
end

function M.minimize()
    M.is_minimized = true
    M.minmax_timer.pos = M.max_height
    M.minmax_timer.target = M.min_height
end

function M.maximize()
    M.is_minimized = false
    M.minmax_timer.pos = M.min_height
    M.minmax_timer.target = M.max_height
end

function M.flyin()
    M.minimize()
    M.is_visible = true
    M.wibox.visible = true
    M.fly_timer.pos = awful.screen.focused().geometry.height + M.min_height
    M.fly_timer.target = awful.screen.focused().geometry.height - M.min_height + beautiful.margins
end

function M.flyout()
    M.is_visible = false
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
