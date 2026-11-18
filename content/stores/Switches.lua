local Switches = {}

function Switches.build(snapshot)
    local on = {}

    for _, entry in ipairs(snapshot.cells) do
        if entry.class.switch and entry.props.on then on[entry.props.id] = true end
    end
    return on
end

function Switches.on(grid, id)
    return grid.simulator:store(Switches)[id] == true
end

function Switches.flip(grid, id)
    local on = grid.simulator:store(Switches)

    on[id] = not on[id] or nil
    grid:invalidate()
end

return Switches
