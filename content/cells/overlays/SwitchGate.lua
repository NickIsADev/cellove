local BaseSwitchGate = require("content/cells/abstract/BaseSwitchGate")

local SwitchGate = setmetatable({
    name = "switchgate",
    k3 = 565,
    title = "Switch Gate",
    description = "Lets every cell pass until a Switch of its ID is on.",
    categories = { "walls", "unlocking" },
    solid = false,
    pair = "switchdoor"
}, { __index = BaseSwitchGate })
SwitchGate.__index = SwitchGate

return SwitchGate
