local BaseCell = require("content/cells/abstract/BaseCell")
local utils = require("src/utils")

local Impeder = setmetatable({
    name = "impeder",
    k3 = 638,
    title = "Impeder",
    description = "Blocks force applied to its front. Force applied from any other side rotates it to face that side first.",
    categories = { "weights" }
}, { __index = BaseCell })
Impeder.__index = Impeder

function Impeder:resist(force, dx, dy)
    if self:_face(dx, dy) == "front" then return 0 end

    self:rotate(utils.direction(-dx, -dy) - self.rotation)
    return force
end

return Impeder
