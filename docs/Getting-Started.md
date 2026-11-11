A mod is a folder in `mods/`, or a `.zip` of one installed from the mod selection menu.

```
mods/mymod/
├─ mod.lua      required, describes the mod
├─ main.lua     runs when the mod loads
├─ icon.png     shown in the mod selection menu
├─ textures/    textures, loaded with the mod
└─ cells/       one .lua file per cell
```

> [!NOTE]
> Folder names cannot contain dots. That includes the name of a `.zip`, and of the folder inside it.

## mod.lua

Describes the mod. It returns a table.

```lua
return {
    id = "mymod",
    name = "My Mod",
    description = "Adds things",
    author = "you",
    version = "1.0.0",
    minVersion = "0.1.0",
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
| `minVersion` | `string` | oldest CelLove version the mod supports, like `0.1.0`. the mod fails on older versions |
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

Put your textures in a `textures/` folder in the mod. It is laid out like a texture pack and loads with the mod, so it is on whenever the mod is and can't be turned off on its own. Packs the player enables still override it. The cell `mymod:thing` uses:

```
mods/mymod/textures/cells/mymod/thing.png
```

Markers use a `markers` folder instead of `cells`, and icons go in `ui`.

```
mods/mymod/textures/
├─ ui/icon.png
└─ cells/mymod/thing.png
```

## Loading

Mods load in the order of the Active list in the mod selection menu. A mod that errors is skipped and shown as failed, with the file and line.

> [!WARNING]
> If two mods change the same constant, module or hotkey, both get a conflict warning. See [Patching](Patching#conflicts).

## Next steps

- [Creating Cells](Creating-Cells) to add your first cell
- [Events](Events) to react to the game
