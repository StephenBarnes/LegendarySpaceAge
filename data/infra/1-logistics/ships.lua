-- Ports, signal buoys, cargo ships.
-- Port: 1 frame + 1 small-lamp + 1 sensor
RECIPE["port"].ingredients = {
	{type="item", name="frame", amount=1},
	{type="item", name="small-lamp", amount=1},
	{type="item", name="sensor", amount=1},
}
-- Buoy: 1 frame + 1 small-lamp + 1 sensor
RECIPE["buoy"].ingredients = {
	{type="item", name="frame", amount=1},
	{type="item", name="small-lamp", amount=1},
	{type="item", name="sensor", amount=1},
}
-- Chain_buoy: 1 frame + 1 small-lamp + 2 sensor
RECIPE["chain_buoy"].ingredients = {
	{type="item", name="frame", amount=1},
	{type="item", name="small-lamp", amount=1},
	{type="item", name="sensor", amount=2},
}
-- Boat: 10 engine-unit + 20 frame + 20 panel
RECIPE["boat"].ingredients = {
	{type="item", name="engine-unit", amount=2},
	{type="item", name="frame", amount=20},
	{type="item", name="panel", amount=20},
}
-- Cargo ship: 40 engine-unit + 80 frame + 80 panel
RECIPE["cargo_ship"].ingredients = {
	{type="item", name="engine-unit", amount=8},
	{type="item", name="frame", amount=80},
	{type="item", name="panel", amount=80},
	{type="item", name="sensor", amount=4},
}
-- Oil_tanker: 40 engine-unit + 60 frame + 60 panel + 20 fluid-fitting + 10 storage-tank
RECIPE["oil_tanker"].ingredients = {
	{type="item", name="engine-unit", amount=8},
	{type="item", name="frame", amount=60},
	{type="item", name="panel", amount=60},
	{type="item", name="fluid-fitting", amount=20},
	{type="item", name="storage-tank", amount=10},
}