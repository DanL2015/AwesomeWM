local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

local key = "afa4db6c8e1430038e3a26524925b0e1"
local city_id = "5327684"
local units = "imperial"


local update_interval = 1600

local weather_details_script = [[
    bash -c '
    KEY="]] .. key .. [["
    CITY="]] .. city_id .. [["
    UNITS="]] .. units .. [["
    weather=$(curl -sf "http://api.openweathermap.org/data/2.5/weather?APPID=$KEY&id=$CITY&units=$UNITS")
    if [ ! -z "$weather" ]; then
        weather_temp=$(echo "$weather" | jq ".main.temp" | cut -d "." -f 1)
        weather_icon=$(echo "$weather" | jq -r ".weather[].icon" | head -1)
        weather_description=$(echo "$weather" | jq -r ".weather[].description" | head -1)
        echo "$weather_icon" "$weather_description"@@"$weather_temp"
    else
        echo "..."
    fi
  ']]

local function update_weather()
    awful.spawn.easy_async_with_shell(weather_details_script, function(stdout)
        local icon_code = string.sub(stdout, 1, 2)
        local weather_details = string.sub(stdout, 5)
        weather_details = string.gsub(weather_details, '^%s*(.-)%s*$', '%1')
        weather_details = string.gsub(weather_details, '%-0', '0')
        weather_details = weather_details:sub(1, 1):upper() .. weather_details:sub(2)
        local description = weather_details:match('(.*)@@')
        local temperature = weather_details:match('@@(.*)')
        if icon_code == "..." then
            awesome.emit_signal("daemon::weather::status", 999, "Weather unavailable", "")
        else
            awesome.emit_signal("daemon::weather::status", tonumber(temperature), description, icon_code)
        end
    end)
end

gears.timer {
    timeout = update_interval,
    autostart = true,
    call_now = true,
    callback = update_weather
}
