local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local function update_tag(self, tag, index, taglist)
    local widget = wibox.widget({
        forced_height = beautiful.taglist_height,
        shape = gears.shape.rounded_bar,
        widget = wibox.container.background
    })
    local color = beautiful.taglist_inactive_fg
    if tag.selected and #tag:clients() > 0 then
        widget.forced_width = beautiful.taglist_active_width
        color = beautiful.taglist_active_fg
    elseif tag.selected then
        widget.forced_width = beautiful.taglist_active_width
        color = beautiful.taglist_active_fg
    elseif #tag:clients() > 0 then
        widget.forced_width = beautiful.taglist_occupied_width
        color = beautiful.taglist_occupied_fg
    else
        widget.forced_width = beautiful.taglist_inactive_width
    end
    widget.bg = color

    self:set_widget(wibox.widget({
        widget,
        valign = "center",
        layout = wibox.container.place
    }))
end

local function create_widget(s)
    return require("widgets.background_widget")(wibox.widget {
        widget = wibox.container.margin,
        left = beautiful.xlarge_space,
        right = beautiful.xlarge_space,
        top = beautiful.large_space,
        bottom = beautiful.large_space,
        awful.widget.taglist {
            screen = s,
            filter = awful.widget.taglist.filter.all,
            layout = wibox.layout.fixed.horizontal,
            spacing = beautiful.taglist_spacing,
            widget_template = {
                widget = wibox.container.margin,
                forced_height = beautiful.taglist_margin_height,
                forced_width = beautiful.taglist_margin_width,
                valign = "center",
                align = "center",
                create_callback = update_tag,
                update_callback = update_tag,
            },
            buttons = taglist_buttons,
        }
    })
end

return create_widget
