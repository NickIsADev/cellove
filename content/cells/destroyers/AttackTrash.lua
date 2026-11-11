local BaseReactiveTrash = require("content/cells/abstract/BaseReactiveTrash")

local AttackTrash = setmetatable({
    name = "attacktrash",
    k3 = 694,
    title = "Attack Trash",
    description = "Deletes any cell that moves into it, then moves back towards where that cell came from.",
    veer = 2
}, { __index = BaseReactiveTrash })
AttackTrash.__index = AttackTrash

return AttackTrash
