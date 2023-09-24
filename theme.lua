local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local rnotification = require("ruled.notification")
local awful = require("awful")
local naughty = require("naughty")
local dpi = xresources.apply_dpi
local gears = require("gears")

local themes_path = gears.filesystem.get_configuration_dir()

local theme = {}

theme.backgrounds_path = themes_path .. "backgrounds/"
theme.backgrounds = {}
theme.background_num = 0
local cmd = "bash -c 'ls " .. theme.backgrounds_path .. "'"
awful.spawn.easy_async_with_shell(cmd, function(stdout)
    for s in stdout:gmatch("[^\r\n]+") do
        s = s:gsub("[\n\r]", "")
        theme.backgrounds[theme.background_num] = s
        theme.background_num = theme.background_num + 1
    end
    awesome.emit_signal("theme::load")
end)

theme.colors = xresources.get_current_theme()

-- theme.font = "Iosevka Nerd Font Medium 12"
-- theme.font_small = "Iosevka Nerd Font Bold 11"
theme.font = "Dosis Medium 12"
theme.font_small = "Dosis Light 11"
theme.font_icon = "Iosevka Nerd Font Mono 18"

-- Old Mountain Colorscheme
-- theme.red = "#AC8A8C"
-- theme.orange = "#C6A679"
-- theme.yellow = "#ACA98A"
-- theme.green = "#8AAC8B"
-- theme.blue = "#8A98AC"
-- theme.purple = "#8F8AAC"
-- theme.pink = "#AC8AAC"
-- theme.black0 = "#0f0f0f"
-- theme.black1 = "#191919"
-- theme.black2 = "#262626"
-- theme.gray0 = "#393939"
-- theme.gray1 = "#4c4c4c"
-- theme.gray2 = "#767676"
-- theme.white0 = "#cacaca"
-- theme.white1 = "#bfbfbf"
-- theme.white2 = "#a0a0a0"
-- theme.bg_blur = "#0f0f0f"

theme.rounded_rect = function(radius)
    return function(cr, width, height) gears.shape.rounded_rect(cr, width, height, radius) end
end

-- theme.bg0 = theme.colors.color0
-- theme.bg1 = theme.colors.color8
-- theme.fg0 = theme.colors.color15
-- theme.fg1 = theme.colors.color7

-- Manually theme fg and bg, let pywal theme accents
theme.bg0 = "#0f0f0f"
theme.bg1 = "#202020"
theme.fg0 = "#cacaca"
theme.fg1 = "#bfbfbf"


-- Accents
theme.a00 = theme.colors.color1
theme.a01 = theme.colors.color9
theme.a10 = theme.colors.color2
theme.a11 = theme.colors.color10
theme.a20 = theme.colors.color3
theme.a21 = theme.colors.color11
theme.a30 = theme.colors.color4
theme.a31 = theme.colors.color12
theme.a40 = theme.colors.color5
theme.a41 = theme.colors.color13
theme.a50 = theme.colors.color6
theme.a51 = theme.colors.color14

theme.bg_normal = theme.bg0
theme.bg_focus = theme.bg0
theme.bg_urgent = theme.bg1
theme.bg_minimize = theme.bg0

theme.fg_normal = theme.fg0
theme.fg_focus = theme.fg0
theme.fg_urgent = theme.fg1
theme.fg_minimize = theme.fg0

theme.clickable_active_bg = theme.a00
theme.clickable_inactive_bg = theme.bg1

theme.useless_gap = dpi(4)

-- OSD
theme.osd_width = dpi(200)
theme.osd_height = dpi(200)
theme.osd_padding = dpi(20)
theme.osd_margin = dpi(100)
theme.osd_bg = theme.bg0
theme.osd_image_height = dpi(100)
theme.osd_image_width = dpi(100)
theme.osd_bar_height = dpi(20)
theme.osd_bar_color = theme.bg1
theme.osd_bar_active_color = theme.fg0
theme.osd_bar_handle_color = theme.fg0
theme.osd_bar_handle_width = dpi(20)

