Patching changes the game without editing its files. Modules are addressed by require path, like `src/engine/simulation/Simulator`. Constants are addressed by dotted path, like `background.logo`.

## Which one do I use?

| you want to | use | works on |
| --- | --- | --- |
| add to or change a constant | [`api.merge`](#apimergepath-values) | constants |
| edit a module in place | [`api.patch`](#apipatchpath-patch) | modules |
| run code around a method | [`api.wrap`](#apiwrappath-method-wrapper) | module methods |
| swap a module for something else | [`api.replace`](#apireplacepath-replacement) | modules, before they load |

## Constants

### `api.merge(path, values)`

Deep-merges `values` into the constants table at `path`.

```lua
api.merge("background.logo", { textures = { "mymod/thing" } })
```

## Modules

### `api.patch(path, patch)`

Calls `patch(module)` when the module loads, or at once if it already has. Change the module in place.

```lua
api.patch("src/engine/simulation/Simulator", function(Simulator)
    function Simulator:hello()
        print("hello")
    end
end)
```

### `api.wrap(path, method, wrapper)`

Replaces a method with `wrapper(original, ...)`. Call `original` to keep the old behavior.

```lua
api.wrap("src/engine/simulation/Simulator", "push", function(original, self, ...)
    local result = original(self, ...)
    return result
end)
```

### `api.replace(path, replacement)`

Swaps a module for another value.

```lua
api.replace("src/engine/audio/Audio", api.require("audio"))
```

> [!IMPORTANT]
> `api.replace` only works before the module loads. A loaded module can only be patched in place.

## Conflicts

> [!WARNING]
> The first mod to change a constant, patch a module, wrap a method or claim a hotkey owns it. If another mod changes the same thing, both get a conflict warning in the mod selection menu. Both still load, and load order decides the result.

What counts as a claim:

| call | claims |
| --- | --- |
| `api.merge("background.logo", { ... })` | each key, like `background.logo.textures` |
| `api.patch(path, ...)` and `api.replace(path, ...)` | the module path |
| `api.wrap(path, method, ...)` | `path:method` |
| `api.tools.add({ key = "x", ... })` | the hotkey `x` |

## Reloading

Changing the active mods reloads the game's modules and runs every `main.lua` again.

> [!TIP]
> Register everything from `main.lua`, since nothing persists across a reload.
