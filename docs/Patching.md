Patching changes the game without editing its files. Modules are addressed by require path, like `src/engine/simulation/Simulator`. Constants are addressed by dotted path, like `background.logo`.

## Which one do I use?

| you want to | use | works on |
| --- | --- | --- |
| change a constant | [`api.merge`](#apimergepath-values) | constants |
| replace a constants table entirely | [`api.overwrite`](#apioverwritepath-values) | constants |
| edit a module in place | [`api.patch`](#apipatchpath-patch) | modules |
| run code around a method | [`api.wrap`](#apiwrappath-method-wrapper) | module methods |
| swap a module for something else | [`api.replace`](#apireplacepath-replacement) | modules, before they load |

Adding something new, like a list entry or a hotkey, usually has its own function. See [When there is a function for it](#when-there-is-a-function-for-it).

## When there is a function for it

Changing something that already exists never gets its own function. Use the table above: recoloring a splash, tweaking a number, renaming a title or rewriting a method is a `merge`, `overwrite`, `patch` or `wrap`.

Adding something new gets an `api.<things>.add` function only when patching can't do it safely:

| reason | why patching fails | examples |
| --- | --- | --- |
| it goes in a list | `api.merge` works by index and replaces other mods' entries, `api.overwrite` drops them | `api.splash.add`, `api.logos.add`, `api.toolbar.add`, `api.categories.add` |
| its ID needs your mod prefix | patching would make you write the prefix yourself | `api.options.add`, `api.hotkeys.add` |
| its position matters | a list entry can't be placed before "back" | `api.pause.add`, `api.markers.add` |
| several places must change together | a marker is a button and a contraption kind, an option is a row and a setting | `api.markers.add`, `api.options.add` |
| it lives in runtime state | there is no constants path or module to patch | `api.cells.add`, `api.scenes.add`, `api.settings.define` |

If it is on this list, the function also exists in reverse. `api.<things>.remove(id)` deletes one entry, which `merge` and `overwrite` can't do without replacing the whole list. `remove` takes the full ID, since it targets built-in and other mods' entries, and only exists where nothing else in the game depends on the entry, so there is no `remove` for categories, tools or hotkeys.

Every function follows the same shape:

- Top-level `api.*` functions are reserved for patching (`merge`, `overwrite`, `patch`, `replace`, `wrap`) and for `require`, `emit`, `on` and `off`.
- Everything else lives under a plural noun, with `add(spec)`, `remove(id)`, `get(name)` and `has(name)`. Anything else is named for what it does, like `api.hotkeys.pressed`.
- `add` prefixes your mod ID onto the ID or key you give it.
- Only changes that two mods can disagree on are claimed as [conflicts](#conflicts). Adding and removing entries never is.

## Constants

### `api.merge(path, values)`

Deep-merges `values` into the constants table at `path`.

```lua
api.merge("menu.splash", { color = 0xFF6AFF, size = 24 })
```

> [!NOTE]
> Merging only adds and changes keys. A list is merged by index, so it can't add to a list and a shorter list leaves the old entries behind. Use `api.overwrite` to replace a table, or the `add` function for that list, like `api.splash.add`.

### `api.overwrite(path, values)`

Replaces everything in the constants table at `path` with `values`.

```lua
api.overwrite("menu.splash.list", { "hello!", "goodbye!" })
```

> [!WARNING]
> This removes every splash text, including other mods'. To add one, use `api.splash.add`.

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
| `api.merge("menu.splash", { ... })` | each key, like `menu.splash.color` |
| `api.overwrite(path, { ... })` | the path, like `menu.splash.list` |
| `api.patch(path, ...)` and `api.replace(path, ...)` | the module path |
| `api.wrap(path, method, ...)` | `path:method` |
| `api.tools.add({ key = "x", ... })` and `api.hotkeys.add({ key = "x", ... })` | the hotkey `x` |

## Reloading

Changing the active mods reloads the game's modules and runs every `main.lua` again.

> [!TIP]
> Register everything from `main.lua`, since nothing persists across a reload.
