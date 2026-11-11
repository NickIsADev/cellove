local JumpTrash = require("content/cells/destroyers/JumpTrash")

local JumpPhantom = setmetatable({
    name = "jumpphantom",
    k3 = 349,
    title = "Jump Phantom",
    description = "A Jump Trash that cannot be generated.",
    phantom = true
}, { __index = JumpTrash })
JumpPhantom.__index = JumpPhantom

return JumpPhantom
