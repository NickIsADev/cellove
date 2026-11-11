local PhysicalTrash = require("content/cells/destroyers/PhysicalTrash")

local PhysicalPhantom = setmetatable({
    name = "physicalphantom",
    k3 = 891,
    title = "Physical Phantom",
    description = "A Physical Trash that cannot be generated.",
    phantom = true
}, { __index = PhysicalTrash })
PhysicalPhantom.__index = PhysicalPhantom

return PhysicalPhantom
