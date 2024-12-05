local Export = {}

local globalParams = require("code.global-params")

Export.startupSetting = function(name)
	-- Can only be called in data stage, not settings stage (bc in settings stage we have to use data.raw["string-setting"] instead of settings.startup).
	return settings.startup["Desolation-"..name].value
end

Export.setDefaultOrForce = function(name, settingType, value)
	if globalParams.forceSettings then
		Export.forceSetting(name, settingType, value)
	else
		Export.setDefault(name, settingType, value)
	end
end

Export.setDefault = function(name, settingType, value)
	local s = data.raw[settingType .. "-setting"][name]
	if s == nil then
		log("Couldn't find setting "..name.." to set default value for.")
	else
		s.default_value = value
	end
end

Export.forceSetting = function(name, settingType, value)
	local s = data.raw[settingType .. "-setting"][name]
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

return Export