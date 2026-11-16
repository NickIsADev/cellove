local BaseToggle = require("content/cells/abstract/BaseToggle")

local ToggleDoor = setmetatable({
    name = "toggledoor",
    k3 = 706,
    title = "Toggle Door",
    description = "Blocks every cell except a Toggle Key, which turns it into a Toggle Gate.",
    pair = "togglegate"
}, { __index = BaseToggle })
ToggleDoor.__index = ToggleDoor

return ToggleDoor
