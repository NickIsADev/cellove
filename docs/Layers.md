A tile holds one cell per layer. Layers let a cell sit on top of or underneath another cell, like a door over a conveyor, instead of replacing it.

## Contents

- [The layers](#the-layers)
- [Putting a cell on a layer](#putting-a-cell-on-a-layer)
- [Blocking and eating](#blocking-and-eating)
- [Updating, clicking and drawing](#updating-clicking-and-drawing)
- [Shared state](#shared-state)
- [Editor and formats](#editor-and-formats)
- [Grid functions](#grid-functions)

## The layers

Listed from bottom to top, as in `constants.grid.layers`.

| layer | what lives there |
| --- | --- |
| `"background"` | cells that sit under everything and never move |
| `"foreground"` | every normal cell. this is the layer cells are pushed, pulled and counted in |
| `"overlay"` | cells on top of the foreground, like doors and gates |

Only the foreground moves. Cells on the other layers are fixed to their tile, cannot be pushed, swapped or generated, and are not counted by a puzzle's enemies, allies or players. They still run `update`, react to clicks and are saved, copied, undone and drawn like any cell.

## Putting a cell on a layer

Set `layer` on the class. The default is `"foreground"`.

```lua
local Tripwire = setmetatable({
    name = "tripwire",
    title = "Tripwire",
    description = "Blocks cells moving left.",
    categories = { "walls" },
    layer = "overlay"
}, { __index = BaseCell })
```

A tile can hold an overlay cell and a foreground cell at once. The editor places a cell on the layer of its class, so placing a tripwire over a mover keeps the mover. Erasing removes the topmost cell on the tile, and the selection tools and copy and paste handle every layer.

## Blocking and eating

Moves into a tile ask that tile's non-foreground cells two questions, in this order:

1. [`bars(dx, dy, action, mover)`](BaseCell#basecellbarsdx-dy-action-mover): return `true` to stop the mover. A push that would enter the tile is blocked as a whole, and swaps and generators cannot enter either.
2. [`eats(dx, dy, action, mover)`](BaseCell#basecelleatsdx-dy-action-mover): return `true` to delete the mover as it arrives. [`absorb`](BaseCell#basecellabsorbcell-dx-dy-action) runs afterwards, and returning `true` from it lets the mover keep going.

A cell that eats the mover must also let it in: `bars` has to return `false` for the same mover.

```lua
local Tripwire = setmetatable({ name = "tripwire", layer = "overlay" }, { __index = BaseCell })

function Tripwire:bars(dx)
    return dx < 0
end

-- a gate that only a key can use, and the key is used up
function Gate:bars(dx, dy, action, mover)
    return not (mover and mover.key == "gold")
end

function Gate:eats(dx, dy, action, mover)
    return mover ~= nil and mover.key == "gold"
end

function Gate:absorb()
    self:become(OpenGate)
end
```

`mover` is `nil` when the game only asks whether a tile could be entered and does not know by what. Answer for the cell you would block most often.

## Updating, clicking and drawing

- Layered cells run `update` in their `subtick`s, after the foreground cells of the same subtick.
- A click goes through the layers from the top down, and the first cell whose [`click`](BaseCell#basecellclickbutton) returns `true` takes it. Clicks only count once the simulation has started.
- Layers are drawn in order, so an overlay is drawn over the foreground. Only the foreground casts shadows.
- Zoomed far out, a tile shows its topmost cell.

## Shared state

Cells sometimes share state, like a switch and the doors that follow it. Keep it in a store: `simulator:store(name, build)` returns the table `build(grid)` made. The table is built when it is first asked for and again whenever the grid changes while the simulation has not started, so it starts from the grid as it was laid out, and is rebuilt from it again when the simulation starts. Once started it is kept until the contraption is reset.

```lua
local function build(grid)
    local on = {}

    for index = 1, grid.width * grid.height do
        local cell = grid.cells[index]
        if cell and cell.props.on then on[cell.props.id] = true end
    end
    return on
end

local function lit(cell)
    return cell.grid.simulator:store("lamps", build)[cell.props.id]
end
```

Call `grid:invalidate()` after changing a store from a cell, so blocked pushes are checked again. Never write run state into `cell.props`: the props table is shared with the saved copy the simulation resets to. Keep it on the cell instead, as a field set in `new`.

## Editor and formats

CL saves every layer. K3 has a place for the foreground and the overlay (CelLua's *above* layer), so a contraption with a background cell is exported as CL instead. A cell with a `k3` ID on the overlay layer is read from and written to the K3 overlay layer.

## Grid functions

| function | description |
| --- | --- |
| `grid:get(x, y, layer)` | the cell on a layer, the foreground by default |
| `grid:set(x, y, cell, layer)` | places or removes a cell. a cell goes on its own class's layer, `layer` only picks the layer to clear when `cell` is `nil` |
| `grid:top(x, y)` | the topmost cell on the tile |
| `grid:invalidate()` | tells the simulator the grid changed in a way that affects blocked moves |
| `grid.stacks[layer]` | the cells of a layer by index, `(y - 1) * width + x` |
