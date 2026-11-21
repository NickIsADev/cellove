local BaseCell = require("content/cells/abstract/BaseCell")
local utils = require("src/utils")

local Portal = setmetatable({
    name = "portal",
    k3 = 221,
    title = "Portal",
    description = "Sends cells into a random Portal whose ID matches its Target ID. Cells pulled through go the other way.",
    categories = { "wraps" },
    guards = { protect = true },
    properties = {
        { id = "id", title = "ID", default = 0, min = 0, max = 99 },
        { id = "target", title = "Target ID", default = 0, min = 0, max = 99 }
    }
}, { __index = BaseCell })
Portal.__index = Portal

function Portal:_exits(reverse)
    local grid, exits = self.grid, {}

    for index = 1, grid.width * grid.height do
        local cell = grid.cells[index]
        if cell and cell.lookup.jump and cell.props.id and (reverse and cell.props.target == self.props.id
            or not reverse and cell.props.id == self.props.target) then
            exits[#exits + 1] = cell
        end
    end
    return exits
end

function Portal:jump(dx, dy, x, y, reverse)
    local exits = self:_exits(reverse)
    local exit = #exits > 0 and exits[math.random(#exits)] or self

    local change = exit.rotation - self.rotation
    local nx, ny = utils.turn(dx, dy, change)
    return exit.x, exit.y, nx, ny, change
end

function Portal:draw(renderer, ...)
    BaseCell.draw(self, renderer, ...)
    renderer:drawLabel(self.props.id .. "\n" .. self.props.target, ...)
end

return Portal
