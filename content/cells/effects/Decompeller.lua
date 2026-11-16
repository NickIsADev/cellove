local BaseEffectRemover = require("content/cells/abstract/BaseEffectRemover")
local Compel = require("content/effects/Compel")

local Decompeller = setmetatable({
    name = "decompeller",
    k3 = 826,
    title = "Decompeller",
    description = "Removes a cell's compel.",
    removes = { Compel }
}, { __index = BaseEffectRemover })
Decompeller.__index = Decompeller

return Decompeller
