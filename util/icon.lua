local Icons = {}

Icons.set = function(thing, icon) 
	if type(thing) == "string" then
		thing = data.raw[thing]
	end
	thing.icon = icon
end

return Icons