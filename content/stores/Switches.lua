local Switches = {}

local function build(grid)
    local on = {}

    for index = 1, grid.width * grid.height do
        local cell = grid.cells[index]
        if cell and cell.switch and cell.props.on then on[cell.props.id] = true end
    end
    return on
end

function Switches.on(grid, id)
    return grid.simulator:store("switches", build)[id] == true
end

function Switches.flip(grid, id)
    local on = grid.simulator:store("switches", build)

    on[id] = not on[id] or nil
    grid:invalidate()
end

return Switches
