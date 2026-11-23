local Alkali = require("content/cells/movers/Alkali")
local BaseSuper = require("content/cells/abstract/BaseSuper")

local SuperAlkali = setmetatable({
    name = "superalkali",
    k3 = 423,
    title = "Super Alkali",
    description = "Acts like a moving Super Acid."
}, { __index = Alkali })
SuperAlkali.__index = SuperAlkali

SuperAlkali.health = BaseSuper.health
SuperAlkali.hit = BaseSuper.hit

return SuperAlkali
