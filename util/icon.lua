local Icons = {}

Icons.set = function(thing, icon) 
	if type(thing) == "string" then
		thing = RAW[thing]
	end
	thing.icon = icon
end

return Icons