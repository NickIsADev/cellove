An effect is a status a cell carries: frozen, armored, painted, carrying coins. Cells that give effects, like freezers and painters, apply them. The effect decides what they do.

Every `.lua` file in a mod's `effects` folder is registered as an effect. Folders named `abstract` are not skipped there, so keep base classes elsewhere. Effects can also be registered from code with [`api.effects.add`](API-Reference#apieffectsaddeffect). The effect's `name` is its texture name in the `effects` texture folder, and a mod's effects get the mod prefix: `mymod:frost` uses `textures/effects/mymod/frost.png`.

## Contents

- [A minimal effect](#a-minimal-effect)
- [Class fields](#class-fields)
- [Methods](#methods)
- [Using effects from cells](#using-effects-from-cells)
- [Giving and removing effects](#giving-and-removing-effects)

## A minimal effect

```lua
local BaseEffect = require("content/effects/abstract/BaseEffect")

local Frost = setmetatable({
    name = "frost",
    subtick = { "freezer" }
}, { __index = BaseEffect })
Frost.__index = Frost

function Frost:update(cell, value)
    cell:rotate(1)
end

return Frost
```

An effect lasts one tick unless it is `permanent`, and is refreshed by whatever gives it. `value` is whatever the giver passes, `true` by default.

## Class fields

| field | type | default | description |
| --- | --- | --- | --- |
| `name` | `string` | | required, lowercase letters, digits and `_`. must be set on the class itself |
| `subtick` | `table` | `{}` | subticks `update` runs in, in the same format as a [cell's](BaseCell#class-fields) |
| `directional` | `boolean` | | runs `update` once per pass direction, cells ordered along it |
| `permanent` | `boolean` | | stays until something removes it, instead of ending after the tick |
| `universal` | `boolean` | | also applies to `fixed` and immune cells |
| `relays` | `boolean` | `true` | passes through transmitters to the cells they touch |
| `guards` | `table` | `{}` | what a cell with the effect is protected from, as `{ protect = true }`. built-in guards are `protect`, `immune`, `lock`, `push`, `pull`, `grab`, `swap`, `scissor`, `tunnel` |
| `cling` | `number` | | makes the cell cling to its neighbors, lower wins when a cell has several |

## Methods

Every method has a default, so override what you need.

| method | description |
| --- | --- |
| `accepts(cell, value)` | whether the effect can be applied to the cell. return `false` to refuse |
| `applied(cell)` | called after the effect was applied |
| `update(cell, value, subtick, direction)` | runs each subtick for every cell carrying the effect |
| `force(value, dx, dy, action, actor)` | force added to a push or pull the cell takes part in |
| `rotated(value, amount)` | returns the value after the cell was rotated |
| `flipped(value, key, turned)` | returns the value after the cell was flipped |
| `tint(value)` | returns a color to draw the cell in |
| `texture(value)` | name of the sprite drawn over the cell, `name` by default |
| `draw(renderer, value, x, y, size, offset)` | draws the effect over the cell |

## Using effects from cells

```lua
local Frost = require("mymod/effects/Frost")

cell:effect(Frost)        -- the value, or nil
cell:guarded("protect")   -- whether any effect on the cell guards it
Frost:apply(cell, true)   -- gives the effect
Frost:remove(cell)        -- takes it away
```

A cell moved into a holder, pipe, generator or similar keeps its permanent effects. Override [`BaseCell:permanent`](BaseCell) in a cell that should keep fewer.

## Giving and removing effects

Build giver and remover cells from `BaseEffectGiver` and `BaseEffectRemover` (`content/cells/abstract`). They affect the cells around them, in the shape set by `faces`.

```lua
local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local Frost = require("mymod/effects/Frost")

local Chiller = setmetatable({
    name = "chiller",
    title = "Chiller",
    description = "Frosts the cells around it.",
    gives = { Frost }
}, { __index = BaseEffectGiver })
Chiller.__index = Chiller
```

| field | description |
| --- | --- |
| `gives` | the effects a giver applies |
| `removes` | the effects a remover takes away |
| `value` | the value a giver passes, `true` by default |
| `distance` | how far it reaches, `1` by default |
| `inclusive` | whether it affects itself, `true` by default |
