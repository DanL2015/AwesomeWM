local gears = require("gears")
local beautiful = require("beautiful")
local bling = require("bling")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

app_menu = bling.widget.app_launcher({
    apps_per_column = 1,
    terminal = "kitty",
    favorites = { "firefox", "kitty", "nemo" },
    background = beautiful.bg_normal,
    border_width = beautiful.border_width,
    border_color = beautiful.border_color_normal,
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 8)
    end,

    prompt_height = beautiful.search_prompt_height,
    prompt_margins = beautiful.search_prompt_margins,
    prompt_paddings = beautiful.search_prompt_paddings,
    prompt_color = beautiful.bg_normal,
    prompt_text_color = beautiful.search_prompt_fg_color,
    prompt_icon_color = beautiful.search_prompt_fg_color,
    prompt_icon_font = beautiful.font_icon,
    prompt_icon = "",
    prompt_cursor_color = beautiful.search_prompt_cursor_color,
    prompt_shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 8)
    end,

    app_shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 8)
    end,
    apps_margin = { left = dpi(10), right = dpi(10), bottom = dpi(10) },
    apps_spacing = beautiful.search_apps_spacing,
    app_normal_color = "#00000000",
    app_normal_hover_color = beautiful.bg_focus,
    app_selected_color = beautiful.search_app_selected_color,
    app_icon_width = beautiful.search_icon_size,
    app_icon_height = beautiful.search_icon_size,
    app_width = beautiful.search_app_width,
    app_height = beautiful.search_app_height,
})