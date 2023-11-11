local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local helpers = require("helpers")
local rubato = require("rubato")

local add_background = require("helpers.background_widget")
local add_clickable = require("helpers.clickable_widget")

local M = {}

-- Class is class name of application
-- Cmd is terminal command to execute application
M.pinned = {{
    class = "firefox",
    cmd = "firefox"
}, {
    class = "Alacritty",
    cmd = "alacritty"
}, {
    class = "nemo",
    cmd = "nemo"
}, {
    class = "obsidian",
    cmd = "obsidian"
}}
M.widgets = {}

function M.add_widget_by_name(client_class, client_icon)
    if not client_class then
        return
    end
    local icon = helpers.get_icon(client_class) or client_icon or beautiful.icon_command

    client_class = client_class:lower()

    local indicator = wibox.widget({
        shape = helpers.rounded_rect(),
        thickness = beautiful.dock_indicator_height,
        forced_height = beautiful.dock_indicator_height,
        forced_width = beautiful.dock_indicator_unfocused_width,
        halign = "center",
        valign = "bottom",
        visible = false,
        widget = wibox.widget.separator
    })

    local icon = wibox.widget({
        image = icon,
        resize = true,
        forced_height = beautiful.dock_icon_size,
        forced_width = beautiful.dock_icon_size,
        valign = "center",
        halign = "center",
        widget = wibox.widget.imagebox
    })

    local background = wibox.widget({
        add_clickable(icon),
        shape = helpers.rounded_rect(),
        bg = beautiful.bg0,
        layout = wibox.container.background
    })

    local widget = wibox.widget({
        {
            background,
            {
                {
                    indicator,
                    margins = beautiful.small_space,
                    layout = wibox.container.margin
                },
                valign = "bottom",
                halign = "center",
                layout = wibox.container.place
            },
            layout = wibox.layout.stack
        },
        margins = beautiful.dock_app_margin,
        layout = wibox.container.margin
    })

    background:connect_signal("mouse::enter", function()
        indicator.color = beautiful.bg0
    end)

    background:connect_signal("mouse::leave", function()
        indicator.color = beautiful.fg0
    end)

    M.widgets[client_class] = {
        icon = icon,
        indicator = indicator,
        background = background,
        widget = widget,
        num_clients = 0
    }

    icon:add_button(gears.table.join(awful.button({}, 1, function()
        local class = client_class
        if not M.widgets[class] or not M.widgets[class].indicator then
            return
        end
        if M.widgets[class].num_clients == 0 then
            for _, app in ipairs(M.pinned) do
                if app.class:lower() == class:lower() then
                    awful.spawn.with_shell(app.cmd)
                end
            end
        elseif M.widgets[class].num_clients == 1 then
            for _, c in ipairs(client.get()) do
                if class == c.class:lower() then
                    if c.first_tag == awful.screen.focused().selected_tag and c == client.focus then
                        c.minimized = not c.minimized
                    else
                        c:jump_to()
                    end
                end
            end
        else
            -- Badly written window cycling
            local first = nil
            local switch_next = false
            local switched = false
            for _, c in ipairs(client.get()) do
                if not first and class == c.class:lower() and client.focus ~= c then
                    first = c
                end
                if client.focus == c then
                    switch_next = true
                end
                if switch_next and class == c.class:lower() and client.focus ~= c then
                    c:jump_to()
                    switched = true
                    break
                end
            end
            if not switched and first then
                first:jump_to()
            end
        end
    end)))

    M.widget:add(widget)
    M.wibox.width = M.wibox.width + beautiful.dock_app_width
    M.place()
end

function M.add_widget_by_client(client)
    if not client or not client.class then
        return
    end

    local class = client.class:lower()

    if not M.widgets[class] then
        M.add_widget_by_name(class, client.icon)
    end

    M.widgets[class].num_clients = M.widgets[class].num_clients + 1
    M.widgets[class].indicator.visible = true

    M.place()
end

function M.remove_widget_by_client(client)
    if not client or not client.class then
        return
    end

    local class = client.class:lower()

    if M.widgets[class] and M.widgets[class].indicator then
        local indicator = M.widgets[class].indicator
        if M.widgets[class].num_clients == 1 and M.widgets[class].widget then
            local is_pinned = false
            for _, i in ipairs(M.pinned) do
                if class == i.class:lower() then
                    is_pinned = true
                    break
                end
            end
            M.widgets[class].num_clients = 0
            if not is_pinned then
                M.widget:remove_widgets(M.widgets[class].widget)
                M.widgets[class] = nil
                M.wibox.width = M.wibox.width - beautiful.dock_app_width
                M.place()
            else
                M.widgets[class].background.bg = "#00000000"
                indicator.visible = false
            end
        elseif M.widgets[class].num_clients > 1 then
            M.widgets[class].num_clients = M.widgets[class].num_clients - 1
        end
    end
    M.place()
