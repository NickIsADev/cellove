local DirectionalTrash = require("content/cells/destroyers/DirectionalTrash")

local DirectionalPhantom = setmetatable({
    name = "directionalphantom",
    k3 = 856,
    title = "Directional Phantom",
    description = "A Directional Trash that cannot be generated.",
    phantom = true
}, { __index = DirectionalTrash })
DirectionalPhantom.__index = DirectionalPhantom

return DirectionalPhantom
