local BaseForker = require("content/cells/abstract/BaseForker")

local Triforker = setmetatable({
    name = "triforker",
    k3 = 49,
    title = "Triforker",
    description = "Clones cells entering from behind out the front and both sides, turning the ones that go out the sides.",
    forks = { [2] = { -1, 1, 0 } },
    reverse = { [0] = 0, [1] = -1, [3] = 1 },
    rotates = true
}, { __index = BaseForker })
Triforker.__index = Triforker

return Triforker
