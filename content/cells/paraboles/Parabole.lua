local Arc = require("content/cells/paraboles/Arc")

local Parabole = setmetatable({
    name = "parabole",
    k3 = 384,
    title = "Parabole",
    description = "Arc that also turns itself as it is pushed."
}, { __index = Arc })
Parabole.__index = Parabole

function Parabole:pushed(dx, dy)
    self:rotate(self:_entry(dx, dy) % 2 == 0 and 1 or -1, { forced = true, quiet = true })
end

return Parabole
