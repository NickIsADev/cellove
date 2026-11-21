local Pushable = require("content/cells/pushables/Pushable")
local BaseTough = require("content/cells/abstract/BaseTough")

local ToughPushable = setmetatable({
    name = "toughpushable",
    k3 = 159,
    title = "Tough Pushable",
    description = "Pushable that cannot be destroyed diagonally.",
    shields = { corner = true }
}, { __index = Pushable })
ToughPushable.__index = ToughPushable

ToughPushable.guarded = BaseTough.guarded

return ToughPushable
