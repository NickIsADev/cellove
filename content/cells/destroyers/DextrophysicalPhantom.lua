local DextrophysicalTrash = require("content/cells/destroyers/DextrophysicalTrash")

local DextrophysicalPhantom = setmetatable({
    name = "dextrophysicalphantom",
    k3 = 893,
    title = "Dextrophysical Phantom",
    description = "A Dextrophysical Trash that cannot be generated.",
    phantom = true
}, { __index = DextrophysicalTrash })
DextrophysicalPhantom.__index = DextrophysicalPhantom

return DextrophysicalPhantom
