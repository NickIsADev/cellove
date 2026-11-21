local Pushable = require("content/cells/pushables/Pushable")
local BaseSuper = require("content/cells/abstract/BaseSuper")

local SuperPushable = setmetatable({
    name = "superpushable",
    k3 = 840,
    title = "Super Pushable",
    description = "Pushable with infinite health."
}, { __index = Pushable })
SuperPushable.__index = SuperPushable

SuperPushable.health = BaseSuper.health
SuperPushable.hit = BaseSuper.hit

return SuperPushable
