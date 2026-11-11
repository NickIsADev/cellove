local BaseReactiveTrash = require("content/cells/abstract/BaseReactiveTrash")

local EvadeTrash = setmetatable({
    name = "evadetrash",
    k3 = 440,
    title = "Evade Trash",
    description = "Deletes any cell that moves into it, then moves to the right of the direction that cell was moving.",
    veer = 1
}, { __index = BaseReactiveTrash })
EvadeTrash.__index = EvadeTrash

return EvadeTrash
