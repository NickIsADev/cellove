local BaseInput = require("content/cells/abstract/BaseInput")

local InputGate = setmetatable({
    name = "inputgate",
    k3 = 917,
    title = "Input Gate",
    description = "Lets every cell pass. Click it while the simulation is running to turn it into an Input Door.",
    categories = { "input", "walls" },
    solid = false,
    pair = "inputdoor"
}, { __index = BaseInput })
InputGate.__index = InputGate

return InputGate
