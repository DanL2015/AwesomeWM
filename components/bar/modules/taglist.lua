local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local helpers = require("helpers")

local taglist_buttons = gears.table.join(awful.button({}, 1, function(t)
    t:view_only()
end), awful.button({modkey}, 1, function(t)
    if client.focus then
        client.focus:move_to_tag(t)
    end
end), awful.button({}, 3, awful.tag.viewtoggle), awful.button({modkey}, 3, function(t)
    if client.focus then
        client.focus:toggle_tag(t)
    end
end), awful.button({}, 4, function(t)
    awful.tag.viewnext(t.screen)
end), awful.button({}, 5, function(t)
    awful.tag.viewprev(t.screen)
end))

local function update_tag(self, tag, index, taglist)
    local widget = self:get_children_by_id("background_role")[1]
    if tag.selected and #tag:clients() > 0 then
        widget.forced_width = beautiful.taglist_active_width
    elseif tag.selected then
        widget.forced_width = beautiful.taglist_active_width
    elseif #tag:clients() > 0 then
        widget.forced_width = beautiful.taglist_occupied_width
    else
        widget.forced_width = beautiful.taglist_inactive_width
    end
end

local function create_widget(s)
    local taglist = awful.widget.taglist({
        screen = s,
        filter = awful.widget.taglist.filter.all,
        layout = wibox.layout.fixed.horizontal,
        spacing = beautiful.taglist_spacing,
        style = {
            shape = helpers.rounded_rect()
        },
        widget_template = {
            {
                {
                    forced_height = beautiful.taglist_height,
                    widget = wibox.container.background,
                    id = "background_role",
                },
                valign = "center",
                layout = wibox.container.place
            },
            layout = wibox.container.background,
            valign = "center",
            halign = "center",
            create_callback = update_tag,
            update_callback = update_tag
        },
        buttons = taglist_buttons
    })
    local widget = wibox.widget({
		taglist,
        layout = wibox.container.margin,
        left = beautiful.xlarge_space,
        right = beautiful.xlarge_space,
        top = beautiful.large_space,
        bottom = beautiful.large_space
    })

    return require("helpers.background_widget")(widget)
end

return create_widget
