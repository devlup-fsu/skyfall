extends Node3D


var run = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationTree.set("parameters/conditions/run", false)
	$AnimationTree.set("parameters/conditions/idle", true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func switch_state():
	if run:
		run = false
		$AnimationTree.set("parameters/conditions/run", false)
		$AnimationTree.set("parameters/conditions/idle", true)
	else:
		run = true
		$AnimationTree.set("parameters/conditions/run", true)
		$AnimationTree.set("parameters/conditions/idle", false)
