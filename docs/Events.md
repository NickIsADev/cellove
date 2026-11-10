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
| `game:keypressed` | `key, scancode, repeated` | a key is pressed |
| `game:textinput` | `text` | text is typed |
| `game:mousepressed` | `x, y, button, touch, presses` | a mouse button is pressed |
| `game:mousemoved` | `x, y, dx, dy, touch` | the mouse moves |
| `game:mousereleased` | `x, y, button, touch, presses` | a mouse button is released |
| `game:wheelmoved` | `x, y` | the mouse wheel moves |
| `game:filedropped` | `file` | a file is dropped on the window |
| `game:focus` | `focused` | the window gains or loses focus |
| `game:quit` | | the game is closing |
| `scene:enter` | `name, data` | a scene is entered |
| `scene:leave` | `name` | a scene is left |
| `simulator:tick` | `simulator` | the simulation finished a tick |
| `simulator:play` | `simulator` | the simulation starts running |
| `simulator:pause` | `simulator` | the simulation is paused |
| `simulator:reset` | `simulator` | the simulation is reset to its start |
| `simulator:load` | `simulator, data` | a contraption is loaded into the simulation |
| `editor:commit` | `editor` | an edit is committed |
| `editor:cell` | `editor, x, y, state, before` | a cell is changed, `state` and `before` are `{ class, rotation, props }` or nothing |
| `editor:undo` | `editor` | an edit is undone |
| `editor:tool` | `editor, id` | the tool changes |
| `editor:select` | `editor, class` | a cell is selected for placing |
| `contraption:imported` | `data` | a contraption is imported |
| `contraption:saved` | `name, data` | a contraption is saved |
| `contraption:deleted` | `name` | a contraption is deleted |
| `puzzle:start` | `info` | a puzzle is opened, reset or replayed |
| `puzzle:solved` | `info` | a puzzle is solved |
| `puzzle:failed` | `info` | a puzzle is failed |
| `settings:changed` | `key, value` | a setting changes |
| `packs:reloaded` | | texture packs are reloaded |

> [!TIP]
> Turn on the debug menu with `F3` to see every event that has fired and how many listeners it has.

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

**React to a key**

```lua
api.on("game:keypressed", function(key)
    if key == "h" then print("hello") end
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
