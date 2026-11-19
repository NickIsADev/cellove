local BaseSwitchGate = require("content/cells/abstract/BaseSwitchGate")

local SwitchDoor = setmetatable({
    name = "switchdoor",
    k3 = 564,
    title = "Switch Door",
    description = "Blocks every cell until a Switch of its ID is on.",
    categories = { "walls", "unlocking" },
    pair = "switchgate"
}, { __index = BaseSwitchGate })
SwitchDoor.__index = SwitchDoor

return SwitchDoor
