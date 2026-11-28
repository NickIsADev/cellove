local Generator = require("content/cells/generators/Generator")
local constants = require("src/constants")

local SniperGenerator = setmetatable({
    name = "snipergenerator",
    k3 = 646,
    title = "Sniper Generator",
    description = "Pushes the generated cell forward until it is blocked."
}, { __index = Generator })
SniperGenerator.__index = SniperGenerator

function SniperGenerator:generated(clone, direction)
    local facing = constants.directions[direction]
    if clone then clone:launch(facing[1], facing[2], { force = constants.force.generate }) end
end

return SniperGenerator
