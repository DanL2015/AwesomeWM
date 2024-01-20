local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

local taglist_buttons = gears.table.join(awful.button({}, 1, function(t)
        t:view_only()
    end),
    awful.button({}, 4, function(t)
        awful.tag.viewnext(t.screen)
    end),
    awful.button({}, 5, function(t)
        awful.tag.viewprev(t.screen)
    end))

local function update_tag(self, tag, index, tags)
    local background = self:get_children_by_id("background_role")[1]
    local text = self:get_children_by_id("icon")[1]

    local urgent = false
    for _, client in ipairs(tag:clients()) do
        if client.urgent then
            urgent = true
            break
        end
    end

    if urgent then
        background.fg = beautiful.red
        text.text = ""
    elseif tag.selected and #tag:clients() > 0 then
        background.fg = beautiful.blue
        text.text = ""
    elseif tag.selected then
        background.fg = beautiful.blue
        text.text = ""
    elseif #tag:clients() > 0 then
        background.fg = beautiful.green
        text.text = ""
    else
        background.fg = beautiful.bg2
        text.text = ""
    end
end

local function create_widget(s)
    local taglist = awful.widget.taglist({
        screen = s,
        filter = awful.widget.taglist.filter.all,
        layout = {
            layout = wibox.layout.fixed.vertical,
            spacing = beautiful.margin[1],
        },
        style = {
            shape = helpers.rrect()
        },
        widget_template = {
            {
                widget = wibox.widget.textbox,
                font = beautiful.font_icon,
                valign = "center",
                halign = "center",
                id = "icon"
            },
            layout = wibox.container.background,
            id = "background_role",
            create_callback = update_tag,
            update_callback = update_tag
        },
        buttons = taglist_buttons
    })

    local widget = helpers.add_margin(taglist);
    return widget
end

return create_widget
