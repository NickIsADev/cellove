local Grabber = require("content/cells/movers/Grabber")

local Thruster = setmetatable({
    name = "thruster",
    k3 = "bm thruster",
    title = "Thruster",
    description = "Moves forward into empty space, dragging the cells at its front diagonals along with it. Cannot push or pull.",
    categories = { "grabbers" },
    subtick = { "thruster" },
    skew = 1
}, { __index = Grabber })
Thruster.__index = Thruster

return Thruster
