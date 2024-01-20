local upower = require('lgi').require('UPowerGlib')

local gtable = require("gears.table")
local gtimer = require("gears.timer")

local M = {}

function M.start()
    local device = upower.Client():get_display_device()

    device.on_notify = function (d)
        awesome.emit_signal('battery::update', d)
    end
    gtimer.delayed_call(awesome.emit_signal, 'battery::update', device)
end

M.start()
