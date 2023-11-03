local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local helpers = require("helpers")

local create_clickable = require("helpers.clickable_widget")

local function buttons()
    return gears.table.join(awful.button({}, 1, function()
        awful.spawn(apps.power_manager, false)
    end))
end

local function update_colors(progressbar)
    local percentage = progressbar.value
    if percentage < 20 then
        progressbar.color = beautiful.bat_danger_color
    elseif percentage < 40 then
        progressbar.color = beautiful.bat_low_color
    elseif percentage < 60 then
        progressbar.color = beautiful.bat_mid_color
    else
        progressbar.color = beautiful.bat_high_color
    end
end

local function update_widget(image, progressbar, tooltip, res)
    local percentage
    local status
    if res == nil then
        percentage = 0
        status = "Unknown"
    else
        status = res[1]
        percentage = tonumber(res[2])
    end

    -- Edit battery icon
    if status == "Charging" or status == "Full" then
        image.markup = ""
    else
        image.markup = ""
    end

    -- Edit progressbar
    if percentage ~= nil then
        progressbar.value = percentage
        if percentage < 20 then
            progressbar.color = beautiful.bat_danger_color
        elseif percentage < 40 then
            progressbar.color = beautiful.bat_low_color
        elseif percentage < 60 then
            progressbar.color = beautiful.bat_mid_color
        else
            progressbar.color = beautiful.bat_high_color
        end
        tooltip.markup = "<b>" .. status .. "</b>: " .. tostring(percentage) .. "%"
    else
        tooltip.markup = "<b>Unknown</b>"
    end

    -- Edit tooltip
end

local function create_widget()

    local image = wibox.widget({
        font = beautiful.font_icon,
        widget = wibox.widget.textbox,
        align = "center",
        valign = "center"
    })

    local background = wibox.widget({
        image,
        fg = beautiful.bg0,
        layout = wibox.container.background
    })

    local progressbar = wibox.widget({
        max_value = 100,
        value = 100,
        forced_width = beautiful.bat_width,
        border_width = 0,
        color = beautiful.bat_fg_color,
        background_color = beautiful.bat_bg_color,
        widget = wibox.widget.progressbar
    })

    local widget = wibox.widget({
        {
            progressbar,
            background,
            layout = wibox.layout.stack
        },
        margins = beautiful.bat_margins,
        layout = wibox.container.margin
    })

    local tooltip = awful.tooltip({
        objects = {widget},
        markup = "<b>Unknown</b>"
    })

    awesome.connect_signal("daemon::battery::status", function(...)
        update_widget(image, progressbar, tooltip, ...)
    end)

    return widget
end
return create_widget
