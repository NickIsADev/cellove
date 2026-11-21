local Resistance = require("content/cells/forces/Resistance")

local Restrainer = setmetatable({
    name = "restrainer",
    k3 = 639,
    title = "Restrainer",
    description = "Resistance that only affects force applied to its front.",
    faces = { 0 },
    front = true
}, { __index = Resistance })
Restrainer.__index = Restrainer

return Restrainer
