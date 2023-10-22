local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local helpers = require("helpers")
local rubato = require("rubato")

local M = {}

function M.new()

    M.title = require("components.control.modules.title")()
    M.left_buttons_widget = require("components.control.modules.large_widgets")()
    M.small_widgets = require("components.control.modules.small_widgets")()
    M.weather = require("components.control.modules.weather")()
    M.brightness = require("components.control.modules.brightness")()
    M.volume = require("components.control.modules.volume")()
    M.media = require("components.control.modules.media")()
    M.background = require("components.control.modules.background")
    M.colorscheme = require("components.control.modules.colorscheme")

    -- Control panel widget
    M.widget = wibox.widget({
        homogeneous = true,
        spacing = beautiful.panel_internal_margin,
        min_cols_size = 10,
        min_rows_size = 10,
        forced_num_rows = 0,
        forced_num_cols = 0,
        expand = true,
        layout = wibox.layout.grid
    })

    local panel_widget = wibox.widget({
        {
            {
                M.title,
                M.widget,
                spacing = beautiful.panel_internal_margin,
                layout = wibox.layout.fixed.vertical
            },
            margins = beautiful.panel_internal_margin,
            layout = wibox.container.margin
        },
        bg = beautiful.panel_bg,
        shape = helpers.rounded_rect(8),
        border_color = beautiful.panel_border_color,
        border_width = beautiful.border_width,
        widget = wibox.container.background
    })

    -- control panel wibox
    M.wibox = wibox({
        width = beautiful.panel_minimize_width,
        height = beautiful.panel_minimize_height,
        widget = panel_widget,
        ontop = true
    })

    M.min_height = beautiful.panel_minimize_height
    M.max_height = beautiful.panel_height
    M.is_minimized = false
    M.is_visible = false

    M.fly_timer = rubato.timed({
        duration = 0.4,
        override_dt = true,
        clamp_position = true
    })

    M.fly_timer:subscribe(function(pos)
        M.wibox.y = pos
        if pos == M.fly_timer.target then
            if M.is_visible then
                M.add_widgets()
            else
                M.wibox.visible = false
            end
        end
    end)

    M.minmax_timer = rubato.timed({
        duration = 0.4,
        override_dt = true,
        clamp_position = true,
        pos = 1
    })

    M.minmax_timer:subscribe(function(pos)
        M.wibox.height = pos
        if pos == M.minmax_timer.target and not M.is_minimized then
            M.add_widgets()
        end
    end)

    M.update_screen()
    return M
end

function M.update_screen()
    M.wibox.x = awful.screen.focused().geometry.width + awful.screen.focused().geometry.x - beautiful.useless_gap - M.wibox.width
end

function M.minimize()
    M.is_minimized = true
    M.reset()
    M.minmax_timer.pos = M.max_height
    M.minmax_timer.target = M.min_height
end

function M.maximize()
    M.is_minimized = false
    M.reset()
    M.minmax_timer.pos = M.min_height
    M.minmax_timer.target = M.max_height
end

function M.flyin()
    M.maximize()
    M.is_visible = true
    M.wibox.visible = true
    M.fly_timer.pos = -M.max_height
    M.fly_timer.target = beautiful.bar_height + beautiful.useless_gap
end

function M.flyout()
    M.is_visible = false
    M.fly_timer.pos = beautiful.bar_height + beautiful.useless_gap
    M.fly_timer.target = -M.max_height
end

function M.reset()
    M.widget:reset()
end

function M.add_widgets()
    M.reset()
    M.widget.homogeneous = true
    M.widget.spacing = beautiful.panel_internal_margin
    M.widget.min_cols_size = 10
    M.widget.min_rows_size = 10
    M.widget.forced_num_rows = 18
    M.widget.forced_num_cols = 6
    M.widget.expand = true
    M.widget:add_widget_at(M.left_buttons_widget, 1, 1, 6, 3)
    M.widget:add_widget_at(M.small_widgets, 1, 4, 2, 3)
    M.widget:add_widget_at(M.weather, 3, 4, 4, 3)
    M.widget:add_widget_at(M.brightness, 7, 1, 3, 6)
    M.widget:add_widget_at(M.volume, 10, 1, 3, 6)
    M.widget:add_widget_at(M.media, 13, 1, 3, 6)
    M.widget:add_widget_at(M.colorscheme, 16, 1, 3, 3)
    M.widget:add_widget_at(M.background, 16, 4, 3, 3)
end

return M.new()
