extends Node

var settings_path := "user://settings.cfg"

func save_settings(resolution_index: int, window_mode_index: int, fps_index: int):
	var config = ConfigFile.new()
	config.set_value("graphics", "resolution", resolution_index)
	config.set_value("graphics", "window_mode", window_mode_index)
	config.set_value("graphics", "fps_cap", fps_index)
	config.save(settings_path)

func load_settings():
	var config = ConfigFile.new()
	if config.load(settings_path) == OK:
		var resolution_index = config.get_value("graphics", "resolution", 1)
		var window_mode_index = config.get_value("graphics", "window_mode", 0)
		var fps_index = config.get_value("graphics", "fps_cap", 0)

		var resolutions = [Vector2i(1280, 720), Vector2i(1920, 1080), Vector2i(2560, 1440)]
		DisplayServer.window_set_size(resolutions[resolution_index])

		match window_mode_index:
			0:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
				DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			1:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
				DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			2:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
				DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

		var fps_values = [60, 120, 0]
		Engine.max_fps = fps_values[fps_index]