-- Bar
theme.bar_height = dpi(36)
theme.bar_bg = theme.bg0

-- Sliders
theme.slider_handle_color = theme.a30
theme.slider_bar_active_color = theme.a20
theme.slider_bar_height = dpi(10)
theme.slider_bar_color = theme.bg0
theme.slider_handle_width = dpi(20)

-- Spacing
theme.xlarge_space = dpi(8)
theme.large_space = dpi(6)
theme.medium_space = dpi(4)
theme.small_space = dpi(2)
theme.bmargin = dpi(2)

-- Borders
theme.border_color_normal = theme.bg1
theme.border_color_active = theme.bg1
theme.border_width = dpi(2)

-- Search
theme.search_icon_size = dpi(24)
theme.search_prompt_height = dpi(60)
theme.search_prompt_margins = dpi(10)
theme.search_prompt_paddings = dpi(15)
theme.search_apps_spacing = dpi(4)
theme.search_app_width = dpi(500)
theme.search_app_height = dpi(50)
theme.search_app_selected_color = theme.a21
theme.search_prompt_fg_color = theme.fg0
theme.search_prompt_cursor_color = theme.a20

-- Taglist
theme.taglist_spacing = dpi(2)
theme.taglist_active_fg = theme.fg0
theme.taglist_occupied_fg = theme.a01
theme.taglist_inactive_fg = theme.bg0
theme.taglist_margin_height = dpi(20)
theme.taglist_margin_width = dpi(20)
theme.taglist_height = dpi(10)
theme.taglist_inactive_width = dpi(10)
theme.taglist_occupied_width = dpi(15)
theme.taglist_active_width = dpi(20)

-- Tasklist
theme.tasklist_bg_normal = theme.bg0
theme.tasklist_bg_focus = theme.bg1
theme.tasklist_shape_border_width = dpi(2)
theme.tasklist_shape_border_color = theme.bg0
theme.tasklist_shape_border_color_focus = theme.fg1
theme.tasklist_spacing = dpi(2)
theme.tasklist_hpadding = dpi(16)

-- Preview
theme.preview_padding = dpi(10)
theme.task_preview_widget_border_radius = 6
theme.task_preview_widget_bg = theme.bg0
theme.task_preview_widget_border_color = theme.bg1
theme.task_preview_widget_border_width = dpi(1)
theme.task_preview_widget_margin = dpi(20)

-- Switcher
theme.window_switcher_widget_bg = theme.bg0
theme.window_switcher_widget_border_width = dpi(2)
theme.window_switcher_widget_border_radius = dpi(8)
theme.window_switcher_widget_border_color = theme.bg1
theme.window_switcher_clients_spacing = dpi(20)
theme.window_switcher_client_icon_horizontal_spacing = dpi(5)
theme.window_switcher_client_width = dpi(200)
theme.window_switcher_client_height = dpi(200)
theme.window_switcher_client_margins = dpi(40)
theme.window_switcher_thumbnail_margins = dpi(10)

theme.thumbnail_scale = false
theme.window_switcher_name_margins = dpi(10)
theme.window_switcher_name_valign = "center"
theme.window_switcher_name_forced_width = dpi(200)
theme.window_switcher_name_font = theme.font
theme.window_switcher_name_normal_color = theme.fg1
theme.window_switcher_name_bg_color = theme.bg0
theme.window_switcher_name_focus_color = theme.fg0
theme.window_switcher_icon_valign = "center"
theme.window_switcher_icon_width = dpi(40)

-- Battery
theme.bat_top_space = dpi(9)
theme.bat_bottom_space = dpi(9)
theme.bat_left_space = dpi(3)
theme.bat_right_space = dpi(8)
theme.bat_danger_color = theme.a50
theme.bat_low_color = theme.a40
theme.bat_mid_color = theme.a30
theme.bat_high_color = theme.a20
theme.bat_fg_color = theme.fg0
theme.bat_bg_color = theme.bg0

