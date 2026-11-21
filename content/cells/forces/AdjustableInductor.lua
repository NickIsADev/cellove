local Inductor = require("content/cells/forces/Inductor")
local constants = require("src/constants")

local AdjustableInductor = setmetatable({
    name = "adjustableinductor",
    k3 = 1198,
    title = "Adjustable Inductor",
    description = "Inductor that uses its own amount instead of the amount of force applied.",
    properties = { constants.adjustable.count, constants.adjustable.amount }
}, { __index = Inductor })
AdjustableInductor.__index = AdjustableInductor

function AdjustableInductor:_label()
    return self.props.count .. "/" .. self.props.amount
end

return AdjustableInductor
