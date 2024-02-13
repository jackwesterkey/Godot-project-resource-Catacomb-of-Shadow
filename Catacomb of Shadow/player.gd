extends CharacterBody3D



# Exported Variables
@export var SPEED : float = 5.0
@export var JUMP_VELOCITY : float = 4.5
@export var sensitivity : float = 0.5
@export var min_angle : float = -80
@export var max_angle : float = 90

# Nodes
@onready var head = $head
@onready var anim_player : AnimationPlayer = $AnimationPlayer

# Gravity from project settings to sync with RigidBody nodes
var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")
var look_rot : Vector2

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	# Apply gravity if not on the floor
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("mouse"):
		anim_player.play("attack")
	
	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle movement
	handle_movement()

	# Move and slide
	move_and_slide()

	# Update head rotation
	head.rotation_degrees.x = look_rot.x
	rotation_degrees.y = look_rot.y

func handle_movement() -> void:
	# Get input direction and handle movement/deceleration
	var input_dir : Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction : Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

func _input(event: InputEvent) -> void:
	# Handle mouse motion for camera rotation
	if event is InputEventMouseMotion:
		look_rot.y -= event.relative.x * sensitivity
		look_rot.x -= event.relative.y * sensitivity
		look_rot.x = clamp(look_rot.x, min_angle, max_angle)

func _on_animation_player_animation_finished(anim_name: String) -> void:
	if anim_name == "attack":
		anim_player.play("Idle")

