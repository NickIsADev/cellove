local Pushable = require("content/cells/pushables/Pushable")

local Bar = setmetatable({
    name = "bar",
    k3 = 207,
    title = "Bar",
    description = "Pushable that attempts to grab the cells at both of its ends when pushed or pulled sideways.",
    categories = { "sticky" },
    faces = { 0, 2 }
}, { __index = Pushable })
Bar.__index = Bar

function Bar:pushed(dx, dy, action)
    if action == "grab" or self:_along(dx, dy) ~= 0 then return end

    local x, y, movement = self.x, self.y, self.simulator.movement
    movement:defer(function() movement:flank(x, y, dx, dy) end)
end

return Bar
