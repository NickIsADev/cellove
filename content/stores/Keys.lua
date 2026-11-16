local Keys = {}

local function build()
    return {}
end

function Keys.held(grid, color)
    return grid.simulator:store("keys", build)[color] == true
end

function Keys.collect(grid, color)
    grid.simulator:store("keys", build)[color] = true
    grid:invalidate()
end

return Keys
