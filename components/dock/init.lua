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

M.pinned = {{
    class = "firefox",
    cmd = "firefox"
}, {
    class = "kitty",
    cmd = "kitty"
}, {
    class = "nemo",
    cmd = "nemo"
}, {
    class = "obsidian",
    cmd = "obsidian"
}}
M.widgets = {}

function M.add_widget_by_name(client_class, client_icon)
    local icon = beautiful.get_icon(client_class) or client_icon
    if not icon then
        return
    end

    local indicator = wibox.widget({
        forced_width = 40,
        spacing = 2,
        widget = wibox.layout.flex.horizontal
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
        bg = beautiful.dock_unfocused_bg,
        layout = wibox.container.background,
        shape = helpers.rounded_rect(4)
    })

    local widget = wibox.widget({
        {
            background,
            {
                indicator,
                valign = "bottom",
                halign = "center",
                layout = wibox.container.place
            },
            layout = wibox.layout.stack
        },
        margins = beautiful.dock_app_margin,
        layout = wibox.container.margin
    })

    M.widgets[client_class] = {
        icon = icon,
        indicator = indicator,
        widget = widget,
        background = background
    }

    icon:add_button(gears.table.join(awful.button({}, 1, function()
        local class = client_class
        if not M.widgets[class] or not M.widgets[class].indicator then
            return
        end
        if #M.widgets[class].indicator.children == 0 then
            for _, app in ipairs(M.pinned) do
                if app.class == class then
                    awful.spawn.with_shell(app.cmd)
                end
            end
        elseif #M.widgets[class].indicator.children == 1 then
            for _, c in ipairs(client.get()) do
                if class == c.class:lower() then
                    c:jump_to()
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

    if M.widgets[class] and M.widgets[class].indicator then
        local indicator = M.widgets[class].indicator
        indicator:add(wibox.widget({
            shape = helpers.rounded_rect(8),
            thickness = beautiful.dock_indicator_height,
            forced_height = beautiful.dock_indicator_height,
            halign = "center",
            valign = "bottom",
            widget = wibox.widget.separator
        }))
    end
    M.place()
end

function M.remove_widget_by_client(client)
    if not client or not client.class then
        return
    end

    local class = client.class:lower()

    if M.widgets[class] and M.widgets[class].indicator then
        local indicator = M.widgets[class].indicator
        if #indicator.children == 1 and M.widgets[class].widget then
            local is_pinned = false
            for _, i in ipairs(M.pinned) do
                if class == i.class then
                    is_pinned = true
                    break
                end
            end
            if not is_pinned then
                M.widget:remove_widgets(M.widgets[class].widget)
                M.widgets[class] = nil
                M.wibox.width = M.wibox.width - beautiful.dock_app_width
                M.place()
            else
                indicator:remove(#indicator.children)
            end
        elseif #indicator.children > 1 then
            indicator:remove(#indicator.children)
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
    if not client then
        return
    end

    local class = client.class:lower()

    for c, widget in pairs(M.widgets) do
        if widget.background then
            if c == class then
                widget.background.bg = beautiful.accent1
            else
                widget.background.bg = beautiful.bg1
            end
        end
    end
    M.place()
end

function M.unfocus(client)
    if not client then
        return
    end

    local class = client.class:lower()
    if not M.widgets[class] or not M.widgets[class].background then
        return
    end

    M.widgets[class].background.bg = beautiful.bg1
    M.place()
end

function M.show()
    if not M.timer then
        return
    end
    M.timer.pos = M.y_pos_hide(M.screen)
    M.timer.target = M.y_pos_show(M.screen)
end

function M.hide()
    if not M.timer then
        return
    end
    M.timer.pos = M.y_pos_show(M.screen)
    M.timer.target = M.y_pos_hide(M.screen)
end

function M.y_pos_show(screen)
    if not screen then
        return
    end
    return screen.geometry.height - beautiful.useless_gap - M.wibox.height
end

function M.y_pos_hide(screen)
    if not screen then
        return
    end
    return screen.geometry.height - beautiful.useless_gap
end

function M.update_display()
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
    M.wibox.x = M.screen.geometry.x + (M.screen.geometry.width - M.wibox.width) / 2
end

function M.new()
    M.screen = awful.screen.focused()

    M.widget = wibox.widget({
        layout = wibox.layout.flex.horizontal
    })

    M.wibox = wibox({
        widget = add_background(M.widget, 0, 0),
        height = beautiful.dock_app_height,
        ontop = true,
        visible = true
    })

    awful.placement.bottom(M.wibox, {
        margins = {
            bottom = beautiful.useless_gap
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
        pos = M.y_pos_hide(M.screen)
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
    screen.connect_signal("added", function()
        M.screen = awful.screen.primary
        M.hide()
    end)
    screen.connect_signal("removed", function()
        M.screen = awful.screen.primary
        M.hide()
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

    return M
end

return M.new()
