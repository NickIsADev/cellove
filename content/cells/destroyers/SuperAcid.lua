local Acid = require("content/cells/destroyers/Acid")
local BaseSuper = require("content/cells/abstract/BaseSuper")

local SuperAcid = setmetatable({
    name = "superacid",
    k3 = 219,
    title = "Super Acid",
    description = "Acid with infinite health."
}, { __index = Acid })
SuperAcid.__index = SuperAcid

SuperAcid.health = BaseSuper.health
SuperAcid.hit = BaseSuper.hit

return SuperAcid
