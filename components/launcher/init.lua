local Gio = require("lgi").Gio
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local gears = require("gears")
local add_background = require("helpers.background_widget")
local add_clickable = require("helpers.clickable_widget")

local M = {}

M.buttons = {{
    icon = "",
    cmd = "systemctl poweroff"
}, {
    icon = "",
    cmd = "systemctl reboot"
}, {
    icon = "",
    cmd = "awesome-client 'awesome.emit_signal(\"lockscreen::toggle\")'"
}, {
    icon = "",
    cmd = "awesome-client 'awesome.quit()'"
}}

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
        local name = app_info.get_name(app)
        local cmd = app_info.get_commandline(app)
        local exec = app_info.get_executable(app)
        local icon = helpers.get_gicon_path(app_info.get_icon(app)) or beautiful.icon_command
        if name and exec then
            table.insert(M.apps, {
                name = name,
                cmd = cmd,
                exec = exec,
                icon = icon
            })
        end
    end

    table.sort(M.apps, function(a, b)
        return a.name:lower() < b.name:lower()
    end)
end

function M.create_app_widget(app)
    local image = wibox.widget({
        image = app.icon,
        resize = true,
        valign = "center",
        halign = "center",
        forced_height = beautiful.launcher_app_icon_size,
        forced_width = beautiful.launcher_app_icon_size,
        widget = wibox.widget.imagebox
    })

    local name = wibox.widget({
        markup = app.name,
        valign = "center",
        halign = "left",
        widget = wibox.widget.textbox
    })

    local background = wibox.widget({
        {
            {
                image,
                name,
                spacing = beautiful.launcher_inner_margin,
                layout = wibox.layout.fixed.horizontal
            },
            margins = beautiful.launcher_inner_margin,
            layout = wibox.container.margin
        },
        layout = wibox.container.background
    })

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
        if app.name:lower():find(M.input:lower()) then
            table.insert(M.matches, app)
        end
    end

    table.sort(M.matches, function(a, b)
        return M.dist(a, M.input) < M.dist(b, M.input)
    end)

    M.list:reset()

    for _, app in pairs(M.matches) do
        M.list:add(M.create_app_widget(app))
    end
end

function M.run_app(app)
    awful.spawn(app.exec)
    M.stop()
end

function M.keypressed_callback(_, mod, key, event)
    if event == "release" then
        return
    end

    if key == "BackSpace" then
        M.input = M.input:sub(1, -2)
    end

    if key == "Escape" then
        M.stop()
    end

    if key == "Return" then
        M.run_app(M.matches[1])
        M.stop()
    end

    if #key == 1 then
        if not M.input then
            M.input = key
        else
            M.input = M.input .. key
        end
    end

    if not M.input or M.input == "" then
        M.prompt.markup = "Search..."
    else
        M.prompt.markup = M.input
    end
    M.update_apps()
end

function M.add_power_button(icon, cmd)
    local image = wibox.widget({
        markup = icon,
        font = beautiful.font_icon,
        valign = "center",
        halign = "center",
        forced_height = beautiful.launcher_large_icon_size,
        forced_width = beautiful.launcher_large_icon_size,
        widget = wibox.widget.textbox
    })

    local button = add_clickable(image, image, 0, 0)

    button:add_button(awful.button({}, 1, function()
        awful.spawn.with_shell(cmd)
    end))

    M.button_group:add(button)
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
        markup = " ",
        font = beautiful.font_icon,
        valign = "center",
        widget = wibox.widget.textbox
    })

    M.prompt = wibox.widget({
        text = "Search...",
        valign = "center",
        halign = "left",
        widget = wibox.widget.textbox
    })

    M.list = wibox.widget({
        spacing = beautiful.launcher_inner_margin,
        layout = wibox.layout.overflow.vertical,
        scrollbar_enabled = false,
        step = 50
    })

    M.pfp = wibox.widget({
        image = gears.filesystem.get_configuration_dir() .. "/pfp.jpg",
        halign = "center",
        valign = "center",
        forced_height = beautiful.launcher_large_icon_size,
        forced_width = beautiful.launcher_large_icon_size,
        resize = true,
        clip_shape = gears.shape.circle,
        widget = wibox.widget.imagebox
    })

    M.button_group = wibox.widget({
        layout = wibox.layout.fixed.vertical
    })

    for _, i in ipairs(M.buttons) do
        M.add_power_button(i.icon, i.cmd)
    end

    M.name = wibox.widget({
        markup = "",
        valign = "center",
        halign = "center",
        widget = wibox.widget.textbox
    })

    M.widget = wibox.widget({
        {
            nil,
            {
                {
                    {
                        {
                            M.pfp,
                            M.name,
                            spacing = beautiful.launcher_inner_margin,
                            layout = wibox.layout.fixed.horizontal
                        },
                        margins = beautiful.launcher_inner_margin,
                        layout = wibox.container.margin
                    },
                    {
                        {
                            {
                                {
                                    M.side_text,
                                    M.prompt,
                                    layout = wibox.layout.fixed.horizontal
                                },
                                margins = beautiful.launcher_inner_margin,
                                layout = wibox.container.margin
                            },
                            shape = helpers.rounded_rect(),
                            bg = beautiful.bg1,
                            layout = wibox.container.background
                        },
                        M.list,
                        spacing = beautiful.launcher_inner_margin,
                        layout = wibox.layout.fixed.vertical
                    },
                    spacing = beautiful.launcher_inner_margin,
                    layout = wibox.layout.fixed.vertical
                },
                forced_width = beautiful.launcher_main_width,
                margins = beautiful.launcher_inner_margin,
                layout = wibox.container.margin
            },
            {
                {
                    nil,
                    nil,
                    M.button_group,
                    layout = wibox.layout.align.vertical
                },
                bg = beautiful.bg1,
                layout = wibox.container.background
            },
            layout = wibox.layout.fixed.horizontal
        },
        border_width = beautiful.border_width,
        border_color = beautiful.border_color_normal,
        bg = beautiful.bg0,
        layout = wibox.container.background
    })

    M.wibox = wibox({
        widget = M.widget,
        shape = helpers.rounded_rect(),
        screen = awful.screen.focused(),
        ontop = true,
        visible = false,
        width = beautiful.launcher_width,
        height = beautiful.launcher_height
    })

    awful.placement.top_left(M.wibox, {
        margins = {
            top = beautiful.bar_height + 2 * beautiful.margins,
            left = beautiful.margins
        }
    })

    awesome.connect_signal("launcher::toggle", function()
        M.toggle()
    end)

    return M
end

function M.toggle()
    M.wibox.visible = not M.wibox.visible
    if M.wibox.visible then
        M.input = ""
        M.prompt.markup = "Search..."
        M.get_apps()
        M.update_apps()
        awful.spawn.easy_async_with_shell("echo $USER", function(stdout)
            stdout = stdout:gsub("[\n\r]", ""):gsub("^%l", string.upper)
            M.name.markup = "<b>" .. stdout .. "</b>"
        end)
        M.keygrabber:start()
    else
        M.keygrabber:stop()
    end
end

function M.stop()
    M.wibox.visible = false
    M.keygrabber:stop()
end

return M.new()
