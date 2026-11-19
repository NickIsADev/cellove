local BaseToggle = require("content/cells/abstract/BaseToggle")

local ToggleGate = setmetatable({
    name = "togglegate",
    k3 = 707,
    title = "Toggle Gate",
    description = "Lets every cell pass. A Toggle Key moving into it turns it into a Toggle Door.",
    categories = { "walls", "unlocking" },
    solid = false,
    pair = "toggledoor"
}, { __index = BaseToggle })
ToggleGate.__index = ToggleGate

return ToggleGate
