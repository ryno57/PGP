extends CharacterBody3D


var ui_open := false
@export var speed := 5.0
@export var mouse_sensitivity := 0.3

@onready var camera := $Camera3D


var rotation_y := 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	process_mode = Node.PROCESS_MODE_ALWAYS


func _unhandled_input(event):
	if ui_open or get_tree().paused:
		return

	if event is InputEventMouseMotion:
		rotation_y -= event.relative.x * mouse_sensitivity
		rotation_degrees.y = rotation_y
		camera.rotation_degrees.x -= event.relative.y * mouse_sensitivity
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -80, 80)

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		var pause_menu = get_tree().get_root().get_node("GarageRoot/PauseMenu")
		if pause_menu:
			if pause_menu.is_pause_open:
				pause_menu.hide_menu()
			else:
				pause_menu.show_menu()

	if ui_open or get_tree().paused:
		return



func _physics_process(_delta):
	if ui_open or get_tree().paused:
		return

	var input_dir = Vector3.ZERO
	input_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_dir.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	input_dir = input_dir.rotated(Vector3.UP, deg_to_rad(rotation_y)).normalized()

	velocity.x = input_dir.x * speed
	velocity.z = input_dir.z * speed
	move_and_slide()


func _process(_delta):
	if ui_open:
		return
	var raycast := $Camera3D/RayCast3D
	if Input.is_action_just_pressed("interact") and raycast and raycast.is_colliding():
		var target = raycast.get_collider()
		if target.has_method("on_interact"):
			target.call("on_interact")
