local SquishAlkali = require("content/cells/movers/SquishAlkali")
local BaseSuper = require("content/cells/abstract/BaseSuper")

local SuperSquishAlkali = setmetatable({
    name = "supersquishalkali",
    k3 = 864,
    title = "Super Squish Alkali",
    description = "Acts like a moving Super Squish Acid."
}, { __index = SquishAlkali })
SuperSquishAlkali.__index = SuperSquishAlkali

SuperSquishAlkali.health = BaseSuper.health
SuperSquishAlkali.hit = BaseSuper.hit

return SuperSquishAlkali
