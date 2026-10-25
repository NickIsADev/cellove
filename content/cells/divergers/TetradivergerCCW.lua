local BaseDiverger = require("content/cells/abstract/BaseDiverger")

local TetradivergerCCW = setmetatable({
    name = "tetradiverger_ccw",
    k3 = 430,
    title = "Tetradiverger (CCW)",
    description = "Turns every cell that enters it counter-clockwise.",
    routes = {
        [0] = -1,
        [1] = -1,
        [2] = -1,
        [3] = -1
    },
    reverse = {
        [0] = 1,
        [1] = 1,
        [2] = 1,
        [3] = 1
    }
}, { __index = BaseDiverger })
TetradivergerCCW.__index = TetradivergerCCW

return TetradivergerCCW
