extends CharacterBody3D

@export var speed := 5.0
@export var mouse_sensitivity := 0.3

@onready var camera := $Camera3D

var rotation_y := 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_y -= event.relative.x * mouse_sensitivity
		rotation_degrees.y = rotation_y
		camera.rotation_degrees.x -= event.relative.y * mouse_sensitivity
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -80, 80)

func _physics_process(_delta):
	var input_dir = Vector3.ZERO
	input_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_dir.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	input_dir = input_dir.rotated(Vector3.UP, deg_to_rad(rotation_y)).normalized()

	velocity.x = input_dir.x * speed
	velocity.z = input_dir.z * speed
	move_and_slide()

func _process(_delta):
	var raycast := $Camera3D/RayCast3D
	if Input.is_action_just_pressed("interact") and raycast and raycast.is_colliding():
		var target = raycast.get_collider()
		if target.has_method("on_interact"):
			target.call("on_interact")
