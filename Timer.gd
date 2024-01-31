extends Timer

signal game_over

@onready var object_scene: PackedScene = load("res://object.tscn")

func _on_timeout():
	var object = object_scene.instantiate()
	add_child(object)
	object.position.y = 50
	object.position.x = randf_range(-5, 5)
	object.position.z = randf_range(-5, 5)

	object.player_killed.connect(_on_player_killed)
	
func _on_player_killed():
	game_over.emit()
	wait_time = 0.05
