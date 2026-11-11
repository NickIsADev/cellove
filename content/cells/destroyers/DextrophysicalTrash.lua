local BaseReactiveTrash = require("content/cells/abstract/BaseReactiveTrash")

local DextrophysicalTrash = setmetatable({
    name = "dextrophysicaltrash",
    k3 = 892,
    title = "Dextrophysical Trash",
    description = "Deletes any cell that moves into it, then pushes the cell on its right away.",
    physical = true,
    veer = 1
}, { __index = BaseReactiveTrash })
DextrophysicalTrash.__index = DextrophysicalTrash

return DextrophysicalTrash
