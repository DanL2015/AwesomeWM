local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful")
local backgrounds = require("themes.wallpaper")
local colorscheme = require("themes.colorscheme")

local add_background = require("helpers.background_widget")
local create_small_button = require("helpers.small_button_widget")

local last_theme_file = gears.filesystem.get_cache_dir() .. "last_theme"
local is_ready = false

local function create_widget()
    -- Background and theme switcher widget
    local theme_id = 1
    local background_id = 1
    local background_prev_button = create_small_button(beautiful.icon_chevron_left,
        "awesome-client 'awesome.emit_signal(\"theme::background::prev\")'", "Previous Background",
        beautiful.small_space, 0)
    local background_set_button = create_small_button(beautiful.icon_check,
        "awesome-client 'awesome.emit_signal(\"theme::set\")'", "Set Background", beautiful.medium_space)
    local background_next_button = create_small_button(beautiful.icon_chevron_right,
        "awesome-client 'awesome.emit_signal(\"theme::background::next\")'", "Next Background", beautiful.small_space, 0)
    local theme_prev_button = create_small_button(beautiful.icon_chevron_left,
        "awesome-client 'awesome.emit_signal(\"theme::colorscheme::prev\")'", "Previous Theme", beautiful.small_space, 0)
    local theme_next_button = create_small_button(beautiful.icon_chevron_right,
        "awesome-client 'awesome.emit_signal(\"theme::colorscheme::next\")'", "Next Theme", beautiful.small_space, 0)
    theme_prev_button.halign = "right"
    theme_next_button.halign = "right"

    local background_name = wibox.widget({
        halign = "center",
        valign = "center",
        markup = "Picture",
        widget = wibox.widget.textbox
    })

    local theme_name = wibox.widget({
        halign = "center",
        valign = "center",
        widget = wibox.widget.textbox
    })

    local background_bg = wibox.widget({
        valign = "center",
        halign = "center",
        downscale = true,
        horizontal_fit_policy = "fit",
        vertical_fit_policy = "fit",
        forced_width = beautiful.panel_theme_bg_width,
        clip_shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 10)
        end,
        widget = wibox.widget.imagebox
    })

    local background = add_background(wibox.widget({
        {
            background_bg,
            {
                background_set_button,
                halign = "right",
                valign = "bottom",
                layout = wibox.container.place
            },
            {
                {
                    {
                        add_background(wibox.widget({
                            {
                                background_prev_button,
                                {
                                    background_name,
                                    left = beautiful.panel_internal_margin,
                                    right = beautiful.panel_internal_margin,
                                    layout = wibox.container.margin
                                },
                                background_next_button,
                                layout = wibox.layout.align.horizontal
                            },
                            margins = beautiful.xlarge_space,
                            layout = wibox.container.margin
                        }), 0, 0),
                        add_background(wibox.widget({
                            {
                                theme_prev_button,
                                {
                                    theme_name,
                                    left = beautiful.panel_internal_margin,
                                    right = beautiful.panel_internal_margin,
                                    layout = wibox.container.margin
                                },
                                theme_next_button,
                                spacing = beautiful.panel_internal_margin,
                                layout = wibox.layout.align.horizontal
                            },
                            margins = beautiful.xlarge_space,
                            layout = wibox.container.margin
                        }), 0, 0),
                        spacing = beautiful.panel_internal_margin,
                        layout = wibox.layout.fixed.vertical
                    },
                    margins = beautiful.xlarge_space,
                    layout = wibox.container.margin
                },
                halign = "left",
                valign = "bottom",
                layout = wibox.container.place
            },
            layout = wibox.layout.stack
        },
        layout = wibox.container.margin
    }), 0, 0)

    awesome.connect_signal("theme::wallpaper::load", function()
        background_bg.image = gears.surface.load_uncached(backgrounds.get_wallpaper_path(background_id))
        background_name.markup = backgrounds.get_wallpaper_name(background_id)
    end)

    awesome.connect_signal("theme::colorscheme::load", function()
        theme_name.markup = colorscheme.get_color_name(theme_id)
    end)
    awesome.connect_signal("theme::background::prev", function()
        background_id = background_id - 1
        if background_id < 1 then
            background_id = background_id + backgrounds.background_num
        end
        background_name.markup = backgrounds.get_wallpaper_name(background_id)
        awesome.emit_signal("theme::wallpaper::load")
    end)
    awesome.connect_signal("theme::background::next", function()
        background_id = background_id + 1
        if background_id > backgrounds.background_num then
            background_id = background_id - backgrounds.background_num
        end
        background_name.markup = backgrounds.get_wallpaper_name(background_id)
        awesome.emit_signal("theme::wallpaper::load")
    end)
    awesome.connect_signal("theme::colorscheme::prev", function()
        theme_id = theme_id - 1
        if theme_id < 1 then
            theme_id = theme_id + colorscheme.colors_num
        end
        theme_name.markup = colorscheme.get_color_name(theme_id)
    end)
    awesome.connect_signal("theme::colorscheme::next", function()
        theme_id = theme_id + 1
        if theme_id > colorscheme.colors_num then
            theme_id = theme_id - colorscheme.colors_num
        end
        theme_name.markup = colorscheme.get_color_name(theme_id)
    end)
    awesome.connect_signal("theme::set", function()
        backgrounds.set_wallpaper(background_id)
        colorscheme.set_color(theme_id)
        awesome.restart()
    end)

    return background
end

return create_widget
