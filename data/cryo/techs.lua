local electrolysisTech = copy(TECH["sulfur-processing"])
electrolysisTech.name = "electrolysis"
electrolysisTech.effects = {
	{type = "unlock-recipe", recipe = "electrolysis"},
}
Icon.set(electrolysisTech, "LSA/techs/electrolysis")
electrolysisTech.prerequisites = {"fluid-handling"}
extend{electrolysisTech}