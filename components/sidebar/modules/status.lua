local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local config = require("config")

local M = {}

function M.create_status_widget(icon, color, hover_text)
    local icon_widget = wibox.widget({
        markup = icon,
        font = beautiful.font_icon_large,
        valign = "center",
        halign = "center",
        widget = wibox.widget.textbox
    })

    local progressbar = wibox.widget({
        icon_widget,
        colors = { color },
        thickness = beautiful.dpi(8),
        forced_height = beautiful.dpi(74),
        paddings = beautiful.dpi(2),
        rounded_edge = true,
        min_value = 0,
        max_value = 100,
        widget = wibox.container.arcchart
    })

    local text = wibox.widget({
        markup = "100%",
        valign = "center",
        halign = "center",
        widget = wibox.widget.textbox
    })

    local widget = helpers.add_bg1(helpers.add_margin(wibox.widget({
        helpers.add_margin(progressbar, beautiful.margin[2], beautiful.margin[2]),
        text,
        spacing = beautiful.margin[1],
        layout = wibox.layout.fixed.vertical
    })))
    widget.fg = color

    local tooltip = awful.tooltip({
        objects = { widget },
        markup = hover_text
    })

    return { widget = widget, icon = icon_widget, text = text, progressbar = progressbar, tooltip = tooltip }
end

function M.new()
    local battery = M.create_status_widget("", beautiful.green, "Battery")
    awesome.connect_signal("battery::update", function(d)
        local percentage = math.floor(d.percentage)
        if percentage < 25 then
            battery.progressbar.colors[1] = beautiful.red
            battery.widget.fg = beautiful.red
        elseif percentage < 50 then
            battery.progressbar.colors[1] = beautiful.orange
            battery.widget.fg = beautiful.orange
        elseif percentage < 75 then
            battery.progressbar.colors[1] = beautiful.blue
            battery.widget.fg = beautiful.blue
        else
            battery.progressbar.colors[1] = beautiful.green
            battery.widget.fg = beautiful.green
        end
        if d.state == 1 or d.state == 4 then
            battery.icon.markup = ""
        end
        battery.tooltip.markup = "<b>Battery</b>: " .. tostring(percentage) .. "%"
        battery.text.markup = tostring(percentage) .. "%"
        battery.progressbar.value = percentage
    end)

    local volume = M.create_status_widget("", beautiful.green, "Volume")
    awesome.connect_signal("volume::update", function(mute, vol)
        if mute then
            volume.tooltip.markup = "<b>Muted</b>"
            volume.icon.markup = ""
            volume.widget.fg = beautiful.red
            return
        end

        if vol == 0 then
            volume.icon.markup = ""
            volume.widget.fg = beautiful.red
            volume.progressbar.colors[1] = beautiful.red
        elseif vol < 30 then
            volume.icon.markup = ""
            volume.widget.fg = beautiful.purple
            volume.progressbar.colors[1] = beautiful.purple
        elseif vol < 60 then
            volume.icon.markup = ""
            volume.widget.fg = beautiful.blue
            volume.progressbar.colors[1] = beautiful.blue
        else
            volume.icon.markup = ""
            volume.widget.fg = beautiful.green
            volume.progressbar.colors[1] = beautiful.green
        end
        volume.text.markup = tostring(vol).."%"
        volume.progressbar.value = -1 * vol
        volume.tooltip.markup = "<b>Volume</b>: " .. tostring(vol) .. "%"
    end)
    volume.widget:buttons({
        awful.button({}, 1, function()
            awful.spawn.with_shell(config.apps.volume_manager)
        end),
        awful.button({}, 2, function()
            awesome.emit_signal("volume::mute")
        end),
        awful.button({}, 4, function()
            awesome.emit_signal("volume::increase", 5)
        end),
        awful.button({}, 5, function()
            awesome.emit_signal("volume::decrease", 5)
        end)
    })

    local brightness = M.create_status_widget("", beautiful.green, "Brightness")
    awesome.connect_signal("brightness::update", function(value)
        if value < 25 then
            brightness.widget.fg = beautiful.red
            brightness.progressbar.colors[1] = beautiful.red
        elseif value < 50 then
            brightness.widget.fg = beautiful.purple
            brightness.progressbar.colors[1] = beautiful.purple
        elseif value < 75 then
            brightness.widget.fg = beautiful.blue
            brightness.progressbar.colors[1] = beautiful.blue
        else
            brightness.widget.fg = beautiful.green
            brightness.progressbar.colors[1] = beautiful.green
        end
        brightness.text.markup = tostring(value).."%"
        brightness.progressbar.value = value
        brightness.tooltip.markup = "<b>Brightness</b>: "..tostring(value).."%"
    end)
    brightness.widget:buttons({
        awful.button({}, 4, function()
            awesome.emit_signal("brightness::increase", 5)
        end),
        awful.button({}, 5, function()
            awesome.emit_signal("brightness::decrease", 5)
        end)
    })

    local cpu = M.create_status_widget("", beautiful.green, "CPU")
    awesome.connect_signal("cpu::update", function(value)
        if value < 25 then
            cpu.widget.fg = beautiful.green
            cpu.progressbar.colors[1] = beautiful.green
        elseif value < 50 then
            cpu.widget.fg = beautiful.blue
            cpu.progressbar.colors[1] = beautiful.blue
        elseif value < 75 then
            cpu.widget.fg = beautiful.purple
            cpu.progressbar.colors[1] = beautiful.purple
        else
            cpu.widget.fg = beautiful.red
            cpu.progressbar.colors[1] = beautiful.red
        end
        cpu.text.markup = tostring(value).."%"
        cpu.progressbar.value = value
        cpu.tooltip.markup = "<b>CPU</b>: "..tostring(value).."%"
    end)

    local memory = M.create_status_widget("", beautiful.green, "Memory")
    awesome.connect_signal("memory::update", function(value)
        if value < 25 then
            memory.widget.fg = beautiful.green
            memory.progressbar.colors[1] = beautiful.green
        elseif value < 50 then
            memory.widget.fg = beautiful.blue
            memory.progressbar.colors[1] = beautiful.blue
        elseif value < 75 then
            memory.widget.fg = beautiful.purple
            memory.progressbar.colors[1] = beautiful.purple
        else
            memory.widget.fg = beautiful.red
            memory.progressbar.colors[1] = beautiful.red
        end
        memory.text.markup = tostring(value).."%"
        memory.progressbar.value = value
        memory.tooltip.markup = "<b>Memory</b>: "..tostring(value).."%"
    end)

    M.widget = helpers.add_margin(wibox.widget({
        battery.widget,
        volume.widget,
        brightness.widget,
        cpu.widget,
        memory.widget,
        spacing = beautiful.margin[2],
        layout = wibox.layout.flex.horizontal
    }))

    return M.widget
end

return M
