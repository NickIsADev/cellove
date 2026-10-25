local BaseDiverger = require("content/cells/abstract/BaseDiverger")

local ParavalveDivergerCCW = setmetatable({
    name = "paravalvediverger_ccw",
    k3 = 85,
    title = "Paravalve Diverger (CCW)",
    description = "Passes cells straight through and turns side entries counter-clockwise.",
    routes = {
        [0] = 0,
        [1] = -1,
        [2] = 0,
        [3] = -1
    },
    reverse = { [0] = 0, [2] = 0 }
}, { __index = BaseDiverger })
ParavalveDivergerCCW.__index = ParavalveDivergerCCW

return ParavalveDivergerCCW
