local Trash = require("content/cells/destroyers/Trash")

local Phantom = setmetatable({
    name = "phantom",
    k3 = 205,
    title = "Phantom",
    description = "A Trash that cannot be generated.",
    phantom = true
}, { __index = Trash })
Phantom.__index = Phantom

return Phantom
