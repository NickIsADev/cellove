local BaseDiverger = require("content/cells/abstract/BaseDiverger")

local ValveDivergerCW = setmetatable({
    name = "valvediverger_cw",
    k3 = 93,
    title = "Valve Diverger (CW)",
    description = "Sends cells out the front. Accepts them from behind and the right.",
    routes = { [1] = 1, [2] = 0 },
    reverse = { [0] = 0 }
}, { __index = BaseDiverger })
ValveDivergerCW.__index = ValveDivergerCW

return ValveDivergerCW
