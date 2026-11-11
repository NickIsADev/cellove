local BaseReactiveTrash = require("content/cells/abstract/BaseReactiveTrash")

local DirectionalTrash = setmetatable({
    name = "directionaltrash",
    k3 = 463,
    title = "Directional Trash",
    description = "Deletes any cell that moves into it, then moves in the direction it faces."
}, { __index = BaseReactiveTrash })
DirectionalTrash.__index = DirectionalTrash

return DirectionalTrash
