Everything on the `api` object that `main.lua` receives. This page is generated from `src/engine/modding/API.lua`, so edit the doc comments there instead of this file.

```lua
return function(api)
    api.categories.add({ id = "machines", title = "Machines", icon = "mymod/thing" })
    api.on("puzzle:solved", function() print("solved") end)
end
```

> [!NOTE]
> IDs you pass to the `add` functions are prefixed with your mod ID. See [Getting Started](Getting-Started#mainlua).

<!-- api:start -->
<!-- api:end -->
