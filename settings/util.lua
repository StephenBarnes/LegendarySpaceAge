--local FORCE_SETTINGS = settings.startup["LSA-force-settings"].value
local FORCE_SETTINGS = true
	-- Can't make this a setting, bc we need to use the value of it in settings stage.


local Export = {}

Export.setDefault = function(name, settingType, value)
	local s = RAW[settingType .. "-setting"][name]
	if s == nil then
		log("Couldn't find setting "..name.." to set default value for.")
	else
		s.default_value = value
	end
end

Export.forceSetting = function(name, settingType, value)
	local s = RAW[settingType .. "-setting"][name]
	if s == nil then
		log("ERROR: Couldn't find setting "..name.." to force value for.")
		return
	end
	if settingType == "bool" then
		s.forced_value = value
	else
		s.allowed_values = {value}
	end
	s.default_value = value
	s.hidden = true
end

Export.setDefaultOrForce = function(name, settingType, value)
	if FORCE_SETTINGS then
		Export.forceSetting(name, settingType, value)
	else
		Export.setDefault(name, settingType, value)
	end
end

return Export