-- Notifications
theme.notification_bg = theme.bg0
theme.notification_fg = theme.fg0
theme.notification_close_size = dpi(20)
theme.notification_trash_size = dpi(20)
theme.notification_padding = dpi(10)
theme.notification_icon_size = dpi(20)
theme.notification_image_size = dpi(60)
theme.notification_inner_margin = theme.xlarge_space
theme.notification_border_width = dpi(2)
theme.notification_border_color = theme.bg1
theme.notification_text_width = dpi(250)
theme.notification_max_width = dpi(400)
theme.notification_max_height = dpi(250)
theme.notification_progress_height = dpi(20)
theme.notification_progress_width = dpi(2)
theme.notification_progress_fg = theme.a00
theme.notification_progress_bg = theme.bg0
theme.notification_action_width = dpi(40)
theme.notification_action_height = dpi(30)
theme.notification_action_bg = theme.bg1
theme.notification_shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 10)
end

-- Panel
theme.panel_bg = theme.bg0
theme.panel_height = dpi(1000)
theme.panel_width = dpi(400)
theme.panel_widget_bg = theme.bg1
theme.panel_button_inactive_bg = theme.bg0
theme.panel_button_active_bg = theme.a00
theme.panel_button_fg = theme.fg0
theme.panel_fg = theme.fg0
theme.panel_button_icon_size = dpi(24)
theme.panel_button_icon_padding = dpi(10)
theme.panel_internal_margin = dpi(8)
theme.panel_art_size = dpi(80)
theme.panel_theme_bg_width = dpi(280)
theme.panel_border_color = theme.bg1

-- Menu
theme.menu_padding = theme.xlarge_space
theme.menu_submenu_icon = ""
theme.menu_height = dpi(20)
theme.menu_width = dpi(100)
theme.menu_border_width = dpi(2)
theme.menu_fg_normal = theme.fg0
theme.menu_bg_normal = theme.bg0

-- systray
theme.bg_systray = theme.bg0
theme.systray_icon_size = dpi(20)

-- Titlebar
theme.titlebar_height = dpi(40)
theme.titlebar_button_bg = theme.bg1
theme.titlebar_fg_normal = theme.fg1
theme.titlebar_bg_normal = theme.bg0
theme.titlebar_fg_focus = theme.fg0
theme.titlebar_bg_focus = theme.bg0

theme.titlebar_close_button_normal = gears.color.recolor_image(themes_path .. "titlebar/close_normal.png", theme.bg0)
theme.titlebar_close_button_focus = gears.color.recolor_image(themes_path .. "titlebar/close_focus.png", theme.a00)
theme.titlebar_minimize_button_normal = gears.color.recolor_image(themes_path .. "titlebar/minimize_normal.png",
    theme.bg0)
theme.titlebar_minimize_button_focus = gears.color.recolor_image(themes_path .. "titlebar/minimize_focus.png", theme.a20)
theme.titlebar_maximized_button_normal_inactive = gears.color.recolor_image(
    themes_path .. "titlebar/maximized_normal_inactive.png", theme.bg0)
theme.titlebar_maximized_button_focus_inactive = gears.color.recolor_image(
    themes_path .. "titlebar/maximized_focus_inactive.png", theme.a40)
theme.titlebar_maximized_button_normal_active = gears.color.recolor_image(
    themes_path .. "titlebar/maximized_normal_active.png", theme.bg0)
theme.titlebar_maximized_button_focus_active = gears.color.recolor_image(
    themes_path .. "titlebar/maximized_focus_active.png", theme.a40)

-- Layout
theme.layout_fairh = themes_path .. "layouts/fairhw.png"
theme.layout_fairv = themes_path .. "layouts/fairvw.png"
theme.layout_floating = themes_path .. "layouts/floatingw.png"
theme.layout_magnifier = themes_path .. "layouts/magnifierw.png"
theme.layout_max = themes_path .. "layouts/maxw.png"
theme.layout_fullscreen = themes_path .. "layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path .. "layouts/tilebottomw.png"
theme.layout_tileleft = themes_path .. "layouts/tileleftw.png"
theme.layout_tile = themes_path .. "layouts/tilew.png"
theme.layout_tiletop = themes_path .. "layouts/tiletopw.png"
theme.layout_spiral = themes_path .. "layouts/spiralw.png"
theme.layout_dwindle = themes_path .. "layouts/dwindlew.png"
theme.layout_cornernw = themes_path .. "layouts/cornernww.png"
theme.layout_cornerne = themes_path .. "layouts/cornernew.png"
theme.layout_cornersw = themes_path .. "layouts/cornersww.png"
theme.layout_cornerse = themes_path .. "layouts/cornersew.png"

