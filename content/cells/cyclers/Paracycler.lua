local BaseCycler = require("content/cells/abstract/BaseCycler")

local Paracycler = setmetatable({
    name = "paracycler",
    k3 = 642,
    title = "Paracycler",
    description = "Cycles the 3 cells in front of it clockwise and the 3 behind it counter-clockwise.",
    subtick = { "cyclerCW", "cyclerCCW" },
    outputs = { 0, 2 }
}, { __index = BaseCycler })
Paracycler.__index = Paracycler

function Paracycler:update(subtick, direction)
    local spin = direction == self.rotation and 1 or -1
    if (spin > 0) == (subtick == self.subtick[1]) then return self:_cycle(direction, spin) end
end

return Paracycler
