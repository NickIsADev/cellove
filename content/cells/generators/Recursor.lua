local BaseCell = require("content/cells/abstract/BaseCell")
local Pushable = require("content/cells/pushables/Pushable")
local constants = require("src/constants")

local Recursor = setmetatable({
    name = "recursor",
    k3 = 412,
    title = "Recursor",
    description = "At recursion 0, it generates Pushables. At any higher level, it generates itself with a lower recursion.",
    categories = { "othergenerators" },
    subtick = { "recursor" },
    directional = true,
    properties = {
        { id = "recursion", title = "Recursion", default = 0, min = 0, max = 99 }
    }
}, { __index = BaseCell })
Recursor.__index = Recursor

function Recursor:update()
    local recursion = self.props.recursion
    local clone = recursion > 0
        and Recursor:new({ rotation = self.rotation, props = { recursion = recursion - 1 } })
        or Pushable:new({ rotation = self.rotation })

    local facing = constants.directions[self.rotation]
    self.simulator.movement:release(self.x, self.y, facing[1], facing[2], clone, { mode = "keep" })
end

function Recursor:draw(renderer, ...)
    BaseCell.draw(self, renderer, ...)
    renderer:drawTag(self.props.recursion, ...)
end

return Recursor
