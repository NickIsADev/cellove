local Nudger = require("content/cells/movers/Nudger")
local Gravity = require("content/effects/Gravity")
local constants = require("src/constants")

local Graviton = setmetatable({
    name = "graviton",
    k3 = 424,
    title = "Graviton",
    description = "Nudger, but when it hits a cell it will gravitize it and disappear.",
    categories = { "othermovers", "effects" }
}, { __index = Nudger })
Graviton.__index = Graviton

function Graviton:update()
    if self:nudge() then return end

    local facing = constants.directions[self.rotation]
    local front = self.grid:get(self.x + facing[1], self.y + facing[2])
    if not (front and Gravity:accepts(front)) then return end

    Gravity:apply(front, self.rotation)
    self:kill()
end

return Graviton
