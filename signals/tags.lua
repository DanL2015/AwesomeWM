local awful = require("awful")

-- Tags
tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({ awful.layout.suit.tile, awful.layout.suit.floating,
        awful.layout.suit.spiral, awful.layout.suit.spiral.dwindle -- awful.layout.suit.max,
    })
end)

screen.connect_signal("request::desktop_decoration", function(s)
    awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[1])
end)
