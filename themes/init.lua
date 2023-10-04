local beautiful = require("beautiful")
local naughty = require("naughty")
local gears = require("gears")
local apply_pywal = require("themes.pywal")
local apply_mountain = require("themes.mountain")
local apply_one_dark = require("themes.one_dark")

local apply_fallback = apply_one_dark

local last_theme_file = gears.filesystem.get_cache_dir() .. "last_theme"

local function last_theme_exist()
	local f = io.open(last_theme_file, "r")
	return f ~= nil and io.close(f)
end

local function apply_theme()
	if last_theme_exist() then
		local last_theme = io.popen("cat " .. last_theme_file):read("*all")
		last_theme = last_theme:gsub("[\n\r]", "")
		local status = 0

		if last_theme == "pywal" then
			status = apply_pywal()
		elseif last_theme == "mountain" then
			status = apply_mountain()
		elseif last_theme == "one_dark" then
			status = apply_one_dark()
		else
			apply_fallback()
		end

		if status == 0 then
			apply_fallback()
		end
	else
    apply_fallback()
  end
end

return apply_theme
