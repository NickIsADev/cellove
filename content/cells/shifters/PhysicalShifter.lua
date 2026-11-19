local Shifter = require("content/cells/shifters/Shifter")

local PhysicalShifter = setmetatable({
    name = "physicalshifter",
    k3 = 665,
    title = "Physical Shifter",
    description = "Shifter that steps backwards and outputs the cell where it was standing if it is blocked in front."
}, { __index = Shifter })
PhysicalShifter.__index = PhysicalShifter

function PhysicalShifter:update(_, direction)
    if not Shifter.update(self, _, direction) then self:_retreat(direction) end
end

return PhysicalShifter
