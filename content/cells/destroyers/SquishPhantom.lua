local SquishTrash = require("content/cells/destroyers/SquishTrash")

local SquishPhantom = setmetatable({
    name = "squishphantom",
    k3 = 350,
    title = "Squish Phantom",
    description = "A Squish Trash that cannot be generated.",
    phantom = true
}, { __index = SquishTrash })
SquishPhantom.__index = SquishPhantom

return SquishPhantom
