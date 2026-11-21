local Keys = {
    names = { "red", "orange", "yellow", "green", "cyan", "blue", "purple", "magenta" },
    colors = { 0xA44643, 0xA46643, 0xA48743, 0x47A342, 0x4288A3, 0x4247A3, 0x8743A4, 0xA34277 }
}

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
