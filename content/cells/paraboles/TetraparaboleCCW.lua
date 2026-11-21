local TetraparaboleCW = require("content/cells/paraboles/TetraparaboleCW")
local TetradivergerCCW = require("content/cells/divergers/TetradivergerCCW")

local TetraparaboleCCW = setmetatable({
    name = "tetraparabole_ccw",
    k3 = 389,
    title = "Tetraparabole (CCW)",
    description = "Parabole that always turns counter-clockwise.",
    routes = TetradivergerCCW.routes,
    reverse = TetradivergerCCW.reverse,
    spins = { push = -1, pull = 1, grab = 1 }
}, { __index = TetraparaboleCW })
TetraparaboleCCW.__index = TetraparaboleCCW

return TetraparaboleCCW
