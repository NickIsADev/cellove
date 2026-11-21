local StraightDiverger = require("content/cells/divergers/StraightDiverger")

local TwistDiverger = setmetatable({
    name = "twistdiverger",
    k3 = 210,
    title = "Twist Diverger",
    description = "Straight Diverger that flips the cells passing through it, like a Twist Generator."
}, { __index = StraightDiverger })
TwistDiverger.__index = TwistDiverger

function TwistDiverger:passed(mover)
    self.grid.simulator.movement:defer(function()
        mover:flip(self.rotation * 2 % 4, true)
    end)
end

return TwistDiverger
