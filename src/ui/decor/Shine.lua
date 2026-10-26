local constants = require("src/constants")

local config = constants.ui.shine

local shader = love.graphics.newShader(config.shader)
shader:send("width", config.width)
shader:send("span", 1 + config.width * 2 + config.gap)
shader:send("strength", config.strength)

local Shine = {}

function Shine.set(active)
    if active then shader:send("time", love.timer.getTime() * config.speed) end
    love.graphics.setShader(active and shader or nil)
end

return Shine
