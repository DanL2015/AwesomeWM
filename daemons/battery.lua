local upower = require('lgi').require('UPowerGlib')
local gears = require("gears")

local M = {}

M.interval = 5
M.device = upower.Client():get_display_device()

function M.update()
  awesome.emit_signal("battery::update", M.device)
end

function M.start()
  gears.timer {
    timeout = M.interval,
    autostart = true,
    call_now = true,
    callback = M.update
  }
end

M.start()