end

function M.add_pinned()
    for _, app in ipairs(M.pinned) do
        M.add_widget_by_name(app.class)
    end
end

function M.focus(client)
    if not client or not client.class then
        return
    end

    local class = client.class:lower()

    for c, widget in pairs(M.widgets) do
        if widget.indicator then
            if c == class then
                widget.indicator.forced_width = beautiful.dock_indicator_focused_width
                widget.background.bg = beautiful.fg1 .. "50"
            else
                widget.indicator.forced_width = beautiful.dock_indicator_unfocused_width
                widget.background.bg = beautiful.bg0
            end
        end
    end
    M.place()
end

function M.unfocus(client)
    if not client or not client.class then
        return
    end

    local class = client.class:lower()
    if not M.widgets[class] or not M.widgets[class].indicator then
        return
    end

    M.widgets[class].indicator.forced_width = beautiful.dock_indicator_unfocused_width
    M.widgets[class].background.bg = "#00000000"

    M.place()
end

function M.show()
    if not M.timer then
        return
    end
    M.timer.pos = M.y_pos_hide()
    M.timer.target = M.y_pos_show()
end

function M.hide()
    if not M.timer then
        return
    end
    M.timer.pos = M.y_pos_show()
    M.timer.target = M.y_pos_hide()
end

function M.y_pos_show()
    if not M.screen then
        M.screen = awful.screen.focused()
    end
    return M.screen.geometry.height - beautiful.margins - M.wibox.height
end

function M.y_pos_hide()
    if not M.screen then
        M.screen = awful.screen.focused()
    end
    return M.screen.geometry.height - beautiful.margins
end

function M.update_display()
    if not M.screen then
        M.screen = awful.screen.focused()
    end
    if not M.screen.selected_tag then
        return
    end

    if #M.screen.selected_tag:clients() == 0 then
        M.display = true
        M.show()
    else
        M.display = false
        M.hide()
    end
end

function M.place()
    if not M.screen then
        M.screen = awful.screen.focused()
    end
    M.wibox.x = M.screen.geometry.x + (M.screen.geometry.width - M.wibox.width) / 2
end

function M.new()
    M.screen = awful.screen.focused()

    M.widget = wibox.widget({
        layout = wibox.layout.flex.horizontal
    })

    M.wibox = wibox({
        widget = wibox.widget({
            M.widget,
            bg = beautiful.bg0,
            border_width = beautiful.border_width,
            border_color = beautiful.border_color_normal,
            layout = wibox.container.background
        }),
        height = beautiful.dock_app_height,
        ontop = true,
        visible = true
    })

    awful.placement.bottom(M.wibox, {
        margins = {
            bottom = beautiful.margins
        }
    })

    M.add_pinned()

    M.place()
    M.display = true
    M.timer = rubato.timed({
        duration = 0.2,
        subscribed = function(pos)
            M.wibox.y = pos
        end,
        pos = M.y_pos_hide()
    })

    client.connect_signal("request::manage", function(c)
        M.update_display()
        M.add_widget_by_client(c)
    end)
    client.connect_signal("request::unmanage", function(c)
        M.update_display()
        M.remove_widget_by_client(c)
    end)
    client.connect_signal("focus", function(c)
        M.focus(c)
    end)
    client.connect_signal("unfocus", function(c)
        M.unfocus(c)
    end)
    client.connect_signal("property::fullscreen", function(c)
        if c.fullscreen and c.tag == awful.screen.focused().tag then
            M.wibox.visible = false
        else
            M.wibox.visible = true
        end
    end)
    tag.connect_signal("property::selected", function(t)
        M.update_display()
    end)

    M.widget:connect_signal("mouse::enter", function()
        if not M.display then
            M.show()
        end
    end)
    M.widget:connect_signal("mouse::leave", function()
        if not M.display then
            M.hide()
        end
    end)
    screen.connect_signal("list", function()
        M.screen = awful.screen.focused()
        M.update_display()
    end)

    return M
end

return M.new()
