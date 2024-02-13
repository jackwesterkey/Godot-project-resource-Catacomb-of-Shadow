extends Node3D

@export var objectToDeletePath : NodePath
@export var secondObjectToDeletePath : NodePath

var deleteFirstObject : bool = true

func _process(_delta):
	if Input.is_action_just_pressed("mouse"):
		# Resolve the NodePaths to get the object references
		var objectToDelete : Object = get_node(objectToDeletePath)
		var secondObjectToDelete : Object = get_node(secondObjectToDeletePath)

		# Check if the first object to delete is assigned
		if objectToDelete != null and deleteFirstObject:
			# Remove or delete the assigned object
			objectToDelete.queue_free()

		# Check if the second object to delete is assigned
		if secondObjectToDelete != null and not deleteFirstObject:
			# Remove or delete the second assigned object
			secondObjectToDelete.queue_free()

		# Toggle the flag for the next mouse press
		deleteFirstObject = not deleteFirstObject
