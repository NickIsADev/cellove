local Shifter = require("content/cells/shifters/Shifter")
local constants = require("src/constants")

local SniperShifter = setmetatable({
    name = "snipershifter",
    k3 = 847,
    title = "Sniper Shifter",
    description = "Shifter that pushes the outputted cell forward until it is blocked."
}, { __index = Shifter })
SniperShifter.__index = SniperShifter

function SniperShifter:_emit(facing, scout)
    local generated, clone = Shifter._emit(self, facing, scout)
    if not generated then return end

    local heading = constants.directions[facing]
    if clone then clone:launch(heading[1], heading[2], { force = constants.force.strength }) end
    return true
end

return SniperShifter
