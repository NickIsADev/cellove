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
| `properties` | `table` | `{}` | [property definitions](Creating-Cells#properties) |
| `subtick` | `table` | `{}` | subticks `update` runs in. empty means never |
| `directional` | `boolean` | | calls `update` once per entry in `outputs` |
| `outputs` | `table` | `{ 0 }` | output directions relative to rotation: `0` forward, `1` right, `2` back, `3` left |
| `drive` | `table` | | actions that move the cell forward, like `{ push = true, pull = true }`. a cell moved that way skips its update that tick |
| `rear` | `boolean` | | scans from the back of the pass direction instead of the front |
| `hostile` | `boolean` | `false` | counts as an enemy. a puzzle is solved when none remain |

```lua
local Mover = setmetatable({
    name = "mover",
    title = "Mover",
    description = "Moves forward every tick.",
    categories = { "movers" },
    subtick = { 3 },
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
| `simulator` | `Simulator` | set while the cell updates |

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
| [`pushable`](#basecellpushabledx-dy) | `true` | whether the cell can be pushed |
| [`eats`](#basecelleatsdx-dy) | `false` | whether cells moving into this one are deleted |
| [`absorb`](#basecellabsorbcell-dx-dy) | nothing | called after this cell eats a cell |
| [`generatable`](#basecellgeneratable) | `true` | whether generators can copy the cell |
| [`force`](#basecellforcedx-dy-action) | `0` | force added to a push or pull |
| [`divert`](#basecelldivertdx-dy-reverse) | nothing | bends the path of a move passing through |
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

### `BaseCell:pushable(dx, dy)`

Whether the cell can be pushed. Default `true`.

| parameter | type | description |
| --- | --- | --- |
| `dx` | `number` | horizontal push direction: `-1`, `0` or `1` |
| `dy` | `number` | vertical push direction: `-1`, `0` or `1` |

**Returns** `boolean`

```lua
-- can only be pushed left and right
function Rail:pushable(dx, dy)
    return dy == 0
end
```

### `BaseCell:eats(dx, dy)`

Whether cells moving into this one are deleted. Default `false`.

| parameter | type | description |
| --- | --- | --- |
| `dx` | `number` | horizontal direction the other cell is moving |
| `dy` | `number` | vertical direction the other cell is moving |

**Returns** `boolean`

```lua
function Trash:eats()
    return true
end
```

### `BaseCell:absorb(cell, dx, dy)`

Called after this cell eats `cell`.

| parameter | type | description |
| --- | --- | --- |
| `cell` | `BaseCell` | the cell that was eaten |
| `dx` | `number` | horizontal direction it was moving |
| `dy` | `number` | vertical direction it was moving |

```lua
function Counter:absorb(cell)
    print("ate a " .. cell.name)
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

### `BaseCell:divert(dx, dy, reverse)`

Called when a push, pull or generation passes through the cell. Return a new direction to bend the path, or nothing to let it pass straight through. Does nothing by default.

| parameter | type | description |
| --- | --- | --- |
| `dx` | `number` | horizontal direction the path is travelling |
| `dy` | `number` | vertical direction the path is travelling |
| `reverse` | `boolean` | whether the path is being traced backwards, as when pulling |

**Returns** the new `dx`, the new `dy`, and how many clockwise quarter turns to rotate the moved cell by.

```lua
-- bends every path a quarter turn clockwise and rotates the cell with it
function Bender:divert(dx, dy)
    return -dy, dx, 1
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
| [`nudge`](#basecellnudgedx-dy) | moves the cell one tile without pushing |
| [`generate`](#basecellgeneratedirection-options) | copies the cell behind this one into the tile in front |
| [`rotate`](#basecellrotateamount) | rotates the cell |
| [`rotateNeighbors`](#basecellrotateneighborsamount-predicate) | rotates the four adjacent cells |
| [`neighbors`](#basecellneighborsdistance-callback) | loops over nearby tiles, no diagonals |
| [`surrounding`](#basecellsurroundingdistance-callback) | loops over the square around the cell, diagonals included |
| [`kill`](#basecellkillexploded) | removes the cell from the grid |

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

### `BaseCell:generate(direction, options)`

Copies the cell behind this one into the tile in front, pushing out what is there.

| parameter | type | description |
| --- | --- | --- |
| `direction` | `number?` | direction to generate in. defaults to the facing direction |
| `options` | `table?` | extra options for the generation |

**Returns** `boolean`

```lua
function Copier:update(_, direction)
    self:generate(direction)
end
```

### `BaseCell:rotate(amount)`

Rotates the cell by `amount` clockwise quarter turns.

| parameter | type | description |
| --- | --- | --- |
| `amount` | `number` | quarter turns. negative turns counterclockwise |

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
