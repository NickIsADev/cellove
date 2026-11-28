local Shifter = require("content/cells/shifters/Shifter")

local TwistShifter = setmetatable({
    name = "twistshifter",
    k3 = 679,
    title = "Twist Shifter",
    description = "Shifter that flips the outputted cell across the same axis as its arrow."
}, { __index = Shifter })
TwistShifter.__index = TwistShifter

function TwistShifter:_emit(facing, scout)
    local generated, clone, turn = Shifter._emit(self, facing, scout)
    if not generated then return end

    if clone and clone.x and self.grid:get(clone.x, clone.y) == clone then
        clone:flip((self.rotation * 2 + turn * 2) % 4, { forced = true })
    end
    return true
end

return TwistShifter
