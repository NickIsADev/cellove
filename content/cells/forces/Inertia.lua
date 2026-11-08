local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")

local function axis(dx)
    return dx ~= 0 and "x" or "y"
end

local Inertia = setmetatable({
    name = "inertia",
    title = "Inertia",
    description = "Keeps moving in the direction it was last pushed. Loses its momentum when it can't move. Adds 1 unit of force to anything pushing it.",
    faces = {},
    categories = { "forces" },
    subtick = { 21 },
    directional = true,
    outputs = { 0, 1, 2, 3 }
}, { __index = BaseCell })
Inertia.__index = Inertia

function Inertia:new(data)
    local cell = BaseCell.new(self, data)
    cell.momentum = { x = 0, y = 0 }

    return cell
end

function Inertia:force(_, _, action)
    return action == "push" and constants.force.strength or 0
end

function Inertia:pushed(dx, dy)
    self.momentum[axis(dx)] = dx + dy
end

function Inertia:update(_, direction)
    local dx, dy = unpack(constants.directions[direction])

    if self.momentum[axis(dx)] == dx + dy and not self:push(dx, dy) then
        self.momentum[axis(dx)] = 0
    end
end

return Inertia
