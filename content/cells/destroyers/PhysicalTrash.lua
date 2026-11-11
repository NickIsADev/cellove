local BaseReactiveTrash = require("content/cells/abstract/BaseReactiveTrash")

local PhysicalTrash = setmetatable({
    name = "physicaltrash",
    k3 = 890,
    title = "Physical Trash",
    description = "Deletes any cell that moves into it, then pushes the cell on its other side away.",
    physical = true,
    veer = 0
}, { __index = BaseReactiveTrash })
PhysicalTrash.__index = PhysicalTrash

return PhysicalTrash
