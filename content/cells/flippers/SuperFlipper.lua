local BaseFlipper = require("content/cells/abstract/BaseFlipper")
local utils = require("src/utils")

local function free(cell)
    return cell and not cell.anchored and not cell:guarded("lock")
end

local SuperFlipper = setmetatable({
    name = "superflipper",
    k3 = 641,
    title = "Super Flipper",
    description = "Flips every cell connected to it along the direction it faces every tick.",
    subtick = { "superFlipper" }
}, { __index = BaseFlipper })
SuperFlipper.__index = SuperFlipper

function SuperFlipper:update()
    local grid, key = self.simulator.grid, utils.flip(self.rotation, self.axis)
    local area = grid:flood(self.x, self.y, free)

    for _, point in ipairs(area) do
        local cell = grid:get(point[1], point[2])
        if cell ~= self then cell:flip(key) end
    end
end

return SuperFlipper
