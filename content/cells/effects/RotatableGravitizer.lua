local Gravitizer = require("content/cells/effects/Gravitizer")

local RotatableGravitizer = setmetatable({
    name = "rotatablegravitizer",
    k3 = 588,
    title = "Rotatable Gravitizer",
    description = "Gravity will rotate when the cell is rotated."
}, { __index = Gravitizer })
RotatableGravitizer.__index = RotatableGravitizer

function RotatableGravitizer:_value()
    return Gravitizer._value(self) + 4
end

return RotatableGravitizer
