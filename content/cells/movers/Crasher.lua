local Mover = require("content/cells/movers/Mover")

local Crasher = setmetatable({
    name = "crasher",
    k3 = 269,
    title = "Crasher",
    description = "Moves forward every tick, pushing whatever is in front of it. Slices the cell in front of it when it cannot push.",
    categories = { "movers", "slicers" }
}, { __index = Mover })
Crasher.__index = Crasher

function Crasher:update()
    return self:push() or self:slice()
end

return Crasher
