local constants = require("src/constants")

local Initial = {}

function Initial.build(snapshot)
    local cells = {}

    for _, entry in ipairs(snapshot.cells) do
        if entry.class.layer == constants.grid.layer then cells[(entry.y - 1) * snapshot.width + entry.x] = entry end
    end
    return cells
end

function Initial.at(grid, x, y)
    return grid.simulator:store(Initial)[(y - 1) * grid.width + x]
end

return Initial
