local Staller = require("content/cells/walls/Staller")

local BulkEnemy = setmetatable({
    name = "bulkenemy",
    k3 = 163,
    title = "Bulk Enemy",
    description = "Blocks pushes like a Wall, but explodes when pushed into, taking the cell that pushed it along.",
    categories = { "enemies" },
    hostile = true
}, { __index = Staller })
BulkEnemy.__index = BulkEnemy

function BulkEnemy:bump(_, _, pusher)
    if pusher then self:_destroy(pusher) end
    Staller.bump(self)
end

return BulkEnemy
