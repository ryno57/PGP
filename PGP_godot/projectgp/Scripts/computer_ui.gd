extends CanvasLayer

func _ready():
	visible = false

func show_ui():
	visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().get_root().get_node("GarageRoot/Player").ui_open = true

func hide_ui():
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().get_root().get_node("GarageRoot/Player").ui_open = false

func _on_button_pressed():
	hide_ui()

func is_open() -> bool:
	return visible
