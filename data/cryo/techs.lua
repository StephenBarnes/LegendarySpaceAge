local electrolysisTech = copy(TECH["sulfur-processing"])
electrolysisTech.name = "electrolysis"
electrolysisTech.effects = {
	{type = "unlock-recipe", recipe = "electrolysis"},
}
Icon.set(electrolysisTech, "LSA/techs/electrolysis")
-- TODO prereqs
extend{electrolysisTech}
Tech.addTechDependency("electrolysis", "planet-discovery-fulgora")