-- Armour should be cheaper, and require rubber.
RECIPE["light-armor"].ingredients = {-- Originally 40 iron plate.
	{type="item", name="iron-plate", amount=10},
}
RECIPE["heavy-armor"].ingredients = {-- Originally 100 copper plate, 50 steel plate.
	{type="item", name="steel-plate", amount=10},
	{type="item", name="rubber", amount=20},
}
Tech.addTechDependency("rubber-1", "heavy-armor")
RECIPE["modular-armor"].ingredients = {-- Originally 50 steel plate, 30 advanced circuits.
	{type="item", name="steel-plate", amount=20},
	{type="item", name="advanced-circuit", amount=20},
	{type="item", name="rubber", amount=20},
}
RECIPE["power-armor"].ingredients = {-- Originally 40 steel plate, 20 electric engine unit, 40 processing unit.
	{type="item", name="steel-plate", amount=20},
	{type="item", name="processing-unit", amount=20},
	{type="item", name="electric-engine-unit", amount=20},
	{type="item", name="rubber", amount=20},
}