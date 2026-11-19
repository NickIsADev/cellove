local Shifter = require("content/cells/shifters/Shifter")

local Backshifter = setmetatable({
    name = "backshifter",
    k3 = 667,
    title = "Backshifter",
    description = "Shifter that steps backwards and outputs the cell where it was standing."
}, { __index = Shifter })
Backshifter.__index = Backshifter

function Backshifter:update(_, direction)
    self:_retreat(direction)
end

return Backshifter
