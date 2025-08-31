extends CanvasLayer

@onready var resolution_option = $Panel/TabContainer/Display/ResolutionOption
@onready var window_mode_option = $Panel/TabContainer/Display/WindowModeOption
@onready var fps_option = $Panel/TabContainer/Display/FPSCapOption

@onready var confirm_button = $Panel/ConfirmButton
@onready var restart_notice = $Panel/RestartNoticeLabel

var pending_changes := false

func _ready():
	# Masquer les éléments au démarrage
	confirm_button.visible = false
	restart_notice.visible = false

	# Initialiser les options visibles
	_init_option_buttons()

	# Connecter les signaux de changement
	_connect_signals()

	# Charger les paramètres sauvegardés
	_load_settings_into_ui()

func _init_option_buttons():
	resolution_option.clear()
	resolution_option.add_item("1280x720")
	resolution_option.add_item("1920x1080")
	resolution_option.add_item("2560x1440")

	window_mode_option.clear()
	window_mode_option.add_item("Windowed")
	window_mode_option.add_item("Fullscreen")
	window_mode_option.add_item("Borderless")

	fps_option.clear()
	fps_option.add_item("60 FPS")
	fps_option.add_item("120 FPS")
	fps_option.add_item("Uncapped")

func _connect_signals():
	resolution_option.connect("item_selected", Callable(self, "_on_any_option_changed"))
	window_mode_option.connect("item_selected", Callable(self, "_on_any_option_changed"))
	fps_option.connect("item_selected", Callable(self, "_on_any_option_changed"))

func _load_settings_into_ui():
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		resolution_option.select(config.get_value("graphics", "resolution", 1))
		window_mode_option.select(config.get_value("graphics", "window_mode", 0))
		fps_option.select(config.get_value("graphics", "fps_cap", 0))

func _on_any_option_changed(index):
	if not pending_changes:
		pending_changes = true
		confirm_button.visible = true
		restart_notice.visible = true

func _on_confirm_button_pressed():
	_apply_settings()
	SettingsManager.save_settings(
		resolution_option.selected,
		window_mode_option.selected,
		fps_option.selected
	)
	confirm_button.visible = false
	restart_notice.visible = false
	pending_changes = false

func _apply_settings():
	var resolutions = [Vector2i(1280, 720), Vector2i(1920, 1080), Vector2i(2560, 1440)]
	DisplayServer.window_set_size(resolutions[resolution_option.selected])

	match window_mode_option.selected:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

	var fps_values = [60, 120, 0]  # 0 = uncapped
	Engine.max_fps = fps_values[fps_option.selected]

func _on_cancel_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