-- Icons
theme.icon_awesome = theme_assets.awesome_icon(dpi(16), theme.fg_focus, theme.bg_focus)
theme.icon_battery_charging = themes_path .. "icons/battery-charging.svg"
theme.icon_battery = themes_path .. "icons/battery.svg"
theme.icon_bell_off = themes_path .. "icons/bell-off.svg"
theme.icon_bell = themes_path .. "icons/bell.svg"
theme.icon_bluetooth = themes_path .. "icons/bluetooth.svg"
theme.icon_video = themes_path .. "icons/video.svg"
theme.icon_check = themes_path .. "icons/check.svg"
theme.icon_chevron_down = themes_path .. "icons/chevron-down.svg"
theme.icon_chevron_right = themes_path .. "icons/chevron-right.svg"
theme.icon_chevron_left = themes_path .. "icons/chevron-left.svg"
theme.icon_chevron_up = themes_path .. "icons/chevron-up.svg"
theme.icon_command = themes_path .. "icons/command.svg"
theme.icon_edit = themes_path .. "icons/edit.svg"
theme.icon_folder = themes_path .. "icons/folder.svg"
theme.icon_globe = themes_path .. "icons/globe.svg"
theme.icon_log_out = themes_path .. "icons/log-out.svg"
theme.icon_maximize = themes_path .. "icons/maximize.svg"
theme.icon_minimize = themes_path .. "icons/minimize.svg"
theme.icon_moon = themes_path .. "icons/moon.svg"
theme.icon_music = themes_path .. "icons/music.svg"
theme.icon_pause = themes_path .. "icons/pause.svg"
theme.icon_play = themes_path .. "icons/play.svg"
theme.icon_power = themes_path .. "icons/power.svg"
theme.icon_refresh_ccw = themes_path .. "icons/refresh-ccw.svg"
theme.icon_search = themes_path .. "icons/search.svg"
theme.icon_settings = themes_path .. "icons/settings.svg"
theme.icon_skip_back = themes_path .. "icons/skip-back.svg"
theme.icon_skip_forward = themes_path .. "icons/skip-forward.svg"
theme.icon_terminal = themes_path .. "icons/terminal.svg"
theme.icon_trash = themes_path .. "icons/trash.svg"
theme.icon_volume_1 = themes_path .. "icons/volume-1.svg"
theme.icon_volume_2 = themes_path .. "icons/volume-2.svg"
theme.icon_volume_x = themes_path .. "icons/volume-x.svg"
theme.icon_volume = themes_path .. "icons/volume.svg"
theme.icon_wifi_off = themes_path .. "icons/wifi-off.svg"
theme.icon_wifi = themes_path .. "icons/wifi.svg"

-- Weather icons
theme.icon_sun = themes_path .. "icons/sun.svg"
theme.icon_cloud = themes_path .. "icons/cloud.svg"
theme.icon_cloud_drizzle = themes_path .. "icons/cloud-drizzle.svg"
theme.icon_cloud_lightning = themes_path .. "icons/cloud-lightning.svg"
theme.icon_cloud_rain = themes_path .. "icons/cloud-rain.svg"
theme.icon_cloud_snow = themes_path .. "icons/cloud-snow.svg"
theme.icon_wind = themes_path .. "icons/wind.svg"

-- Set different colors for urgent notifications.
rnotification.connect_signal("request::rules", function()
    rnotification.append_rule({
        rule = { urgency = "critical" },
        properties = { bg = theme.a51, fg = theme.bg0 },
    })
end)

return theme
