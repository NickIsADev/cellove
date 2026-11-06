local BaseRedirector = require("content/cells/abstract/BaseRedirector")

local SuperRedirector = setmetatable({
    name = "superredirector",
    k3 = 1045,
    title = "Super Redirector",
    description = "Turns every cell connected to it to face the same direction as it every tick. Ignores other redirectors.",
    faces = { 0 },
    subtick = { 17 }
}, { __index = BaseRedirector })
SuperRedirector.__index = SuperRedirector

function SuperRedirector:update()
    local grid = self.simulator.grid
    local area = grid:flood(self.x, self.y, function(cell) return cell and not cell.redirector and not cell.anchored end)

    for _, point in ipairs(area) do
        local cell = grid:get(point[1], point[2])
        cell:rotate(self.rotation - cell.rotation)
    end
end

return SuperRedirector
