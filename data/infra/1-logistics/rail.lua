-- Rail stuff
RECIPE["rail"].ingredients = {
	{type="item", name="structure", amount=1},
	{type="item", name="frame", amount=1},
	-- Stone in rail recipe represents the track ballast; makes sense to crush/process stone before using as ballast. So could have sand as ingredient here, but it doesn't quite work with Gleba.
}
RECIPE["rail-ramp"].ingredients = {
	{type="item", name="structure", amount=20},
	{type="item", name="frame", amount=20},
	{type="item", name="rail", amount=10},
}
RECIPE["rail-ramp"].energy_required = 10
RECIPE["rail-support"].ingredients = {
	{type="item", name="structure", amount=5},
	{type="item", name="frame", amount=5},
}
RECIPE["rail-support"].energy_required = 5
-- Train stop: 4 frame + 2 small-lamp + 1 wiring + 2 electronic-circuit
RECIPE["train-stop"].ingredients = {
	{type="item", name="frame", amount=2},
	{type="item", name="small-lamp", amount=2},
	{type="item", name="sensor", amount=1},
}
-- Rail signals should need some glass.
RECIPE["rail-signal"].ingredients = {
	{type="item", name="frame", amount=1},
	{type="item", name="sensor", amount=1},
	{type="item", name="small-lamp", amount=1},
}
RECIPE["rail-chain-signal"].ingredients = {
	{type="item", name="frame", amount=1},
	{type="item", name="sensor", amount=2},
	{type="item", name="small-lamp", amount=1},
}
RECIPE["locomotive"].ingredients = {
	{type="item", name="engine-unit", amount=5},
	{type="item", name="sensor", amount=5},
	{type="item", name="shielding", amount=2},
	{type="item", name="frame", amount=5},
}
RECIPE["locomotive"].energy_required = 5
RECIPE["cargo-wagon"].ingredients = {
	{type="item", name="frame", amount=5},
	{type="item", name="mechanism", amount=2},
	{type="item", name="panel", amount=5},
}
-- Artillery-wagon: 20 shielding + 20 engine-unit + 8 electric-engine-unit + 4 structure + 8 sensor
RECIPE["artillery-wagon"].ingredients = {
	{type="item", name="frame", amount=5},
	{type="item", name="shielding", amount=5},
	{type="item", name="electric-engine-unit", amount=5},
}
RECIPE["artillery-wagon"].energy_required = 10