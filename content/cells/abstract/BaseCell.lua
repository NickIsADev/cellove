local Audio = require("src/engine/audio/Audio")
local Properties = require("src/engine/registry/Properties")
local constants = require("src/constants")

local none = {}

local function covers(faces, rotation, directions)
    for _, offset in ipairs(faces) do
        if not directions[(rotation + offset) % 4] then return false end
    end
    return true
end

local function reflect(class, rotation, key)
    local mirrored = {}
    for _, offset in ipairs(class.faces or class.outputs) do
        mirrored[(key - rotation - offset) % 4] = true
    end

    class = class.flipped or class
    local faces = class.faces or class.outputs
    if covers(faces, rotation, mirrored) then return class, rotation end
    for turn = 0, 3 do
        local candidate = (key - rotation + turn) % 4
        if covers(faces, candidate, mirrored) then return class, candidate end
    end
    return class, (key - rotation) % 4
end

local BaseCell = {
    name = "base",
    layer = constants.grid.layer,
    title = "Base",
    description = "",
    hostile = false,
    friendly = false,
    player = false,
    subtick = {},
    outputs = { 0 },
    properties = {},
    guards = {}
}
BaseCell.__index = BaseCell

function BaseCell:new(data)
    assert(self ~= BaseCell, "BaseCell is abstract")
    data = data or {}

    local cell = setmetatable({ rotation = (data.rotation or 0) % 4, turn = 0, props = {} }, self)

    for _, property in ipairs(self.properties) do
        cell.props[property.id] = Properties.value(data.props, property)
    end
    for effect, value in pairs(data.effects or none) do
        cell.effects = cell.effects or {}
        cell.effects[effect] = value
    end
    return cell
end

function BaseCell:_alignment(dx, dy)
    local facing = constants.directions[self.rotation]
    return facing[1] * dx + facing[2] * dy
end

function BaseCell:_side(dx, dy)
    local facing = constants.directions[self.rotation]
    return facing[1] * dy - facing[2] * dx
end

function BaseCell:_face(dx, dy)
    local along, across = self:_alignment(dx, dy), self:_side(dx, dy)
    if along ~= 0 and across ~= 0 then return "corner" end
    if along ~= 0 then return along > 0 and "back" or "front" end
    return across < 0 and "right" or "left"
end

function BaseCell:_aim(dx, dy)
    local facing = constants.directions[self.rotation]
    return dx or facing[1], dy or facing[2]
end

function BaseCell:force(dx, dy, action)
    return 0
end

function BaseCell:strength(dx, dy, action, actor)
    local force = self:force(dx, dy, action)

    for effect, value in pairs(self.effects or none) do
        force = force + effect:force(value, dx, dy, action, actor)
    end
    return force
end

function BaseCell:resist(force)
    return force
end

function BaseCell:imaginary(dx, dy)
    return 0
end

function BaseCell:settled(total)
    return true
end

function BaseCell:driven(dx, dy, action)
    local drive = self.drive
    return drive and drive[action] and self:_alignment(dx, dy) > 0
end

function BaseCell:pushable(dx, dy)
    return not self.fixed
end

function BaseCell:swappable(dx, dy)
    return not self.fixed
end

function BaseCell:rotatable(amount)
    return not self.fixed
end

function BaseCell:eats(dx, dy, action, mover)
    return false
end

function BaseCell:rams(cell, dx, dy, action)
    return false
end

function BaseCell:ram(cell, dx, dy)
end

function BaseCell:bars(dx, dy, action, mover)
    return false
end

function BaseCell:absorb(cell, dx, dy)
end

function BaseCell:bump(dx, dy, pusher)
end

function BaseCell:side()
    return self.team or self.hostile and "hostile" or self.friendly and "friendly" or nil
end

function BaseCell:health()
    return 1
end

function BaseCell:breakable()
    return not (self.fixed or self:guarded("protect"))
end

function BaseCell:hit(damage)
    if self:breakable() then self.grid.simulator.movement:destroy(self, true) end
end

function BaseCell:swapped(dx, dy)
end

function BaseCell:pushed(dx, dy, action)
end

function BaseCell:chained(action, dx, dy, anchor)
end

function BaseCell:click(button)
end

function BaseCell:generatable()
    return true
end

function BaseCell:transformable()
    return self:breakable()
end

function BaseCell:moved()
    local path = self.path
    return path ~= nil and (path[1][1] ~= self.x or path[1][2] ~= self.y)
end

function BaseCell:effect(effect)
    return self.effects and self.effects[effect]
end

function BaseCell:kept()
    local kept

    for effect, value in pairs(self.effects or none) do
        if effect.permanent then
            kept = kept or {}
            kept[effect] = value
        end
    end
    return kept
end

function BaseCell:contents(rotation)
    return { class = getmetatable(self), rotation = rotation or self.rotation, props = self.props, effects = self:kept() }
end

function BaseCell:clinging(dx, dy)
    local cling

    for effect in pairs(self.effects or none) do
        if effect.cling and (not cling or effect.cling < cling.cling) then cling = effect end
    end
    return cling
end

function BaseCell:guarded(guard)
    if self.guards[guard] then return true end

    for effect in pairs(self.effects or none) do
        if effect.guards[guard] then return true end
    end
    return false
end

