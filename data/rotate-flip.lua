-- Create custom inputs to rotate and flip things. This is needed because game thinks some things like turrets can't be rotated.
extend{
	{
		type = "custom-input",
		name = "LSA-rotate",
		linked_game_control = "rotate",
		key_sequence = "",
		consuming = nil,
	},
	{
		type = "custom-input",
		name = "LSA-reverse-rotate",
		linked_game_control = "reverse-rotate",
		key_sequence = "",
		consuming = nil,
	},
	{
		type = "custom-input",
		name = "LSA-flip",
		linked_game_control = "flip-vertical",
		key_sequence = "",
		consuming = nil,
	},
}