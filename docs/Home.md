CelLove is a sandbox game based on Cell Machine by Sam Hogan. These pages cover everything you need to extend/mod it: new cells, tools, menus, and changes to the engine itself.

## Where to start

New to modding? Read these in order:

1. [Getting Started](Getting-Started): the folder layout, `mod.lua`, `main.lua` and textures
2. [Creating Cells](Creating-Cells): write a cell, put it in a category, give it properties
3. [Events](Events): react to what the game is doing

## All pages

### Guides

| page | what it covers |
| --- | --- |
| [Getting Started](Getting-Started) | folder layout, `mod.lua`, `main.lua`, textures |
| [Creating Cells](Creating-Cells) | cell classes, categories, properties, patterns |

### Topics

| page | what it covers |
| --- | --- |
| [Events](Events) | listen to the game, emit your own events |
| [Patching](Patching) | change constants and engine modules |

### Reference

| page | what it covers |
| --- | --- |
| [API Reference](API-Reference) | every function on the `api` object, generated from `API.lua` |
| [BaseCell](BaseCell) | fields and methods every cell inherits |

## A mod at a glance

```lua
-- mods/mymod/main.lua
return function(api)
    api.categories.add({
        id = "machines",
        title = "Machines",
        icon = "mymod/eraser"
    })

    api.on("puzzle:solved", function()
        print("nice")
    end)
end
```
