local recipes = data.raw.recipe

-- Rail stuff
recipes["rail"].ingredients = {
	{type="item", name="structure", amount=1},
	{type="item", name="frame", amount=1},
	-- Stone in rail recipe represents the track ballast; makes sense to crush/process stone before using as ballast. So could have sand as ingredient here, but it doesn't quite work with Gleba.
}
recipes["rail-ramp"].ingredients = {
	{type="item", name="structure", amount=20},
	{type="item", name="frame", amount=20},
	{type="item", name="rail", amount=8},
}
recipes["rail-support"].ingredients = {
	{type="item", name="structure", amount=4},
	{type="item", name="frame", amount=4},
}
-- Train stop: 4 frame + 2 small-lamp + 1 wiring + 2 electronic-circuit
recipes["train-stop"].ingredients = {
	{type="item", name="frame", amount=4},
	{type="item", name="small-lamp", amount=2},
	{type="item", name="sensor", amount=1},
}
-- Rail signals should need some glass.
recipes["rail-signal"].ingredients = {
	{type="item", name="frame", amount=1},
	{type="item", name="sensor", amount=1},
	{type="item", name="small-lamp", amount=1},
}
recipes["rail-chain-signal"].ingredients = {
	{type="item", name="frame", amount=1},
	{type="item", name="sensor", amount=2},
	{type="item", name="small-lamp", amount=1},
}
recipes["locomotive"].ingredients = {
	{type="item", name="engine-unit", amount=4},
	{type="item", name="sensor", amount=4},
	{type="item", name="shielding", amount=4},
	{type="item", name="frame", amount=4},
}
recipes["cargo-wagon"].ingredients = {
	{type="item", name="frame", amount=4},
	{type="item", name="mechanism", amount=4},
	{type="item", name="panel", amount=8},
}
-- Artillery-wagon: 20 shielding + 20 engine-unit + 8 electric-engine-unit + 4 structure + 8 sensor
recipes["artillery-wagon"].ingredients = {
	{type="item", name="shielding", amount=20},
	{type="item", name="engine-unit", amount=4},
	{type="item", name="electric-engine-unit", amount=8},
	{type="item", name="structure", amount=4},
	{type="item", name="sensor", amount=4},
}