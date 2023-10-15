local gears = require("gears")
local M = {}

M.rounded_rect = function(radius)
    return function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, radius)
    end
end

return M