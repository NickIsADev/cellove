local Slicer = require("content/cells/slicers/Slicer")

local Neutrino = setmetatable({
    name = "neutrino",
    k3 = 906,
    title = "Neutrino",
    description = "Moves forward and pushes cells to the side, then pulls them back into place."
}, { __index = Slicer })
Neutrino.__index = Neutrino

function Neutrino:update()
    local x, y, dx, dy = self.x, self.y, self:_aim()

    if self:slice() then self.simulator.movement:staple(x, y, dx, dy, self.bend) end
end

return Neutrino
