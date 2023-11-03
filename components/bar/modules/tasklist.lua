local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local bling = require("bling")

local helpers = require("helpers")

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                { raise = true }
            )
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end))

local function create_widget(s)
    local widget = awful.widget.tasklist {
        screen          = s,
        filter          = awful.widget.tasklist.filter.currenttags,
        buttons         = tasklist_buttons,
        style           = {
            shape = helpers.rounded_rect()
        },
        -- Notice that there is *NO* wibox.wibox prefix, it is a template,
        -- not a widget instance.
        widget_template = {
            {
                {
                    {
                        {
                            id     = 'clienticon',
                            widget = awful.widget.clienticon,
                        },
                        top    = beautiful.large_space,
                        bottom = beautiful.large_space,
                        left   = beautiful.tasklist_hpadding,
                        right  = beautiful.tasklist_hpadding,
                        widget = wibox.container.margin
                    },
                    id     = 'background_role',
                    layout = wibox.container.background,
                },
                margins = beautiful.small_space,
                layout = wibox.container.margin,
            },
            create_callback = function(self, c, index, objects) --luacheck: no unused args
                self:get_children_by_id('clienticon')[1].client = c

                -- BLING: Toggle the popup on hover and disable it off hover
                self:connect_signal('mouse::enter', function()
                    awesome.emit_signal("bling::task_preview::visibility", s,
                        true, c)
                end)
                self:connect_signal('mouse::leave', function()
                    awesome.emit_signal("bling::task_preview::visibility", s,
                        false, c)
                end)
            end,
            layout = wibox.layout.flex.vertical,
        },
    }
    return widget
end

return create_widget
