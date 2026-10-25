local constants = require("src/constants")

local config = constants.puzzles

local function byOrder(a, b)
    if a.namespace ~= b.namespace then return (a.namespace or "") < (b.namespace or "") end
    if a.order ~= b.order then return a.order < b.order end
    return a.name:lower() < b.name:lower()
end

local Puzzles = {}
Puzzles.__index = Puzzles

function Puzzles.new(data)
    local self = setmetatable({}, Puzzles)
    self.contraptions = data.contraptions
    self.items = {}
    self.byId = {}

    self:load(config.root)
    data.mods:each(function(mod)
        self:load(mod.root .. "/" .. constants.mods.puzzles, mod.id)
    end)
    table.sort(self.items, byOrder)
    for index, puzzle in ipairs(self.items) do
        puzzle.number = index
    end
    return self
end

function Puzzles:_load(path, id, namespace)
    local info = require(path .. "/" .. config.info)
    assert(info.name, path .. " must define a name")
    local difficulty = info.difficulty or "unknown"
    assert(config.difficulties[difficulty], path .. " has an invalid difficulty: " .. difficulty)
    assert(type(info.order) == "number", path .. " must define a numeric order")

    local data, err = self.contraptions:import(love.filesystem.read(path .. "/" .. config.data))
    assert(data, path .. ": " .. tostring(err))

    local puzzle = {
        id = id,
        namespace = namespace,
        name = info.name,
        description = info.description or "",
        tip = info.tip or "",
        difficulty = difficulty,
        order = info.order,
        data = data
    }
    self.items[#self.items + 1] = puzzle
    self.byId[id] = puzzle
end

function Puzzles:load(root, namespace)
    for _, folder in ipairs(love.filesystem.getDirectoryItems(root)) do
        local path = root .. "/" .. folder
        if love.filesystem.getInfo(path, "directory") then
            self:_load(path, namespace and namespace .. ":" .. folder or folder, namespace)
        end
    end
end

function Puzzles:list()
    return self.items
end

function Puzzles:get(id)
    return self.byId[id]
end

function Puzzles:after(id)
    for index, puzzle in ipairs(self.items) do
        if puzzle.id == id then return self.items[index + 1] end
    end
end

return Puzzles
