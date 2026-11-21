Every cell inherits from `BaseCell` (`content/cells/abstract/BaseCell`). It cannot be instantiated directly.

```lua
local BaseCell = require("content/cells/abstract/BaseCell")

local Thing = setmetatable({ name = "thing" }, { __index = BaseCell })
Thing.__index = Thing
```

## Contents

- [Class fields](#class-fields): set on the class
- [Instance fields](#instance-fields): available on `self`
- [Behavior](#behavior): override to define how a cell acts
- [Actions](#actions): call from your own methods

## Class fields

Set these in the table you pass to `setmetatable`.

| field | type | default | description |
| --- | --- | --- | --- |
| `name` | `string` | | required, lowercase letters, digits and `_`. must be set on the class itself |
| `title` | `string` | `"Base"` | name in the library |
| `description` | `string` | `""` | description in the library |
| `categories` | `table` | | required, list of [category IDs](Creating-Cells#categories) |
| `k3` | `number` or `string` | | the cell's ID in CelLua or BHMod, used by the K3 format. must be set on the class itself. a contraption with a cell that has none is exported in the other format |
| `properties` | `table` | `{}` | [property definitions](Creating-Cells#properties) |
| `subtick` | `table` | `{}` | subticks `update` runs in, as names or numbers. names come from the built-in order, like `"mover"`. lower runs first and cells sharing a subtick run together. only the order matters, so a decimal like `34.5` runs between movers (`34`) and nudgers (`35`). see [built-in subticks](Creating-Cells#subticks). empty means never |
| `directional` | `boolean` | | calls `update` once per entry in `outputs` |
| `outputs` | `table` | `{ 0 }` | output directions relative to rotation: `0` forward, `1` right, `2` back, `3` left |
| `drive` | `table` | | actions that move the cell forward, like `{ push = true, pull = true }`. a cell moved that way skips its update that tick |
| `sweep` | `table` | | scans the subtick row by row (or column by column) instead of by facing, as `{ x = 1, y = -1 }`. `x` and `y` are `1` or `-1`, and `columns = true` makes `x` the outer loop. a directional cell maps each of its subticks to a table that maps a pass direction to one of these |
| `rear` | `boolean` | | scans from the back of the pass direction instead of the front |
| `skew` | `number` | `0` | where [`grab`](#basecellgrabdx-dy) drags cells from: `0` the sides, `1` the front diagonals, `-1` the back diagonals |
| `hostile` | `boolean` | `false` | counts as an enemy. a puzzle is solved when none remain |
| `friendly` | `boolean` | `false` | counts as an ally. a puzzle is failed when fewer remain than there were at the start |
| `team` | `string` | | `"hostile"` or `"friendly"`: the side sentries and seekers take for this cell. defaults to `"hostile"` for `hostile` cells and `"friendly"` for `friendly` ones. unlike those flags it does not affect puzzles |
| `player` | `boolean` | `false` | counts as a player. a puzzle is failed when none remain, unless no enemies do either |
| `layer` | `string` | `"foreground"` | the [layer](Layers) the cell lives on: `"background"`, `"foreground"` or `"overlay"` |
| `tile` | `string` | | the marker kind this library item paints instead of placing a cell, like `"placeable"`. Such an item is never put on the grid, so it has no behavior |
| `pair` | `string` | | the name of the cell [`alternate`](#basecellalternate) turns this one into, like a door's gate |
| `outcome` | `string` | | `"win"` or `"lose"`. a puzzle is won (or lost) when every foreground cell sharing a [`group`](#basecellgroup) is [`lit`](#basecelllit), for any group |
| `fixed` | `boolean` | | cannot be pushed, swapped or transformed |
| `hollow` | `boolean` | | sentries and seekers see through it as if the tile were empty, like a coin |
| `destroys` | `boolean` | | cells moving into it are destroyed unless protected by an effect |
| `freezes` | `boolean` | | keeps updating while frozen, like freezers do |
| `anchored` | `boolean` | | cannot be rotated |
| `guards` | `table` | `{}` | actions the cell refuses, like `{ push = true }`. checked by [`guarded`](#basecellguardedguard-dx-dy). guards come from effects too |
| `faces` | `table` | `outputs` | directions relative to rotation that flip gears mirror, in the same format as `outputs`. `{}` keeps the rotation when flipped |
| `twin` | `string` | | the name of the cell this one becomes when flipped by a flip gear, such as a clockwise gear's counter-clockwise twin. cells that look the same mirrored don't need one |

```lua
local Mover = setmetatable({
    name = "mover",
    title = "Mover",
    description = "Moves forward every tick.",
    categories = { "movers" },
    subtick = { "mover" },
    drive = { push = true, pull = true },
    directional = true
}, { __index = BaseCell })
```

## Instance fields

| field | type | description |
| --- | --- | --- |
| `rotation` | `number` | `0` right, `1` down, `2` left, `3` up |
| `props` | `table` | property values by ID |
| `x`, `y` | `number` | grid position |
| `effects` | `table` | active effects and their values, keyed by effect class like `Frozen` or `Armored`. `nil` when there are none |
| `simulator` | `Simulator` | set while the cell updates |
| `spark` | `string` | name of a spark kind from `constants.graphics.spark.kinds` to burst when the cell is next drawn. [layered](Layers) cells and cells that were just killed play it once |

```lua
function Thing:update()
    print(self.x, self.y, self.rotation, self.props.range)
end
```

## Behavior

Override these to define how a cell acts. Each one has a default, so only override what you need.

| method | default | description |
| --- | --- | --- |
| [`update`](#basecellupdatesubtick-direction) | nothing | runs during the cell's subticks |
| [`pushable`](#basecellpushabledx-dy-bare-action) | `true` | whether the cell can be pushed |
| [`eats`](#basecelleatsdx-dy-action-mover) | `false` | whether cells moving into this one are deleted |
| [`bars`](#basecellbarsdx-dy-action-mover) | `false` | whether this cell stops cells from moving onto its tile, for [layered](Layers) cells |
| [`click`](#basecellclickbutton) | `false` | called when the tile is clicked while the simulation runs |
| [`tint`](#basecelltint) | nothing | color the sprite is drawn in |
| [`group`](#basecellgroup) and [`lit`](#basecelllit) | | what an `outcome` cell reports |
| [`absorb`](#basecellabsorbcell-dx-dy-action) | nothing | called after this cell eats a cell |
| [`bump`](#basecellbumpdx-dy-pusher) | nothing | called when a push runs into this cell and it blocks or eats it |
| [`swapped`](#basecellswappeddx-dy) | nothing | called after a swap carried this cell to the other cell's place |
| [`pushed`](#basecellpusheddx-dy-action) | nothing | called after a push, pull or grab moved this cell |
| [`side`](#basecellside) | the `team` | which side sentries and seekers see this cell on |
| [`health`](#basecellhealth) | `1` | how much damage the cell takes to destroy |
| [`breakable`](#basecellbreakable) | not `fixed` or protected | whether collisions and explosions can destroy the cell |
| [`hit`](#basecellhitdamage) | destroys a breakable cell | called when a collision or an explosion damages this cell |
| [`generatable`](#basecellgeneratable) | `true` | whether generators can copy the cell |
| [`generated`](#basecellgenerated) | the same class and props | what a generator's copy of the cell becomes |
| [`force`](#basecellforcedx-dy-action) | `0` | force added to a push or pull |
| [`resist`](#basecellresistforce-dx-dy) | the same force | changes the force that is left after this cell |
| [`imaginary`](#basecellimaginarydx-dy) | `0` | imaginary force this cell adds to the line it moves in |
| [`settled`](#basecellsettledtotal) | `true` | whether the line is allowed to move for its imaginary force |
| [`guarded`](#basecellguardedguard-dx-dy) | whether `guards` has the action | whether the cell refuses an action |
| [`chained`](#basecellchainedaction-dx-dy-anchor) | nothing | called when a push, pull or grab reaches the cell, even if it fails |
| [`clinging`](#basecellclingingdx-dy) | the cell's stickiest effect | what the cell sticks to on one side |
| [`divert`](#basecelldivertdx-dy-reverse) | nothing | bends the path of a move passing through |
| [`jump`](#basecelljumpdx-dy-x-y) | nothing | moves the path of a move passing through somewhere else |
| [`preview`](#basecellpreviewprops) | `self.texture` | name of the texture a cell with these properties looks like |
| [`sprite`](#basecellsprite) | `self:preview(self.props)` | name of the texture `draw` uses |
| [`draw`](#basecelldrawrenderer-x-y-angle-scale-offset) | default sprite | draws the cell |

### `BaseCell:update(subtick, direction)`

Runs during the cell's `subtick`s. Directional cells run once per output, with that output's direction.

| parameter | type | description |
| --- | --- | --- |
| `subtick` | `number` | the subtick being run |
| `direction` | `number` | direction of the current output |

```lua
function Eraser:update(subtick, direction)
    self:neighbors(1, function(cell)
        if cell then cell:kill() end
    end)
end
```

### `BaseCell:pushable(dx, dy, bare, action)`

Whether the cell can be moved by a push, pull or grab. Default `true`, or `false` for a `fixed` cell.

| parameter | type | description |
| --- | --- | --- |
| `dx` | `number` | horizontal push direction: `-1`, `0` or `1` |
| `dy` | `number` | vertical push direction: `-1`, `0` or `1` |
| `bare` | `boolean` | the cell is first in a push that has no pusher, like a Repulsor's |
| `action` | `"push"\|"pull"\|"grab"?` | what is moving the cell, `nil` for other moves |

**Returns** `boolean`

```lua
-- can only be pushed left and right
function Rail:pushable(dx, dy)
    return dy == 0
end
```

### `BaseCell:eats(dx, dy, action, mover)`

Whether cells moving into this one are deleted. Default `false`. A [layered](Layers) cell can eat too: the mover is deleted before it reaches whatever is in the foreground.

| parameter | type | description |
| --- | --- | --- |
| `dx` | `number` | horizontal direction the other cell is moving |
| `dy` | `number` | vertical direction the other cell is moving |
| `action` | `string?` | how the other cell arrives: `nil` when pushed, `"pull"` when a puller or nudger moves itself in, `"swap"` when it swaps places with this cell. a Storage or Converter accepts the last two even when it cannot eject what it holds |

| `mover` | `BaseCell?` | the cell moving in, `nil` when it is not known |

**Returns** `boolean`

```lua
function Trash:eats()
    return true
end

-- only lets keys in
function Door:eats(dx, dy, action, mover)
    return mover ~= nil and mover.key == "door"
end
```

### `BaseCell:bars(dx, dy, action, mover)`

Whether this cell stops `mover` from moving onto its tile. Only [layered](Layers) cells are asked. Pushes, pulls, swaps and generators all respect it, and a push that would enter a barred tile is blocked as a whole.

| parameter | type | description |
| --- | --- | --- |
| `dx` | `number` | horizontal direction the mover is moving |
| `dy` | `number` | vertical direction the mover is moving |
| `action` | `string?` | how it arrives, as in [`eats`](#basecelleatsdx-dy-action-mover), or `"generate"` for a generator's copy |
| `mover` | `BaseCell?` | the cell moving in, `nil` for a probe |

**Returns** `boolean`

```lua
-- a one way tile that only lets cells in from the left
function OneWay:bars(dx)
    return dx ~= 1
end
```

### `BaseCell:click(button)`

Called when the tile is clicked while the simulation has started. [Layers](Layers) are asked from the top down and the first cell to return `true` takes the click.

| parameter | type | description |
| --- | --- | --- |
| `button` | `number` | mouse button, `1` is left |

**Returns** `boolean`

### `BaseCell:preview(props)`

Optional. Returns the texture name for a cell with the given `props`. The editor calls it on the class, before any cell exists, for the placement preview. [`sprite`](#basecellsprite) uses it for placed cells, so a cell whose sprite only depends on its properties only needs this one.

```lua
function Gem:preview(props)
    return self.texture .. "_" .. names[props.color]
end
```

### `BaseCell:sprite()`

Optional. Returns the texture name to draw, so a cell can change its sprite without overriding `draw`. Override it for sprites that depend on the cell's state, and `preview` for the look it starts with. The library icon always uses `self.texture`.

```lua
function Lamp:sprite()
    return self.lit and self.texture .. "_on" or self.texture
end
```

### `BaseCell:tint()`

Optional. Define it to draw the sprite in a color, as a hex number. Effects such as paint take priority.

```lua
function Gem:tint()
    return colors[self.props.color]
end
```

### `BaseCell:group()`

For `outcome` cells, the group the cell belongs to. Cells with the same group are judged together.

### `BaseCell:lit()`

For `outcome` cells, whether the cell is enabled. An `outcome` is reached when every cell of one group is lit.

### `BaseCell:absorb(cell, dx, dy, action)`

Called after this cell eats `cell`. Return `true` to let `cell` survive and take the eaten cell's place instead, like a coin being collected.

| parameter | type | description |
| --- | --- | --- |
| `cell` | `BaseCell` | the cell that was eaten |
| `dx` | `number` | horizontal direction it was moving |
| `dy` | `number` | vertical direction it was moving |
| `action` | `string?` | how it arrived, as in [`eats`](#basecelleatsdx-dy-action) |

```lua
function Counter:absorb(cell)
    print("ate a " .. cell.name)
end
```

### `BaseCell:bump(dx, dy, pusher)`

Called when a push runs into this cell and it blocks or eats the push instead of moving. Storage uses it to release its content, and Spinners use it to turn the pusher.

| parameter | type | description |
| --- | --- | --- |
| `dx` | `number` | horizontal direction of the push |
| `dy` | `number` | vertical direction of the push |
| `pusher` | `BaseCell?` | the cell that ran into this one, or `nil` when the push came from a force like a Repulsor or a generator |

```lua
function Storage:bump(dx, dy)
    self:_hold({})
end
```

### `BaseCell:swapped(dx, dy)`

Called after a mirror swap carried this cell onto the other cell's place, with the direction it counts as moving. A curved mirror counts its cells as moving straight toward the other cell's side, not along the diagonal they travel. CelLua handles that cell as if it had swapped with itself, so gates are fed from the side it moved in and storages store themselves.

| parameter | type | description |
| --- | --- | --- |
| `dx` | `number` | horizontal direction it moved |
| `dy` | `number` | vertical direction it moved |

```lua
function BaseGate:swapped(dx, dy)
    if self:eats(dx, dy) then self:absorb(self, dx, dy) end
end
```

### `BaseCell:pushed(dx, dy, action)`

Called after a push, pull or grab moved this cell, with the direction it moved in. Every cell in the moved line counts, including the ones a repulsor or generator pushes, but not the mover itself and not cells that were swapped. Inertia uses it to store its momentum, and extensions use it to extend the force.

| parameter | type | description |
| --- | --- | --- |
| `dx` | `number` | horizontal direction of the push |
| `dy` | `number` | vertical direction of the push |
| `action` | `"push"\|"pull"\|"grab"` | what moved the cell |

```lua
-- remembers the direction it was last pushed in
function Glider:pushed(dx, dy)
    self.heading = { dx, dy }
end
```

### `BaseCell:side()`

Which side sentries and seekers see this cell on. A cell only targets cells on the other side. Default is the `team`, or `"hostile"` for `hostile` cells and `"friendly"` for `friendly` ones.

**Returns** `"hostile"`, `"friendly"` or `nil` for a neutral cell

```lua
-- a spy is only friendly until it disguises
function Spy:side()
    local mask = self.props.disguise.class
    return mask and mask:side() or "friendly"
end
```

### `BaseCell:health()`

How much damage the cell takes to destroy. Missiles and enemies compare it when they collide: both take the lower of the two healths as damage. Default `1`.

**Returns** `number`, where `math.huge` can only be destroyed by infinite damage

```lua
function Strong:health()
    return 2
end
```

### `BaseCell:breakable()`

Whether collisions and explosions can destroy the cell. Default is not `fixed` and not protected.

### `BaseCell:hit(damage)`

Called when a collision or an explosion damages this cell. Default destroys the cell if it is [`breakable`](#basecellbreakable). Enemies override it to take the damage the way they do when pushed into.

| parameter | type | description |
| --- | --- | --- |
| `damage` | `number` | how much damage was dealt. an explosion deals `1` |

```lua
function Strong:hit(damage)
    if damage > 1 then self:kill(true) else self:become(Weak) end
end
```

### `BaseCell:generatable()`

Whether generators can copy the cell. Default `true`.

**Returns** `boolean`

```lua
function Unique:generatable()
    return false
end
```

### `BaseCell:generated()`

What a generator's copy of the cell becomes. Only called when [`generatable`](#basecellgeneratable) is true. Default is the cell's own class and props.

**Returns** the class of the copy, and optionally the props it starts with and its rotation. Return nothing to generate nothing. The rotation defaults to the cell's own.

```lua
-- copies turn into an Ungeneratable
function Fragile:generated()
    return Ungeneratable
end
```

### `BaseCell:force(dx, dy, action)`

Force added to a push or pull. The move fails if the total is 0 or less. Default `0`.

| parameter | type | description |
| --- | --- | --- |
| `dx` | `number` | horizontal direction of the move |
| `dy` | `number` | vertical direction of the move |
| `action` | `"push"\|"pull"` | what is moving the cell |

**Returns** `number`

```lua
-- like Weight: absorbs one unit of force from every push and pull
function Weight:force()
    return -1
end
```

### `BaseCell:resist(force, dx, dy)`

Changes the force that is left after this cell, after its own [`force`](#basecellforcedx-dy-action) is added. Return the new total: `0` blocks the move, and a smaller number leaves less force for the cells after it. Default is the same force.

| parameter | type | description |
| --- | --- | --- |
| `force` | `number` | force left on arriving at this cell, including its own |
| `dx` | `number` | horizontal direction of the move |
| `dy` | `number` | vertical direction of the move |

**Returns** `number`

```lua
-- like Restrictor: at most one unit of force gets through
function Restrictor:resist(force)
    return math.min(force, 1)
end
```

### `BaseCell:imaginary(dx, dy)`

Imaginary force this cell adds to the line it moves in. The line only moves if every cell in it agrees to the sum, see [`settled`](#basecellsettledtotal). Default `0`.

| parameter | type | description |
| --- | --- | --- |
| `dx` | `number` | horizontal direction of the move |
| `dy` | `number` | vertical direction of the move |

**Returns** `number`

### `BaseCell:settled(total)`

Whether the moved line is allowed to move for its total [imaginary force](#basecellimaginarydx-dy). Every moved cell is asked, and the move is cancelled when one says no. Default `true`.

| parameter | type | description |
| --- | --- | --- |
| `total` | `number` | sum of the imaginary force of the moved line |

**Returns** `boolean`

```lua
-- like Imaginary Weight: the line may not weigh more than it is pushed
function ImaginaryWeight:settled(total)
    return total >= 0
end
```

### `BaseCell:guarded(guard, dx, dy)`

Whether the cell refuses an action, from `guards` or an effect. Override it to refuse by side. `"protect"` is asked with the direction the threat moves in, so a cell can shield some of its sides, but the other guards are asked without one.

| parameter | type | description |
| --- | --- | --- |
| `guard` | `string` | `"push"`, `"pull"`, `"grab"`, `"swap"`, `"scissor"`, `"tunnel"`, `"lock"` or `"protect"` |
| `dx` | `number?` | horizontal direction the threat moves in |
| `dy` | `number?` | vertical direction the threat moves in |

**Returns** `boolean`

### `BaseCell:chained(action, dx, dy, anchor)`

Called when a push, pull or grab reaches the cell, before the chain is known to succeed. Queue work with `movement:post`: it runs once the chain has finished, even when the chain failed, and receives whether the chain moved. Does nothing by default.

| parameter | type | description |
| --- | --- | --- |
| `action` | `string` | `"push"`, `"pull"` or `"grab"` |
| `dx` | `number` | horizontal direction the cell would move in |
| `dy` | `number` | vertical direction the cell would move in |
| `anchor` | `table` | `x`, `y`, `dx`, `dy` of the push that started the chain, and `extended` to mark that a cell has already extended it |

```lua
-- pulls the cell behind it once the chain is over
function PullExtension:chained(action, dx, dy)
    local movement, x, y = self.simulator.movement, self.x, self.y
    movement:post(function() movement:pull(x - dx, y - dy, dx, dy) end)
end
```

### `BaseCell:clinging(dx, dy)`

What the cell sticks to on the side facing `dx, dy`. Two neighbors move together when each one returns the same value for the side facing the other. Default is the cell's stickiest effect, or `nil`.

| parameter | type | description |
| --- | --- | --- |
| `dx` | `number` | horizontal direction of the side |
| `dy` | `number` | vertical direction of the side |

**Returns** `any`

```lua
-- sticks to other Silicon on every side
function Silicon:clinging()
    return "silicon"
end
```

### `BaseCell:divert(dx, dy, reverse, mover)`

Called when a push, pull or generation passes through the cell. Return a new direction to bend the path, or nothing to let it pass straight through. Does nothing by default.

| parameter | type | description |
| --- | --- | --- |
| `dx` | `number` | horizontal direction the path is travelling |
| `dy` | `number` | vertical direction the path is travelling |
| `reverse` | `boolean` | whether the path is being traced backwards, as when pulling |
| `mover` | `BaseCell?` | the cell travelling through, for diverters that depend on it |

**Returns** the new `dx`, the new `dy`, and how many clockwise quarter turns to rotate the moved cell by.

```lua
-- bends every path a quarter turn clockwise and rotates the cell with it
function Bender:divert(dx, dy)
    return -dy, dx, 1
end
```

### `BaseCell:jump(dx, dy, x, y)`

Called when a push, pull or generation passes through the cell. Return a position to continue the path from, or nothing to let it pass straight through. Does nothing by default.

| parameter | type | description |
| --- | --- | --- |
| `dx` | `number` | horizontal direction the path is travelling |
| `dy` | `number` | vertical direction the path is travelling |
| `x` | `number` | horizontal position the path reached |
| `y` | `number` | vertical position the path reached |

**Returns** the new `x` and `y`.

```lua
-- sends every path to the left edge of its row
function Warper:jump(_, _, _, y)
    return 0, y
end
```

### `BaseCell:draw(renderer, x, y, angle, scale, offset)`

Draws the cell. Call `BaseCell.draw` to keep the default sprite.

| parameter | type | description |
| --- | --- | --- |
| `renderer` | `Renderer` | the renderer to draw with |
| `x` | `number` | screen x position |
| `y` | `number` | screen y position |
| `angle` | `number` | rotation to draw at |
| `scale` | `number` | size multiplier |
| `offset` | `number` | draw offset |

```lua
function Counter:draw(renderer, ...)
    BaseCell.draw(self, renderer, ...)
    renderer:drawTag(self.ticks or 0, ...)
end
```

## Actions

Call these from your own methods, usually from `update`. Where `dx` and `dy` are optional, they default to the direction the cell is facing.

| method | description |
| --- | --- |
| [`push`](#basecellpushdx-dy-force) | pushes the cell one tile, moving whatever is in the way |
| [`pull`](#basecellpulldx-dy-force) | moves the cell one tile and drags the cells behind it |
| [`grab`](#basecellgrabdx-dy) | moves the cell one tile and drags the cells beside it |
| [`nudge`](#basecellnudgedx-dy) | moves the cell one tile without pushing |
| [`swap`](#basecellswapax-ay-bx-by) | swaps the cells at two offsets from this one |
| [`generate`](#basecellgeneratedirection-options) | copies the cell behind this one into the tile in front |
| [`fire`](#basecellfireclass-direction) | puts a new cell into the tile in front, if it is empty or eats the cell |
| [`repel`](#basecellrepeldirection-force-row) | pushes the cell in front of this one away without moving this cell |
| [`rotate`](#basecellrotateamount-forced) | rotates the cell |
| [`rotateNeighbors`](#basecellrotateneighborsamount-predicate) | rotates the four adjacent cells |
| [`neighbors`](#basecellneighborsdistance-callback) | loops over nearby tiles, no diagonals |
| [`surrounding`](#basecellsurroundingdistance-callback) | loops over the square around the cell, diagonals included |
| [`kill`](#basecellkillexploded) | removes the cell from the grid |
| [`become`](#basecellbecomeclass) | turns the cell into another class in place |
| [`alternate`](#basecellalternate) | turns the cell into its `pair` |

### `BaseCell:push(dx, dy, force)`

Pushes the cell one tile, moving whatever is in the way.

| parameter | type | description |
| --- | --- | --- |
| `dx` | `number?` | horizontal direction |
| `dy` | `number?` | vertical direction |
| `force` | `number?` | extra force added to the push |

**Returns** `boolean`, true if it moved.

```lua
function Mover:update()
    self:push()
end
```

### `BaseCell:pull(dx, dy, force)`

Moves the cell one tile and drags the cells behind it.

| parameter | type | description |
| --- | --- | --- |
| `dx` | `number?` | horizontal direction |
| `dy` | `number?` | vertical direction |
| `force` | `number?` | extra force added to the pull |

**Returns** `boolean`, true if it moved.

```lua
function Puller:update()
    self:pull()
end
```

### `BaseCell:grab(dx, dy)`

Moves the cell one tile and drags the cells on both sides of it one tile the same way. Set [`skew`](#class-fields) on the class to drag the front or back diagonals instead of the sides.

| parameter | type | description |
| --- | --- | --- |
| `dx` | `number?` | horizontal direction |
| `dy` | `number?` | vertical direction |

**Returns** `boolean`, true if it moved.

```lua
function Grabber:update()
    self:grab()
end
```

### `BaseCell:advance(dx, dy)`

Moves the cell one tile, pushing the cells in front of it and dragging the cells behind it.

| parameter | type | description |
| --- | --- | --- |
| `dx` | `number?` | horizontal direction |
| `dy` | `number?` | vertical direction |

**Returns** `boolean`, true if it moved.

```lua
function Advancer:update()
    self:advance()
end
```

### `BaseCell:nudge(dx, dy)`

Moves the cell one tile without pushing. Fails if the tile is occupied.

| parameter | type | description |
| --- | --- | --- |
| `dx` | `number?` | horizontal direction |
| `dy` | `number?` | vertical direction |

**Returns** `boolean`, true if it moved.

```lua
function Nudger:update()
    self:nudge()
end
```

### `BaseCell:swap(ax, ay, bx, by)`

Swaps the cells at two offsets from this one. A cell that cannot be pushed the way it would move stops the swap, and a cell that [eats](#basecelleatsdx-dy-action) the other one deletes it instead of moving. Curved mirrors count each cell as moving straight toward the other cell's side, not along the diagonal it travels.

| parameter | type | description |
| --- | --- | --- |
| `ax` | `number` | horizontal offset of the first cell |
| `ay` | `number` | vertical offset of the first cell |
| `bx` | `number` | horizontal offset of the second cell |
| `by` | `number` | vertical offset of the second cell |

**Returns** `boolean`, true if a cell moved.

```lua
-- swaps the cells on the left and right
function Swapper:update()
    self:swap(-1, 0, 1, 0)
end
```

### `BaseCell:generate(direction, options)`

Copies the cell behind this one into the tile in front, pushing out what is there.

| parameter | type | description |
| --- | --- | --- |
| `direction` | `number?` | direction to generate in. defaults to the facing direction |
| `options` | `table?` | extra options for the generation |

**Returns** `boolean`, then the new cell and the turn that diverters applied to it. Both are nil when nothing was copied.

```lua
function Copier:update(_, direction)
    self:generate(direction)
end
```

### `BaseCell:fire(class, direction)`

Puts a new cell of `class` into the tile in front of this one without pushing anything, and plays the shoot sound. A cell that eats it takes it in. A breakable cell collides with it if the new cell has `struck`, like a missile, and nothing happens otherwise.

| parameter | type | description |
| --- | --- | --- |
| `class` | `table` | class of the new cell, facing `direction` |
| `direction` | `number?` | direction to fire in. defaults to the facing direction |

**Returns** `boolean`

```lua
function Gun:update()
    self:fire(Bullet)
end
```

### `BaseCell:repel(direction, force, row)`

Pushes the cell next to this one away, along with whatever is in its way. This cell does not move.

| parameter | type | description |
| --- | --- | --- |
| `direction` | `number` | direction to push towards (0-3) |
| `force` | `number` | force of the push, defaults to `constants.force.strength` |
| `row` | `boolean` | keep pushing past gaps, so the whole row moves |

**Returns** the move it pushed from, or `false` if the push failed.

```lua
function Repulsor:update(_, direction)
    self:repel(direction, nil, self.row)
end
```

### `BaseCell:rotate(amount, forced)`

Rotates the cell by `amount` clockwise quarter turns. Does nothing to an `anchored` cell unless `forced` is set.

| parameter | type | description |
| --- | --- | --- |
| `amount` | `number` | quarter turns. negative turns counterclockwise |
| `forced` | `boolean` | rotates even an `anchored` cell |

```lua
self:rotate(1)  -- clockwise
self:rotate(-1) -- counterclockwise
self:rotate(2)  -- flip around
```

### `BaseCell:rotateNeighbors(amount, predicate)`

Rotates the four adjacent cells. With `predicate`, only cells it returns true for are rotated.

| parameter | type | description |
| --- | --- | --- |
| `amount` | `number` | quarter turns, like `rotate` |
| `predicate` | `function?` | called with each neighbor, return true to rotate it |

```lua
-- only rotate cells that are not walls
self:rotateNeighbors(1, function(cell)
    return cell.name ~= "wall"
end)
```

### `BaseCell:neighbors(distance, callback)`

Calls `callback(cell, x, y, dx, dy)` for each tile within `distance` steps, without diagonals. `cell` is nil for empty tiles.

| parameter | type | description |
| --- | --- | --- |
| `distance` | `number` | how many tiles out to look |
| `callback` | `function` | called for every tile, including empty ones |

```lua
self:neighbors(2, function(cell, x, y)
    if cell then print(cell.name, x, y) end
end)
```

### `BaseCell:surrounding(distance, callback)`

Same as `neighbors`, but covers the full square around the cell, diagonals included.

| parameter | type | description |
| --- | --- | --- |
| `distance` | `number` | how many tiles out to look |
| `callback` | `function` | called for every tile, including empty ones |

```lua
-- go away if anything hostile is nearby
self:surrounding(1, function(cell)
    if cell and cell.hostile then self:kill() end
end)
```

### `BaseCell:kill(exploded)`

Removes the cell from the grid.

| parameter | type | description |
| --- | --- | --- |
| `exploded` | `boolean?` | marks the cell as exploded instead of removed |

```lua
function Bomb:update()
    self:kill(true)
end
```

### `BaseCell:become(class)`

Turns the cell into another class without moving it or changing its rotation and props. The cell object stays the same, so references to it stay valid.

| parameter | type | description |
| --- | --- | --- |
| `class` | `table` | the cell class to become |

```lua
function Sprout:update()
    self:become(Tree)
end
```

### `BaseCell:alternate()`

Turns the cell into the class named by its `pair` field. Toggle doors and gates use it to swap with each other.

```lua
local Door = setmetatable({ name = "door", pair = "gate" }, { __index = BaseCell })

function Door:click()
    self:alternate()
    return true
end
```
