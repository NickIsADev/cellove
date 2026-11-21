local BaseCoil = require("content/cells/abstract/BaseCoil")
local constants = require("src/constants")

local Inductor = setmetatable({
    name = "inductor",
    k3 = 1197,
    title = "Inductor",
    description = "Only lets force through every nth tick, where n is the amount of force applied to it.",
    properties = { constants.adjustable.count }
}, { __index = BaseCoil })
Inductor.__index = Inductor

function Inductor:resist(force)
    self.props.count = self.props.count + 1
    if self.props.count < (self.props.amount or force) then return 0 end

    self.props.count = 0
    return force
end

return Inductor
