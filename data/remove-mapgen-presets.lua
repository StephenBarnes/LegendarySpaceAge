-- This file removes existing mapgen presets, since we've created a custom one.

if settings.startup["LSA-remove-mapgen-presets"] then
	log("Removing all existing mapgen presets!")
    for k, _ in pairs(data.raw["map-gen-presets"]["default"]) do
        if k ~= "type" and k ~= "name" and k ~= "default" and k ~= "LegendarySpaceAge" then
            log("Removing mapgen preset: "..k)
            data.raw["map-gen-presets"]["default"][k] = nil
        end
    end

	-- We can't completely remove the default map preset.
	-- So instead, adjust the default map preset to make it generate almost only water, so people don't accidentally play on it.
	data.raw["noise-expression"].elevation.expression = "if(distance < 50, 10, -10)"
end