local Crusher = require("content/cells/movers/Crusher")
local SuperMover = require("content/cells/movers/SuperMover")

local SuperCrusher = setmetatable({
    name = "supercrusher",
    k3 = 1161,
    title = "Super Crusher",
    description = "A Crusher with the infinite force and speed of a Super Mover.",
    subtick = { "superMover" },
    damage = math.huge
}, { __index = Crusher })
SuperCrusher.__index = SuperCrusher

SuperCrusher.force = SuperMover.force

function SuperCrusher:update()
    SuperMover.update(self)
    self:_crush()
end

return SuperCrusher
