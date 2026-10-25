local BaseDiverger = require("content/cells/abstract/BaseDiverger")

local TetradivergerCW = setmetatable({
    name = "tetradiverger_cw",
    k3 = 429,
    title = "Tetradiverger (CW)",
    description = "Turns every cell that enters it clockwise.",
    routes = {
        [0] = 1,
        [1] = 1,
        [2] = 1,
        [3] = 1
    },
    reverse = {
        [0] = -1,
        [1] = -1,
        [2] = -1,
        [3] = -1
    }
}, { __index = BaseDiverger })
TetradivergerCW.__index = TetradivergerCW

return TetradivergerCW
