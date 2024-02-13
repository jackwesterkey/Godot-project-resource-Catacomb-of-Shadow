extends CharacterBody3D

@export var objectToDeletePath : NodePath
@onready var nav_agent = $NavigationAgent3D
@onready var timer : Timer = $Timer  
@export var SPEED : float = 3.8

func _physics_process(_delta):
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	velocity = new_velocity
	move_and_slide()

func update_target_location(target_location):
	nav_agent.target_position = target_location

func _ready():
	timer.start()

func _on_timer_timeout():
	# Ensure the objectToDeletePath is a valid Node reference
	var objectToDelete = get_node_or_null(objectToDeletePath)
	
	if objectToDelete:
		objectToDelete.queue_free()
