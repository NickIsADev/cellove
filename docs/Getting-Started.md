A mod is a folder in `mods/`, or a `.zip` of one installed from the mod selection menu.

```
mods/mymod/
├─ mod.lua      required, describes the mod
├─ main.lua     runs when the mod loads
├─ icon.png     shown in the mod selection menu
└─ cells/       one .lua file per cell
```

> [!NOTE]
> Folder names cannot contain dots.

## mod.lua

Describes the mod. It returns a table.

```lua
return {
    id = "mymod",
    name = "My Mod",
    description = "Adds things",
    author = "you",
    version = "1.0.0",
    texturepack = "mymod",
    icon = "icon.png",
    dependencies = { "othermod" }
}
```

| field | type | description |
| --- | --- | --- |
| `id` | `string` | required, lowercase letters, digits and `_`. `cellove` is reserved |
| `name` | `string` | display name |
| `description` | `string` | shown in the mod selection menu |
| `author` | `string` | shown in the mod selection menu |
| `version` | `string` | shown in the mod selection menu |
| `texturepack` | `string` | pack in `texturepacks/` linked to the mod |
| `icon` | `string` | image path inside the mod folder |
| `dependencies` | `table` | mod IDs that load first. the mod fails if one is missing or failed |

## main.lua

Returns a function that receives the [api](API-Reference) object. Register everything here.

```lua
return function(api)
    api.categories.add({
        id = "machines",
        title = "Machines",
        icon = "mymod/thing"
    })
end
```

> [!NOTE]
> IDs are prefixed with the mod ID. `machines` is registered as `mymod:machines`, and a cell named `thing` as `mymod:thing`.

## Textures

Textures come from texture packs, not the mod folder. The cell `mymod:thing` uses:

```
texturepacks/<pack>/cells/mymod/thing.png
```

Markers use a `markers` folder instead of `cells`.

A pack is a folder with a `pack.lua` next to its textures. Link it to your mod with `texturepack` in `mod.lua`.

```
texturepacks/mymod/
├─ pack.lua
├─ ui/icon.png
└─ cells/mymod/thing.png
```

```lua
return {
    name = "My Mod",
    description = "Textures for my mod",
    author = "you",
    icon = "ui/icon.png"
}
```

## Loading

Mods load in the order of the Active list in the mod selection menu. A mod that errors is skipped and shown as failed, with the file and line.

> [!WARNING]
> If two mods change the same constant, module or hotkey, both get a conflict warning. See [Patching](Patching#conflicts).

## Next steps

- [Creating Cells](Creating-Cells) to add your first cell
- [Events](Events) to react to the game
