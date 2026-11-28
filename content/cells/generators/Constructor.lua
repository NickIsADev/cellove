local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")

local Constructor = setmetatable({
    name = "constructor",
    k3 = 229,
    title = "Constructor",
    description = "Clones any cell pushed into its back and pushes the clone out the front. Cannot be pushed, rotated, or destroyed.",
    categories = { "walls", "builders" },
    fixed = true,
    anchored = true
}, { __index = BaseCell })
Constructor.__index = Constructor

function Constructor:bumped(dx, dy, pusher)
    if not (pusher and pusher:cloneable() and self:_along(dx, dy) > 0) then return end

    local class, props, rotation = pusher:template()
    if not class then return end

    local clone = class:new({ rotation = rotation or pusher.rotation, props = props, effects = pusher:permanent() })
    local facing = constants.directions[self.rotation]

    self.simulator.movement:defer(function()
        self.simulator.movement:release(self.x, self.y, facing[1], facing[2], clone)
    end)
end

return Constructor
