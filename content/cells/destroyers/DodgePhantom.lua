local DodgeTrash = require("content/cells/destroyers/DodgeTrash")

local DodgePhantom = setmetatable({
    name = "dodgephantom",
    k3 = 439,
    title = "Dodge Phantom",
    description = "A Dodge Trash that cannot be generated.",
    phantom = true
}, { __index = DodgeTrash })
DodgePhantom.__index = DodgePhantom

return DodgePhantom
