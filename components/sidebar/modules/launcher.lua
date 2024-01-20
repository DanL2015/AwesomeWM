local Gio = require("lgi").Gio
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local gears = require("gears")

local M = {}

M.pinned = { "Nemo", "Firefox Web Browser", "Vesktop" }

function M.dist(str1, str2)
    -- Classic dp problem thing
    local len1 = #str1
    local len2 = #str2
    local dp = {}
    local c = 0

    if (len1 == 0) then
        return len2
    elseif (len2 == 0) then
        return len1
    elseif (str1 == str2) then
        return 0
    end

    for i = 0, len1, 1 do
        dp[i] = {}
        dp[i][0] = i
    end
    for j = 0, len2, 1 do
        dp[0][j] = j
    end

    for i = 1, len1, 1 do
        for j = 1, len2, 1 do
            if (str1:byte(i) == str2:byte(j)) then
                c = 0
            else
                c = 1
            end

            dp[i][j] = math.min(dp[i - 1][j] + 1, dp[i][j - 1] + 1, dp[i - 1][j - 1] + c)
        end
    end
    return dp[len1][len2]
end

function M.get_apps()
    M.apps = {}
    local app_info = Gio.AppInfo
    local apps = app_info.get_all()

    for _, app in pairs(apps) do
        local name = app_info.get_display_name(app)
        local cmd = app_info.get_commandline(app)
        local exec = app_info.get_executable(app)
        local icon = helpers.get_gicon_path(app_info.get_icon(app)) or nil
        local description = Gio.AppInfo.get_description(app)
        local filter = name

        local pinned = false
        for _, pin_app in pairs(M.pinned) do
            if name == pin_app then
                pinned = true
                break
            end
        end

        if pinned then
            filter = "aaaaaaaaaa" .. filter
        end

        if name and exec and icon then
            table.insert(M.apps, {
                name = "<b>"..name.."</b>",
                cmd = cmd,
                exec = exec,
                icon = icon,
                filter = filter,
                description = description
            })
        end
    end
end

function M.create_default()
    local image = wibox.widget({
        image = beautiful.icon_terminal,
        resize = true,
        valign = "center",
        halign = "center",
        forced_height = beautiful.icon_size[2],
        forced_width = beautiful.icon_size[2],
        widget = wibox.widget.imagebox
    })

    local name = wibox.widget({
        markup = "<b>Run in terminal</b>",
        valign = "center",
        halign = "left",
        widget = wibox.widget.textbox
    })

    local description = wibox.widget({
        text = "Run prompt input in terminal",
        valign = "center",
        halign = "left",
        widget = wibox.widget.textbox
    })

    local background = helpers.add_bg0(helpers.add_margin(wibox.widget({
        image,
        {
            name,
            description,
            layout = wibox.layout.fixed.vertical
        },
        spacing = beautiful.margin[1],
        layout = wibox.layout.fixed.horizontal
    })))

    background:buttons(gears.table.join(awful.button({}, 1, function()
        awful.spawn.with_shell(M.prompt.text)
        awesome.emit_signal("launcher::stop")
    end)))

    background:connect_signal("mouse::enter", function()
        background.bg = beautiful.bg1
    end)
    background:connect_signal("mouse::leave", function()
        background.bg = beautiful.bg0
    end)

    return background
end

function M.create_app_widget(app)
    local image = wibox.widget({
        image = app.icon or beautiful.icon_default,
        resize = true,
        valign = "center",
        halign = "center",
        forced_height = beautiful.icon_size[2],
        forced_width = beautiful.icon_size[2],
        widget = wibox.widget.imagebox
    })

    local name = wibox.widget({
        markup = app.name or "<b>Unknown</b>",
        valign = "center",
        halign = "left",
        widget = wibox.widget.textbox
    })

    local description = wibox.widget({
        text = app.description,
        valign = "center",
        halign = "left",
        widget = wibox.widget.textbox
    })

    local background = helpers.add_bg0(helpers.add_margin(wibox.widget({
        image,
        {
            name,
            description,
            layout = wibox.layout.fixed.vertical
        },
        spacing = beautiful.margin[1],
        layout = wibox.layout.fixed.horizontal
    })))

    background:buttons(gears.table.join(awful.button({}, 1, function()
        M.run_app(app)
    end)))

    background:connect_signal("mouse::enter", function()
        background.bg = beautiful.bg1
    end)
    background:connect_signal("mouse::leave", function()
        background.bg = beautiful.bg0
    end)

    return background
end

function M.update_apps()
    M.matches = {}
    for _, app in pairs(M.apps) do
        if app.filter:lower():find(M.input:lower()) then
            table.insert(M.matches, app)
        end
    end

    table.sort(M.matches, function(a, b)
        return a.filter:lower() < b.filter:lower()
    end)

    M.list:reset()

    for _, app in pairs(M.matches) do
        M.list:add(M.create_app_widget(app))
    end

    M.list:add(M.create_default())
end

function M.run_app(app)
    awful.spawn(app.exec)
    awesome.emit_signal("launcher::stop")
end

function M.keypressed_callback(_, mod, key, event)
    if event == "release" then
        return
    end

    if key == "BackSpace" then
        M.input = M.input:sub(1, -2)
    end

    if key == "Escape" then
        awesome.emit_signal("launcher::stop")
    end

    if key == "Return" and M.matches[1] then
        M.run_app(M.matches[1])
        awesome.emit_signal("launcher::stop")
    end

    if #key == 1 then
        if not M.input then
            M.input = key
        else
            M.input = M.input .. key
        end
    end

    if not M.input or M.input == "" then
        M.prompt.text = "Search..."
    else
        M.prompt.text = M.input
    end
    M.update_apps()
end

function M.new()
    M.apps = {}
    M.matches = {}
    M.input = ""

    M.keygrabber = awful.keygrabber({
        mask_event_callback = true,
        keypressed_callback = M.keypressed_callback
    })

    M.side_text = wibox.widget({
        markup = "",
        font = beautiful.font_icon,
        valign = "center",
        halign = "center",
        widget = wibox.widget.textbox
    })

    M.prompt = wibox.widget({
        text = "Search...",
        valign = "center",
        halign = "left",
        widget = wibox.widget.textbox
    })

    M.list = wibox.widget({
        spacing = beautiful.margin[1],
        layout = wibox.layout.overflow.vertical,
        scrollbar_enabled = false,
        step = 50
    })

    M.search = helpers.add_bg1(helpers.add_margin(wibox.widget({
        M.side_text,
        M.prompt,
        spacing = beautiful.margin[1],
        layout = wibox.layout.fixed.horizontal
    }), beautiful.margin[3], beautiful.margin[3]))

    M.widget = wibox.widget({
        helpers.add_margin(wibox.widget(
            {
                M.search,
                M.list,
                spacing = beautiful.margin[1],
                layout = wibox.layout.fixed.vertical
            })),
        bg = beautiful.bg0,
        forced_height = beautiful.dpi(400),
        layout = wibox.container.background
    })

    return M.widget
end

return M
