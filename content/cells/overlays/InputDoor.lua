local BaseInput = require("content/cells/abstract/BaseInput")

local InputDoor = setmetatable({
    name = "inputdoor",
    k3 = 916,
    title = "Input Door",
    description = "Blocks every cell. Click it while the simulation is running to turn it into an Input Gate.",
    pair = "inputgate"
}, { __index = BaseInput })
InputDoor.__index = InputDoor

return InputDoor
