local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:activate({ context = "tasklist", action = "toggle_minimization" })
    end))

local function update(self, client, index, clients)
    local background = self:get_children_by_id("background")[1]
    local icon = self:get_children_by_id("icon")[1]
    local separator = self:get_children_by_id("separator")[1]

    icon.image = client.icon or beautiful.icon_default
    if client.active then
        background.bg = beautiful.bg2
        separator.visible = true
    else
        background.bg = beautiful.bg1
        separator.visible = false
    end
end

local function init(self, client, index, clients)
    local background = self:get_children_by_id("background")[1]
    local tooltip = helpers.add_tooltip(background, "<b>" .. (client.class:gsub("^%l", string.upper)) .. "</b>")
    update(self, client, index, clients)
end

local function create_widget(s)
    local tasklist = awful.widget.tasklist({
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        spacing = beautiful.margin[0],
        style = {
            shape = helpers.rrect()
        },
        layout = {
            spacing_widget = {
                {
                    forced_width  = beautiful.dpi(20),
                    forced_height = beautiful.dpi(4),
                    thickness     = beautiful.dpi(2),
                    color         = beautiful.fg2,
                    widget        = wibox.widget.separator
                },
                valign = "center",
                halign = "center",
                widget = wibox.container.place,
            },
            spacing        = beautiful.margin[1],
            layout         = wibox.layout.fixed.vertical,
        },
        widget_template = {
            {
                {
                    {
                        widget = wibox.widget.imagebox,
                        id = "icon",
                    },
                    layout = wibox.container.margin,
                    margins = beautiful.margin[0],
                },
                layout = wibox.container.background,
                shape = helpers.rrect(),
                id = "background",
            },
            {
                {
                    {
                        widget = wibox.widget.separator,
                        id = "separator",
                        shape = helpers.rrect(),
                        thickness = beautiful.dpi(2),
                        forced_width = beautiful.dpi(2),
                        forced_height = beautiful.dpi(16),
                        color = beautiful.blue,
                    },
                    margins = beautiful.dpi(1),
                    layout = wibox.container.margin
                },
                valign = "center",
                halign = "left",
                layout = wibox.container.place
            },
            layout = wibox.layout.stack,
            create_callback = init,
            update_callback = update
        },
        buttons = tasklist_buttons
    })

    local widget = helpers.add_margin(tasklist)
    return widget
end

return create_widget
