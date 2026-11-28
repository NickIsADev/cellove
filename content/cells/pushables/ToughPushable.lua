local Pushable = require("content/cells/pushables/Pushable")

local Wall = require("content/cells/walls/Wall")

local ToughPushable = setmetatable({
    name = "toughpushable",
    k3 = 159,
    title = "Tough Pushable",
    description = "Pushable that cannot be destroyed diagonally.",
    mimic = { corner = Wall }
}, { __index = Pushable })
ToughPushable.__index = ToughPushable

return ToughPushable
