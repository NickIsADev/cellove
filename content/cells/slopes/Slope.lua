local BaseCell = require("content/cells/abstract/BaseCell")
local utils = require("src/utils")

local senses = {
    oriented = function(self, _, dy)
        return (dy == 0 and -1 or 1) * (self.rotation % 2 == 0 and 1 or -1)
    end,
    cw = function(_, _, _, reverse)
        return reverse and 1 or -1
    end,
    ccw = function(_, _, _, reverse)
        return reverse and -1 or 1
    end,
    rng = utils.randomSign
}

local Slope = setmetatable({
    name = "slope",
    k3 = 381,
    title = "Slope",
    description = "Shifts cells sideways as they pass through it, without changing their direction.",
    categories = { "slopes" },
    sense = "oriented",
    run = 0,
    rise = 1
}, { __index = BaseCell })
Slope.__index = Slope

function Slope:measure()
    return self.run, self.rise
end

function Slope:jump(dx, dy, x, y, reverse)
    local run, rise = self:measure()
    local sx, sy = utils.turn(dx, dy, senses[self.sense](self, dx, dy, reverse))
    return x + (run - 1) * dx + rise * sx, y + (run - 1) * dy + rise * sy
end

return Slope
