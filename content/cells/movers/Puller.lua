local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")

local Puller = setmetatable({
    name = "puller",
    k3 = 14,
    title = "Puller",
    description = "Moves forward into empty space, pulling everything behind it. Cannot push.",
    categories = { "pullers" },
    subtick = { "puller" },
    drive = { push = true, pull = true, grab = true },
    directional = true
}, { __index = BaseCell })
Puller.__index = Puller

function Puller:force(dx, dy, action)
    if action ~= "pull" then return 0 end
    return self:_alignment(dx, dy) * constants.force.strength
end

function Puller:update()
    self:pull()
end

return Puller
