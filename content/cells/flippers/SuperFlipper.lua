local Flipper = require("content/cells/flippers/Flipper")
local utils = require("src/utils")

local SuperFlipper = setmetatable({
    name = "superflipper",
    k3 = 641,
    title = "Super Flipper",
    description = "Flips every cell connected to it every tick.",
    subtick = { "superFlipper" }
}, { __index = Flipper })
SuperFlipper.__index = SuperFlipper

function SuperFlipper:update()
    local grid, key = self.grid, utils.flip(self.rotation, self.axis)
    local area = grid:flood(self.x, self.y, function(cell) return cell and not cell.anchored end)

    for _, point in ipairs(area) do
        grid:get(point[1], point[2]):flip(key)
    end
end

return SuperFlipper
