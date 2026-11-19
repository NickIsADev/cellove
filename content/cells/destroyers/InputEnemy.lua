local Enemy = require("content/cells/destroyers/Enemy")

local InputEnemy = setmetatable({
    name = "inputenemy",
    k3 = 915,
    title = "Input Enemy",
    description = "Enemy that is destroyed by clicking it while the simulation is running. Does not need to be defeated to solve a puzzle.",
    categories = { "input", "enemies" },
    hostile = false
}, { __index = Enemy })
InputEnemy.__index = InputEnemy

function InputEnemy:click(button)
    if button ~= 1 then return false end

    self:kill(true)
    return true
end

return InputEnemy
