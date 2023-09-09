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

local function update_tag(widget, tag, index, taglist)
    local text = ""
    local color = beautiful.taglist_inactive_fg
    if tag.selected and #tag:clients() > 0 then
        text = ""
        color = beautiful.taglist_active_fg
    elseif tag.selected then
        text = ""
        color = beautiful.taglist_active_fg
    elseif #tag:clients() > 0 then
        text = ""
        color = beautiful.taglist_occupied_fg
    else
        text = ""
    end

    widget.markup = "<span foreground='" .. color .. "'>" .. text .. "</span>"
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
                widget = wibox.widget.textbox,
                text = "taglist_widget",
                font = beautiful.font_icon,
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
