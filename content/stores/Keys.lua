local Keys = {}

function Keys.build()
    return {}
end

function Keys.held(grid, color)
    return grid.simulator:store(Keys)[color] == true
end

function Keys.collect(grid, color)
    grid.simulator:store(Keys)[color] = true
    grid:invalidate()
end

return Keys
