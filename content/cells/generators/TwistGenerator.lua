local Generator = require("content/cells/generators/Generator")

local TwistGenerator = setmetatable({
    name = "twistgenerator",
    k3 = 40,
    title = "Twist Generator",
    description = "Flips the cell that it generates, across the same axis as the arrow."
}, { __index = Generator })
TwistGenerator.__index = TwistGenerator

function TwistGenerator:generated(clone, _, turn)
    if clone then clone:flip((self.rotation * 2 + turn * 2) % 4, { forced = true }) end
end

return TwistGenerator
