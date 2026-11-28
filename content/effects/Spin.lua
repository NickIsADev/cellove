local BaseEffect = require("content/effects/abstract/BaseEffect")
local utils = require("src/utils")

local turns = { cw = 1, ccw = -1, half = 2 }
local axes = { [0] = "horizontal", "diagonal_down", "vertical", "diagonal_up" }
local opposite = { cw = "ccw", ccw = "cw" }

local Spin = setmetatable({
    name = "spin",
    permanent = true,
    subtick = { "perpetual" }
}, { __index = BaseEffect })
Spin.__index = Spin

function Spin:update(cell, value)
    if type(value) == "number" then return cell:flip(value, { forced = true }) end
    cell:rotate(turns[value] or utils.randomSign(), { forced = true })
end

function Spin:rotated(value, amount)
    return type(value) == "number" and (value + amount * 2) % 4 or value
end

function Spin:flipped(value, key, turned)
    if type(value) == "number" then return (key * 2 - value + turned * 2) % 4 end
    return opposite[value] or value
end

function Spin:texture(value)
    return self.name .. "_" .. (type(value) == "number" and "flip_" .. axes[value] or value)
end

return Spin
