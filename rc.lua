pcall(require, "luarocks.loader")

local awful = require("awful")
local beautiful = require("beautiful")
require("awful.autofocus")
local menubar = require("menubar")
local gears  = require("gears")
require("awful.hotkeys_popup.keys")

-- Beautiful
require("themes")

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
-- awful.spawn.single_instance("xfsettingsd", false)
awful.spawn.single_instance("picom", false)

-- Run garbage collector regularly to prevent memory leaks
gears.timer {
       timeout = 30,
       autostart = true,
       callback = function() collectgarbage("collect") end
}
