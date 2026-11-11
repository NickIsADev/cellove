local BaseReactiveTrash = require("content/cells/abstract/BaseReactiveTrash")

local JumpTrash = setmetatable({
    name = "jumptrash",
    k3 = 347,
    title = "Jump Trash",
    description = "Deletes any cell that moves into it, then moves in the direction that cell was moving.",
    veer = 0
}, { __index = BaseReactiveTrash })
JumpTrash.__index = JumpTrash

return JumpTrash
