local Mover = require("content/cells/movers/Mover")
local BaseAcid = require("content/cells/abstract/BaseAcid")

local Alkali = setmetatable({
    name = "alkali",
    k3 = 863,
    title = "Alkali",
    description = "Acts like a moving Acid.",
    categories = { "movers", "acids" },
    acid = true
}, { __index = Mover })
Alkali.__index = Alkali

Alkali.rams = BaseAcid.rams
Alkali.ram = BaseAcid.ram

return Alkali
