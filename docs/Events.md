Events let a mod react to the game without changing it. Listen from `main.lua` with `api.on`.

## Listening

```lua
return function(api)
    api.on("puzzle:solved", function(info)
        print("solved", info)
    end)
end
```

Remove a listener with `api.off(name, callback)`. Keep the function in a variable so you can pass the same one back.

```lua
local function onTick(simulator)
    print("tick")
end

api.on("simulator:tick", onTick)
api.off("simulator:tick", onTick)
```

> [!NOTE]
> An error in a listener is printed to the console. The other listeners still run.

## Built-in events

| event | arguments | fired when |
| --- | --- | --- |
| `game:ready` | `context` | the game has finished loading |
| `game:update` | `dt` | every frame, before drawing |
| `game:draw` | | every frame, after update |
| `scene:enter` | `name, data` | a scene is entered |
| `simulator:tick` | `simulator` | the simulation finished a tick |
| `editor:commit` | `editor` | an edit is committed |
| `contraption:imported` | `data` | a contraption is imported |
| `puzzle:solved` | `info` | a puzzle is solved |

### Examples

**Count ticks**

```lua
local ticks = 0

api.on("simulator:tick", function()
    ticks = ticks + 1
end)
```

**Run code every frame**

```lua
api.on("game:update", function(dt)
    -- dt is the time since the last frame in seconds
end)
```

**Know which scene opened**

```lua
api.on("scene:enter", function(name)
    print("entered", name)
end)
```

## Custom events

`api.emit(name, ...)` fires `<modId>:<name>`. Any mod can listen to it with the full name.

```lua
-- in mymod
api.emit("powered", cell)
```

```lua
-- in any other mod
api.on("mymod:powered", function(cell)
    print("powered", cell.x, cell.y)
end)
```

## Sharing code between mods

Events are for notifications. To share functions or data, put them in `api.exports`.

```lua
-- in mymod
api.exports.double = function(value) return value * 2 end
```

```lua
-- in any other mod
local other = api.mods.get("mymod")
if other then print(other.double(4)) end
```

| call | does |
| --- | --- |
| `api.mods.get("mymod")` | returns the exports of `mymod`, or nothing if it did not load |
| `api.mods.has("mymod")` | checks that `mymod` loaded without errors |

> [!TIP]
> Add `mymod` to `dependencies` in `mod.lua` if you need it loaded first. See [Getting Started](Getting-Started#modlua).
