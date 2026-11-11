local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")

local Grabber = setmetatable({
    name = "grabber",
    k3 = 71,
    title = "Grabber",
    description = "Moves forward into empty space, dragging the cells at its sides along with it. Cannot push or pull.",
    categories = { "grabbers" },
    subtick = { "grabber" },
    drive = { push = true, pull = true, grab = true },
    directional = true
}, { __index = BaseCell })
Grabber.__index = Grabber

function Grabber:force(dx, dy, action)
    if action ~= "grab" then return 0 end
    return self:_alignment(dx, dy) * constants.force.strength
end

function Grabber:update()
    self:grab()
end

return Grabber
