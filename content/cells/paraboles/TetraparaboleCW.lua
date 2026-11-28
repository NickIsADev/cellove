local Arc = require("content/cells/paraboles/Arc")
local TetradivergerCW = require("content/cells/divergers/TetradivergerCW")

local TetraparaboleCW = setmetatable({
    name = "tetraparabole_cw",
    k3 = 388,
    title = "Tetraparabole (CW)",
    description = "Parabole that always turns clockwise.",
    faces = {},
    routes = TetradivergerCW.routes,
    reverse = TetradivergerCW.reverse,
    spins = { push = 1, pull = -1, grab = -1 }
}, { __index = Arc })
TetraparaboleCW.__index = TetraparaboleCW

function TetraparaboleCW:pushed(_, _, action)
    self:rotate(self.spins[action], { forced = true, quiet = true })
end

return TetraparaboleCW
