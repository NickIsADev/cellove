Every `.lua` file in a mod's `cells` folder is registered as a cell. Folders named `abstract` are skipped, so they can hold base classes. Classes can also be registered from code with [`api.cells.add`](API-Reference#apicellsaddclass).

## Contents

- [A minimal cell](#a-minimal-cell)
- [Categories](#categories)
- [Properties](#properties)
- [Subticks](#subticks)
- [Common patterns](#common-patterns)
- [Inheriting](#inheriting)
- [Talking to other cells](#talking-to-other-cells)

## A minimal cell

`mods/mymod/cells/Eraser.lua`

```lua
local BaseCell = require("content/cells/abstract/BaseCell")

local Eraser = setmetatable({
    name = "eraser",
    title = "Eraser",
    description = "Deletes the cells around it every tick.",
    categories = { "machines" },
    subtick = { "generator" }
}, { __index = BaseCell })
Eraser.__index = Eraser

function Eraser:update()
    self:neighbors(1, function(cell)
        if cell then cell:kill() end
    end)
end

return Eraser
```

This registers `mymod:eraser`. It updates in subtick `9` and removes whatever is on the four tiles around it.

> [!TIP]
> Everything a cell can define is listed on the [BaseCell](BaseCell) page.

## Categories

`categories` takes one or more IDs. A category can be named anything. It does not have to match the mod ID.

| ID | resolves to |
| --- | --- |
| `"movers"` | built-in category |
| `"machines"` | `mymod:machines`, added by this mod with `api.categories.add` |
| `"othermod:machines"` | another mod's category, by full ID |

> [!IMPORTANT]
> A category that does not exist is an error, and the mod fails to load.

### Subcategories

A category can be listed under another one with `parent`, which takes the parent's full ID. Cells in a subcategory also show up in its parent, so a cell only needs to name the most specific category. Name the parent as well to also list the cell in the parent's own row.

```lua
api.categories.add({
    id = "drills",
    title = "Drills",
    icon = "mymod/drill",
    parent = "movers"
})
```

## Properties

Properties show up in the property panel and are saved with contraptions. The type of `default` sets the kind.

```lua
properties = {
    { id = "range", title = "Range", default = 8, min = 1, max = 32 },
    { id = "loud", title = "Loud", default = false },
    { id = "label", title = "Label", default = "hi", limit = 16 }
}
```

| type of `default` | input | requires |
| --- | --- | --- |
| `number` | stepper | `min` and `max`. `min` is at least 0 and `default` is between them |
| `boolean` | toggle | nothing |
| `string` | text field | `limit`, the maximum length |
| `table` | none | an empty table as `default`. holds a cell as `{ class, rotation, props }`, like Storage does |

Read values from `self.props`:

```lua
function Eraser:update()
    if self.props.loud then print(self.props.label) end
end
```

## Subticks

A tick runs its subticks in ascending order, and a cell's `update` runs in the subticks listed in its `subtick`. Use the names of the built-in subticks, like `subtick = { "mover" }`, to run alongside them. A name stands for its position in the list below, starting at `0`, so a number works too, and only the order matters: `34.5` runs after movers and before nudgers without renumbering anything.

| subtick | cells |
| --- | --- |
| `pipe` | pipes |
| `trueGear` | true gears |
| `midas` | midas |
| `superMirror`, `mirror`, `curvedMirror` | super mirrors, mirrors, curved mirrors |
| `cyclerCW`, `cyclerCCW` | clockwise cyclers, counter-clockwise cyclers (paracyclers use both) |
| `memoryGenerator`, `generator`, `memoryReplicator`, `maker` | memory generators, generators, memory replicators, makers |
| `rotator`, `spin` | rotators, the spin of rotator movers |
| `flipGear` | flip gears |
| `gearCW`, `gearCCW`, `gear180`, `gearRNG` | clockwise gears, counter-clockwise gears, 180 gears, random gears |
| `superRedirector`, `redirector` | super redirectors, redirectors |
| `inertia` | inertia |
| `vacuum`, `superImpulsor`, `impulsor` | vacuums, super impulsors, impulsors |
| `fan`, `superRepulsor`, `repulsor` | fans, super repulsors, repulsors |
| `magnetX`, `magnetY` | magnets, split by axis |
| `puller` | pullers, advancers, luggers, hoisters |
| `trawler` | trawlers |
| `grabber` | grabbers, heavers |
| `thruster` | thrusters, skewers |
| `mover` | movers, birds, the push of rotator movers |
| `nudger` | nudgers, CelLoves |
| `player` | players |
| `fearful` | fearful enemies, fearful allies |
| `gate` | gates |
| `spread`, `decay` | life, split into spreading and dying |
| `settlestorage` | settlestorages |

## Common patterns

Most cells override one or two methods. These are the usual ones, taken from the built-in cells.

| you want a cell that | use |
| --- | --- |
| acts every tick | `subtick` and `update` |
| moves on its own | `drive`, `directional` and `update` with `push` |
| deletes what moves into it | `eats` |
| can only be pushed in some directions | `pushable` |
| helps or resists pushes | `force` |
| looks different when flipped | `twin`, or `faces` when only the rotation changes |
| reacts to being swapped by a mirror | `swapped` |
| must run row by row, like gears | `sweep` |

**Deletes cells that move into it**, like Trash:

```lua
function Trash:eats()
    return true
end
```

**Pushes itself forward every tick**, like Mover:

```lua
local Mover = setmetatable({
    name = "mover",
    subtick = { "mover" },
    drive = { push = true, pull = true },
    directional = true
}, { __index = BaseCell })
Mover.__index = Mover

function Mover:update()
    self:push()
end
```

**Resists being pushed**, like Weight:

```lua
function Weight:force()
    return -1
end
```

## Inheriting

A cell can inherit from any cell, including built-in ones. This one is a Mover that counts its updates and shows the number on its sprite.

```lua
local Mover = require("content/cells/movers/Mover")

local Counter = setmetatable({
    name = "counter",
    title = "Counter",
    description = "A mover that shows how many times it has updated.",
    categories = { "movers" }
}, { __index = Mover })
Counter.__index = Counter

function Counter:update()
    Mover.update(self)
    self.ticks = (self.ticks or 0) + 1
end

function Counter:draw(renderer, ...)
    Mover.draw(self, renderer, ...)
    renderer:drawTag(self.ticks or 0, ...)
end
```

Call the parent's method directly, like `Mover.update` above, to keep its behavior and add to it. Everything you don't override, like `subtick` and `drive`, comes from the parent.

## Talking to other cells

Cells are plain tables. Check that a method exists before calling it.

```lua
self:surrounding(self.props.range, function(cell)
    if cell and cell.wake then cell:wake() end
end)
```

> [!NOTE]
> `surrounding` calls the callback with `nil` for empty tiles, so always check `cell` first.
