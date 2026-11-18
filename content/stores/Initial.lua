local constants = require("src/constants")

local Initial = {}

local function build(grid)
    local cells = {}

    for _, entry in ipairs(grid.saved.cells) do
        if entry.class.layer == constants.grid.layer then cells[(entry.y - 1) * grid.width + entry.x] = entry end
    end
    return cells
end

function Initial.at(grid, x, y)
    return grid.simulator:store("initial", build)[(y - 1) * grid.width + x]
end

return Initial
