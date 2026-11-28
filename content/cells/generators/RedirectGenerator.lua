local Generator = require("content/cells/generators/Generator")

local RedirectGenerator = setmetatable({
    name = "redirectgenerator",
    k3 = 113,
    title = "Redirect Generator",
    description = "Rotates the generated cell so it faces the same way as itself."
}, { __index = Generator })
RedirectGenerator.__index = RedirectGenerator

function RedirectGenerator:generated(clone, direction)
    if clone then clone:rotate(direction - clone.rotation, { forced = true, quiet = true }) end
end

return RedirectGenerator
