local wibox = require("wibox")
local beautiful = require("beautiful")
local add_background = require("components.panel.add_background")

local function create_widget()
    -- Weather widget
    local weather_icon = wibox.widget({
        image = beautiful.icon_sun,
        widget = wibox.widget.imagebox,
        forced_height = beautiful.panel_button_icon_size,
        forced_width = beautiful.panel_button_icon_size,
        align = "center",
        valign = "center",
    })

    local weather_temperature = wibox.widget({
        markup = "0",
        widget = wibox.widget.textbox,
    })

    local weather_description = wibox.widget({
        markup = "<b>Weather Unavailable</b>",
        widget = wibox.widget.textbox,
    })

    local weather = add_background(wibox.widget({
        {
            {
                weather_temperature,
                nil,
                {
                    weather_icon,
                    margins = beautiful.panel_internal_margin,
                    layout = wibox.container.margin,
                },
                layout = wibox.layout.align.horizontal,
            },
            weather_description,
            layout = wibox.layout.flex.vertical,
        },
        margins = beautiful.panel_internal_margin,
        layout = wibox.container.margin,
    }))

    awesome.connect_signal("daemon::weather::status", function(temperature, description, icon_code)
        if description ~= nil and temperature ~= nil then
            weather_description.markup = "<b>" .. description .. "</b>"
            weather_temperature.markup = tostring(temperature) .. "°F"
        end

        if icon_code == "01" then
            weather_icon = beautiful.icon_sun
        elseif icon_code == "02" or icon_code == "03" or icon_code == "04" then
            weather_icon = beautiful.icon_cloud
        elseif icon_code == "09" then
            weather_icon = beautiful.icon_cloud_drizzle
        elseif icon_code == "10" then
            weather_icon = beautiful.icon_cloud_rain
        elseif icon_code == "11" then
            weather_icon = beautiful.icon_cloud_lightning
        elseif icon_code == "13" then
            weather_icon = beautiful.icon_cloud_snow
        elseif icon_code == "50" then
            weather_icon = beautiful.icon_wind
        end
    end)

    return weather
end

return create_widget
