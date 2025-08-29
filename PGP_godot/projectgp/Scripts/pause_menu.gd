extends CanvasLayer

var is_pause_open := false

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS


func show_menu():
	is_pause_open = true
	visible = true
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func hide_menu():
	is_pause_open = false
	visible = false
	get_tree().paused = false

	var computer_ui = get_tree().get_root().get_node("GarageRoot/ComputerUI")
	if computer_ui and computer_ui.is_open():
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_continue_pressed():
	hide_menu()

func _on_bt_main_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _on_leave_pressed():
	get_tree().quit()
