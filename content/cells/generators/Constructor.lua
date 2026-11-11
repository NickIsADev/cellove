local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")

local Constructor = setmetatable({
    name = "constructor",
    k3 = 229,
    title = "Constructor",
    description = "Clones any cell pushed into its back and pushes the clone out the front. Cannot be pushed, rotated, or destroyed.",
    categories = { "generators" },
    fixed = true,
    anchored = true
}, { __index = BaseCell })
Constructor.__index = Constructor

function Constructor:bump(dx, dy, pusher)
    if not (pusher and pusher:generatable() and self:_alignment(dx, dy) > 0) then return end

    local class, props, rotation = pusher:generated()
    if not class then return end

    local clone = class:new({ rotation = rotation or pusher.rotation, props = props })
    local facing = constants.directions[self.rotation]

    self.simulator.movement:defer(function()
        self.simulator.movement:release(self.x, self.y, facing[1], facing[2], clone)
    end)
end

return Constructor
