local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")

awesome.set_preferred_icon_size(64)

local M = {}

M.themes_path = gears.filesystem.get_configuration_dir()

M.wallpaper = M.themes_path .. "backgrounds/mountains_1.jpg"
screen.connect_signal("request::desktop_decoration", function(s)
    gears.wallpaper.maximized(M.wallpaper, s)
end)

-- Converts the input to dpi
function M.dpi(i)
    return dpi(i)
end

M.font = "RobotoCondensed 14"
M.font_medium = "RobotoCondensed 48"
M.font_large = "RobotoCondensed 64"
M.font_icon = "Material-Design-Iconic-Font 14"
M.font_icon_large = "Material-Design-Iconic-Font 24"
M.radius = M.dpi(8)

M.margin = {}
M.margin[0] = M.dpi(4)
M.margin[1] = M.dpi(8)
M.margin[2] = M.dpi(12)
M.margin[3] = M.dpi(16)
M.margin[4] = M.dpi(32)

M.icon_size = {}
M.icon_size[0] = M.dpi(16)
M.icon_size[1] = M.dpi(32)
M.icon_size[2] = M.dpi(48)
M.icon_size[3] = M.dpi(64)
M.icon_size[4] = M.dpi(128)

-- Github Dark Theme
M.bg0 = "#0d1117"
M.bg1 = "#161b22"
M.bg2 = "#21262d"
M.fg0 = "#ecf2f8"
M.fg1 = "#c6cdd5"
M.fg2 = "#89929b"

M.red = "#fa7970"
M.orange = "#faa356"
M.green = "#7ce38b"
M.cyan = "#a2d2fb"
M.blue = "#77bdfb"
M.purple = "#cea5fb"

-- Default colors
M.bg_normal = M.bg0
M.bg_focus = M.bg0
M.bg_urgent = M.bg0
M.bg_minimize = M.bg0

M.fg_normal = M.fg1
M.fg_focus = M.fg0
M.fg_urgent = M.red
M.fg_minimize = M.fg2

M.border_color_normal = M.bg0
M.border_color_active = M.bg0
M.border_width = dpi(2)

-- Configs
M.bar_width = M.dpi(42)

M.titlebar_height = M.dpi(42)
M.useless_gap = M.dpi(8)

M.switcher_height = M.dpi(200)
M.switcher_width = M.dpi(200)

M.notification_bg_normal = M.bg2
M.notification_bg_selected = M.blue

M.hotkeys_bg = M.bg0
M.hotkeys_fg = M.fg0
M.hotkeys_shape = helpers.rrect()
M.hotkeys_modifiers_fg = M.blue
M.hotkeys_border_width = M.margin[1]
M.hotkeys_border_color = M.bg0
M.hotkeys_label_bg = M.red
M.hotkeys_label_fg = M.bg0
M.hotkeys_group_margin = M.margin[3]
M.hotkeys_font = M.font
M.hotkeys_description_font = M.font

-- AwesomeWM icon
M.icon_awesome = beautiful.theme_assets.awesome_icon(M.dpi(64), M.fg0, M.bg0)

M.icon_default = M.themes_path .. "assets/default.svg"
M.icon_music = M.themes_path .. "assets/music.svg"
M.icon_terminal = M.themes_path .. "assets/terminal.svg"

-- Layout icons
M.layout_fairh = M.themes_path .. "layouts/fairhw.png"
M.layout_fairv = M.themes_path .. "layouts/fairvw.png"
M.layout_floating = M.themes_path .. "layouts/floatingw.png"
M.layout_magnifier = M.themes_path .. "layouts/magnifierw.png"
M.layout_max = M.themes_path .. "layouts/maxw.png"
M.layout_fullscreen = M.themes_path .. "layouts/fullscreenw.png"
M.layout_tilebottom = M.themes_path .. "layouts/tilebottomw.png"
M.layout_tileleft = M.themes_path .. "layouts/tileleftw.png"
M.layout_tile = M.themes_path .. "layouts/tilew.png"
M.layout_tiletop = M.themes_path .. "layouts/tiletopw.png"
M.layout_spiral = M.themes_path .. "layouts/spiralw.png"
M.layout_dwindle = M.themes_path .. "layouts/dwindlew.png"
M.layout_cornernw = M.themes_path .. "layouts/cornernww.png"
M.layout_cornerne = M.themes_path .. "layouts/cornernew.png"
M.layout_cornersw = M.themes_path .. "layouts/cornersww.png"
M.layout_cornerse = M.themes_path .. "layouts/cornersew.png"

beautiful.init(M)

return M
