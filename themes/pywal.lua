local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local set_theme = require("themes.theme")

local pywal_colors_file = gears.filesystem.get_xdg_cache_home() .. "/wal/colors"
local last_theme_file = gears.filesystem.get_cache_dir() .. "last_theme"

local function colors_exist()
  local f = io.open(pywal_colors_file, "r")
  return f ~= nil and io.close(f)
end

local function apply_colors()
	local colors = {}
	-- I know the documentation says not to use this but I need this to finish running before the program starts
  if colors_exist() then
		local stdout = io.popen("cat " .. pywal_colors_file):read("*all")
		colors[1] = "#0f0f0f"
		colors[9] = "#202020"
		colors[8] = "#cacaca"
		colors[16] = "#bfbfbf"
		local i = 1
		for s in stdout:gmatch("[^\r\n]+") do
			s = s:gsub("[\n\r]", "")
			if i ~= 1 and i ~= 9 and i ~= 8 and i ~= 17 then
				colors[i] = s
			end
			i = i + 1
		end
		set_theme(colors)
		awful.spawn.with_shell("echo pywal > "..last_theme_file)
		return 1
	else
		naughty.notify({ text = "Could not find pywal colors, using fallback colors." })
		return 0
	end
end

return apply_colors
