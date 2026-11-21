local Coil = require("content/cells/forces/Coil")
local constants = require("src/constants")

local AdjustableCoil = setmetatable({
    name = "adjustablecoil",
    k3 = 1188,
    title = "Adjustable Coil",
    description = "Coil that uses its own amount instead of the amount of force applied.",
    properties = { constants.adjustable.count, constants.adjustable.amount }
}, { __index = Coil })
AdjustableCoil.__index = AdjustableCoil

function AdjustableCoil:_label()
    return self.props.count .. "/" .. self.props.amount
end

return AdjustableCoil
