local Mover = require("content/cells/movers/Mover")
local constants = require("src/constants")

local Bird = setmetatable({
    name = "bird",
    title = "Bird",
    description = "Flies like a bird in a zig-zag pattern when moving horizontally, straight when moving vertically, and pushes whatever is in its way. When blocked, it turns clockwise.",
}, { __index = Mover })
Bird.__index = Bird

function Bird:new(data)
    local cell = Mover.new(self, data)
    cell.step = 0

    return cell
end

function Bird:update()
    local dx, dy = unpack(constants.directions[self.rotation])
    local sidestep = self.rotation % 2 == 0 and self.step % 2 == 1

    if sidestep then
        local side = 2 - self.step
        dx, dy = -dy * side, dx * side
    end

    if self:push(dx, dy, sidestep and constants.force.strength) then
        self.step = (self.step + 1) % 4
    else
        self:rotate(1)
        self.step = 0
    end
end

return Bird
