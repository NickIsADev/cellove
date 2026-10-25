local BaseDiverger = require("content/cells/abstract/BaseDiverger")

local ValveDivergerCCW = setmetatable({
    name = "valvediverger_ccw",
    k3 = 94,
    title = "Valve Diverger (CCW)",
    description = "Sends cells out the front. Accepts them from behind and the left.",
    routes = { [2] = 0, [3] = -1 },
    reverse = { [0] = 0 }
}, { __index = BaseDiverger })
ValveDivergerCCW.__index = ValveDivergerCCW

return ValveDivergerCCW
