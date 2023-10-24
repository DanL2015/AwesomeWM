local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local bling = require("bling")
local playerctl = bling.signal.playerctl.lib()
local add_background = require("helpers.background_widget")

local function create_widget()
    -- Media widget
    local art = wibox.widget({
        image = beautiful.icon_music,
        resize = true,
        align = "center",
        valign = "center",
        forced_height = beautiful.panel_art_size,
        forced_width = beautiful.panel_art_size,
        clip_shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 8)
        end,
        widget = wibox.widget.imagebox
    })

    local title_text = wibox.widget({
        markup = "Playing",
        align = "left",
        valign = "center",
        widget = wibox.widget.textbox
    })

    local title_widget = wibox.widget({
        layout = wibox.container.scroll.horizontal,
        step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
        fps = 60,
        speed = 75,
        title_text
    })

    title_widget:pause()

    local artist_text = wibox.widget({
        markup = "Nothing",
        align = "left",
        valign = "center",
        widget = wibox.widget.textbox
    })

    local artist_widget = wibox.widget({
        layout = wibox.container.scroll.horizontal,
        step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
        fps = 60,
        speed = 75,
        artist_text
    })
    artist_widget:pause()

    local toggle_button = wibox.widget({
        image = beautiful.icon_play,
        widget = wibox.widget.imagebox,
        forced_height = beautiful.panel_button_icon_size,
        forced_width = beautiful.panel_button_icon_size,
        align = "center",
        valign = "center"
    })

    local prev_button = wibox.widget({
        image = beautiful.icon_skip_back,
        widget = wibox.widget.imagebox,
        forced_height = beautiful.panel_button_icon_size,
        forced_width = beautiful.panel_button_icon_size,
        align = "center",
        valign = "center"
    })

    local next_button = wibox.widget({
        image = beautiful.icon_skip_forward,
        widget = wibox.widget.imagebox,
        forced_height = beautiful.panel_button_icon_size,
        forced_width = beautiful.panel_button_icon_size,
        align = "center",
        valign = "center"
    })

    toggle_button:buttons(gears.table.join(awful.button({}, 1, function()
        playerctl:play_pause()
    end)))

    next_button:buttons(gears.table.join(awful.button({}, 1, function()
        playerctl:next()
    end)))

    prev_button:buttons(gears.table.join(awful.button({}, 1, function()
        playerctl:previous()
    end)))

    local media = add_background(wibox.widget({
        {
            {
                art,
                margins = beautiful.panel_internal_margin,
                layout = wibox.container.margin
            },
            {
                {
                    {
                        artist_widget,
                        fg = beautiful.panel_fg,
                        widget = wibox.container.background
                    },
                    {
                        title_widget,
                        fg = beautiful.panel_fg,
                        widget = wibox.container.background
                    },
                    layout = wibox.layout.flex.vertical
                },
                right = beautiful.panel_internal_margin,
                top = beautiful.panel_internal_margin,
                bottom = beautiful.panel_internal_margin,
                layout = wibox.container.margin
            },
            {
                {
                    {
                        prev_button,
                        margins = beautiful.medium_space,
                        layout = wibox.container.margin
                    },
                    {
                        toggle_button,
                        margins = beautiful.medium_space,
                        layout = wibox.container.margin
                    },
                    {
                        next_button,
                        margins = beautiful.medium_space,
                        layout = wibox.container.margin
                    },
                    layout = wibox.layout.flex.horizontal
                },
                margins = beautiful.panel_internal_margin,
                layout = wibox.container.margin
            },
            layout = wibox.layout.align.horizontal
        },
        margins = beautiful.panel_internal_margin,
        layout = wibox.container.margin
    }), 0, 0)

    media:connect_signal("mouse::enter", function()
        title_widget:continue()
        artist_widget:continue()
    end)

    media:connect_signal("mouse::leave", function()
        title_widget:pause()
        artist_widget:pause()
    end)

    playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)
        art:set_image(gears.surface.load_uncached(album_path))
        title_text:set_markup_silently(title)
        artist_text:set_markup_silently(artist)
    end)

    playerctl:connect_signal("playback_status", function(_, playing, player_name)
        if playing then
            toggle_button.image = beautiful.icon_pause
        else
            toggle_button.image = beautiful.icon_play
        end
    end)

    return media
end

return create_widget
