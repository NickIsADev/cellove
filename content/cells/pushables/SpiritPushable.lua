local Pushable = require("content/cells/pushables/Pushable")
local BaseSpirit = require("content/cells/abstract/BaseSpirit")

local SpiritPushable = setmetatable({
    name = "spiritpushable",
    k3 = 214,
    title = "Spirit Pushable",
    description = "Pushable that cannot be generated."
}, { __index = Pushable })
SpiritPushable.__index = SpiritPushable

SpiritPushable.generatable = BaseSpirit.generatable

return SpiritPushable
