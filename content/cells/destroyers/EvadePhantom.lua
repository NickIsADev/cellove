local EvadeTrash = require("content/cells/destroyers/EvadeTrash")

local EvadePhantom = setmetatable({
    name = "evadephantom",
    k3 = 441,
    title = "Evade Phantom",
    description = "An Evade Trash that cannot be generated.",
    phantom = true
}, { __index = EvadeTrash })
EvadePhantom.__index = EvadePhantom

return EvadePhantom
