local Shifter = require("content/cells/shifters/Shifter")

local PhysicalBackshifter = setmetatable({
    name = "physicalbackshifter",
    k3 = 666,
    title = "Physical Backshifter",
    description = "Backshifter that outputs forwards like a Shifter if it is blocked from stepping backwards."
}, { __index = Shifter })
PhysicalBackshifter.__index = PhysicalBackshifter

function PhysicalBackshifter:update(_, direction)
    if not self:_retreat(direction) then Shifter.update(self, _, direction) end
end

return PhysicalBackshifter
