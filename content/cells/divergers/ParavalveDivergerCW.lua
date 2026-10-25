local BaseDiverger = require("content/cells/abstract/BaseDiverger")

local ParavalveDivergerCW = setmetatable({
    name = "paravalvediverger_cw",
    k3 = 84,
    title = "Paravalve Diverger (CW)",
    description = "Passes cells straight through and turns side entries clockwise.",
    routes = {
        [0] = 0,
        [1] = 1,
        [2] = 0,
        [3] = 1
    },
    reverse = { [0] = 0, [2] = 0 }
}, { __index = BaseDiverger })
ParavalveDivergerCW.__index = ParavalveDivergerCW

return ParavalveDivergerCW
