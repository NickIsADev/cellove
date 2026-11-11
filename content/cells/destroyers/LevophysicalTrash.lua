local BaseReactiveTrash = require("content/cells/abstract/BaseReactiveTrash")

local LevophysicalTrash = setmetatable({
    name = "levophysicaltrash",
    k3 = 894,
    title = "Levophysical Trash",
    description = "Deletes any cell that moves into it, then pushes the cell on its left away.",
    physical = true,
    veer = 3
}, { __index = BaseReactiveTrash })
LevophysicalTrash.__index = LevophysicalTrash

return LevophysicalTrash
