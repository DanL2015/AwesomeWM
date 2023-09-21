pcall(require, "luarocks.loader")

local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
local menubar = require("menubar")
require("awful.hotkeys_popup.keys")

beautiful.init("~/.config/awesome/theme.lua")

apps = {
	terminal = "kitty",
	editor = "nvim",
	browser = "firefox",
	file_manager = "thunar",
	volume_manager = "pavucontrol",
	network_manager = "nm-connection-editor",
	power_manager = "xfce4-power-manager-settings",
	bluetooth_manager = "blueman-manager",
	settings = "xfce4-settings-manager",
}

modkey = "Mod4"

menubar.utils.terminal = apps.terminal -- Set the terminal for applications that require it

-- Signals
require("signals")

--Daemons
require("daemons")

-- Components
require("components")

-- Keys
require("keys")

-- Client rules
require("rules")

-- Notifications
require("notifications")

-- Autostart Applications
awful.spawn.single_instance("xfsettingsd", false)
awful.spawn.single_instance("picom", false)
awful.spawn.single_instance("nm-applet", false)
