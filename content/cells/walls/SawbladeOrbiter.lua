local Wall = require("content/cells/walls/Wall")
local Audio = require("src/engine/audio/Audio")

local sides = { { 1, 0 }, { 0, 1 }, { -1, 0 }, { 0, -1 } }

local function isBlade(grid, point)
    local cell = grid:get(point[1], point[2])
    return cell and cell.blade
end

local SawbladeOrbiter = setmetatable({
    name = "sawbladeorbiter",
    k3 = 1117,
    title = "Sawblade Orbiter",
    description = "Moves Sawblades around a square path, destroying every cell in their way. Does nothing while the path is blocked by a cell that cannot be destroyed.",
    subtick = { "orbiter" },
    sweep = { x = 1, y = -1 },
    properties = {
        { id = "speed", title = "Speed", default = 1, min = 0, max = 99 },
        { id = "distance", title = "Distance", default = 1, min = 1, max = 99 },
        { id = "reverse", title = "Reverse", default = false }
    }
}, { __index = Wall })
SawbladeOrbiter.__index = SawbladeOrbiter

function SawbladeOrbiter:_path()
    local distance, path = self.props.distance, {}

    for i, side in ipairs(sides) do
        local corner = sides[i % 4 + 1]

        for step = 1, 2 * distance do
            local offset = step - distance
            path[#path + 1] = {
                self.x + side[1] * distance + corner[1] * offset,
                self.y + side[2] * distance + corner[2] * offset
            }
        end
    end
    if not self.props.reverse then return path end

    local reversed = {}
    for i = #path, 1, -1 do
        reversed[#reversed + 1] = path[i]
    end
    return reversed
end

function SawbladeOrbiter:_blocked(path)
    for _, point in ipairs(path) do
        local cell = self.grid:get(point[1], point[2])
        if cell and not cell.blade and not cell:breakable() then return true end
    end
    return false
end

function SawbladeOrbiter:_runs(path)
    local grid, count = self.grid, #path
    local runs, run, start = {}, nil, nil

    for i, point in ipairs(path) do
        if not isBlade(grid, point) then start = i end
    end
    if not start then return { path } end

    for offset = 1, count do
        local point = path[(start + offset - 1) % count + 1]

        if isBlade(grid, point) then
            run = run or {}
            run[#run + 1] = point
        elseif run then
            run[#run + 1] = point
            runs[#runs + 1], run = run, nil
        end
    end
    return runs
end

function SawbladeOrbiter:_orbit(path)
    for _, run in ipairs(self:_runs(path)) do
        local last = run[#run]
        local victim = self.grid:get(last[1], last[2])

        if victim and not victim.blade then
            victim:kill()
            Audio.play("destroy")
        end
        self.simulator.movement:cycle(run)
    end
end

function SawbladeOrbiter:update()
    local path = self:_path()
    if self:_blocked(path) then return end

    for _ = 1, self.props.speed do
        self:_orbit(path)
    end
end

return SawbladeOrbiter
