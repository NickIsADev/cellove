local BaseReactiveTrash = require("content/cells/abstract/BaseReactiveTrash")

local DodgeTrash = setmetatable({
    name = "dodgetrash",
    k3 = 438,
    title = "Dodge Trash",
    description = "Deletes any cell that moves into it, then moves to the left of the direction that cell was moving.",
    veer = 3
}, { __index = BaseReactiveTrash })
DodgeTrash.__index = DodgeTrash

return DodgeTrash
