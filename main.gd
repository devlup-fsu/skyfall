extends Node3D

@onready var object = preload("res://object.tscn")

var time = -5
var alive = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	$Camera3D.rotation_degrees.x += sin(time) * 0.01
	$Camera3D.rotation_degrees.z += cos(time) * 0.007
	if alive:
		$Camera3D.fov = clamp(lerp(35, 98, time * -1/5), 35, 98)
		var int_time = abs(int(time))
		$Camera3D/Control/BottomContainer/score.text = str(int_time)
		if int_time == 0:
			$Camera3D/Control/CenterContainer/Ready.visible = false
	else:
		$Camera3D.fov = clamp(lerp(35, 98, time * 1/20), 35, 98)
		spawn_object()
	
func _on_spawn_timer_timeout():
	if time > 0:
		spawn_object()

func spawn_object():
	var newObj: Node3D = object.instantiate()
	add_child(newObj)
	newObj.hit.connect(hit)
	newObj.global_position = Vector3(randf_range(-5.5, 5.5), 50, randf_range(-5.5, 5.5))
	newObj.rotation_degrees = Vector3(randf_range(-90, 90), randf_range(-90, 90), randf_range(-90, 90))
	# follow player, i think it's too hard:
	# newObj.global_position = Vector3($player.position.x, 50, $player.position.z)
	
	# the below line makes the spawn time get faster
	# honestly, after trying it, I don't think that this makes it more fun - try, lmk what you think
	# $SpawnTimer.wait_time = clamp($SpawnTimer.wait_time - 0.001, 0.05, 1)

func hit():
	# make sure to add a slide that is basically just "call down, signal up"
	if alive:
		time = 0
	alive = false
	$player.alive = false
	$Camera3D/Control/CenterContainer/YOUDIE.visible = true
	$Camera3D/Control/CenterContainer/YOUDIE/RestartButton.visible = true


func _on_area_3d_body_entered(body):
	if body is Player and alive:
		hit()
	elif body is RigidBody3D:
		body.get_parent_node_3d().queue_free()
		len(get_children())



func _on_restart_button_pressed():
	get_tree().reload_current_scene()
