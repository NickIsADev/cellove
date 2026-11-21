local BaseDiverger = require("content/cells/abstract/BaseDiverger")
local utils = require("src/utils")

local names = {
    [0] = "Rotate CW",
    "Rotate CCW",
    "Rotate 180",
    "Flip Vertical",
    "Flip Horizontal",
    "Flip Diagonal",
    "Flip Anti-Diagonal",
    "Random",
    "Face Right",
    "Face Down",
    "Face Left",
    "Face Up"
}

local textures = {
    [0] = "cw",
    "ccw",
    "180",
    "flip_vertical",
    "flip_horizontal",
    "flip_diagonal",
    "flip_antidiagonal",
    "rng",
    "right",
    "down",
    "left",
    "up"
}

local turns = { [0] = 1, [1] = -1, [2] = 2 }
local shifts = { [3] = 2, [4] = 0, [5] = 3, [6] = 1 }

local RotatorDiverger = setmetatable({
    name = "rotatordiverger",
    k3 = 488,
    title = "Rotator Diverger",
    description = "Rotates or flips cells that pass straight through it along its axis.",
    faces = { 0, 2 },
    routes = { [0] = 0, [2] = 0 },
    properties = {
        { id = "mode", title = "Mode", default = 0, min = 0, max = #names, names = names, icons = true }
    }
}, { __index = BaseDiverger })
RotatorDiverger.__index = RotatorDiverger

function RotatorDiverger:_spin(mover)
    local mode = self.props.mode
    if turns[mode] then return turns[mode] end
    if mode == 7 then return utils.randomSign() end
    if mode > 7 then return (self.rotation + mode - 8 - mover.rotation) % 4 end
    return 0
end

function RotatorDiverger:divert(dx, dy, reverse, mover)
    local nx, ny = BaseDiverger.divert(self, dx, dy, reverse)
    if nx then return nx, ny, reverse and -self:_spin(mover) or self:_spin(mover) end
end

function RotatorDiverger:preview(props)
    return self.texture .. "_" .. textures[props.mode]
end

function RotatorDiverger:passed(mover)
    local shift = shifts[self.props.mode]
    if not shift then return end

    self.grid.simulator.movement:defer(function()
        mover:flip((self.rotation * 2 + shift) % 4, true)
    end)
end

return RotatorDiverger
