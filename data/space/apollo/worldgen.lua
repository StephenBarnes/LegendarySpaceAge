--[[ This file collects worldgen for lunar terrain - tiles, resources, etc.
]]

for _, vals in pairs{
	------------------------------------------------------------------------
	--- General terrain noise.
	{
		name = "lunar_rockiness",
		expression = "basis_noise{x = x, y = y, seed0 = map_seed, seed1 = 1, input_scale = 1/60, output_scale = 1}",
	},
	{
		name = "lunar_elevation",
		expression = "basis_noise{x = x, y = y, seed0 = map_seed, seed1 = 2, input_scale = 1/60, output_scale = 1}",
	},
	------------------------------------------------------------------------
	--- Tiles.
	{
		name = "lunar_doughy",
		-- Doughy highland is wherever elevation is fairly high, OR elevation is very high but rockiness is low.
		expression = "max((lunar_elevation > 0.2)*(lunar_elevation <= 0.8), (lunar_elevation > 0.8)*(lunar_rockiness <= -0.4))",
	},
	{
		name = "lunar_sandy_rock",
		-- Sandy rock is wherever elevation is very high, AND rockiness isn't low.
		expression = "(lunar_elevation > 0.8)*(lunar_rockiness > -0.4)",
	},
	{
		name = "lunar_dirt",
		-- Dirt midlands are wherever elevation is somewhat low but not too low.
		expression = "(lunar_elevation > -0.5)*(lunar_elevation <= 0.2)",
	},
	{
		name = "lunar_clay",
		-- Clay lowlands are wherever elevation is very low.
		expression = "lunar_elevation <= -0.5",
	},
} do
	extend{{
		type = "noise-expression",
		name = vals.name,
		expression = vals.expression,
	}}
end