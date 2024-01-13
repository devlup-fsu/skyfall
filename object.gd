extends RigidBody3D

signal hit

# @onready var s_impact = preload("res://525101__jomse__plasticimpactb3.wav")

var mat = StandardMaterial3D.new()
var kill = true

var impacted = false

func _ready():
	mat.albedo_color = Color.RED
	$MeshInstance3D.set_surface_override_material(0, mat)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$MeshInstance3D.scale = Vector3.ONE * ((global_position.y - 50) / - 50 )
	
func _physics_process(delta):
	var bodies = get_colliding_bodies()
	for body in bodies:
		if not impacted:
			$AudioStreamPlayer3D.play()
			impacted = true
		if body is Player and kill:
			hit.emit()
		else:
			kill = false
			var mat = $MeshInstance3D.get_active_material(0)
			mat.albedo_color = Color.ALICE_BLUE
