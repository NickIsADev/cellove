local LevophysicalTrash = require("content/cells/destroyers/LevophysicalTrash")

local LevophysicalPhantom = setmetatable({
    name = "levophysicalphantom",
    k3 = 895,
    title = "Levophysical Phantom",
    description = "A Levophysical Trash that cannot be generated.",
    phantom = true
}, { __index = LevophysicalTrash })
LevophysicalPhantom.__index = LevophysicalPhantom

return LevophysicalPhantom
