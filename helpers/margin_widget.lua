local wibox = require("wibox")

local function create_widget(widget, h, v)
    h = h or 0
    v = v or 0
    return wibox.container.margin(widget, h, h, v, v)
end

return create_widget