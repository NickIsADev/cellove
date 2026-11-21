local Pushable = require("content/cells/pushables/Pushable")
local BaseBroken = require("content/cells/abstract/BaseBroken")

local BrokenPushable = setmetatable({
    name = "brokenpushable",
    k3 = 618,
    title = "Broken Pushable",
    description = "Pushable that is destroyed when moved."
}, { __index = Pushable })
BrokenPushable.__index = BrokenPushable

BrokenPushable.pushed = BaseBroken.pushed

return BrokenPushable