function BaseCell:generated()
    return getmetatable(self), self.props
end

function BaseCell:divert(dx, dy, reverse, mover)
end

function BaseCell:passed(mover, dx, dy)
end

function BaseCell:rotated(amount, wide)
end

function BaseCell:relay(action, wide)
end

function BaseCell:jump(dx, dy, x, y, reverse)
end

function BaseCell:nudge(dx, dy)
    return self.simulator.movement:nudge(self.x, self.y, self:_aim(dx, dy))
end

function BaseCell:slice(dx, dy)
    dx, dy = self:_aim(dx, dy)
    return self.simulator.movement:slice(self.x, self.y, dx, dy, self.bend)
end

function BaseCell:push(dx, dy, force, options)
    dx, dy = self:_aim(dx, dy)
    return self.simulator.movement:push(self.x, self.y, dx, dy, force, options)
end

function BaseCell:pull(dx, dy, force, row)
    dx, dy = self:_aim(dx, dy)
    return self.simulator.movement:pull(self.x, self.y, dx, dy, force, row)
end

function BaseCell:grab(dx, dy)
    dx, dy = self:_aim(dx, dy)
    return self.simulator.movement:grab(self.x, self.y, dx, dy, self.skew, self.strong)
end

function BaseCell:advance(dx, dy, options)
    dx, dy = self:_aim(dx, dy)
    return self.simulator.movement:advance(self.x, self.y, dx, dy, options)
end

function BaseCell:swap(ax, ay, bx, by, heading)
    return self.simulator.movement:swap(self.x + ax, self.y + ay, self.x + bx, self.y + by, heading)
end

function BaseCell:rotate(amount, forced, quiet, wide)
    if (self.anchored or self:guarded("lock")) and not forced then return false end
    if not self:rotatable(amount) and not forced then return false end

    self.turn = (self.turn or 0) + (amount + 2) % 4 - 2
    self.rotation = (self.rotation + amount) % 4

    for effect, value in pairs(self.effects or none) do
        self.effects[effect] = effect:rotated(value, amount)
    end
    if self.grid then self.grid:touch(self) end
    if not quiet then self:rotated(amount, wide) end
    return true
end

function BaseCell:flip(key, forced)
    if self:guarded("lock") and not forced then return end

    local grid, held = self.grid, self.props.stored
    local class, rotation = reflect(getmetatable(self), self.rotation, key)
    local turned = rotation - self.rotation
    if not self:rotate(turned, forced) then turned = 0 end

    for effect, value in pairs(self.effects or none) do
        self.effects[effect] = effect:flipped(value, key, turned)
    end

    self:become(class)

    if held and held.class then
        local content, turned = reflect(held.class, held.rotation, key)
        self.props.stored = { class = content, rotation = turned, props = held.props }
    end
end

function BaseCell:become(class)
    if class == getmetatable(self) then return end

    local grid = self.grid
    grid:set(self.x, self.y, nil, self.layer)
    setmetatable(self, class)
    grid:set(self.x, self.y, self)
end

function BaseCell:alternate()
    self:become(getmetatable(self).paired)
end

function BaseCell:neighbors(distance, callback)
    self.simulator.grid:neighbors(self.x, self.y, distance, callback)
end

function BaseCell:surrounding(distance, callback)
    self.simulator.grid:surrounding(self.x, self.y, distance, callback)
end

function BaseCell:rotateNeighbors(amount, predicate)
    local grid = self.simulator.grid

    for _, facing in pairs(constants.directions) do
        local x, y = self.x + facing[1], self.y + facing[2]
        local cell = grid:bounds(x, y) and grid:get(x, y)
        if cell and (not predicate or predicate(cell)) then cell:rotate(amount) end
    end
end

function BaseCell:kill(exploded)
    local sim = self.grid.simulator

    sim.grid:set(self.x, self.y, nil, self.layer)
    self.exploded = exploded
    self.path = { { self.x, self.y }, { self.x, self.y } }
    sim.dying[#sim.dying + 1] = self
end

function BaseCell:generate(direction, options)
    local facing = constants.directions[direction or self.rotation]
    return self.simulator.movement:generate(self.x, self.y, facing[1], facing[2], options)
end

function BaseCell:fire(class, direction)
    direction = direction or self.rotation
    local facing = constants.directions[direction]
    Audio.play("shoot")
    return self.simulator.movement:fire(self.x, self.y, facing[1], facing[2], class:new({ rotation = direction }))
end

function BaseCell:repel(direction, force, row)
    local facing = constants.directions[direction]
    return self.simulator.movement:repel(self.x, self.y, facing[1], facing[2], force, row)
end

function BaseCell:look(direction, reverse)
    local facing = constants.directions[direction]
    return self.simulator.movement:look(self.x, self.y, facing[1], facing[2], reverse)
end

function BaseCell:transform(direction, cell)
    local facing = constants.directions[direction]
    return self.simulator.movement:transform(self.x, self.y, facing[1], facing[2], cell)
end

function BaseCell:update(subtick, direction)
end

function BaseCell:preview(props)
    return self.texture
end

function BaseCell:sprite()
    return self:preview(self.props)
end

function BaseCell:draw(renderer, x, y, angle, scale, offset)
    renderer:drawSprite(self:sprite(), x, y, angle, scale, offset)
end

return BaseCell
