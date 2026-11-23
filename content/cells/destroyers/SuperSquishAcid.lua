local SquishAcid = require("content/cells/destroyers/SquishAcid")
local BaseSuper = require("content/cells/abstract/BaseSuper")

local SuperSquishAcid = setmetatable({
    name = "supersquishacid",
    k3 = 716,
    title = "Super Squish Acid",
    description = "Squish Acid with infinite health."
}, { __index = SquishAcid })
SuperSquishAcid.__index = SuperSquishAcid

SuperSquishAcid.health = BaseSuper.health
SuperSquishAcid.hit = BaseSuper.hit

return SuperSquishAcid
