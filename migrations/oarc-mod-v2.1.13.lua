---For each planet's surface, mark the center of the map permanently safe from regrowth.
-- If we can detect and redirect cargo-pods, then this can be removed.

-- TODO: Hopefully a temporary measure to make sure map center never gets deleted.
-- If we can detect and redirect cargo-pods, then this can be removed.

-- Loop through each surface
for _,surface in pairs(game.surfaces) do
    if (storage.rg[surface.name] ~= nil) then
        for i = -2, 2 do
            for j = -2, 2 do
                MarkChunkSafe(surface.name, { x = i, y = j }, true)
            end
        end
        log("Applying migration for V2.1.13: Marked center of "..surface.name.." safe from regrowth.")
    end
end

-- Make sure vulcanus config is set up if it is missing.
if script.active_mods["space-age"] ~= nil then
    if (storage.ocfg.surfaces_config["vulcanus"] == nil) or
        (storage.ocfg.surfaces_config["vulcanus"].spawn_config.liquid_tile ~= "lava") then
        storage.ocfg.surfaces_config["vulcanus"] =
        {
            spawn_config = VULCANUS_SPAWN_CONFIG,
            starting_items = VULCANUS_STARTER_ITEMS
        }
        log("Updating vulcanus config with new spawn_config and starting_items.")
    end
end